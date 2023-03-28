library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(RPostgreSQL)
library(DBI)
library(DT)
library(bs4Dash)
library(dplyr)

#=========================== Interface (Front-End) ============================#

fluidPage(
  dashboardPage(
    #--------------HEADER-----------------#
    header = dashboardHeader(
      title = span(img(src="https://camo.githubusercontent.com/73bfb19e2b1ee79da76442abf820912460c1548e23f1f622f8375e31260f6411/687474703a2f2f6273646d2e756e61732e61632e69642f77702d636f6e74656e742f75706c6f6164732f323032322f30382f73696e74615f6c6f676f312e706e67",
                       height = 75))
    ),
    #------------SIDEBAR-----------------#
    sidebar = dashboardSidebar(
      collapsed = TRUE,
      sidebarMenu(
        menuItem(
          text = "Beranda",
          tabName = "beranda",
          icon = icon("house")
        ),
        menuItem(
          text = "Cari Publikasi",
          tabName = "jurnal",
          icon = icon("file")
        ),
        menuItem(
          text = "Cari Penulis",
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
    body = dashboardBody(
      tabItems(
        #-------------------------Tab Beranda-------------------------#
        tabItem(
          tabName = "beranda",
          jumbotron(
            title = span("SINTA Stats: Pencarian Publikasi Statistika Indonesia",style = "font-size:46px;font-weight:bold;"),
            lead = "Selamat Datang di SINTA Stats", 
            span("SINTA Stats menyediakan akses terhadap kumpulan publikasi yang terkait dengan penelitian dan studi di bidang statistika terindex SINTA di Indonesia. 
            Terdapat 3776 publikasi dari 499 Perguruan Tinggi maupun Lembaga Penelitian yang tersebar di seluruh Indonesia. 
            Situs ini terdiri dari 1114 penulis dari berbagai bidang ilmu sehingga informasi terkait topik yang di inginkan dapat diakses dengan mudah. 
            Seluruh database yang digunakan oleh SINTA Stats mengacu kepada situs SINTA Kemendikbud.",
                 style = "font-size:20px;text-align:justify;"),
            status = "info",
            href = "https://sinta.kemdikbud.go.id/journals"
          ),
          tags$h2("Panduan"),
          tags$p("Arahkan kursor ke sisi kiri layar atau klik ikon garis tiga pada sisi pojok kanan atas untuk mengakses bilah sisi (side bar). 
                 Tiga fitur utama pada SINTA Stats adalah sebagai berikut,"),
          tags$ol(
            tags$li("Cari Publikasi"),
            tags$p("Pencarian judul publikasi Statistika terindeks SINTA dengan memanfaatkan fitur penyaringan tahun, akreditasi, dan bidang ilmu. 
            Lengkapi kriteria penyaringan agar didapatkan publikasi yang relevan."),
            tags$br(),
            tags$li("Cari Penulis"),
            tags$p("Pencarian nama penulis yang berkontribusi pada pembuatan publikasi Statistika terindeks SINTA dengan memanfaatkan fitur penyaringan nama instansi dan bidang ilmu. 
            Lengkapi kriteria penyaringan agar didapatkan publikasi yang relevan."),
            tags$br(),
            tags$li("Statistik"),
            tags$p("Informasi tentang kinerja instansi dan penulis dalam pembuatan publikasi Statistika dengan kategori pemeringkatan berdasarkan nilai skor SINTA dan banyaknya publikasi yang telah dibuat.")
          ),
          tags$h2("Info Pengembang Situs"),
          tags$p("Situs ini merupakan projek praktikum kelompok mata kuliah Manajemen Data Statistika (STA1582) dari Program Statistika dan Sains Data Pascasarjana IPB University.
                 Tim pengembang situs adalah sebagai berikut,"),
          tags$ul(
            tags$li("L.M. Risman Dwi Jumansyah sebagai Database Manager"),
            tags$li("Rafika Aufa Hasibuan sebagai Back-end Shiny Developer"),
            tags$li("Akmarina Khairunnisa sebagai Front-end Shiny Developer"),
            tags$li("Megawati sebagai Technical Writer")
          ),
          tags$p("Info lebih lanjut mengenai projek database ini dapat diakses di github pengembang."),
          tags$a(href="https://github.com/rismandwij/kel7_mds", "link github")
        ),
        #--------------------------Tab Jurnal--------------------------#
        tabItem(
          tabName = "jurnal",
          fluidRow(
            tags$h1("Pencarian Publikasi Statistika")
          ),
          fluidRow(
            # Filter tahun terbit
            box(
              tags$h3("Filter Tahun"),
              tags$p("Pilih rentang tahun publikasi yang ingin ditampilkan"),
              tags$br(),
              uiOutput("filter_1"),
              width = 4
            ),
            # Filter akreditasi
            box(
              tags$h3("Filter Akreditasi"),
              tags$p("Pilih akreditasi publikasi yang ingin ditampilkan"),
              tags$br(),
              uiOutput("filter_2"),
              width = 4
            ),
            # Filter bidang studi
            box(
              tags$h3("Filter Bidang Studi"),
              tags$p("Pilih bidang studi publikasi yang ingin ditampilkan"),
              tags$br(),
              uiOutput("filter_3"),
              width = 4
            )
          ),
          fluidRow(
            # Display tabel 
            box(
              tags$h3("Tabel"),
              dataTableOutput("out_tbl1"),
              width = 12
            )
          )
        ),
        #-------------------------Tab Penulis-------------------------#
        tabItem(
          tabName = "penulis",
          fluidRow(
            tags$h1("Pencarian Publikasi Statistika")
          ),
          fluidRow(
            # Filter nama_instansi
            box(
              tags$h3("Filter Instansi"),
              tags$p("Pilih instansi penulis yang ingin ditampilkan"),
              tags$br(),
              uiOutput("filter_4"),
              width = 6
            ),
            # Filter bidang studi
            box(
              tags$h3("Filter Bidang Studi"),
              tags$p("Pilih bidang studi penulis yang ingin ditampilkan"),
              tags$br(),
              uiOutput("filter_5"),
              width = 6
            )
          ),
          fluidRow(
            # Display tabel 
            box(
              tags$h3("Tabel"),
              dataTableOutput("out_tbl2"),
              width = 12
            )
          )
        ),
        #-------------------------Tab Statistik-------------------------#
        tabItem(
          tabName = "statistik",
          tabsetPanel(
            type = "tabs",
            tabPanel(
              title = "Instansi",
              fluidRow(
                tags$br(),
                tags$h2("10 Peringkat Teratas Instansi pada Penulisan Publikasi Statistika"),
                tags$p("Berikut adalah 10 peringkat teratas dari seluruh instansi terdaftar dalam partisipasi publikasi bidang statistika")
              ),
              fluidRow(
                box(
                  tags$h4("Sinta Score"),
                  tags$p("Peringkat diurutkan berdasarkan skor SINTA dari seluruh penulis yang tergabung pada instansi"),
                  tableOutput("out_tbl3"),
                  width = 6
                ),
                box(
                  tags$h4("Banyak Publikasi Scopus"),
                  tags$p("Peringkat diurutkan berdasarkan banyaknya publikasi terindeks scopus dari masing-masing instansi"),
                  tableOutput("out_tbl4"),
                  width = 6
                )
              )
            ),
            tabPanel(
              title = "Penulis",
              fluidRow(
                tags$br(),
                tags$ h2("10 Peringkat Teratas Penulis Publikasi Statistika"),
                tags$p("Berikut adalah 10 peringkat teratas dari seluruh penulis terdaftar dalam partisipasi publikasi bidang statistika")
              ),
              fluidRow(
                box(
                  h4("Sinta Score"),
                  p("Peringkat diurutkan berdasarkan skor SINTA dari masing-masing penulis"),
                  tableOutput("out_tbl5"),
                  width = 6
                ),
                box(
                  h4("Banyak Publikasi Scopus"),
                  p("Peringkat diurutkan berdasarkan banyaknya publikasi terindeks scopus dari masing-masing penulis"),
                  tableOutput("out_tbl6"),
                  width = 6
                )
              )
            )
          )
        )
      )
    ),
    #-----------------FOOTER-----------------#
    footer = dashboardFooter(
      left = "by Kelompok 7",
      right = "Bogor, 2023"
    )
  )
)

