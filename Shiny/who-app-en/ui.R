library(shiny)
require(rCharts)

# Define UI the application 
shinyUI(fluidPage(
  
  # Row 1: Header
  fluidRow (
    column(10, offset=1,
       includeHTML("Intro.html"),
       br()
    )  
  ),
  
  # Row 2: Filters Gender & Dates
  fluidRow (    
    column(2, offset=1, radioButtons("gender", "", c("Male" = 1, "Female" = 2))),
    column(2, dateInput ("birthday", label = "Birthday date", value = '2014-11-24')),
    column(2, dateInput ("date", label = "Measure date")),
    column(4, textOutput("age"))
  ),
  
  # Row 3: Filters weight & height
  fluidRow (
    column(2, offset=3, textInput("weight", label = ("Weight (Kg)"))),
    column(2, textInput("height", label = ("Height (cm)"))),
    column(4, 
           textOutput("wText"),
           textOutput("hText")
    )           
  ),
    
  # Row 4: Output
  fluidRow (
  
    # Columns 1: Output
    column(10, offset=1,
       br(),
       showOutput("weightPlot","highcharts"),
       br(),
       showOutput("heightPlot","highcharts")      
    )    
  )
  
))