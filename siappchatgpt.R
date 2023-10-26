# Load the required packages
library(shiny)
library(RSQLite)
library(DT)
library(shinyTime)

# Initialize or connect to the SQLite database
con <- dbConnect(RSQLite::SQLite(), "student_interactions.db")

# Create a table if it doesn't exist
dbExecute(con, "CREATE TABLE IF NOT EXISTS interactions (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              first_name TEXT,
              last_name TEXT,
              date DATE,
              time TIME,
              location TEXT,
              notes TEXT)")

# Define UI
ui <- fluidPage(
  titlePanel("Student Interactions App"),
  sidebarLayout(
    sidebarPanel(
      textInput(inputId = "first_name", label = "First name"),
      textInput(inputId = "last_name", label = "Last name"),
      dateInput(inputId = "date", label = "Date"),
#      shinyTime::timeInput(inputId = "time", label = "Time"),
      textInput(inputId = "location", label = "Location"),
      textAreaInput(inputId = "notes", label = "Notes"),
      actionButton(inputId = "submit", label = "Submit")
    ),
    mainPanel(
      DT::dataTableOutput(outputId = "table")
    )
  )
)

# Define server logic
# Define server logic
server <- function(input, output, session) {

  # Create a reactive value to hold the data
  rv <- reactiveVal(dbGetQuery(con, "SELECT * FROM interactions"))

  observeEvent(input$submit, {
    current_time <- format(Sys.time(), "%H:%M:%S")
    new_row <- data.frame(first_name = input$first_name,
                          last_name = input$last_name,
                          date = as.character(input$date),
                          time = current_time,
                          location = input$location,
                          notes = input$notes)

    dbWriteTable(con, "interactions", new_row, append = TRUE)

    # Update the reactive value with the latest data
    rv(dbGetQuery(con, "SELECT * FROM interactions"))
  })

  output$table <- DT::renderDataTable({
    rv()
  })
}


# Run the app
shinyApp(ui, server)
