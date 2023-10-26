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
                 textOutput("selected_student"),
                 textAreaInput("note", "Note"),
                 actionButton("add_note", "Add Note"),
                 DTOutput("previous_notes"))
      )
    ),
    mainPanel(
      DTOutput("student_table")
    )
  )
)

server <- function(input, output, session) {

  selected_student <- reactiveVal(NULL)

  output$student_table <- renderDT({
    dbGetQuery(con, "SELECT * FROM Students")
  }, selection = "single")

  observe({
    sel_student <- input$student_table_rows_selected
    if (!is.null(sel_student) && length(sel_student) > 0) {
      selected_student(sel_student[1])
    }
  })

  output$selected_student <- renderText({
    if (!is.null(selected_student())) {
      paste("Selected Student ID: ", selected_student())
    }
  })

  output$previous_notes <- renderDT({
    if (!is.null(selected_student())) {
      dbGetQuery(con, paste("SELECT * FROM Notes WHERE StudentID = ", selected_student()))
    }
  })

  observeEvent(input$add_student, {
    dbExecute(con, "INSERT INTO Students (FirstName, LastName) VALUES (?, ?)",
              params = list(input$first_name, input$last_name))
  })

  observeEvent(input$add_note, {
    if (!is.null(selected_student())) {
      dbExecute(con, "INSERT INTO Notes (StudentID, NoteText, DateAdded) VALUES (?, ?, ?)",
                params = list(selected_student(), input$note, Sys.time()))
    }
  })

}

shinyApp(ui, server)
