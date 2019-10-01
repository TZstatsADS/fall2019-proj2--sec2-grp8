library(shiny)

shinyServer(function(input, output) {
  output$table <- renderDataTable(noise311,options = list(pageLength = 10, lengthMenu = list(c(10)))
  )
})