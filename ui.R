#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

default_date = "10/11/2014"
turnstile_data <- read.csv("final_data.csv")
unique_station_list <- unique(turnstile_data[,2])
unique_station_list <- sort(unique_station_list)
unique_date_list <- unique(turnstile_data[,1])
unique_date_list <- sort(unique_date_list)

# Define UI for application that draws a histogram
shinyUI(
  navbarPage("MTA Turnstile Data Visualization Creator",
    tabPanel("Entry and Exit Histograms",
    
      # HISTOGRAM
      titlePanel("Histograms of Entry and Exit Data of all MTA Subway Stations on Chosen Day"),
  
      # Sidebar
      sidebarLayout(
          sidebarPanel(
            
              # Date Picker
              textInput("chosen_date1", 
                        "Enter a Date from 10/11/2014 to 11/5/2021 in the format MM/DD/YYYY", 
                        value = default_date, 
                        width = NULL, 
                        placeholder = NULL
              ),
              
              # Entry Histogram Bin Code
              sliderInput("binsEntry",
                          "Number of bins in Entry Histogram:",
                          min = 1,
                          max = 50,
                          value = 30
              ),
              
              # Entry Histogram Data Color
              selectInput("colorsEntry",
                          "Choose your data Color for Entry Histogram:",
                          choices = c('Default (gray)' = 'gray','Black'= 'black','Blue' = 'blue','Brown' = 'brown','Cyan' = 'cyan','Green' = 'green','Red'= 'red','White' ='white'),
                          selected = 'Default (gray)'
              ),
              
              # Entry Histogram Color Borders
              selectInput("borderEntry",
                          "Choose your Border Color for Entry Histogram:",
                          choices = c('Default (black)' = 'black','Blue' = 'blue','Brown' = 'brown','Cyan' = 'cyan','Gray'= 'gray','Green' = 'green','Red'= 'red','White' ='white'),
                          selected = 'Default (black)'
              ),       
              
              # Entry Histogram Font Size Changer
              sliderInput("fontEntry",
                          "Font Size of Entry Histogram (%):",
                          min = 100,
                          max = 150,
                          value = 100
              ),
              
              # Exit Histogram Bin Code
              sliderInput("binsExit",
                          "Number of bins in Exit Histogram:",
                          min = 1,
                          max = 50,
                          value = 30
              ),
              
              # Exit Histogram Data Color             
              selectInput("colorsExit",
                          "Choose your data Color for Exit Histogram:",
                          choices = c('Default (gray)' = 'gray','Black'= 'black','Blue' = 'blue','Brown' = 'brown','Cyan' = 'cyan','Green' = 'green','Red'= 'red','White' ='white'),
                          selected = 'Default (gray)'
              ),

              # Exit Histogram Color Borders
              selectInput("borderExit",
                          "Choose your Border Color  for Exit Histogram:",
                          choices = c('Default (black)' = 'black','Blue' = 'blue','Brown' = 'brown','Cyan' = 'cyan','Gray'= 'gray','Green' = 'green','Red'= 'red','White' ='white'),
                          selected = 'Default (black)'
              ),
              
              # Exit Histogram Font Size Changer
              sliderInput("fontExit",
                          "Font Size of Exit Histogram (%):",
                          min = 100,
                          max = 150,
                          value = 100
              ),

          ),
  
          # Show a plot of the generated distribution
          mainPanel(
              plotOutput("distPlot1"),
              plotOutput("distPlot2")
          )
      )
    ),
    
    # Leaflet Map
    tabPanel("Leaflet Map of Data",
      # Page title
      titlePanel("Entry and Exit Data of all MTA Subway Stations on Chosen Day"),
      sidebarLayout(
        sidebarPanel(
          # Date Picker
          textInput("chosen_date2", 
                    "Enter a Date from 10/11/2014 to 11/5/2021 in the format MM/DD/YYYY", 
                    value = default_date, 
                    width = NULL, 
                    placeholder = NULL
          ),
          
          # Label Text Color
          selectInput("label_color",
                      "Choose the color of label text you would like: ",
                      choices = c('Default (black)' = 'black','Blue' = 'blue','Brown' = 'brown','Cyan' = 'cyan','Gray'= 'gray','Green' = 'green','Red'= 'red','White' ='white'),
                      selected = 'Default (black)'
          ),
          
          # Label Text Font Family
          selectInput("font_family",
                      "Choose the font family of the label text: ",
                      choices = c("Helvetica","Arial","Comic Sans MS","Times New Roman","Serif"),
                      selected = "Helvetica"
          ),
          # Label Text Font Style
          selectInput("font_style",
                      "Choose the font style of the label text: ",
                      choices = c('normal','italic'),
                      selected = 'normal'
          ),
          # Label Font Size
          selectInput("font_size",
                      "Choose the font size of the label text: ",
                      choices = c('10px','11px','12px','13px','14px','15px','16px','17px','18px','19px','20px'),
                      selected = '12px'
          ),

        ),
        mainPanel(
          leafletOutput("leafletMap", height = "800px")
        )
      )

    ),
    
    # SCATTER PLOT
    tabPanel("Scatter Plot of Data",
             # Page title
             titlePanel("Scatter Plot of Entry and Exit Data of all MTA Subway Stations on Chosen Day"),
             
             sidebarLayout(
               sidebarPanel(
                 
                 # Date Picker
                 textInput("chosen_date3", 
                           "Enter a Date from 10/11/2014 to 11/5/2021 in the format MM/DD/YYYY", 
                           value = default_date, 
                           width = NULL, 
                           placeholder = NULL
                 ),     
                 
                 img(src ="Scatter_Plot_Point_Shapes.png",height = 300, width = 300),
                 # Scatter Plot Shape Picker
                 sliderInput("scatterPlotPointShape",
                             "Select your point shape based on the corresponding number",
                             min = 0,
                             max = 25,
                             value = 1
                 ),
                 
                 # Scatter Plot Border Color
                 selectInput("SPDataBorderColor",
                             "Choose your data border Color for Scatter Plot",
                             choices = c('Default (black)' = 'black','Blue' = 'blue','Brown' = 'brown','Cyan' = 'cyan','Gray'= 'gray','Green' = 'green','Red'= 'red','White' ='white'),
                             selected = 'Default (black)'
                 ),
                 
                 # Scatter Plot Fill Color
                 selectInput("SPDataFillColor",
                             "Choose your data fill-in Color for Scatter Plot (Exclusive to 21 through 25)",
                             choices = c('Default (gray)' = 'gray','Black'= 'black','Blue' = 'blue','Brown' = 'brown','Cyan' = 'cyan','Green' = 'green','Red'= 'red','White' ='white'),
                             selected = 'Default (gray)'
                 ),

                 # Scatter Plot Symbol Size Adjuster
                 sliderInput("scatterSymbolScale",
                             "Size of Scatter Plot Points(%):",
                             min = 100,
                             max = 150,
                             value = 100
                 ),
                 
                 # Scatter Plot Font Size Adjuster
                 sliderInput("scatterFontScale",
                             "Size of Scatter Plot Font(%):",
                             min = 100,
                             max = 150,
                             value = 100
                 ),
               ),

               mainPanel(
                 plotOutput("scatterPlot", height = "800px")
               )
             )
    ),
    
    # LINE CHART
    tabPanel("Entry and Exit Line Charts",
             # Page title
             titlePanel("Line Charts of Entry and Exit Data of Selected Subway Station"),
             
             sidebarLayout(
               sidebarPanel(
                 
                 # Station Picker
                 selectInput("chosen_station", 
                           "Choose a Subway Station:",
                           choices = unique_station_list,
                           selected = "68 St-Hunter College"
                 ),     
                 # Year
                 selectInput("year",
                             "Choose a year:",
                             choices = c('2021','2020','2019','2018','2017','2016','2015','2014'),
                             selected = '2021'
                 ),
                 # Entry LINE COLOR
                 selectInput("EntryLineColor",
                             "Choose the color for the Entry Line:",
                             choices = c('Default (black)' = 'black','Blue' = 'blue','Brown' = 'brown','Cyan' = 'cyan','Gray'= 'gray','Green' = 'green','Red'= 'red','White' ='white'),
                             selected = 'Default (black)'
                 ),
                 
                 # Entry Point COLOR
                 selectInput("EntryPointColor",
                             "Choose the color for the Entry Points:",
                             choices = c('Default (gray)' = 'gray','Black'= 'black','Blue' = 'blue','Brown' = 'brown','Cyan' = 'cyan','Green' = 'green','Red'= 'red','White' ='white'),
                             selected = 'Default (gray)'
                 ),
                 
                 # Entry Graph Font
                 selectInput("entry_font",
                             "Choose the font for the Entry Line Graph: ",
                             choices = c("Helvetica","Arial","Comic Sans MS","Times New Roman","Serif"),
                             selected = "Helvetica"
                 ),
                 
                 # Entry Graph Font Size
                 sliderInput("entry_font_size",
                             "Choose the font size of the Entry Line Graph: ",
                             min = 10,
                             max = 20,
                             value = 16
                 ),
                 
                 # Exit LINE COLOR
                 selectInput("ExitLineColor",
                             "Choose the color for the Exit Line:",
                             choices = c('Default (black)' = 'black','Blue' = 'blue','Brown' = 'brown','Cyan' = 'cyan','Gray'= 'gray','Green' = 'green','Red'= 'red','White' ='white'),
                             selected = 'Default (black)'
                 ),
                 
                 # Exit Point COLOR
                 selectInput("ExitPointColor",
                             "Choose the color for the Exit Points:",
                             choices = c('Default (gray)' = 'gray','Black'= 'black','Blue' = 'blue','Brown' = 'brown','Cyan' = 'cyan','Green' = 'green','Red'= 'red','White' ='white'),
                             selected = 'Default (gray)'
                 ),
                 
                 # Exit Graph Font
                 selectInput("exit_font",
                             "Choose the font for the Exit Line Graph: ",
                             choices = c("Helvetica","Arial","Comic Sans MS","Times New Roman","Serif"),
                             selected = "Helvetica"
                 ),

                 # Exit Graph Font Size
                 sliderInput("exit_font_size",
                             "Choose the font size of the Exit Line Graph: ",
                             min = 10,
                             max = 20,
                             value = 16
                 ),
               ),
               
               mainPanel(
                 plotOutput("lineChart1"),
                 plotOutput("lineChart2")
               )
             )
    )
))

