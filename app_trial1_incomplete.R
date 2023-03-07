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
      menuItem("Performance Dasboard", tabName = "performance", icon = icon("chart-simple")),
      menuItem("About", tabName = "about", icon = icon("info-circle"))
    )
  )
  ,
  dashboardBody(
    tabItems(
      tabItem(tabName = "view_table", uiOutput("tab_1")),
      tabItem(tabName = "about", uiOutput("tab_2"))
    )
  )
)

server <- function(input, output) {
  output$tab_1 <- renderUI({
    box(width = NULL, status = "primary",
        sidebarLayout(
          sidebarPanel(
            box(width = 12,
                collapsible = TRUE,
                div(style = "height: 15px; background-color: white;"),
                title = "Database Info:",
                p("")),
            selectInput(inputId = "sel_table_1",
                        label = "Tables in Database",
                        choices = dbListTables(db),
                        selected = "penulis"),
            textOutput(outputId = "tab_intro"),
            tags$head(tags$style("#tab_intro{font-size: 15px;font-style: italic;}"))
          ),
          mainPanel(
            h4(strong("Table Preview")),
            dataTableOutput(outputId = "sel_table_view")
          )
        )
    )
  })
  output$sel_table_view <- renderDataTable()
  table_intro <- list(penulis = "Penjelasan tabel", 
                      judul = "Penjelasan tabel",
                      instansi = "Penjelasan tabel",
                      departemen = "Penjelasan tabel")
  output$tab_intro <- renderText(
    if (input$sel_table_1 %in% c("penulis","judul","instansi","departemen"))
    {table_intro[[input$sel_table_1]]}
    else {table_intro$other}
  )
}

shinyApp(ui, server)

