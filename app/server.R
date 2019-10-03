library(shiny)
library(leaflet)
<<<<<<< HEAD
library(data.table)
library(plotly)
library(shinyWidgets)

shinyServer(function(input, output) {
              output$map <- renderLeaflet({
                              leaflet() %>%
                              addProviderTiles(providers$Stamen.TonerLite,
                              options = providerTileOptions(noWrap = TRUE))  %>% 
                              setView(-73.983,40.7639,zoom = 10) })
=======

shinyServer(function(input, output,session) {
  
  ## Map Tab section
  output$map <- renderLeaflet({
    #marker_opt <- markerOptions(opacity=0.8,riseOnHover=T)
    #m <- leaflet() %>%  addProviderTiles("Stamen.TonerLite") %>% setView(-73.983,40.7639,zoom = 13)
    leaflet() %>%
      addProviderTiles(providers$Stamen.TonerLite,options = providerTileOptions(noWrap = TRUE)) %>% setView(-73.983,40.7639,zoom = 13)
                        
  })
  
  ## Statistics Part
  
  output$stat_plot_ts <- renderPlotly(plot1)
  output$stat_plot_ts2 <- renderPlotly(plot2)
  output$crime_type <- renderGvis(crime_type_count)
  
  output$crime_sex <- renderGvis(crime_sex_count)
    
  output$crime_race <- renderGvis(crime_race_count)
>>>>>>> c620f283b3d102cf2371e9ea1fd42b712aa0be0e
  # The activities data display column in the Data Search Column  
  output$table1 <- renderDataTable(activities,
                                   options = list(pageLength = 10, lengthMenu = list(c(10))))
  
  # The crime data display column in the Data Search Column  
  output$table2 <- renderDataTable(crime,
                                   options = list(pageLength = 10, lengthMenu = list(c(10))))
  
  
})

