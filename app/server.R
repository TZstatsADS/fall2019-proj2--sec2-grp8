library(shiny)
library(leaflet)
library(data.table)
library(plotly)
library(shinyWidgets)

shinyServer(function(input, output) {
              output$map <- renderLeaflet({
                              leaflet() %>%
                              addProviderTiles(providers$Stamen.TonerLite,
                              options = providerTileOptions(noWrap = TRUE))  %>% 
                              setView(-73.983,40.7639,zoom = 10) })
  # The activities data display column in the Data Search Column  
  output$table1 <- renderDataTable(activities,
                                   options = list(pageLength = 10, lengthMenu = list(c(10))))
  
  # The crime data display column in the Data Search Column  
  output$table2 <- renderDataTable(crime,
                                   options = list(pageLength = 10, lengthMenu = list(c(10))))
  
  
})

