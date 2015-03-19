library(shiny)
source("helpers.R")
require(rCharts)

shinyServer(function(input, output) {
  
  # -------------
  # Reactive data
  # -------------
  
  data.days <- reactive({
    as.integer (input$date - input$birthday)
  })
  
  data.pecentilWeight <- reactive({
    weight.percentil (input$gender, data.days(), as.numeric (input$weight))
  })
  
  data.pecentilHeight <- reactive({
    height.percentil (input$gender, data.days(), as.numeric (input$height))
  })
  
  # -----------
  # Output text
  # -----------
  
  output$age <- renderText({ 
    paste(data.days(), " days - ", round(data.days()/7,0), ".", data.days()%%7, "weeks")
  })
  
  output$wText <- renderText({
    if (is.na(as.numeric(input$weight))) {
      paste ("p 50: ",
             weight.value (input$gender, data.days(), 0.5),
             " Kg")
    }
    else {
      paste ("p 50: ",
             weight.value (input$gender, data.days(), 0.5),
             " Kg | p ",
             round(data.pecentilWeight() * 100, 0))
    }    
  })
  
  output$hText <- renderText({
    if (is.na(as.numeric(input$height))) {
      paste ("p 50: ",
             height.value (input$gender, data.days(), 0.5),
             " cm")
    }
    else {
      paste ("p 50: ",
             height.value (input$gender, data.days(), 0.5),
             " cm | p ",
             round(data.pecentilHeight() * 100, 0))
    }
  })
  
  # -----------
  # Output plot
  # -----------
  
  output$weightPlot <- renderChart({
    
    year <- round(data.days() / 365, 0)
    ini <- 365 * year
    end <- 365 * (year+1)
    plotData = weianthro [weianthro$sex == input$gender & weianthro$age > ini & weianthro$age < end,] 
    
    currentPercentil <- mapply (fvalue, plotData$l, plotData$m, plotData$s, data.pecentilWeight())
    
    h1 <- Highcharts$new()
    h1$chart(type = "spline")
    h1$title(text = 'Weight: percentile evolution', x = -20)
    h1$subtitle(text = paste(year+1, 'th year'), x = -20)
    h1$xAxis(title = list(text = 'Days'), labels=list(overflow='justify'), categories = plotData$age, tickInterval=31)
    h1$yAxis(title = list(text = 'Weight (kg)', plotlines = list (value = 0, width = 1, color = '#808080')))
    h1$tooltip(valueSuffix = 'Kg')
    h1$plotOptions(spline = list(lineWidth=3, states=list(hover=list(lineWidth=6)), marker=list(enabled=0)))
    
    if (!is.na(as.numeric(input$weight))) {
      h1$series(name = paste ('p', round(data.pecentilWeight() * 100, 0)), data = currentPercentil, dashStyle = "shortdot")
    }
    
    h1$series(name = 'p5', data = plotData$p5)
    # h1$series(name = 'p10', data = plotData$p10)
    # h1$series(name = 'p20', data = plotData$p20)
    #h1$series(name = 'p20', data = plotData$p20)
    # h1$series(name = 'p30', data = plotData$p30)
    # h1$series(name = 'p40', data = plotData$p40)
    h1$series(name = 'p50', data = plotData$p50)
    # h1$series(name = 'p60', data = plotData$p60)
    # h1$series(name = 'p70', data = plotData$p70)
    #h1$series(name = 'p80', data = plotData$p80)
    # h1$series(name = 'p90', data = plotData$p90)
    h1$series(name = 'p95', data = plotData$p95)
    h1$legend(layout = 'vertical', align = 'right', verticalAlign='middle', borderWidth=1)
    h1$addParams(dom='weightPlot')
    return(h1)
    
  })
  
  output$heightPlot <- renderChart({
    
    year <- round(data.days() / 365, 0)
    ini <- 365 * year
    end <- 365 * (year+1)
    plotData = lenanthro [lenanthro$sex == input$gender & lenanthro$age > ini & lenanthro$age < end,] 
    
    currentPercentil <- mapply (fvalue, plotData$l, plotData$m, plotData$s, data.pecentilHeight())
    
    h1 <- Highcharts$new()
    h1$chart(type = "spline")
    h1$title(text = 'Height: percentile evolution', x = -20)
    h1$subtitle(text = paste(year+1, ' th year'), x = -20)
    h1$xAxis(title = list(text = 'Days'), labels=list(overflow='justify'), categories = plotData$age, tickInterval=31)
    h1$yAxis(title = list(text = 'Height (cm)', plotlines = list (value = 0, width = 1, color = '#808080')))
    h1$tooltip(valueSuffix = 'cm')
    h1$plotOptions(spline = list(lineWidth=3, states=list(hover=list(lineWidth=6)), marker=list(enabled=0)))
    
    if (!is.na(as.numeric(input$height))) {
      h1$series(name = paste ('p', round(data.pecentilHeight() * 100, 0)), data = currentPercentil, dashStyle = "shortdot")
    }
    
    h1$series(name = 'p5', data = plotData$p5)
    # h1$series(name = 'p10', data = plotData$p10)
    # h1$series(name = 'p20', data = plotData$p20)
    # h1$series(name = 'p20', data = plotData$p20)
    # h1$series(name = 'p30', data = plotData$p30)
    # h1$series(name = 'p40', data = plotData$p40)
    h1$series(name = 'p50', data = plotData$p50)
    # h1$series(name = 'p60', data = plotData$p60)
    # h1$series(name = 'p70', data = plotData$p70)
    # h1$series(name = 'p80', data = plotData$p80)
    # h1$series(name = 'p90', data = plotData$p90)
    h1$series(name = 'p95', data = plotData$p95)
    h1$legend(layout = 'vertical', align = 'right', verticalAlign='middle', borderWidth=1)
    h1$addParams(dom='heightPlot')
    return(h1)
    
  })
  
})