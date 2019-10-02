library(shiny)
library(leaflet)
library(data.table)
library(plotly)
library(shinyWidgets)

shinyUI(
  div(id="canvas",
      
      navbarPage(strong("Are Children Living in Danger?",style="color: black;"), theme="styles.css",
                 
                 tabPanel("Intro",
                        
                          mainPanel(width=12,
                                    
                                    h1("Are Children Safe During Their School and Afdter-school Activities?"),
                                    h3("News 1:"),
                                    h3("Dulce Maria Alavez, A 5-Year-Old Girl Went Missing From a Playground in New Jersey"),
                                    p("According to the New York Times, in BRIDGETON, N.J.-Dulce went missing on the afternoon of Sept. 
                                      16 after her mother,Noema Alavez Perez, took her, her 3-year-old brother and her 8-year-old cousin 
                                      to get ice cream at a neighborhood convenience store.Dulce disappeared while Ms. Alavez Perez sat 
                                      in the car with the 8-year-old, roughly 30 yards away. The mother is still desperately seeking 
                                      for information about her daughtertwo weeks after the girl is believed to have been abducted from a local park."),
                                     
                                    h3("News 2:"),
                                    h3("Boy who was sucker-punched at Moreno Valley school dies from injuries"),
                                    p("According to LA Times, Diego, a boy who was critically injured last week after being sucker-punched at school 
                                      in an assault captured on video died Tuesday night.A video posted to Facebook shows a boy punching Diego, who is 
                                      then struck by a third person standing out of frame. Diego appears to hit his head on a concrete pillar as he falls 
                                      to the ground. The assailant who threw the first punch strikes the boy again before running away. He died after sending 
                                      to the hospital in a extremely critical condition.
                                      "),
                                    
                                    
                                    h2("Our Motivation"),
                                    p("Devloping an App that relates the crimes whose victims are kids or teenages with places where 
                                        children spend the most, for instance schools and after-school activities spots.Inspired by how the Amber 
                                        Alarm works, We want to develop a visualization and give children warnings of certain areas even before 
                                        they are in danger.
                                        "),
                                    h2("Project contents"),
                                    p("The projects decomposes into several sections that help children and their parents to get a sense of if children are in potential danger."),
                                    br(),
                                      p("   - ",strong("Map Visualization"), ": xxxxx"),
                                    p("   - ",strong("Statistics Anlysis"),": xxx" ),
                                    p("   - ",strong("Database Search"),": A page designed for searching particular crime data, school and after-school activities information that interest the users. Users
                                      can serach for keywords and get basic written records of the data analyzed in the previous sections." ),
                                    
                                    h2("Techical Terms Explaination in this app"),
                                    p("Danger Index:"),
                                    p(),
                                  
                                    p(em(a("Github link",href="https://github.com/TZstatsADS/fall2019-proj2--sec2-grp8")))
                                    ),
                          div(class="footer", "Group Project by xxx xxx xxx")
                                    ),
                 
                 tabPanel("Map",
                          div(class="outer",
                              leafletOutput("map", width="100%", height="100%"),
                              
                              
                              absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE, draggable = TRUE,
                                            top = 120, left = 20, right = "auto", bottom = "auto", width = 250, height = "auto",
                                            h3("xxxxxxxx"),
                                            checkboxGroupInput("enable_markers", "Children Grades:",
                                                               choices = c("Elementray School","Middle School","High School"),
                                                               selected = c("Elementray School","Middle School","High School")),
                                            sliderInput("click_radius", "Radius of area around  the selected address", min=100, max=1000, value=100, step=5),
                                            checkboxInput("click_multi", "Compare among multiple locations",value = F),
                                            actionButton("clear_circles", "Clear all circles")
                              ),
                              
                              absolutePanel(id = "controls", class = "panel panel-default", fixed= TRUE, draggable = TRUE,
                                            top = 120, left = "auto", right = 20, bottom = "auto", width = 320, height = "auto",
                                            h3("Summary of the Covered Area"),
                                            h4("The Geographical Information"),
                                            #p(textOutput("click_coord")),
                                            h4("The Danger Index"),
                                            h4("Number of noise complaints"),
                                            #p(strong(textOutput("click_complaints_total", inline = T)), " in total (year 2015)."),
                                            #p(strong(textOutput("click_complaints_per_day", inline = T)), " per day."),
                                            #p(strong("Noise level"), "(Number of complaints per day per 100m radius area):", strong(textOutput("click_complaints_per_day_area", inline = T))),
                                            #plotlyOutput("click_complaint_timedist", height="100"),
                                            br(),
                                            h4("Bar chart of the distribution of crimes")
                                            #uiOutput("click_complaints_hour_text"),
                                            #plotlyOutput("click_complaint_pie",height="300")
                              ),
                              
                              absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE, draggable = TRUE,
                                            top=120, left=270, right='auto', bottom="auto", width=200, height="auto",
                                            #checkboxGroupInput("click_violence_type", "Violence Types",
                                            #                   choices = complaint$type, selected = complaint$type),
                                            actionButton("click_all_complaint_types", "Select ALL"),
                                            actionButton("click_none_complaint_types", "Select NONE"),
                                            checkboxInput("click_enable_hours", "Seperate hours",value = F)
                                            #uiOutput("click_hours")
                              )
                              
                          )        
                 ),
                 
                 
                 tabPanel("Statistics Analysis",
                          h2("Summary Statistics"),
                          
                          wellPanel(style = "overflow-y:scroll; height: 850px; max-height: 750px; background-color: #ffffff;",
                                    tabsetPanel(type="tabs",
                                                tabPanel(title="Stat1",
                                                         br()
                                                         #div(plotlyOutput("stat_plot_ts"), align="center")
                                                ),
                                                tabPanel(title="Stat2",
                                                         br()
                                                         #div(img(src="img/stat_time_distribution.png", width=800), align="center")
                                                ),
                                                tabPanel(title="Stat3",
                                                         br()
                                                         #div(img(src="img/stat_plot_heatmap.png", width="90%"), align="center" )
                                                ),
                                                tabPanel(title="Stat4",
                                                         br()
                                                         #div(htmlOutput("stat_plot_doughnut"), align="center")
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
