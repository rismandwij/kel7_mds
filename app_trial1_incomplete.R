library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(
    title = span("Database Jurnal Statistika", style = "font-size: 20px"),
    titleWidth = 300
  ),
  dashboardSidebar(
    collapsed = TRUE, 
    div(htmlOutput("Selamat Datang!"), style = "padding: 20px"),
    sidebarMenu(
      menuItem("View Tables", tabName = "view_table", icon = icon("search")),
      menuItem("Create Tables", tabName = "create_table", icon = icon("plus-square")),
      menuItem("Update Tables", tabName = "update_table", icon = icon("exchange-alt")),
      menuItem("Insert Entries", tabName = "insert_value", icon = icon("edit")),
      menuItem("Delete Tables", tabName = "del_table", icon = icon("trash-alt")),
      menuItem("Performance Dasboard", tabName = "performance", icon = icon("chart-simple")),
      menuItem("About", tabName = "about", icon = icon("info-circle"))
    )
  )
  ,
  dashboardBody()
)

server <- function(input, output) { }

shinyApp(ui, server)