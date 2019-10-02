library(shiny)

shinyServer(function(input, output) {
  
  # The activities data display column in the Data Search Column  
  output$table1 <- renderDataTable(activities,options = list(pageLength = 10, lengthMenu = list(c(10)))
  )
  
  # The crime data display column in the Data Search Column  
  output$table2 <- renderDataTable(crime,options = list(pageLength = 10, lengthMenu = list(c(10)))
  )
})

