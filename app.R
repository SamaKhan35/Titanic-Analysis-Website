# Load the required libraries
library(shiny)
library(shinythemes)
library(ggplot2)
library(DT)
library(dplyr)
titanic <- read.csv('data/Titanic.csv')
# Define UI
ui <- fluidPage(
  theme = shinytheme("cerulean"),  # Theme chosen for the web application
  # Image for Titanic web application
  img(src = "https://upload.wikimedia.org/wikipedia/commons/a/af/Titanic-computergraphic2011.png", # title image for the web application
      width = "100%", height = "auto", style = "max-height:350px;"),
   navbarPage("Surviving The Titanic",#Title for website
              tabPanel("Data Exploration", #tab for data visualization
                       HTML("<p><b><span style='font-size: 18px;'>This website provides a multivariate analysis related to Titanic passengers.</span></b></p>"),
                      sidebarLayout(
                        
                        sidebarPanel(
                          selectInput("variable1", "X:", choices = c("PassengerClass", "Age", "Survived", "Sex", "Embarked"), selected = "PassengerClass"), #First variable to select, passenger class will be selected by default
                          selectInput("variable2", "Y:", choices = c("PassengerClass", "Age", "Survived", "Sex", "Fare", "Embarked"), selected = "Survived"), #Second variable to select, survival status will be selected by default
                          sliderInput("sample_count", "Passenger Count:", min = 1, max = nrow(titanic), value = 100, step = 1), #passenger count can be controlled (1-891; from dataset)
                          actionButton("plot_btn", "Now You See!"), #action button for the variables
                          width = 3,
                          HTML("<br><h5>Data Representations:</h5>"), #inform what each variable is and what their values represents
                          HTML("<p><strong>Age:</strong> Age of the passenger(1-80)</p>"),
                          HTML("<p><strong>Sex:</strong> Gender of the passenger (Male, Female)</p>"),
                          HTML("<p><strong>Fare:</strong> Fare paid by the passenger</p>"),
                          HTML("<p><strong>Survived:</strong> Survival status of the passenger (0=No, 1=Yes)</p>"),
                          HTML("<p><strong>PassengerClass:</strong> Passenger Class (1=First Class, 2=Second Class, 3=Third Class)</p>"),
                          HTML("<p><strong>Embarked:</strong> Port of Embarkation (C=Cherbourg, Q=Queenstown, S=Southampton)</p>")
                        )
                        ,
                        mainPanel(
                          plotOutput("scatter_plot"),#main plot to show relations among variable
                          plotOutput("pie_chart"), #reflects variable 1/X information
                          width = 9
                        )
                      )
             ),
             tabPanel("Correlation Analysis", #depicts correlations among numerical value
                      sidebarLayout(
                        sidebarPanel(
                          selectInput("var1", "Variable 1:", choices = c("PassengerClass", "Age", "Survived"), selected = "PassengerClass"), #First variable to select, passenger class will be selected by default
                          selectInput("var2", "Variable 2:", choices = c("PassengerClass", "Age", "Survived"), selected = "Survived"),#Second variable to select, passenger class will be selected by default
                          actionButton("corr_btn", "Relations!!!"),
                          width = 3
                        ),
                        mainPanel(
                          verbatimTextOutput("corr_output"), #this will give the correlation value
                          width = 30
                        )
                      )
             ),
             tabPanel("Data Table", #tab for displaying dataset
                      DT::dataTableOutput("table"),
                      downloadButton("download_data", "Download CSV") #download button for dowloading data into a CSV file
             )
  )
)

# Define Server
server <- function(input, output) {
  
  # Load Titanic dataset
  titanic <- read.csv('data/Titanic.csv')
  
  # Data Exploration - Scatter plot with jitter
  output$scatter_plot <- renderPlot({
    if (!is.null(input$plot_btn) && input$variable1 != input$variable2) {
      sampled_titanic <- titanic[sample(nrow(titanic), input$sample_count), ]
      ggplot(sampled_titanic, aes(x = .data[[input$variable1]], y = .data[[input$variable2]])) +
        geom_point(color = "blue", alpha = 0.7, position = position_jitter(width = 0.2, height = 0.2)) +
        labs(x = input$variable1, y = input$variable2) +
        ggtitle(paste(input$variable1, "vs", input$variable2)) +
        theme_minimal()
    } else {
      NULL
    }
  }) # codes for main plot to show relations among variable
  
  
  # Data Exploration - Colored Pie Chart
  output$pie_chart <- renderPlot({
    if (!is.null(input$plot_btn) && input$variable1 != input$variable2) {
      sampled_data <- titanic[sample(1:nrow(titanic), input$sample_count, replace = FALSE), ]
      
      # legend based on variable values
      legend_labels <- switch(input$variable1,
                              "PassengerClass" = c("First Class", "Second Class", "Third Class"),
                              "Survived" = c("Not Survived", "Survived"),
                              "Sex" = c("Male", "Female"),
                              "Age" = c("0-9", "10-19", "20-29", "30-39", "40-49", "50-59", "60-69", "70-79", "80-89", "90+"),
                              "Embarked" = c("Cherbourg", "Queenstown", "Southampton"))
      
      
      # Calculate counts for each category in variable 1
      if (input$variable1 == "Age") {
        # Creating age groups
        age_groups <- cut(sampled_data$Age, breaks = c(0, 9, 19, 29, 39, 49, 59, 69, 79, 89, 150),
                          labels = c("0-9", "10-19", "20-29", "30-39", "40-49", "50-59", "60-69", "70-79", "80-89", "90+"),
                          include.lowest = TRUE, right = FALSE)
        counts <- table(age_groups)
      } else {
        counts <- table(sampled_data[[input$variable1]])
      }
      
      # Define custom colors for pie chart
      my_colors <- c("variable1_1" = "skyblue",
                     "variable1_2" = "blue",
                     "variable1_3" = "darkblue", # most variables will use colors upto this 
                     "variable1_4" = "pink", 
                     "variable1_5" = "lightgreen", 
                     "variable1_6" = "lightyellow", 
                     "variable1_7" = "turquoise", 
                     "variable1_8" = "purple", 
                     "variable1_9" = "red", 
                     "variable1_10" = "black") # 7 extra colors used for Age group data representation  
      
      # Create pie chart without labels
      pie_chart <- pie(counts, labels = NA, col = my_colors, main = paste("Pie Chart of", input$variable1))
      
      # Add legend with custom labels
      legend("right", legend = legend_labels, fill = my_colors) #legend for defining pie chart results
      
      # Return pie chart
      pie_chart
      
      
    } else {
      NULL
    }
  })
  
  #code for pie chart reflects variable 1/X information
  

  
  # Correlation Analysis - Calculate Correlation
  output$corr_output <- renderPrint({
    if (!is.null(input$corr_btn)) {
      if (input$var1 == input$var2) {
        corr <- 1
      } else {
        corr <- cor(titanic[[input$var1]], titanic[[input$var2]], use = "complete.obs")
      }
      paste("Correlation between", input$var1, "and", input$var2, "is:", corr)
    } else {
      NULL
    }
  })
  
  
  # Data table
  output$table <- DT::renderDataTable({
    titanic
  })
  
  # Download data CSV
  output$download_data <- downloadHandler(
    filename = function() {
      paste("titanic_data", Sys.Date(), ".csv", sep = "_") # Filename for the downloaded file
    },
    content = function(file) {
      write.csv(titanic, file, row.names = FALSE) # Converting dataset to a CSV file
    }
  )
}

# Run the app
shinyApp(ui, server)