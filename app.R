suppressPackageStartupMessages({
  library(shiny)
  library(shinyWidgets)
  library(leaflet)
  library(plotly)
  library(DT)
  library(shinythemes)
  library(tidyverse)
  library(shinydashboard)
  library(httr) # Required for the GET function
  library(ranger)
  library(parsnip)
})

# Define custom colors and font------------------------
custom_css <- "
      /* Custom CSS for the AutoWorthWizard dashboard */
  
      /* Set the background color for the entire dashboard */
      /* Ensure the header logo is always visible */
      .skin-blue .main-header .navbar .sidebar-toggle {
        float: left;
      }

      /* Adjust the logo and header title */
      .skin-blue .main-header .logo {
        padding: 0 15px; /* Add padding to show the Team6 logo when collapsed */
      }
      
      .skin-blue .main-header .logo img {
        height: 50px; /* Adjust the Team6 logo size */
      }
      
      .header-title {
        display: inline-block;
        vertical-align: middle;
        font-size: 24px; /* Adjust the title size here */
      }
      
      /* Adjustments for the sidebar icons */
      .skin-blue .sidebar-menu > li > a {
        padding: 12px 5px 12px 15px; /* Adjust padding to fit icons */
      }
      
      .skin-blue .sidebar-menu .treeview-menu > li > a {
        padding: 5px 5px 5px 15px; /* Adjust padding for treeview-menu */
      }
      
      /* Adjustments when sidebar is collapsed */
      .skin-blue .sidebar-collapse .sidebar-menu > li > a > .sidebar-mini-hide,
      .skin-blue .sidebar-collapse .sidebar-menu > li > a > span {
        display: none; /* Hide text when collapsed */
      }

      /* Ensure the header logo is always visible */
    .skin-blue .main-header .navbar .sidebar-toggle {
     float: left;
      }

      /* Adjust the logo and header title */
      .header-logo img {
      height: 40px;
      margin-right: 10px; /* Adjust spacing to the right of the logo */
      }

      .header-title {
      display: inline-block;
      vertical-align: middle;
      font-size: 24px; /* Adjust the title size here */
      color: #000000; /* Black font color for the title */
  }

      /* Style adjustments when the sidebar is collapsed */
      .skin-blue .sidebar-mini.sidebar-collapse .main-header .logo {
        padding: 0; /* Remove padding to allow the logo to be fully visible */
      }
      
      /* Change the background color of the navbar/header and the title */
      .skin-blue .main-header .navbar,
      .skin-blue .main-header .logo {
        background-color: #86a094;
      }
      
      /* Sidebar active item indicator color */
      .skin-blue .sidebar-menu > li a:hover,
      .skin-blue .sidebar-menu > li.active > a {
        border-left-color: #5e776c;
      }
      
      /* Change sidebar color */
      .skin-blue .main-sidebar {
        background-color: #eff0e4;
      }
      
      /* Change color of the active sidebar menu item */
      .skin-blue .sidebar-menu li.active a {
        background-color: #86a094;
        color: #000000; /* Black font color for the active menu item */
      }
      
      /* Change sidebar menu item hover and active state color */
      .skin-blue .sidebar-menu li a:hover,
      .skin-blue .sidebar-menu li.active a {
        background-color: #86a094;
        color: #000000;
      }
      
      /* Change the font color for menu items */
      .skin-blue .sidebar-menu li a {
        color: #000000;
      }
      
      /* Change the main background color */
      .content-wrapper,
      .main-footer {
        background-color: #eff0e4;
      }
      
      /* Change the sidebar toggle button color */
      .skin-blue .main-header .navbar .sidebar-toggle {
        background-color: #86a094;
        color: #000000;
      }
      
      /* Change the sidebar toggle button color on active/focus */
      .skin-blue .main-header .navbar .sidebar-toggle:hover,
      .skin-blue .main-header .navbar .sidebar-toggle:focus,
      .skin-blue .main-header .navbar .sidebar-toggle:active {
        background-color: #eff0e4;
        color: #000000;
      }
      
      /* Change color of the header brand area when clicked */
      .skin-blue .main-header .logo:hover,
      .skin-blue .main-header .logo:active,
      .skin-blue .main-header .logo:focus {
        background-color: #eff0e4;
        color: #000000;
      }
      
      /* Footer styling to fix it to the bottom and center the content */
      .footer {
        position: fixed;
        bottom: 0;
        width: 100%;
        background-color: #eff0e4;
        color: #000000;
        text-align: center;
        padding: 10px 0;
      }
      
      /* Change font and other styling if needed */
      body, h1, h2, h3, h4, h5, h6, .navbar, button, .sidebar-menu, p {
        font-family: 'Arial', sans-serif; 
        color: #000000; /* Black font color */
      }
      
      /* Adjust the sidebar menu to show icons when collapsed */
      .skin-blue .sidebar-mini.sidebar-collapse .sidebar-menu > li {
        white-space: nowrap; /* Prevent text wrapping */
      }
      
      .skin-blue .sidebar-mini.sidebar-collapse .sidebar-menu > li > a {
        text-align: center; /* Center align the icons */
        padding-left: 12px; /* Add padding to left to align with collapsed sidebar */
      }

      /* Normal state, sidebar expanded */
      .skin-blue .main-header .logo img {
        height: 40px; /* Larger height when sidebar is expanded */
        transition: height .3s ease; /* Smooth transition for the height change */
      }
      
      /* Collapsed state, sidebar collapsed */
      .skin-blue.sidebar-mini .main-header .logo img {
        height: 30x; /* Smaller height when collapsed */
      }

      /* Apply the background color across the entire dashboard */
      body, .content-wrapper, .main-sidebar, .right-side, .box {
        background-color: #eff0e4; /* Set your desired color */
      }

      /* Increase font size and add style to the text output */
        #prediction {
          font-size: 20px; /* Set the font size */
          font-weight: bold; /* Make it bold */
          color: #000000; /* Set the text color */
          background-color: #86a094; /* Set the background color */
        }
        
          /* Active item background color */
    .selectize-input.focus, .selectize-input.dropdown-active, .selectize-dropdown-content .option.selected {
      background-color: #86a094; /* Dark Green */
      color: #000000; /* Black */
    }
    
    /* Hover item background color */
    .selectize-dropdown-content .option:hover {
      background-color: #eff0e4; /* Light Green */
      color: #000000; /* Black */
    }
    
    /* Dropdown background color */
    .selectize-dropdown, .selectize-dropdown.form-control {
      background-color: #eff0e4; /* Light Green */
      color: #000000; /* Black */
    }
    
    /* Slider handle when active */
    .irs-handle.state_hover, .irs-handle.state_active, .irs-handle:hover {
      background-color: #86a094; /* Dark Green */
    }
    
    /* Slider handle color */
    .irs-handle {
      border-color: #86a094; /* Dark Green */
    }
    
    /* Slider bar and border color */
    .irs-bar, .irs-bar-edge, .irs-line {
      background-color: #86a094; /* Dark Green */
      border-color: #86a094; /* Dark Green */
    }
    
    /* Slider connect active part */
    .irs-bar-edge {
      background-color: #eff0e4; /* Light Green */
    }
    
    /* Slider from/to labels and connect inactive part */
    .irs-from, .irs-to, .irs-single, .irs-line-left {
      background-color: #eff0e4; /* Light Green */
    }


         /* Custom CSS to change button colors */
          .btn-primary {
            background-color: #86a094 !important;
            border-color: #86a094 !important;
            color: #000000 !important; /* Set text color */
          }
          .btn-primary:hover,
          .btn-primary:active,
          .btn-primary:focus {
            background-color: #5e776c !important; /* Adjust hover color if needed */
            border-color: #5e776c !important; /* Adjust hover color if needed */
            color: #000000 !important; /* Set text color */
          }
          .btn-secondary {
            background-color: #eff0e4 !important;
            border-color: #5e776c !important;
            color: #000000 !important; /* Set text color for secondary button */
          }
          .btn-secondary:hover,
          .btn-secondary:active,
          .btn-secondary:focus {
            background-color: #e7e8dd !important; /* Adjust hover color if needed */
            border-color: #e7e8dd !important; /* Adjust hover color if needed */
            color: #000000 !important; /* Set text color */
          }

          
         /* Styling for the slider handles */
          .irs .irs-handle {
              background: #eff0e4 !important; /* Change to your handle color */
              border-color: #86a094 !important; /* Change to your border color */
          }
          
          /* Styling for the slider track (the line) */
          .irs .irs-line {
              background: #86a094 !important; /* Change to your track color */
          }
          
          /* Styling for the slider bar (the filled part) */
          .irs .irs-bar {
              background: #5e776c !important; /* Change to your filled part color */
          }
          
          /* Styling for the slider values */
          .irs .irs-single, .irs .irs-min, .irs .irs-max {
              background: #eff0e4 !important; /* Change to the background color of labels */
              color: #000000 !important; /* Change to the color of the text of labels */
          }
        
        /* Styling for the handle from/to labels (if using a range slider) */
        .irs .irs-from, .irs .irs-to, .irs .irs-single {
          background: #86a094 !important;
          border-color: #5e776c !important;
          color: #eff0e4 !important;

          /* Change the background color of the selected item in the dropdown */
          .selectize-dropdown-content .has-options {
            background-color: #5E776C; /* Set your desired color */
            color: #000000; /* Set the text color for the selected item */
          }
        
        /* Styling for selected options in the select input */
        .selectize-control .selectize-input.items.not-full.has-options.full.has-items .item {
          color: #000000 !important; /* Text color for the selected item */
          background-color: #eff0e4 !important; /* Background color for the selected item */
        }
        
        /* Styling for the dropdown menu items */
        .selectize-dropdown .selectize-dropdown-content .option {
          color: #000000 !important; /* Text color for dropdown items */
          background-color: #86a094!important; /* Background color for dropdown items */
        }
        /* Hover item background color */
        .selectize-dropdown-content .option:hover,
        .selectize-dropdown-content .option:active,
        .selectize-dropdown-content .option:focus{
          background-color: #86a094 !important; /* Change to the color you want on hover */
          color: #000000 !important; /* Change to the color you want the text to be on hover */
        }

          /* Active item background color */
          .selectize-input.focus, .selectize-input.dropdown-active, .selectize-dropdown-content .option.selected {
            background-color: #86a094 !important; /* Dark Green */
            color: #000000 !important; /* Black */
          }

        .dashboard-title {
          color: #000000 !important;
          font-size: 24px;
          display: inline-block;
          vertical-align: middle;
        }
        .dashboard-title img {
          height: 50px; /* Adjust the Team6 logo size */
        }
  }
  "
