# student interactions app
# main page

# libraries
library(shiny)

# Pull data

student.name = c("John","Kathryn","Joshua","Anna")


# Define UI for application that draws a histogram
ui <- fluidPage(

  titlePanel("Student Interactions App"),

  sidebarLayout(
    sidebarPanel(

      tabsetPanel(
        tabPanel("New Interaction",
                 selectInput("student", "Which student?", student.name),
                 textAreaInput("interaction_text", "Enter notes:", rows = 4, cols = 40),
                 actionButton("create_new_interaction", "Create New Interaction")
                 ),
        tabPanel("New Student",
                 textInput("first_name","First Name"),
                 textInput("last_name","Last Name"),
                 dateInput("creation_date","Date"),
                 textAreaInput("student_notes", "Enter student notes:", rows = 4, cols = 40),
                 actionButton("create_new_student", "Create New Student")

        )
      )
    ),
    mainPanel(
      # Output: Table of recorded interactions
      DT::dataTableOutput(outputId = "table")

    )

  )



)

# Define server logic required to draw a histogram
server <- function(input, output) {


  # Create an empty data frame to store the interactions
  interactions <- data.frame(first_name = character(),
                             last_name = character(),
                             date = as.Date(character()),
                             time = as.POSIXct(character()),
                             location = character(),
                             notes = character(),
                             stringsAsFactors = FALSE)

  # Use a reactive value to hold the data frame
  values <- reactiveValues(data = interactions)

  # Observe the submit button and append the input to the data frame
  observeEvent(input$create_new_student, {
    new_row <- data.frame(first_name = input$first_name,
                          last_name = input$last_name,
                          date = input$date,
                          time = input$time,
                          location = input$location,
                          notes = input$notes,
                          stringsAsFactors = FALSE)
    values$data <- rbind(values$data, new_row)
  })

  # Render the table of recorded interactions
  output$table <- DT::renderDataTable({
    values$data
  })



}

# Run the application
shinyApp(ui = ui, server = server)




#Source: Conversation with Bing, 4/21/2023(1) Building Shiny apps - an interactive tutorial - Dean Attali. https://deanattali.com/blog/building-shiny-apps-tutorial/ Accessed 4/21/2023.
#(2) Shiny - Tutorial - RStudio. https://shiny.rstudio.com/tutorial/ Accessed 4/21/2023.
#(3) Shiny - Welcome to Shiny - RStudio. https://shiny.rstudio.com/tutorial/written-tutorial/lesson1/ Accessed 4/21/2023.
#(4) Getting Started with Shiny - GitHub Pages. https://ourcodingclub.github.io/tutorials/shiny/ Accessed 4/21/2023.
