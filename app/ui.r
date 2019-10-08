library(shiny)
library(leaflet)
library(data.table)
library(plotly)
library(shinythemes)
library(shinyWidgets)



shinyUI(
  div(id="canvas",
      
      navbarPage(strong("Are Children Living in Danger?",style="color: white;"), 
                 theme=shinytheme("cerulean"),
                 #theme = "bootstrap.min.css",
                 #theme="styles.css",
                 
                 tabPanel("Intro",
                          
                          mainPanel(width=12,
                                    setBackgroundImage(
                                      src = "../FullSizeRender.jpg"
                                    ),
                                    
                                    style = "opacity: 0.80",
                                    h1("Are Children Safe During After-school Activities?"),
                                    h3("News:"),
                                    h3("Dulce Maria Alavez, A 5-Year-Old Girl Went Missing From a Playground in New Jersey"),
                                    p("Dulce went missing on the afternoon of Sept. 
                                      16 while her mother in the car with the 8-year-old son, roughly 30 yards away. The mother is still seeking 
                                      for information about her daughter two weeks after the girl is believed to have been abducted from a local park."),
                                    p(em(a("New York Times",href="https://www.nytimes.com/2019/10/01/nyregion/missing-child-nj-dulce-alavez.html"))),

                                    h3("Boy who was sucker-punched at Moreno Valley school dies from injuries"),
                                    p("Diego, a boy who was critically injured last week after being sucker-punched at school 
                                      in an assault captured on video died Tuesday night. Diego appears to hit his head on a concrete.He died after sending 
                                      to the hospital in a extremely critical condition.
                                      "),
                                    p(em(a("Los Angeles Times",href="https://www.latimes.com/california/story/2019-09-25/boy-sucker-punched-moreno-valley-school-dies-from-injuries"))),
                                    
                                    
                                    h2("Our Motivation"),
                                    p("Developing an App that relates the crimes related to kids or teenagers with places where children spend the most, for instance, after-school activities spots. Inspired by how the Amber Alarm works, We want to develop visualization and give children warnings of certain areas even before they are in danger.
                                      "),
                                    p(),
                                    p(em(a("Github link",href="https://github.com/TZstatsADS/fall2019-proj2--sec2-grp8")))
                                    ),
                          div(class="footer", "Group Project by Lihao Xiao, Dingyi Fang, Mo Yang, Thomson Batidzirai, Sixuan Li")
                                    ),
                 
                 tabPanel("Map",
                          div(class="outer",
                              leafletOutput("map",width="100%",height=700),
                              
                              
                              absolutePanel(id = "control", class = "panel panel-default", fixed = TRUE, draggable = TRUE,
                                            top = 170, left = 20, right = "auto", bottom = "auto", width = 250, height = "auto",
                                            
                                            checkboxGroupInput("enable_markers", "Children Grades for Activities Search:",
                                                               choices = c("Elementary School","Middle School","High School"),
                                                               selected = c("Elementary School","Middle School","High School")),
                                           
                                            sliderInput("click_radius", "Radius of area around  the selected address", min=500, max=3000, value=250, step=10),
                                            
                                            checkboxGroupInput("click_violence_type", "Violence Types",
                                                               choices =c("VIOLATION","MISDEMEANOR", "FELONY"), selected =c("VIOLATION","MISDEMEANOR", "FELONY")),
                                            actionButton("click_all_crime_types", "Select ALL"),
                                            actionButton("click_none_crime_types", "Select NONE"),
                              
                                            sliderInput("from_hour", "Starting Time", min=0, max=23, value=0, step=1),
                                            sliderInput("to_hour", "End Time", min=0, max=23, value=23, step=1),
                                            style = "opacity: 0.80"
                                            
                              ),
                              
                              absolutePanel(id = "controls", class = "panel panel-default", fixed= TRUE, draggable = TRUE,
                                            top = 70, left = "auto", right = 20, bottom = "auto", width = 320, height = "auto",
                                            h3("Summary of the Covered Area"),
                                            h4("The Geographical Information"),
                                            p(textOutput("click_coord")),
                                            h4("The Danger Index"),
                                            p(strong(textOutput("click_danger_index_red", inline = T))),
                                            tags$head(tags$style("#click_danger_index_red{color: red;
                                            font-size: 20px;
                                            font-style: italic;
                                            }"
                                            )
                                            ),
                                            p(strong(textOutput("click_danger_index_orange", inline = T))),
                                            tags$head(tags$style("#click_danger_index_orange{color: orange;
                                            font-size: 20px;
                                            font-style: italic;
                                            }"
                                            )
                                            ),
                                            p(strong(textOutput("click_danger_index_green", inline = T))),
                                            tags$head(tags$style("#click_danger_index_green{color: green;
                                            font-size: 20px;
                                                                 font-style: italic;
                                                                 }"
                                            )
                                            ),
                                            h4("Number of Crimes in Selected Area"),
                                            p(strong(textOutput("click_crimes_total", inline = T)), " in total (year 2018)."),
                                            p(strong(textOutput("click_crimes_per_day", inline = T)), " per day."),
                                
                                            br(),
                                            h4("Bar chart of the distribution of crimes"),
                                            style = "opacity: 0.80",
                                            br(),
                                            plotlyOutput("click_crime_pie",height="300")
                              )
                              
                          )        
                 ),
                 tabPanel("Heatmap Crime Danger Index",
                 titlePanel("Heat Map: After-School Facilities (NYC)"),
                 
                 sidebarLayout(
                   
                   # Sidebar panel for inputs ----
            
                   
                   # Main panel for displaying outputs ----
                   mainPanel(
                     # Output: Heat Map ----
                     leafletOutput("heatMap",width="100%",height=700)),
                     sidebarPanel(
                       
                       # Input: Slider for time of the day ----
                       
                       
                       sliderInput(inputId = "time",
                                   label = "Select time (in hours):",
                                   min = 0,
                                   max = 23,
                                   value = 12)
                     )
                   
                 )
                 ),
                 
                 tabPanel("Statistics Analysis",
                          h2("Summary Statistics"),
                          
                          wellPanel(style = "overflow-y:scroll; height: 850px; max-height: 750px; background-color: #ffffff;",
                                    tabsetPanel(type="tabs",
                                                
                                                tabPanel(title="Crime Rate By borough by hour",
                                                         br(),
                                                         div(plotlyOutput("stat_plot_ts_crime"), align="center")
                                                         
                                                ),
                                                tabPanel(title="The Pie Chart Sumnmary of the Crime",
                                                         br(),
                                                         div(plotlyOutput("crime_type"), align="center")
                                                         
                                                ),
                                                tabPanel(title="Children Activities Spots Information",
                                                         br(),
                                                         div(img(src="Bar_plot_activities.png", width="90%"), align="center" )
                  
                                                )
                                                
                                                
                                    )
                          )
                 ),
                 
                 
                 tabPanel("Data Search",
                          div(width = 12,
                              h1("The Data Summary of Crime Data"), # title for data tab
                              br(),
                              dataTableOutput('table1'),
                              
                              h1("The Data Summary of Activities Data"), # title for data tab
                              br(),
                              dataTableOutput('table2')
                          ),
                          # footer
                          div(class="footer", em(a("Data origniated from NYC Open Data",href="https://opendata.cityofnewyork.us")))
                          
                 )
                 
                                    )
      
                          )
                 )   