# load the data --------------------------------------------------------------
# Load the preprocessed dataset
load("/home/ubuntu/data_final.RData") # adjust the path to the location of the data_final.RData file

# Load the trained model
model_fit <- readRDS("/home/ubuntu/model_fit.rds") # adjust the path to the location of the model_fit.rds file
# Define UI -------------------------------------------------------------------
ui <- dashboardPage(
  dashboardHeader(title = span(class = "dashboard-title", img(src = "https://raw.githubusercontent.com/tingjintj/Team6/main/Team6.png"), "AutoWorthWizard")),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Information", tabName = "info", icon = icon("info-circle")),
      menuItem("Overview", tabName = "dashboard", icon = icon("home")),
      menuItem("Detailed Insights", tabName = "brand", icon = icon("tags")),
      menuItem("Price Predictor", tabName = "price", icon = icon("calculator")),
      menuItem("Full Table", tabName = "table", icon = icon("table"))
    )
  ),
  dashboardBody(
    tags$head(tags$style(HTML(custom_css))),
    tabItems(
      tabItem(tabName = "info",
              fluidRow(
                box(
                  title = "AutoWorthWizard: Your used car price calculator tool",
                  width = 12,
                  solidHeader = TRUE, # Gives a solid header
                  style = "border-top: 3px solid #5E776C",
                  tags$img(
                    id = "rotatingImage",
                    src = "https://raw.githubusercontent.com/tingjintj/Team6/main/Image1.png",
                    style = "display: block; margin-left: auto; margin-right: auto; max-height: 30vh; width: auto;"
                  ),
                  tags$script(
                    HTML('
                var imageIndex = 0;
                var imageUrls = [
                  "https://raw.githubusercontent.com/tingjintj/Team6/main/Image1.png",
                  "https://raw.githubusercontent.com/tingjintj/Team6/main/Image2.png",
                  "https://raw.githubusercontent.com/tingjintj/Team6/main/Image3.png"
                ];
                function rotateImages() {
                  var imgElement = document.getElementById("rotatingImage");
                  imageIndex = (imageIndex + 1) % imageUrls.length;
                  imgElement.src = imageUrls[imageIndex];
                }
                setInterval(rotateImages, 5000); // Rotate images every 5 seconds
              ')
                  ),
              tags$div(
                id = "content",
                style = "margin: 20px;",
                HTML("
                <h4>Welcome to AutoWorthWizard</h4>
                <p>We are glad you found us! AutoWorthWizard is your ultimate destination for exploring the prices of a <strong>wide range of pre-owned vehicles</strong> from various sellers across Germany. Whether you're in search of a practical hatchback, a rugged off-road SUV, or a luxurious sedan, our website offers a comprehensive platform to discover prices for the perfect vehicle to suit your lifestyle and budget.</p>
                <h5><strong>Explore Our Website:</strong></h5>
                <ul>
                  <li><strong>Overview:</strong> Have a look at the top brands in our database and see on which models we have historic data.</li>
                  <li><strong>Detailed Insights:</strong> Dive deep into information clustered by brand, model, fuel type, gear type, build year, price, horse power, and maximum mileage.</li>
                  <li><strong>Price Calculator:</strong> Harness the accuracy of our innovative tool, powered by <strong>advanced machine learning algorithms</strong>, that boasts a finely-tuned Random Forest model with a RMSE of 7196, reflecting its adeptness in estimating vehicle prices with substantial precision.</li>
                  <li><strong>Full Table:</strong> Dive into the raw data with our full table feature, providing a detailed overview of all available vehicles for reference and analysis, should you be in search of a specific model.</li>
                </ul>
                <h5>Start your journey with Second-Hand Cars Germany today and experience the ease and convenience of determining the optimal buy or sell price of your pre-owned vehicle <strong>completely free of charge!</strong></h5>
              ")
              )
                )
              )
      ),
      tabItem(tabName = "dashboard",
              fluidRow(
                box(
                  title = "Overview",
                  status = NULL,
                  solidHeader = TRUE,
                  width = 12,
                  id = "Introbox",
                  style = "border-top: 3px solid #5E776C",
                  h4("Introduction to our price prediction tool"),
                  p("We have built our price prediction tool powered by machine learning based on a database that includes a variety of information on used car sales, ranging from car brands, models, and years, over to price, mileage, and other features of the cars."),
                  p("On this overview page, we want to give you a sense for what kind of brands and models are included in our database."),
                  p("Feel free to explore the top 10 car brands (by number of sold cars) and the distribution of models for a selected brand included in our database.")
                )
              ),
              fluidRow(
                column(
                  width = 12,
                  style = "padding-bottom: 50px;",  # Increase padding at the bottom
                  div(plotlyOutput("plot1"), style = "padding-top: 40px;"),
                  selectInput("selectedMake", "Choose a Make", choices = NULL),  # Dropdown to select make
                  plotlyOutput("modelPieChart")  # Output for the pie chart
                )
              )
      ),
      # Detailed Insights tab content
      tabItem(tabName = "brand",
              fluidRow(
                box(
                  title = "Detailed insights",
                  status = NULL,
                  solidHeader = TRUE,
                  width = 12,
                  id = "Introbox",
                  style = "border-top: 3px solid #5E776C",
                  h4("Detailed insights for your purchase or sale"),
                  p("Use the following controls to choose brand, model, fuel type, gear type, build year, price, horse power, and maxmimum mileage in roder to get insihgts on purchase prices."),
                  p("Next to the table format, we also provided insights into average historic prices vs. the average price across all models (market price) in those years, which you can find in the second tab"),
                  p("Also make sure to discover the distribution of prices in the histogram in the third tab.It provides you with an overview of how the prices are distributed, based on your chosen preferences."),
                )
              ),               
              fluidRow(
                column(width = 3, 
                       pickerInput("make", "Brand", 
                                   choices = unique(data_final$make), 
                                   options = list(`actions-box` = TRUE), 
                                   multiple = TRUE, 
                                   selected = unique(data_final$make))
                ),
                column(width = 3, uiOutput("model_select")),
                column(width = 3, uiOutput("fuel_select")),
                column(width = 3, uiOutput("gear_select")),
                column(width = 3, 
                       sliderInput("year", "Year", 
                                   min = min(data_final$year), 
                                   max = max(data_final$year), 
                                   value = range(data_final$year), 
                                   step = 1, ticks = FALSE,
                                   pre = "",
                                   post = "",
                                   sep = "")
                ),
                column(width = 3, 
                       sliderInput("price", "Price (€)", 
                                   min = min(data_final$price), 
                                   max = max(data_final$price), 
                                   value = range(data_final$price), 
                                   step = 1000, pre = "€", post = "")
                ),
                column(width = 3, uiOutput("hp_slider")),
                column(width = 3, uiOutput("mileage_input"))
              ),
              fluidRow(
                column(width = 12, 
                       textOutput("totalCars"), 
                       tabsetPanel(
                         id = "myTabset",  # Add an id to the tabset panel for styling
                         tabPanel("Filtered Table", dataTableOutput("carsTable")), 
                         tabPanel("Average Price Graph", plotlyOutput("salesGraph")), 
                         tabPanel("Price Histogram", plotlyOutput("priceHistogram"))
                       ),
                       style = "height: 650px; overflow-y: auto;"  # Set the height and enable vertical scrolling if needed
                )
              )
      ),
      # Price Predictor tab content----------------------------------------------
      tabItem(tabName = "price",
              fluidRow(
                box(
                  title = "Price Predictor",
                  status = NULL,
                  solidHeader = TRUE,
                  width = 12,
                  id = "Introbox",
                  style = "border-top: 3px solid #5E776C",
                  h4("Determine the optimal buy/sell price with our AI-powered tool"),
                  p("Leverage our tool's precision, backed by a sophisticated Random Forest model with a fine-tuned RMSE of 7196, ensuring reliable buy or sell price estimations for vehicles."),
                  p("Simply input key details such as Make (Brand), Model, Fuel Type, Gear Type, Offer Type, Horsepower, Year, and Mileage - our advanced algorithms will handle the rest, providing you with an optimal price instantly."),
                )
                
              ),
              fluidRow(
                column(width = 4, selectInput("make_predict", "Make", choices = sort(unique(data_final$make)))),
                column(width = 4, selectInput("model_predict", "Model", choices = sort(unique(data_final$model)))),
                column(width = 4, selectInput("fuel_type_predict", "Fuel Type", choices = sort(unique(data_final$fuel))))
              ),
              fluidRow(
                column(width = 4, selectInput("gear_type_predict", "Gear Type", choices = sort(unique(data_final$gear)))),
                column(width = 4, selectInput("offer_type_predict", "Offer Type", choices = sort(unique(data_final$offerType)))),
                column(width = 4, sliderInput("hp_predict", "Horse Power", min = min(data_final$hp), max = max(data_final$hp), value = median(data_final$hp), step = 10))
              ),
              fluidRow(
                column(width = 4, sliderInput("year_predict", "Year", min = min(data_final$year), max = max(data_final$year), value = median(data_final$year), step = 1)),
                column(width = 4, sliderInput("mileage_predict", "Mileage", min = min(data_final$mileage), max = max(data_final$mileage), value = median(data_final$mileage), step = 10000))
              ),
              fluidRow(
                column(width = 6, align = "center", actionButton("predictButton", "Predict Price", class = "btn-primary")),
                column(width = 6, align = "center", actionButton("clearButton", "Clear Prediction", class = "btn-secondary"))
              ),
              fluidRow(
                column(width = 12, div(style = "height: 30px;"))
              ),
              fluidRow(
                column(width = 3),
                column(width = 6, align = "center", div(style = "height: 40px;"), textOutput("prediction")),
                column(width = 3)
              )
      ),
      tabItem(tabName = "table",
              fluidRow(
                DT::dataTableOutput("fullTable")
              )
      )
    ),
    tags$footer(class = "footer",
                div(style = "padding: 10px 0;",
                    img(src = "https://raw.githubusercontent.com/tingjintj/Team6/main/Esade_logo.png", height = "30px"),
                    " © 2024 DAR - Final Project - Section B Team 6 - All rights reserved."
                )
    )
  )
)

# Define server logic ----------------------------------------------------------
server <- function(input, output, session) {
  # Brand Selection -------------------------------------------------------------
  observe({
    # Initializing all filters only once to reduce redundancy
    updatePickerInput(session, "make", choices = unique(data_final$make), selected = unique(data_final$make), options = list(`actions-box` = TRUE))
    updatePickerInput(session, "model", choices = unique(data_final$model), selected = unique(data_final$model), options = list(`actions-box` = TRUE))
    updatePickerInput(session, "fuel", choices = unique(data_final$fuel), selected = unique(data_final$fuel), options = list(`actions-box` = TRUE))
    updatePickerInput(session, "gear", choices = unique(data_final$gear), selected = unique(data_final$gear), options = list(`actions-box` = TRUE))
  })
  
  # Reactive filters update based on `make` selection
  observeEvent(input$make, {
    valid_models <- unique(data_final %>% filter(make %in% input$make) %>% pull(model))
    valid_fuels <- unique(data_final %>% filter(make %in% input$make) %>% pull(fuel))
    valid_gears <- unique(data_final %>% filter(make %in% input$make) %>% pull(gear))
    
    updatePickerInput(session, "model", choices = valid_models, selected = valid_models)
    updatePickerInput(session, "fuel", choices = valid_fuels, selected = valid_fuels)
    updatePickerInput(session, "gear", choices = valid_gears, selected = valid_gears)
  })
  
  # Filtered data based on user inputs
  filtered_data <- reactive({
    req(input$make)  # Ensure that `input$make` is not NULL
    data_final %>%
      filter(make %in% input$make) %>%
      filter(model %in% input$model) %>%
      filter(fuel %in% input$fuel) %>%
      filter(gear %in% input$gear) %>%
      filter(year >= input$year[1] & year <= input$year[2]) %>%
      filter(price >= input$price[1] & price <= input$price[2]) %>%
      filter(hp >= input$hp[1] & hp <= input$hp[2]) %>%
      filter(mileage <= input$mileage)
  })
  output$hp_slider <- renderUI({
    sliderInput("hp", "Horse Power",
                min = min(data_final$hp), max = max(data_final$hp),
                value = range(data_final$hp),
                step = 1, ticks = FALSE)
  })
  
  output$model_select <- renderUI({
    req(input$make)  # Ensure that a make is selected
    valid_models <- unique(data_final[data_final$make %in% input$make, "model"])
    pickerInput("model", "Model", choices = valid_models, options = list(`actions-box` = TRUE), multiple = TRUE, selected = valid_models)
  })
  
  output$fuel_select <- renderUI({
    req(input$make)  # Filter options based on selected make
    valid_fuels <- unique(data_final[data_final$make %in% input$make, "fuel"])
    pickerInput("fuel", "Fuel", choices = valid_fuels, options = list(`actions-box` = TRUE), multiple = TRUE, selected = valid_fuels)
  })
  
  output$gear_select <- renderUI({
    req(input$make)
    valid_gears <- unique(data_final[data_final$make %in% input$make, "gear"])
    pickerInput("gear", "Gear", choices = valid_gears, options = list(`actions-box` = TRUE), multiple = TRUE, selected = valid_gears)
  })
  
  output$hp_slider <- renderUI({
    sliderInput("hp", "Horse Power",
                min = min(data_final$hp), max = max(data_final$hp),
                value = range(data_final$hp), step = 1, ticks = FALSE,
                pre = "", post = ""
    )
  })
  
  output$mileage_input <- renderUI({
    numericInput("mileage", "Insert Maximum Mileage (in km)", value = 200000, min = 0)
  })
  
  
  # Input for maximum mileage
  output$mileage_input <- renderUI({
    numericInput("mileage", "Insert Maximum Mileage", value = 200000)
  })
  
  # Render total cars message
  output$totalCars <- renderText({
    # Use the 'filtered_data' reactive expression that filters the dataset based on input
    data <- filtered_data()
    count <- nrow(data)
    paste("Total cars corresponding to your search criteria:", count)
  })
  
  output$priceHistogram <- renderPlotly({
    # Initialize empty plotly object
    p <- plot_ly()
    
    # Check if the reactive data has any entries before pulling price
    if (nrow(filtered_data()) > 0) {
      filtered_prices <- filtered_data() %>%
        pull(price) %>%
        # Accumulate values over 60000 at the 60000 mark
        map_dbl(~ ifelse(. > 60000, 60000, .))
      
      # Add histogram for filtered prices
      p <- add_trace(p, x = filtered_prices, type = 'histogram', name = 'Filtered Prices',
                     marker = list(color = 'rgba(134, 164, 148, 1)'), opacity = 1,
                     autobinx = FALSE, xbins = list(start = 0, end = 60000, size = 2000))
    }
    
    # Conditionally add histogram for unfiltered prices if checkbox is checked
    if (!is.null(input$showAllPrices) && input$showAllPrices) {
      unfiltered_prices <- data_final$price %>%
        map_dbl(~ ifelse(. > 60000, 60000, .))
      
      p <- add_trace(p, x = unfiltered_prices, type = 'histogram', name = 'Unfiltered Prices',
                     marker = list(color = 'rgba(94, 119, 108, 0.75)'), opacity = 0.75,
                     autobinx = FALSE, xbins = list(start = 0, end = 60000, size = 2000))
    }
    
    # Final layout adjustments
    p <- layout(p, title = "", 
                xaxis = list(title = "Price (€)", tickmode = "array", 
                             tickvals = seq(0, 60000, by = 2000), 
                             ticktext = lapply(seq(0, 60000, by = 2000), as.character), 
                             tickangle = 90),
                yaxis = list(title = "Count"),
                paper_bgcolor = '#EFF0E4',
                plot_bgcolor = '#EFF0E4',
                barmode = 'overlay',
                margin = list(b = 120)) # Ensure space for x-axis labels
    
    return(p)
  })
  
  
  # Generate the table output
  output$carsTable <- renderDataTable({
    filtered_data()
  }, options = list(
    pageLength = 10,
    autoWidth = TRUE,
    dom = 'Bfrtip',
    initComplete = I("function(settings, json) {$(this.api().table().header()).css({'background-color': '#E7E8DD', 'color': '#000'});}")))
  
  average_market_prices <- data.frame(
    year = min(data_final$year):max(data_final$year),
    avg_price = runif(length(min(data_final$year):max(data_final$year)), min = mean(data_final$price, na.rm = TRUE) * 0.8, max = mean(data_final$price, na.rm = TRUE) * 1.2)
  )
  
  average_market_prices <- data.frame(
    year = min(data_final$year):max(data_final$year),
    avg_price = runif(length(min(data_final$year):max(data_final$year)), min = 20000, max = 30000)
  )
  
  # Generate the graph output
  output$salesGraph <- renderPlotly({
    # Calculate the filtered average price per year
    df_filtered <- filtered_data() %>%
      group_by(year) %>%
      summarise(avg_price = mean(price, na.rm = TRUE)) %>%
      arrange(year)
    
    # Create the plot
    p <- plot_ly() %>%
      add_trace(
        data = df_filtered,
        x = ~year,
        y = ~avg_price,
        type = 'scatter',
        mode = 'lines+markers',
        name = 'Filtered Average Price',
        line = list(color = '#86A094') # Green color for the filtered data
      ) %>%
      add_trace(
        data = average_market_prices,
        x = ~year,
        y = ~avg_price,
        type = 'scatter',
        mode = 'lines',
        name = 'Market Average Price',
        line = list(color = '#5E776C') # Darker green color for market data
      ) %>%
      layout(
        xaxis = list(title = 'Year', tickvals = df_filtered$year),
        yaxis = list(title = 'Average Price (€)'),
        plot_bgcolor = '#EFF0E4',
        paper_bgcolor = '#EFF0E4',
        legend = list(orientation = 'h', x = 0, y = 1.2),
        margin = list(b = 80) # Adjust bottom margin to avoid cutting off labels
      )
    
    return(p)
  })
  
  # Full Table --------------------------------------------------------------
  
  output$fullTable <- DT::renderDataTable({
    # Ensure the column names 'Brand' and 'Model' exist in 'data_final', or replace them with the actual column names.
    # Example: If your columns are named 'make' and 'model', replace 'Brand' with 'make' and 'Model' with 'model'.
    summarized_data <- data_final %>%
      group_by(make, model) %>% # Corrected column names assuming 'make' and 'model' are the correct ones.
      summarise(
        Quantity = n(),
        AveragePrice = mean(price, na.rm = TRUE)
      ) %>%
      ungroup() %>%
      arrange(desc(Quantity))
    DT::datatable(summarized_data, options = list(pageLength = 10, autoWidth = TRUE), 
                  filter = 'top', rownames = FALSE) %>%
      DT::formatCurrency(columns = 'AveragePrice', currency = '€', digits = 2)
  })
  
  # Overview graphs on Homepage ---------------------------------------------
  output$plot1 <- renderPlotly({
    # Summarize data to count the number of cars per make
    cars_per_make <- data_final %>% 
      group_by(make) %>% 
      summarise(count = n()) %>%
      ungroup() %>%
      arrange(desc(count)) %>%
      slice_max(order_by = count, n = 10)  # Keep only the top 10 makes by count
    
    # Since Plotly doesn't maintain the factor levels order, we convert make to factor with levels in the order of the count
    cars_per_make$make <- factor(cars_per_make$make, levels = cars_per_make$make)
    
    # Create the bar chart for the top 10 makes using plotly
    plot_ly(data = cars_per_make, x = ~make, y = ~count, type = 'bar',
            marker = list(color = '#86a094')) %>%
      layout(title = 'Top 10 Car Brands by Number of Cars',
             xaxis = list(title = 'Brand', categoryorder = 'total descending'),  # This will order the brands by total count
             yaxis = list(title = 'Number of Cars in the Dataset'),
             plot_bgcolor = '#EFF0E4',  # Set plot background color
             paper_bgcolor = '#EFF0E4',  # Set the background color for the plot area
             showlegend = FALSE)
  })
  
  # Dynamically update the dropdown with available car makes
  observe({
    updateSelectInput(session, "selectedMake", "Choose a Brand",
                      choices = unique(data_final$make[order(data_final$make)])
    )
  })
  
  # Reactive expression to filter data based on selected make
  filtered_data_make <- reactive({
    req(input$selectedMake)  # Ensure make is selected
    data_final %>% 
      filter(make == input$selectedMake) %>%
      group_by(model) %>%
      summarise(count = n(), .groups = 'drop')
  })
  
  # Generate the pie chart for models of the selected make
  output$modelPieChart <- renderPlotly({
    req(filtered_data_make())  # Ensure data is available
    df <- filtered_data_make()
    
    # Order the data and slice the top 5 models
    df <- df %>% 
      arrange(desc(count)) %>% 
      mutate(model = if_else(row_number() <= 10, as.character(model), "Others")) %>% 
      group_by(model) %>% 
      summarise(count = sum(count), .groups = 'drop')  # Aggregate counts for "Others"
    
    # Use Plotly to create the pie chart
    # Use Plotly to create the pie chart
    plot_ly(df, labels = ~model, values = ~count, type = 'pie',
            marker = list(colors = c('#aabdb4', '#b3c0b7', '#bac4bb', '#c1c8bf', '#c8cdc4', '#d0d3c8', '#d7dacd', '#deded2', '#e5e3d7', '#ecead9','#f3f2de')),
            showlegend = TRUE) %>% # Set the colors for the pie chart
      layout(title = paste("Model Distribution for", input$selectedMake),
             plot_bgcolor = '#EFF0E4',  # Set plot background color
             paper_bgcolor = '#EFF0E4',  # Set the background color for the plot area
             margin = list(l = 20, r = 20, t = 50, b = 20),  # Adjust margins around the pie chart
             legend = list(x = 1, y = 0.5, traceorder = 'normal', font = list(size = 12), bgcolor = 'rgba(255, 255, 255, 0.5)', bordercolor = 'rgba(255, 255, 255, 0)'))  # Customize the legend appearance
  })
  # Prediction logic when 'Predict Price' button is clicked---------------------
  ## Update model choices based on selected make
  ## Update model choices based on selected make
  observeEvent(input$make_predict, {
    # When a make is selected, filter data_final to get the corresponding models and update the select input
    models_for_make <- unique(data_final$model[data_final$make == input$make_predict])
    updateSelectInput(session, "model_predict", choices = models_for_make)
  })
  
  # React to the predict button press
  observeEvent(input$predictButton, {
    # Validate inputs
    req(input$make_predict, input$model_predict, input$fuel_type_predict, input$gear_type_predict, input$offer_type_predict, input$hp_predict, input$year_predict, input$mileage_predict)
    
    # Create new data for prediction
    new_data <- data.frame(
      make = factor(input$make_predict, levels = levels(data_final$make)),
      model = factor(input$model_predict, levels = levels(data_final$model)),
      fuel = factor(input$fuel_type_predict, levels = levels(data_final$fuel)),
      gear = factor(input$gear_type_predict, levels = levels(data_final$gear)),
      offerType = factor(input$offer_type_predict, levels = levels(data_final$offerType)),
      hp = as.numeric(input$hp_predict),
      year = as.numeric(input$year_predict),
      mileage = as.numeric(input$mileage_predict)
    )
    # Predict using the trained model
    prediction_results <- predict(model_fit, new_data)
    
    # Extract the price from the prediction results
    predicted_price <- if(is.data.frame(prediction_results)) {
      prediction_results[[1,1]]  # assuming the first column is the predicted price
    } else {
      prediction_results  # if it's just a single number
    }
    
    # Output the prediction
    output$prediction <- renderText({
      paste("Predicted Price: €", formatC(predicted_price, format = "f", digits = 2, big.mark = ",", decimal.mark = "."))
    })
  })
  
  # Clear prediction when clear button is clicked
  observeEvent(input$clearButton, {
    updateSelectInput(session, "make_predict", selected = NULL)
    updateSelectInput(session, "model_predict", selected = NULL)
    updateSelectInput(session, "fuel_type_predict", selected = NULL)
    updateSelectInput(session, "gear_type_predict", selected = NULL)
    updateSelectInput(session, "offer_type_predict", selected = NULL)
    updateNumericInput(session, "hp_predict", value = NULL)
    updateNumericInput(session, "year_predict", value = NULL)
    updateNumericInput(session, "mileage_predict", value = NULL)
    output$prediction <- renderText({}) # Clear the prediction output
  })
  
}

# Run the app
shinyApp(ui, server)
