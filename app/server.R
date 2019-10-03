library(shiny)
library(leaflet)
library(data.table)
library(plotly)
library(shinyWidgets)
library(googleVis)

setwd("/Users/jacob/Desktop/FALL 2019/Applied Data Science/fall2019-proj2--sec2-grp8/data")

activities <- read.csv("activities_processed.csv")
kid_activity <- activities[activities$Grade.Level...Age.Group == "Elementary",]
middle_activity <- activities[activities$Grade.Level...Age.Group == "Middle School",]
high_activity <- activities[activities$Grade.Level...Age.Group == "High School",]

marker_opt <- markerOptions(opacity = 0.7, riseOnHover = TRUE)

shinyServer(function(input, output,session) {
  
  ## Map Tab section
  
  output$map <- renderLeaflet({
    m <- leaflet() %>%
      addProviderTiles("CartoDB.Positron", 
                       options = providerTileOptions(noWrap = TRUE)) %>%
                        setView(-73.983,40.7639,zoom = 13)
    #plot kids activities
    leafletProxy("map", data = kid_activity) %>%
      addMarkers(~Longitude, ~Latitude,
                 group = "kid_activity" ,
                 options = marker_opt, popup = ~ paste0("<b>",SITE.NAME,"</b>",
                                                          "<br/>", "Phone: ", Contact.Number,
                                                          "<br/>", "Address: ", Location.1, 
                                                           " ",Postcode) ,
                 label = ~ SITE.NAME ,
                 icon = list(iconUrl = 'https://cdn2.vectorstock.com/i/1000x1000/47/76/kids-icon-happy-boy-and-girl-children-silhouettes-vector-9674776.jpg'
                             ,iconSize = c(25,25)))
    leafletProxy("map", data = middle_activity) %>%
      addMarkers(~Longitude, ~Latitude ,
                 group = "middle_activity"
                 , options = marker_opt, popup = ~ paste0("<b>",SITE.NAME,"</b>",
                                                          "<br/>", "Phone: ", Contact.Number,
                                                          "<br/>", "Address: ", Location.1, 
                                                          " ",Postcode) ,  
                 label = ~ SITE.NAME ,
                 icon = list(iconUrl = 'https://cdn3.iconfinder.com/data/icons/school-pack-3-1/512/5-512.png'
                             ,iconSize = c(25,25)))
    leafletProxy("map", data = high_activity) %>%
      addMarkers(~Longitude, ~Latitude,
                 group = "high_activity"
                 , options = marker_opt, popup = ~ paste0("<b>",SITE.NAME,"</b>",
                                                          "<br/>", "Phone: ", Contact.Number,
                                                          "<br/>", "Address: ", Location.1, 
                                                          " ",Postcode) ,  
                 label = ~ SITE.NAME,
                 icon = list(iconUrl = 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/50/Closed_Book_Icon.svg/512px-Closed_Book_Icon.svg.png'
                             ,iconSize = c(25,25)))
    m
  })
  
  #enable/disable markers of specific group
  observeEvent(input$enable_markers, {
    if("Elementray School" %in% input$enable_markers) leafletProxy("map") %>% showGroup("kid_activity")
    else{leafletProxy("map") %>% hideGroup("kid_activity")}
    if("Middle School" %in% input$enable_markers) leafletProxy("map") %>% showGroup("middle_activity")
    else{leafletProxy("map") %>% hideGroup("middle_activity")}
    if("High School" %in% input$enable_markers) leafletProxy("map") %>% showGroup("high_activity")
    else{leafletProxy("map") %>% hideGroup("high_activity")}
  }, ignoreNULL = FALSE)
  
  
  
  
  
  ## Statistics Part
  
  output$stat_plot_ts <- renderPlotly(plot1)
  output$stat_plot_ts2 <- renderPlotly(plot2)
  output$crime_type <- renderGvis(crime_type_count)
  
  output$crime_sex <- renderGvis(crime_sex_count)
    
  output$crime_race <- renderGvis(crime_race_count)
  
  # The activities data display column in the Data Search Column  
  output$table1 <- renderDataTable(activities,
                                  options = list(pageLength = 10, lengthMenu = list(c(10))))
  # The crime data display column in the Data Search Column  
  output$table2 <- renderDataTable(crime,
                                   options = list(pageLength = 10, lengthMenu = list(c(10))))
})

