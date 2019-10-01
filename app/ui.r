library(shiny)
library(leaflet)
library(data.table)
library(plotly)

shinyUI(
  div(id="canvas",
      
      navbarPage(strong("Are we safe in daily activities?",style="color: white;"), theme="styles.css",
                 tabPanel("Intro",
                          mainPanel(width=12,
                                    h1("Are Children safe during their afdter-school activities?-  A shiny app projrct driven by NYC open data"),
                                    h2("News1"),
                                    p("Are Children safe during their afdter-school activities?-  
                                      A shiny app projrct driven by NYC open dataAre Children safe during their afdter-school activities?-
                                      A shiny app projrct driven by NYC open dataAre Children safe during their afdter-school activities?-  
                                      A shiny app projrct driven by NYC open data"),
                                    h2("News2"),
                                    p("Are Children safe during their afdter-school activities?-  
                                      A shiny app projrct driven by NYC open dataAre Children safe during their afdter-school activities?-
                                      A shiny app projrct driven by NYC open dataAre Children safe during their afdter-school activities?-  
                                      A shiny app projrct driven by NYC open data"),
                                    h2("Our Motivation"),
                                    p("Are Children safe during their afdter-school activities?-  
                                      A shiny app projrct driven by NYC open dataAre Children safe during their afdter-school activities?-
                                      A shiny app projrct driven by NYC open dataAre Children safe during their afdter-school activities?-  
                                      A shiny app projrct driven by NYC open data"),
                                    h2("Project content"),
                                    p("A shiny app projrct driven by NYC open dataAre Children safe during their afdter-school activities?"),
                                    br(),
                                    p("   - ",strong("Section 1"), ": presents 3 visualizations of"),
                                    p("   - ",strong("Section 2"),": enables users to pinpoint any location in" ),
                                    p("   - ",strong("Section 3"),": enables users to pinpoint any location in" ),
                                    h2("Techical Terms Explaination in this app"),
                                    p("Danger Index:"),
                                    p(),
                                    h2("Our Goals"),
                                    p("Are Children safe during their afdter-school activities?-  
                                      A shiny app projrct driven by NYC open dataAre Children safe during their afdter-school activities?-
                                      A shiny app projrct driven by NYC open dataAre Children safe during their afdter-school activities?-"),
                                    p(em(a("Github link",href="https://github.com/TZstatsADS/Fall2016-Proj2-grp8")))
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
                              dataTableOutput('table'),
                              
                              h1("The Data Summary of Activities Data"), # title for data tab
                              br()
                          ),
                          # footer
                          div(class="footer", em(a("Data origniated from NYC Open Data",href="https://opendata.cityofnewyork.us")))
                          
                 )
                 
                                    )
      
                                    )
      )   
