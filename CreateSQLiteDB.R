# App to Create SQLite Database and Tables

library(shiny)
library(DBI)

ui <- fluidPage(
  titlePanel("SQLite Table Creator"),
  sidebarPanel(
    actionButton("create_db", "Create Database and Tables")
  ),
  mainPanel(
    textOutput("status")
  )
)

server <- function(input, output) {

  observeEvent(input$create_db, {
    con <- dbConnect(RSQLite::SQLite(), "students_notes.db")

    dbExecute(con, "CREATE TABLE IF NOT EXISTS Students (
                   StudentID INTEGER PRIMARY KEY AUTOINCREMENT,
                   FirstName TEXT,
                   LastName TEXT);")

    dbExecute(con, "CREATE TABLE IF NOT EXISTS Notes (
                   NoteID INTEGER PRIMARY KEY AUTOINCREMENT,
                   StudentID INTEGER,
                   NoteText TEXT,
                   DateAdded DATETIME,
                   FOREIGN KEY (StudentID) REFERENCES Students(StudentID));")

    dbDisconnect(con)

    output$status <- renderText("Database and tables created successfully.")
  })

}

shinyApp(ui, server)
