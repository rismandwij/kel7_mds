library(shiny)
library(shinythemes)
library(bs4Dash)
library(DT)
library(DBI)
library(RPostgreSQL)
library(dplyr)

#======================= Koneksi Shiny ke Database =======================#
connectDB <- function(){
  driver <- dbDriver('PostgreSQL')
  # mengatur koneksi ke server database ElephantSQL
  DB <- dbConnect(
    driver,
    dbname = "gxhvvifq", # nama database
    host = "topsy.db.elephantsql.com",
    user = "gxhvvifq",
    password = "naY2KJEmWUNOWvuOwEutRtwlqE4iLH3L"
  )
}

#-----------------------------------------------------------------------------#
# Query 1: Tabel Judul

q1 <- print('SELECT judul.id_sinta,penulis.nama_penulis,judul_paper,
            nama_penerbit,nama_journal,tahun_terbit,accred FROM 
            penulis INNER JOIN judul ON penulis.id_sinta=judul.id_sinta')
#-----------------------------------------------------------------------------#
# Query 2: Tabel Penulis & Instansi

q2 <- print('SELECT id_sinta,nama_penulis,instansi.nama_instansi,
            departemen.nama_departemen,subject_list FROM penulis INNER JOIN 
            instansi ON penulis.id_instansi=instansi.id_instansi INNER JOIN 
            departemen ON instansi.id_instansi=departemen.id_instansi')
#-----------------------------------------------------------------------------#
# Query 3: Sinta score - Performa

q3 <- print('SELECT penulis.id_instansi,nama_instansi,
            SUM(penulis.sinta_score_ovr ) as total_score_sinta,
            SUM(penulis.jumlah_article_scopus) as jumlah_artikel_scopus 
            FROM instansi INNER JOIN penulis ON 
            instansi.id_instansi=penulis.id_instansi GROUP BY 
            penulis.id_instansi,instansi.nama_instansi ORDER BY 
            total_score_sinta DESC LIMIT 10')
#-----------------------------------------------------------------------------#
# Ubah dataset yang ditarik dari database menjadi bentuk Dataframe
DB <- connectDB()
tabel01 <- data.frame(dbGetQuery(DB, q1))
tabel02 <- data.frame(dbGetQuery(DB, q2))
tabel03 <- data.frame(dbGetQuery(DB, q3))
dbDisconnect(DB)


#======================= Interface (Front-End) =======================#
ui <- fluidPage(
  dashboardPage(
    #--------------HEADER-----------------#
    dashboardHeader(
      title = span("Database Jurnal Statistika",
                   style = "font-size: 20px"),
      titleWidth = 300
    ),
    #------------SIDEBAR-----------------#
    dashboardSidebar(
      collapsed = TRUE,
      div(htmlOutput("Selamat Datang!"),
                     style = "padding: 20 px"),
      sidebarMenu(
        menuItem(
          text = "Home",
          tabName = "beranda",
          icon = icon("house")
        ),
        menuItem(
          text = "Cari Jurnal",
          tabName = "jurnal",
          icon = icon("file")
        ),
        menuItem(
          text = "Penulis Jurnal",
          tabName = "penulis",
          icon = icon("user")
        ),
        menuItem(
          text = "Statistik",
          tabName = "statistik",
          icon = icon("chart-column")
        )
      )
    ),
    #-----------------BODY-----------------#
    dashboardBody(
      tabItems(
        tabItem(
          tabName = "beranda",
          h1("Database Jurnal Statistika"),
          p("Lorem ipsum dolor sit amet, consectetur adipiscing elit. 
          Nullam lobortis vestibulum diam, sit amet consequat ipsum mattis eu. 
          Morbi at orci odio. Nam in vestibulum mauris. 
            Quisque tristique nunc et sollicitudin lobortis. 
            Donec eu erat aliquet, semper risus a, eleifend nisl. 
            Phasellus semper, sem quis ultrices eleifend, lorem risus interdum enim, at lobortis mi ex in ligula. 
            Vivamus nisl diam, tristique eu est vitae, aliquet lobortis augue. Morbi rhoncus magna dolor, eu posuere neque volutpat vel. Etiam ut tellus varius, gravida tortor a, pulvinar est. In luctus justo at nisl rutrum, quis elementum orci ornare. Suspendisse nibh justo, pulvinar in enim dignissim, iaculis lobortis leo. Quisque elementum arcu quis turpis congue pharetra."),
          br(),
          h2("Panduan"),
          p("Jelaskan tentang fitur atau panduan terkait cara penggunaan"),
          br(),
          h2("Tim Pengembang"),
          p("")
        ),
        tabItem(
          tabName = "jurnal",
          fluidRow(
            # Filter tahun terbit
            box(
              h3("Filter Tahun"),
              br(),
              uiOutput("filter_1"),
              width = 6
            ),
            # Filter akreditasi
            box(
              h3("Filter Akreditasi"),
              br(),
              uiOutput("filter_2"),
              width = 6
            )
            # ,
            # # Filter bidang studi
            # box(
            #   h3("Filter Bidang Studi"),
            #   br(),
            #   uiOutput("filter_3"),
            #   width = 6
          ),
          fluidRow(
            # Display tabel 
            box(
              h3("Tabel"),
              dataTableOutput("out_tbl1"),
              width = 12
            )
          )
        ),
        tabItem(
          tabName = "penulis",
          fluidRow(
            # Filter nama_instansi
            box(
              h3("Filter Instansi"),
              br(),
              uiOutput("filter_4"),
              width = 6
            )
            # ,
            # # Filter bidang studi
            # box(
            #   h3("Filter Bidang Studi"),
            #   br(),
            #   uiOutput("filter_5"),
            #   width = 6
            ),
          fluidRow(
            # Display tabel 
            box(
              h3("Tabel"),
              dataTableOutput("out_tbl2"),
              width = 12
            )
          )
        ),
        tabItem(
          tabName = "statistik"
        )
      )
    )
  )
)

  

#========================== SERVER (back-end) ==========================#

server <- function(input,output){
  
  output$filter_1 <- renderUI({
    sliderInput(
      inputId = "in_year",
      label = "Pilih Tahun",
      min = 2000,
      max = 2023,
      step = 1,
      value = c(2015, 2023),
      sep = ''
    )
  })
  
  output$filter_2 <- renderUI({
    selectInput(
      inputId = "in_acc",
      label = "Pilih Akreditasi",
      multiple = TRUE,
      choices = sort(as.character(tabel01$accred))
      )
  })
  data1 <- reactive({
    tabel01 %>% filter(tahun_terbit >= input$in_year[1],
                       tahun_terbit <= input$in_year[2],
                       accred %in% input$in_acc)
  })
  
  output$out_tbl1 <- renderDataTable({
    data1()
  })
  
  output$filter_4 <- renderUI({
    selectInput(
      inputId = "in_intansi",
      label = "Pilih Instansi",
      selected = "",
      choices = sort(tabel02$nama_instansi)
    )
  })
  
  data2 <- reactive({
    tabel02 %>% filter(nama_instansi %in% input$in_instansi)
  })
  
  output$out_tbl2 <- renderDataTable({
    data2()
  })
  
}

shinyApp(ui,server)
