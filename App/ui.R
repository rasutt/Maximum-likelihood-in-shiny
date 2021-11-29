library(shiny)

# Define UI for app
ui <- fluidPage(
  # App title
  titlePanel("Maximum likelihood"),
  
  # Sidebar layout with input and output definitions
  sidebarLayout(
    # Sidebar panel for inputs
    sidebarPanel(
      # Slider for amplitude
      sliderInput(inputId = "a", label = "Amplitude:",
                  min = min_a, max = max_a, value = 1, step = step, 
                  animate = animationOptions(int = 2000)),
      
      # Slider for the Standard deviation
      sliderInput(inputId = "sig", label = "Standard deviation:",
                  min = min_sig, max = max_sig, value = 1.5, step = step, 
                  animate = animationOptions(int = 2000))
    ),
    
    # Main panel for displaying outputs
    mainPanel(
      fluidRow(
        splitLayout(
          cellWidths = c("60%", "40%"), 
          # NLL plot
          plotOutput(outputId = "NLLPlot"),
          
          # Scatterplot
          plotOutput(outputId = "scatterPlot")
        )
      )
    )
  )
)