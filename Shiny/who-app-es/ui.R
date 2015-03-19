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
    column(2, offset=1, radioButtons("gender", "", c("Hombre" = 1, "Mujer" = 2))),
    column(2, dateInput ("birthday", label = "F. nacimiento", format="dd-mm-yyyy", value = '2014-11-24')),
    column(2, dateInput ("date", label = "F. medida", format="dd-mm-yyyy")),
    column(4, textOutput("age"))
  ),
  
  # Row 3: Filters weight & height
  fluidRow (
    column(2, offset=3, textInput("weight", label = ("Peso (Kg)"))),
    column(2, textInput("height", label = ("Estatura (cm)"))),
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