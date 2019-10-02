library(shiny)
library(leaflet)

shinyServer(function(input, output,session) {
  
  output$map <- renderLeaflet({
    #marker_opt <- markerOptions(opacity=0.8,riseOnHover=T)
    #m <- leaflet() %>%  addProviderTiles("Stamen.TonerLite") %>% setView(-73.983,40.7639,zoom = 13)
    leaflet() %>%
      addProviderTiles(providers$Stamen.TonerLite,
                       options = providerTileOptions(noWrap = TRUE)) %>% setView(-73.983,40.7639,zoom = 13)
  })
    
  # The activities data display column in the Data Search Column  
  output$table1 <- renderDataTable(activities,options = list(pageLength = 10, lengthMenu = list(c(10)))
  )
  
  # The crime data display column in the Data Search Column  
  output$table2 <- renderDataTable(crime,options = list(pageLength = 10, lengthMenu = list(c(10)))
  )
})

