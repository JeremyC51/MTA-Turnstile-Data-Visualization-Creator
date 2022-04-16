#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

default_date = "10/11/2014"
turnstile_data <- read.csv("final_data.csv")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  

  
    # HISTOGRAMS
    output$distPlot1 <- renderPlot({
        # Filter data by date and filtering out absurd values
        data <- dplyr::filter(turnstile_data, DATE == input$chosen_date1 & ENTRIES < 50000)
        # Grab entry data
        x    <- data[,3]
        binsEntry <- seq(min(x), max(x), length.out = input$binsEntry + 1)

        # draw the histogram with the specified number of bins
        hist(x, 
             breaks = binsEntry, 
             col = input$colorsEntry, 
             border = input$borderEntry, 
             main = paste("Frequency of Subway Station Turnstile Entries on", input$chosen_date1), 
             xlab = "Subway Station Turnstile Entries",
             cex.lab=input$fontEntry / 100, 
             cex.axis=input$fontEntry / 100, 
             cex.main=input$fontEntry / 100, 
             cex.sub=input$fontEntry / 100)

    })
    
    output$distPlot2 <- renderPlot({
      # Filtering data by date and filtering out absurd values
      data <- dplyr::filter(turnstile_data, DATE == input$chosen_date1 & EXITS < 50000)
      # Grab entry data
      x <- data[,4]
      binsExit <- seq(min(x), max(x), length.out = input$binsExit + 1)
      
      # draw the histogram with the specified number of bins
      hist(x, 
           breaks = binsExit, 
           col = input$colorsExit, 
           border = input$borderExit, 
           main = paste("Frequency of Subway Station Turnstile Exits on", input$chosen_date1), 
           xlab = "Subway Station Turnstile Exits",
           cex.lab=input$fontExit / 100, 
           cex.axis=input$fontExit / 100, 
           cex.main=input$fontExit / 100, 
           cex.sub=input$fontExit / 100)
      
      
    })
    
    # LEAFLET MAP
    output$leafletMap <- renderLeaflet({
      # Filtering data by date
      data <- dplyr::filter(turnstile_data, DATE == input$chosen_date2)
      
      leaflet(data) %>%  
        addProviderTiles("CartoDB.Positron", group = "CartoDB Positron Map",options = providerTileOptions(minZoom = 11, maxZoom = 22)) %>%
        addProviderTiles("CartoDB.DarkMatter", group = "CartoDB DarkMatter Map", options = providerTileOptions(minZoom = 11, maxZoom = 22)) %>%
        addProviderTiles("Stamen.TonerLite", group = "Stamen TonerLite Map", options = providerTileOptions(minZoom = 11, maxZoom = 22)) %>%
        addProviderTiles("OpenStreetMap.Mapnik", group = "OSM Mapnik Map", options = providerTileOptions(minZoom = 11, maxZoom = 22)) %>% 
        addLayersControl(baseGroups = c("OSM Mapnik Map","Stamen TonerLite Map", "CartoDB Positron Map","CartoDB DarkMatter Map"), options = layersControlOptions(collapsed = TRUE)) %>%
        setView(-73.942112, 40.712514, zoom = 11) %>% 
        addMarkers(lng = data[,6],
                   lat = data[,5],
                   popup = paste("<b>",data[,1],"</br> <b>",data[,2],"</b> </br> <b>Entries: </b>",data[,3],"<br> <b>Exits: </b>", data[,4]),
                   label = data[,2],
                   labelOptions = labelOptions(noHide = T, 
                                               style = list(
                                                        "color" = input$label_color,
                                                        "font-family" = input$font_family,
                                                        "font-style" = input$font_style,
                                                        "font-size" =  input$font_size
                                                       )
                                               )
                   )
        
    })
    
    # SCATTER PLOT
    output$scatterPlot <- renderPlot({
      
      # Filtering data by date and filtering out absurd values
      data <- dplyr::filter(turnstile_data, DATE == input$chosen_date3 & ENTRIES < 50000 & EXITS < 50000)
      x <- data[,3]
      y <- data[,4]
      
      plot(x,y,
           bg = input$SPDataFillColor,
           col = input$SPDataBorderColor,
           pch = input$scatterPlotPointShape,
           main = paste("Scatter Plot of Subway Station Turnstile Entries and Exits on", input$chosen_date3), 
           xlab = "Entries",
           ylab = "Exits",
           cex = input$scatterSymbolScale / 100,
           cex.lab = input$scatterFontScale / 100, 
           cex.axis = input$scatterFontScale / 100, 
           cex.main = input$scatterFontScale / 100, 
           cex.sub = input$scatterFontScale / 100)
      
    })
    
    # LINE CHARTS
    output$lineChart1 <- renderPlot({
      
      # Filtering data by station and filtering out absurd values
      LC_data <- dplyr::filter(turnstile_data, STATION == input$chosen_station & ENTRIES < 50000 & EXITS < 50000)
      # Convert Dates to date objects and filter data
      LC_data$DATE <- as.Date(LC_data$DATE , format = "%m/%d/%Y")
      print(paste(input$year,"-01-01",sep = ""))
      lower_bound <- as.Date(paste(input$year,"-01-01",sep = ""))
      upper_bound = as.Date(paste(input$year,"-12-31",sep = ""))
      LC_data2 <- LC_data %>% select(DATE, STATION, ENTRIES, EXITS, Latitude, Longitude) %>% filter(DATE >= lower_bound & DATE <= upper_bound)

      ggplot(data = LC_data2,aes(x = DATE, y = ENTRIES, group = 1)) + geom_line(color = input$EntryLineColor) + geom_point(color = input$EntryPointColor) + ggtitle(paste("Entries at ",input$chosen_station,"(",input$year,")",sep = "")) +
        xlab("Month") + ylab("Entries") + theme(text=element_text(size=input$entry_font_size,  family=input$entry_font))
    })

    output$lineChart2<- renderPlot({
      
      # Filtering data by station and filtering out absurd values
      LC_data <- dplyr::filter(turnstile_data, STATION == input$chosen_station & ENTRIES < 50000 & EXITS < 50000)
      # Convert Dates to date objects and filter data
      LC_data$DATE <- as.Date(LC_data$DATE , format = "%m/%d/%Y")
      print(paste(input$year,"-01-01",sep = ""))
      lower_bound <- as.Date(paste(input$year,"-01-01",sep = ""))
      upper_bound = as.Date(paste(input$year,"-12-31",sep = ""))
      LC_data2 <- LC_data %>% select(DATE, STATION, ENTRIES, EXITS, Latitude, Longitude) %>% filter(DATE >= lower_bound & DATE <= upper_bound)
      
      ggplot(data = LC_data2,aes(x = DATE, y = EXITS, group = 1)) + geom_line(color = input$ExitLineColor) + geom_point(color = input$ExitPointColor) + ggtitle(paste("Exits at ",input$chosen_station,"(",input$year,")",sep = "")) +
        xlab("Month") + ylab("Exits") + theme(text=element_text(size=input$exit_font_size,  family=input$exit_font))
      
    })
})
