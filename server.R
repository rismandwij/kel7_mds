library(shiny)
library(shinydashboard)
library(RPostgreSQL)
library(DBI)
library(DT)

connectDB <- function(){
  driver <- dbDriver('PostgreSQL')
  DB <- dbConnect(
    driver,
    dbname="gxhvvifq", # User & Default database
    host="topsy.db.elephantsql.com", # Server
    #port=5433,
    user="gxhvvifq", # User & Default database
    password="naY2KJEmWUNOWvuOwEutRtwlqE4iLH3L" # Password
  )
}

function(input, output, session) {
  output$tbldept <- renderDataTable({
    DB <- connectDB()
    dept<-dbGetQuery(DB, 'SELECT judul.id_sinta,penulis.nama_penulis,judul_paper,nama_penerbit,
    nama_journal,tahun_terbit,accred FROM penulis
                      INNER JOIN judul ON penulis.id_sinta=judul.id_sinta')
    dbDisconnect(DB)
    dept
  })
  
  output$tblinstansi <- renderDataTable({
    DB <- connectDB()
    instansi<-dbGetQuery(DB,'SELECT id_sinta,nama_penulis,instansi.nama_instansi,departemen.nama_departemen,subject_list 
                            FROM penulis
                          INNER JOIN instansi ON penulis.id_instansi=instansi.id_instansi
                         INNER JOIN departemen ON instansi.id_instansi=departemen.id_instansi')
    dbDisconnect(DB)
    instansi
  })
  
  output$tblpenulis <- renderDataTable({
    DB <- connectDB()
    penulis<-dbGetQuery(DB,'SELECT id_sinta,nama_penulis,instansi.nama_instansi,departemen.nama_departemen,subject_list 
                            FROM penulis
                          INNER JOIN instansi ON penulis.id_instansi=instansi.id_instansi
                         INNER JOIN departemen ON instansi.id_instansi=departemen.id_instansi')
    dbDisconnect(DB)
    penulis
  })
  
  output$tblleaderboard <- renderDataTable({
    DB <- connectDB()
    leader<-dbGetQuery(DB,'SELECT penulis.id_instansi,nama_instansi,SUM(penulis.sinta_score_ovr ) as total_score_sinta,SUM(penulis.jumlah_article_scopus) as jumlah_artikel_scopus
                      FROM instansi
                      INNER JOIN penulis ON instansi.id_instansi=penulis.id_instansi
                      GROUP BY penulis.id_instansi,instansi.nama_instansi
                      ORDER BY total_score_sinta DESC
                      LIMIT 10')
    dbDisconnect(DB)
    leader
  })
}

