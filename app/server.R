library(shiny)
library(leaflet)
library(data.table)
library(plotly)
library(shinyWidgets)
library(googleVis)
library(geosphere)
library(leaflet.extras)
library(shinythemes)

setwd("/Users/jacob/Desktop/FALL 2019/Applied Data Science/fall2019-proj2--sec2-grp8/data")

activities <- read.csv("activities_processed.csv")

crime_data <- read.csv("teen_data.csv")

kid_activity <- activities[activities$Grade.Level...Age.Group == "Elementary",]
middle_activity <- activities[activities$Grade.Level...Age.Group == "Middle School",]
high_activity <- activities[activities$Grade.Level...Age.Group == "High School",]

marker_opt <- markerOptions(opacity = 0.7, riseOnHover = TRUE)

crimes_within <- function(r,long,lat){return(crime_data[distCosine(c(long,lat),crime_data[,c("Longitude","Latitude")])<=r,])} 
### pallette for circle fill color #6666cc  #3333cc
pal <- colorNumeric("#666699",c(0,1), na.color = "#808080" )
shinyServer(function(input, output,session) {
  
  ## Map Tab section
  
  output$map <- renderLeaflet({
    m <- leaflet() %>%
      addProviderTiles("CartoDB.Positron", 
                       options = providerTileOptions(noWrap = TRUE)) %>%
                        setView(-73.9463,40.6641,zoom = 12) %>%
                        addResetMapButton()
            
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
    if("Elementary School" %in% input$enable_markers) leafletProxy("map") %>% showGroup("kid_activity")
    else{leafletProxy("map") %>% hideGroup("kid_activity")}
    if("Middle School" %in% input$enable_markers) leafletProxy("map") %>% showGroup("middle_activity")
    else{leafletProxy("map") %>% hideGroup("middle_activity")}
    if("High School" %in% input$enable_markers) leafletProxy("map") %>% showGroup("high_activity")
    else{leafletProxy("map") %>% hideGroup("high_activity")}
  }, ignoreNULL = FALSE)
  
## show the crime data around the location along with popups
observeEvent(input$map_click, {
    if(!input$click_multi)leafletProxy("map") %>% clearGroup(c("circles","centroids",paste(crime_data$LAW_CAT_CD, rep(1:24, each = 7))))
    click <- input$map_click
    clat <- click$lat
    clong <- click$lng
    radius <- input$click_radius
    address <- NULL
    if(input$click_show_address) address <-  revgeocode(c(clong,clat))
    #output info
    output$click_coord <- renderText(paste("Latitude:",round(clat,7),", Longitude:",round(clong,7)))
    output$click_address <- renderText(address)
    ## calculated noise info
    crimes_within_range <- crimes_within(input$click_radius, clong, clat)
    ### need weighted avg here
    crimes_total <- nrow(crimes_within_range)
    crimes_per_day <- crimes_total / 365
    crimes_per_day_area <- crimes_per_day / (radius/100)^2
    
    #danger index
    output$click_crimes_total <- renderText(crimes_total)
    output$click_crimes_per_day <- renderText(round(crimes_per_day,2))
    output$click_crimes_per_day_area <- renderText(round(crimes_per_day_area, 2))
   
    #circles
    leafletProxy('map') %>%
      addCircles(lng = clong, lat = clat, group = 'circles',
                 stroke = TRUE, radius = radius, 
                 popup = paste("CRIME LEVEL: ", round(click_crimes_per_day_area,2), sep = ""),
                 color = '#3333cc', opcity = 1, weight = 1,
                 fillColor = pal(click_crimes_per_day_area),fillOpacity = 0.5) %>%
      addCircles(lng = clong, lat = clat, group = 'centroids', radius = 1, weight = 2,
                 color = 'black',opacity = 1,fillColor = 'black',fillOpacity = 1)
    #draw dots for every single crime within range
    crimes_within_range <- merge(crimes_within_range,crime_data,by = c("CMPLNT_NUM","CMPLNT_NUM"), all.y = F)
    leafletProxy('map', data = crimes_within_range) %>%
      addCircles(~Longitude,~Latitude, group = ~ paste(LAW_CAT_CD), stroke = F, 
                 radius = 12, fillOpacity = 0.3)
  })
  
  
  
  
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

