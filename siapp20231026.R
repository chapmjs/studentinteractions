library(shiny)
library(DBI)
library(DT)

# Create or connect to SQLite database
con <- dbConnect(RSQLite::SQLite(), "students_notes.db")

# UI
ui <- fluidPage(
  titlePanel("Student and Notes Manager"),

  sidebarLayout(
    sidebarPanel(
      textInput("first_name", "First Name"),
      textInput("last_name", "Last Name"),
      actionButton("add_student", "Add Student"),
      textAreaInput("note", "Note"),
      actionButton("add_note", "Add Note")
    ),

    mainPanel(
      DTOutput("student_table"),
      DTOutput("notes_table")
    )
  )
)

# Server logic
server <- function(input, output, session) {

  selected_student <- reactiveVal(NULL)

  observeEvent(input$student_table_rows_selected, {
    if (length(input$student_table_rows_selected) > 0) {
      selected_student(input$student_table_rows_selected[1])
    }
  })

  output$student_table <- renderDT({
    datatable(dbGetQuery(con, "SELECT * FROM Students"),
              options = list(lengthChange = FALSE))
  })

  output$notes_table <- renderDT({
    if (is.null(selected_student())) return()
    datatable(dbGetQuery(con, paste("SELECT * FROM Notes WHERE StudentID = ", selected_student())),
              options = list(lengthChange = FALSE))
  })

  observeEvent(input$add_student, {
    dbExecute(con, "INSERT INTO Students (FirstName, LastName) VALUES (?, ?)",
              params = list(input$first_name, input$last_name))
  })

  observeEvent(input$add_note, {
    if (is.null(selected_student())) return()
    dbExecute(con, "INSERT INTO Notes (StudentID, NoteText, DateAdded) VALUES (?, ?, ?)",
              params = list(selected_student(), input$note, Sys.time()))
  })
}

# Run app
shinyApp(ui, server)
