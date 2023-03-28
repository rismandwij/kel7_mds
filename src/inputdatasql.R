library(RPostgreSQL)
library(DBI)
driver <- dbDriver('PostgreSQL')
DB <- dbConnect(
  driver, 
  dbname="sinta_jurnal", 
  host="localhost",
  port=5432,
  user="postgres",
  password="risman1998"
)

data_instansi<-read.csv("https://raw.githubusercontent.com/rismandwij/kel7_mds/main/scraping/instansi.csv")
str(data_instansi)
data_instansi$id_instansi<-as.character(data_instansi$id_instansi)
data_instansi$nama_instansi<-data_instansi$nama_instansi %>% gsub("'", "", .)
for (i in 1:nrow(data_instansi)){
  query <- paste0("INSERT INTO instansi (id_instansi,nama_instansi,lokasi,jumlah_penulis,jumlah_departement,jumlah_journals) VALUES(",
                  "'", data_instansi[i, ]$id_instansi, "', ", 
                  "'", data_instansi[i, ]$nama_instansi, "', ",
                  "'",data_instansi[i, ]$lokasi,"', ", 
                  "'", data_instansi[i, ]$jumlah_penulis, "', ",
                  "'", data_instansi[i, ]$jumlah_departemen, "', ",
                  "'", data_instansi[i, ]$jumlah_journals, "');")
  query_execute <- DBI::dbGetQuery(conn = DB, statement = query)
}

data_departemen<-read.csv("https://raw.githubusercontent.com/rismandwij/kel7_mds/main/scraping/departemen.csv")
str(data_departemen)
data_departemen$id_instansi<-as.character(data_departemen$id_instansi)
data_departemen$nama_departemen<-data_departemen$nama_departemen %>% gsub("'", "", .)
for (i in 1:nrow(data_departemen)){
  query <- paste0("INSERT INTO departemen (id_dept,id_instansi,nama_departemen) VALUES(",
                  "'", data_departemen[i, ]$id_dept, "', ", 
                  "'", data_departemen[i, ]$id_instansi, "', ",
                  "'",data_departemen[i, ]$nama_departemen,"');")
  query_execute <- DBI::dbGetQuery(conn = DB, statement = query)
}

data_penulis<-read.csv("https://raw.githubusercontent.com/rismandwij/kel7_mds/main/scraping/penulis.csv")
str(data_penulis)
data_penulis$id_sinta<-as.character(data_penulis$id_sinta)
data_penulis$id_instansi<-as.character(data_penulis$id_instansi)
data_penulis$nama_penulis<-data_penulis$nama_penulis %>% gsub("'", "", .)
for (i in 1:nrow(data_penulis)){
  query <- paste0("INSERT INTO penulis (id_sinta,nama_penulis,id_instansi,id_dept,subject_list,sinta_score_ovr,jumlah_article_scopus,jumlah_article_gscholar) VALUES(",
                  "'", data_penulis[i, ]$id_sinta, "', ", 
                  "'", data_penulis[i, ]$nama_penulis, "', ",
                  "'",data_penulis[i, ]$id_instansi,"', ",
                  "'",data_penulis[i, ]$id_dept,"', ",
                  "'", data_penulis[i, ]$subject_list, "', ",
                  "'", data_penulis[i, ]$sinta_score_ovr, "', ",
                  "'", data_penulis[i, ]$jumlah_article_scopus, "', ",
                  "'", data_penulis[i, ]$jumlah_article_gscholar, "');")
  query_execute <- DBI::dbGetQuery(conn = DB, statement = query)
}

data_jurnal<-read.csv("https://raw.githubusercontent.com/rismandwij/kel7_mds/main/scraping/judul.csv")
str(data_jurnal)
data_jurnal$id_sinta<-as.character(data_jurnal$id_sinta)
data_jurnal$id_instansi<-as.character(data_jurnal$id_instansi)
data_jurnal$id_paper<-as.character(data_jurnal$id_paper)
data_jurnal$tahun_terbit<-as.character(data_jurnal$tahun_terbit)
data_jurnal$team_penulis<-data_jurnal$team_penulis %>% gsub("'", "", .)
data_jurnal$nama_journal<-data_jurnal$nama_journal %>% gsub("'", "", .)
data_jurnal$nama_penerbit<-data_jurnal$nama_penerbit %>% gsub("'", "", .)
data_jurnal$judul_paper<-data_jurnal$judul_paper %>% gsub("'", "", .)
data_jurnal$jumlah_penulis<-ifelse(is.na(data_jurnal$jumlah_penulis)=="TRUE",0,data_jurnal$jumlah_penulis*1)
for (i in 1:nrow(data_jurnal)){
  query <- paste0("INSERT INTO judul (id_sinta,id_instansi,id_dept,id_paper,judul_paper,nama_penerbit,nama_journal,penulis_ke,jumlah_penulis,team_penulis,tahun_terbit,doi,accred) VALUES(",
                  "'", data_jurnal[i, ]$id_sinta, "', ", 
                  "'", data_jurnal[i, ]$id_instansi, "', ",
                  "'", data_jurnal[i, ]$id_dept,"', ",
                  "'", data_jurnal[i, ]$id_paper,"', ",
                  "'", data_jurnal[i, ]$judul_paper, "', ",
                  "'", data_jurnal[i, ]$nama_penerbit, "', ",
                  "'", data_jurnal[i, ]$nama_journal, "', ",
                  "'", data_jurnal[i, ]$penulis_ke, "', ",
                  "'", data_jurnal[i, ]$jumlah_penulis, "', ",
                  "'", data_jurnal[i, ]$team_penulis, "', ",
                  "'", data_jurnal[i, ]$tahun_terbit, "', ",
                  "'", data_jurnal[i, ]$doi, "', ",
                  "'", data_jurnal[i, ]$accred, "');")
  query_execute <- DBI::dbGetQuery(conn = DB, statement = query)
}