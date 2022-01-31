library(shiny)
library(reactable)
library(here)
library(tidyverse)




ui <- fluidPage(
  reactableOutput("table")
)

data <- read.csv(here("data", "studies.csv")) %>% 
  janitor::clean_names() %>% 
  select(l1_influence, l2_influence, typological_influence, hybrid_influence,
         mirror_image_groups, author_year, l3, other_languages, non_facilitative_transfer)

server <- function(input, output) {
  output$table <- renderReactable({
    reactable(data, searchable = TRUE, columns = list(
      author_year = colDef(html = TRUE, cell = JS("
    function(cellInfo) {
      // Render as a link
      const url = 'https://' + cellInfo.row['doi']
      return '<a href=\"' + url + '\" target=\"_blank\">' + cellInfo.value + '</a>'
    }
  "))
  })
}

shinyApp(ui, server)