library(shiny)
library(leaflet)
library(data.table)
library(plotly)
library(shinyWidgets)
library(googleVis)
library(geosphere)
library(leaflet.extras)
library(ggmap)

source("global.R")

#Get the Google API
register_google(key = "AIzaSyAXxi_jjBKmoortYOFU1WeenatppEgJgdc")

marker_opt <- markerOptions(opacity = 0.7, riseOnHover = TRUE)

### pallette for circle fill color #6666cc  #3333cc
pal <- colorNumeric("#666699",c(0,1), na.color = "#808080" )

shinyServer(function(input, output,session) {
  
  ## Map Tab section
  
  output$map <- renderLeaflet({
    m <- leaflet() %>%
      addProviderTiles("CartoDB.Positron", 
                       options = providerTileOptions(noWrap = TRUE)) %>%
      setView(-73.9252853,40.7910694,zoom = 13) %>%
      addResetMapButton()
    
    #plot kids activities
    leafletProxy("map", data = kid_activity) %>%
      addMarkers(~Longitude, ~Latitude,
                 group = "kid_activity" ,
                 options = marker_opt, popup = ~ paste0("<b>",SITE.NAME,"</b>",
                                                        "<br/>", "Danger Index: ", Danger_Index,
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
                                                          "<br/>", "Danger Index: ", Danger_Index,
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
                                                          "<br/>", "Danger Index: ", Danger_Index,
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
  
  observeEvent(input$map_click, {
    #if(!input$click_multi) 
    leafletProxy("map") %>% clearGroup(c("circles","centroids",crime_type$LAW_CAT_CD))
    click <- input$map_click
    clat <- click$lat
    clong <- click$lng
    radius <- input$click_radius
    
    #output info
    output$click_coord <- renderText(paste("Latitude:",round(clat,7),", Longitude:",round(clong,7)))
    ## calculated noise info
    #if(input$click_enable_hours){
      f_hour <- input$from_hour 
      t_hour <- input$to_hour
      crimes_within_range <- crimes_within(input$click_radius, clong, clat)
      if(input$from_hour<=input$to_hour){
        crimes_within_range  <- crimes_within_range[(crimes_within_range$Hour>=f_hour)&(crimes_within_range$Hour<=t_hour),]
      }
      else{
        crimes_within_range  <- crimes_within_range[(crimes_within_range$Hour>=f_hour)|(crimes_within_range$Hour<=t_hour),]
      }

    
    ### need weighted avg here
    
    crimes_total <- nrow(crimes_within_range)
    crimes_per_day <- crimes_total / 365
    total_index <- sum(crimes_within_range$Severity)
   
    
    #danger index
    if(t_hour==f_hour){
      danger_index <- (total_index/(radius/1000)^2)*24
    }
    else if(t_hour>f_hour){
      danger_index <- (total_index/(radius/1000)^2)*24/(t_hour-f_hour)
    }
    else{
      danger_index <- (total_index/(radius/1000)^2)*24/(24+t_hour-f_hour)
    }
    
    if(danger_index> 650){
      output$click_danger_index_red <- renderText(round(danger_index,2))
      output$click_danger_index_green <- renderText({})
      output$click_danger_index_orange <- renderText({})
    }
    else if(danger_index<250){
      output$click_danger_index_green <- renderText(round(danger_index,2))
      output$click_danger_index_red <- renderText({})
      output$click_danger_index_orange <- renderText({})
    }
    else{
      output$click_danger_index_orange <- renderText(round(danger_index,2))
      output$click_danger_index_green <- renderText({})
      output$click_danger_index_red <- renderText({})
    }
    
    output$click_crimes_total <-renderText(crimes_total)
    output$click_crimes_per_day <- renderText(round(crimes_per_day,2))
    output$click_danger_index <- renderText(round(danger_index, 2))
    
    leafletProxy('map') %>%
      addCircles(lng = clong, lat = clat, group = 'circles',
                 stroke = TRUE, radius = radius,popup = paste("CRIME LEVEL: ", round(danger_index,2), sep = ""),
                 color = 'black', weight = 1
                 ,fillOpacity = 0.5)%>%
      addCircles(lng = clong, lat = clat, group = 'centroids', radius = 1, weight = 2,
                 color = 'black',fillColor = 'black',fillOpacity = 1)
    
    crimes_within_range <- merge(crimes_within_range,crime_type,by = c("LAW_CAT_CD","LAW_CAT_CD"), all.y = F)
    
    leafletProxy('map', data = crimes_within_range) %>%
      addCircles(~Longitude,~Latitude, group =~LAW_CAT_CD, stroke = F,
                 radius = 12, fillOpacity = 0.8,fillColor=~color.x)
    
    
    
    
    #Distribution of the Types of Crime
    output$click_crime_pie <- renderPlotly({
    ds <- table(crimes_within_range$LAW_CAT_CD)
    pie_title <- paste("Crime type ","from ",input$from_hour,"h to ",input$to_hour,"h",sep="")
    ds <- ds[crime_type$LAW_CAT_CD]
    ds[is.na(ds)] <- 0
    #ds <- data.frame(ds)
    #names(ds) <- c("Type", "Frequency")
    plot_ly(labels=crime_type$LAW_CAT_CD, values=ds, type = "pie",
            marker=list(colors=crime_type$color)) %>%
      layout(title = pie_title,showlegend=F,
             xaxis=list(showgrid=F,zeroline=F,showline=F,autotick=T,ticks='',showticklabels=F),
             yaxis=list(showgrid=F,zeroline=F,showline=F,autotick=T,ticks='',showticklabels=F))
    
    })
    
    #activities_within_range <- activities_within(input$click_radius, clong, clat)
    
    
  })
  
  # Select the types of the crimes to be  visualize
  observeEvent(input$click_violence_type, {
    
      for(type in crime_type$LAW_CAT_CD){
        if(type %in% input$click_violence_type) leafletProxy("map") %>% showGroup(type)
        else{leafletProxy("map") %>% hideGroup(type)}
    }
    
  }, ignoreNULL = FALSE)
  
  # Select all or none of the crimes to be  visualize
  observeEvent(input$click_all_crime_types, {
    updateCheckboxGroupInput(session, "click_violence_type",
                             choices = crime_type$LAW_CAT_CD,
                             selected =crime_type$LAW_CAT_CD)
  })
  observeEvent(input$click_none_crime_types, {
    updateCheckboxGroupInput(session, "click_violence_type",
                             choices = crime_type$LAW_CAT_CD,
                             selected = NULL)
  })
  
  ## Statistics Part
  
  output$stat_plot_ts <- renderPlotly(plot1)
  output$crime_type <- renderPlotly(p)
  output$heatMap <- renderLeaflet({
    teen_data_by_HR<-subset(teen_data_by_hour,Hour %in% c(input$time))
    teen_data_by_HR%>%
      leaflet(width = "100%") %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addProviderTiles(providers$Stamen.TonerHybrid) %>%
      setView(-73.8767716,40.7379555,zoom = 10) %>%
      addHeatmap(lng = teen_data_by_HR$Longitude, lat = teen_data_by_HR$Latitude, intensity = ifelse(teen_data_by_HR$LAW_CAT_CD=="FELONY",10,ifelse(teen_data_by_HR$LAW_CAT_CD=="MISDEMEANOR",4,1)),
                 blur = 15, max = 0.05, radius = 12
      )
    
  })
  
  output$stat_plot_ts_crime <- renderPlotly(plot_muliti_crime)
  
  # The activities data display column in the Data Search Column  
  output$table1 <- renderDataTable(activities,
                                   options = list(pageLength = 10, lengthMenu = list(c(10))))
  # The crime data display column in the Data Search Column  
  output$table2 <- renderDataTable(crime,
                                   options = list(pageLength = 10, lengthMenu = list(c(10))))
})


