# Set number of samples and sample x-values
n = 1e2
x = runif(n, -1, 1)

# Define server logic for app
server <- function(input, output) {
  # Function to re-sample y-values each time inputs change
  y = reactive(input$a * x + input$b + rnorm(n) / 2)
  
  # Plot of random sample
  output$scatterPlot <- renderPlot({
    plot(x, y(), main = "Sample")
  })
  
  # Plot of NLL surface
  output$NLLPlot <- renderPlot({
    # NLL function
    nll = function(a, b, x, y) {
      -sum(dnorm(y - (a*x + b), log = T))
    }
    
    # Create grid of input values
    a_grid = seq(min_a - 1, max_a + 1, step)
    b_grid = seq(min_b - 0.5, max_b + 0.5, step)
    l_a = length(a_grid)
    l_b = length(b_grid)
    nll_grid = matrix(nrow = l_a, ncol = l_b)
    nll_a = numeric(l_a)
    nll_b = numeric(l_b)
    
    # Find NLL over grid of input values
    for (i in 1:l_a) {
      nll_a[i] = nll(a_grid[i], input$b, x, y())
      for (j in 1:l_b) {
        nll_b[j] = nll(input$a, b_grid[j], x, y())
        nll_grid[i, j] = nll(a_grid[i], b_grid[j], x, y())
      }
    }
    
    # Plot NLL over grid of input values
    res = persp(a_grid, b_grid, nll_grid, theta = 225, phi = 25, 
                main = "Negative log-likelihod surface", xlab = "Gradient", 
                ylab = "Intercept", zlab = "Negative log-likelihod")
    
    # Plot NLL at true values
    points(trans3d(input$a, input$b, nll(input$a, input$b, x, y()), res), 
           col = 2, pch = 20, lwd = 2)
    lines(trans3d(input$a, b_grid, nll_b, res), col = 2, pch = 20, lwd = 2)
    lines(trans3d(a_grid, input$b, nll_a, res), col = 2, pch = 20, lwd = 2)
  })
}