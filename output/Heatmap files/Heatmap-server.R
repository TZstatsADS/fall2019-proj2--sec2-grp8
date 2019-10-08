library(shiny)
library(leaflet)
library(leaflet.extras)
library(tigris)
library(sp)


teen_data_by_hour<-read.csv("../output/teen_data_by_hour.csv")
load("../output/dfa.RData")

dfa_plot= dfa%>% sample_n(200)

server <- function(input, output) {

  
  output$heatMap <- renderLeaflet({
    teen_data_by_HR<-subset(teen_data_by_hour,Hour %in% c(input$time))
    teen_data_by_HR%>%
      leaflet(width = "100%") %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addProviderTiles(providers$Stamen.TonerHybrid) %>%
      setView(-74.00, 40.71, zoom = 11 ) %>%
      addHeatmap(lng = teen_data_by_HR$Longitude, lat = teen_data_by_HR$Latitude, intensity = ifelse(teen_data_by_HR$LAW_CAT_CD=="FELONY",3,ifelse(teen_data_by_HR$LAW_CAT_CD=="MISDEMEANOR",2,1)),
                 blur = 20, max = 0.05, radius = 10
      )%>%
      addCircleMarkers(dfa_plot$Longitude, lat = dfa_plot$Latitude,fillColor = "black", color="black", fillOpacity = 1, radius=2)
    
    
  })
}
