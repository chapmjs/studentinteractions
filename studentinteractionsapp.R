# student interactions app
# main page

# libraries
library(shiny)


# Define UI for application that draws a histogram
ui <- fluidPage(

  # Application title
  titlePanel("Student Interactions App"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(


    ),

    # Show a plot of the generated distribution
    mainPanel(


    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {



}

# Run the application
shinyApp(ui = ui, server = server)
