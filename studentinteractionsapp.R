# student interactions app
# main page

# libraries
library(shiny)

# Pull data

student.name = c("John","Kathryn","Joshua","Anna")


# Define UI for application that draws a histogram
ui <- fluidPage(

  tabsetPanel(
    tabPanel("Record interaction",
             selectInput("student", "Which student?", student.name),
             textAreaInput("interactiontext", "Enter notes:", rows = 4, cols = 40),
             actionButton("createnew", "Create New Student")
             ),
    tabPanel("New Student",
             textInput("name","Student Name"),
             dateInput("creationdate","Date"),
             textAreaInput("student.notes", "Enter student notes:", rows = 4, cols = 40),
             actionButton("createnew", "Create New Student")

    )
  )




)

# Define server logic required to draw a histogram
server <- function(input, output) {



}

# Run the application
shinyApp(ui = ui, server = server)
