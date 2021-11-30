# Set number of samples and sample x-values
n = 1e2
x = runif(n)

# Define server logic for app
server <- function(input, output) {
  # Function to re-sample y-values each time inputs change
  y = reactive(rnorm(n, input$a * sin(x * 2 * pi), input$sig))
  
  # Plot of random sample
  output$scatterPlot <- renderPlot({
    plot(x, y(), main = "Sample")
  })
  
  # Plot of NLL surface
  output$NLLPlot <- renderPlot({
    # NLL function
    nll = function(a, sigma, x, y) {
      -sum(dnorm(y, a*sin(2*pi*x), sigma, log = T))
    }
    
    # Create grid of input values
    a_grid = seq(min_a - 1, max_a + 1, step)
    sig_grid = seq(min_sig - 0.5, max_sig + 0.5, step)
    l_a = length(a_grid)
    l_sig = length(sig_grid)
    nll_grid = matrix(nrow = l_a, ncol = l_sig)
    nll_a = numeric(l_a)
    nll_sig = numeric(l_sig)
    
    # Find NLL over grid of input values
    for (i in 1:l_a) {
      nll_a[i] = nll(a_grid[i], input$sig, x, y())
      for (j in 1:l_sig) {
        nll_sig[j] = nll(input$a, sig_grid[j], x, y())
        nll_grid[i, j] = nll(a_grid[i], sig_grid[j], x, y())
      }
    }
    
    # Plot NLL over grid of input values
    res = persp(a_grid, sig_grid, nll_grid, theta = 225, phi = 25, 
                main = "Negative log-likelihod surface", xlab = "Amplitude", 
                ylab = "Standard deviation", zlab = "Negative log-likelihod")
    
    # Plot NLL at true values
    points(trans3d(input$a, input$sig, nll(input$a, input$sig, x, y()), res), 
           col = 2, pch = 20, lwd = 2)
    lines(trans3d(input$a, sig_grid, nll_sig, res), col = 2, pch = 20, lwd = 2)
    lines(trans3d(a_grid, input$sig, nll_a, res), col = 2, pch = 20, lwd = 2)
  })
}