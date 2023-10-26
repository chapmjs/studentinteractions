# App to Create New Students and Add Notes

library(shiny)
library(DBI)
library(DT)

con <- dbConnect(RSQLite::SQLite(), "students_notes.db")

ui <- fluidPage(
  titlePanel("Student Notes App"),
  sidebarLayout(
    sidebarPanel(
      tabsetPanel(
        tabPanel("Add Student",
                 textInput("first_name", "First Name"),
                 textInput("last_name", "Last Name"),
                 actionButton("add_student", "Add Student")),
        tabPanel("Add Note",
                 DTOutput("student_table"),
                 textAreaInput("note", "Note"),
                 actionButton("add_note", "Add Note"))
      )
    ),
    mainPanel(
      DTOutput("notes_table")
    )
  )
)

server <- function(input, output, session) {

  output$student_table <- renderDT({
    dbGetQuery(con, "SELECT * FROM Students")
  }, selection = "single")

  output$notes_table <- renderDT({
    dbGetQuery(con, "SELECT * FROM Notes")
  })

  observeEvent(input$add_student, {
    dbExecute(con, "INSERT INTO Students (FirstName, LastName) VALUES (?, ?)",
              params = list(input$first_name, input$last_name))
  })

  observeEvent(input$add_note, {
    selected_student <- input$student_table_rows
    if (!is.null(selected_student)) {
      dbExecute(con, "INSERT INTO Notes (StudentID, NoteText, DateAdded) VALUES (?, ?, ?)",
                params = list(selected_student, input$note, Sys.time()))
    }
  })

}

shinyApp(ui, server)
