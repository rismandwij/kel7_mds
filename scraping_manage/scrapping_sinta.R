#install.packages(c("rvest","tidyverse","rio","kableExtra","readxl","stingr"))

#Packages yang digunakan
library(rvest)
library(tidyverse)
library(rio)
library(kableExtra) 
library(readxl)
library(stingr)

#Membuat Master ID Sinta
id = 45509
page = 119
df_master = data.frame()
for(p in 1:page){
  url <- paste("https://sinta.kemdikbud.go.id/subjects/detail/",id,"?page=",p,sep="")
  sinta <- read_html(url)
  NAMA <- html_nodes(sinta, ".profile-name") %>%  html_text2()
  SINTA_ID <- sinta %>% html_nodes("div.profile-id")  %>%  html_text2() %>% gsub("SINTA ID : ", "", .)
  output <- cbind(SINTA_ID,NAMA)
  df_master = rbind(df_master, output)
  print(paste("scraping page", p))
}
head(df_master)

#Melakukan Pengecekan Jurnal pada Tab Garuda
#Check Jurnal
SINTA_ID=unique(df_master$SINTA_ID[])
df_cek = data.frame()
for(i in SINTA_ID){
  url <- paste("https://sinta.kemdikbud.go.id/authors/profile/",i,sep="","/?view=garuda")
  sinta<-read_html(url)
  article<-sinta %>% html_nodes("div.profile-article")
  list_garuda <- article %>% html_children() %>% gsub("[^[:alnum:][:blank:]+?&/\\-]", "", .)
  jumlah<-sum(ifelse(str_like(list_garuda, "%classar-list-item mb-5%")=="FALSE",0,1))
  vektor = c(i,jumlah)
  df_cek = rbind(df_cek, vektor)
}
head(df_cek)

#Scraping data authors
SINTA_ID=unique(df_master$SINTA_ID[])
df_authors = data.frame()
for(i in SINTA_ID){
  url <- paste("https://sinta.kemdikbud.go.id/authors/profile/",i,sep="","/?view=garuda")
  sinta<-read_html(url)
  nama_authors <- sinta %>% html_nodes("h3") %>% html_text2()
  meta_profile <- sinta %>% html_nodes("div.meta-profile") 
  meta_profile <- meta_profile %>% html_nodes("a")
  nama_univ <- meta_profile[1] %>% html_text2()
  id_univ <- as.character(meta_profile[1] %>% html_attrs()) %>% gsub("https://sinta.kemdikbud.go.id/affiliations/profile/", "", .)
  nama_dept <- meta_profile[2] %>% html_text2()
  sinta_id <- meta_profile[3] %>% html_text2() %>% gsub("SINTA ID : ", "", .)
  url_dept <- as.character(meta_profile[2] %>% html_attrs())
  id_dept <- ifelse(nama_dept=="Unknown",paste("u",sinta_id,sep=""),sub('.*/', '', url_dept))
  stat_profile <- sinta %>% html_nodes("div.pr-num")
  sinta_score_ovr <- stat_profile[1] %>% html_text2()
  sinta_score_ovr <- as.numeric(gsub('[^[:alnum:] ]',"",sinta_score_ovr))
  subject_list <- sinta %>% html_nodes("div.profile-subject.mt-3")
  subject_list <- subject_list %>% html_nodes("ul.subject-list")
  subject_list <- subject_list %>% html_nodes("li")
  subject_list <- subject_list %>% html_text2()
  subject_list <- paste(subject_list, collapse= ", ")
  Table <- sinta %>%
    html_nodes("table") %>% 
    html_table(fill = FALSE) %>% .[[1]]
  jumlah_artikel_scopus <- as.numeric(Table[1,2])
  jumlah_artikel_gscholar <- as.numeric(Table[1,3])
  vektor = c(sinta_id,nama_authors,id_univ,id_dept,nama_dept,subject_list,sinta_score_ovr,jumlah_artikel_scopus,jumlah_artikel_gscholar)
  df_authors = rbind(df_authors, vektor)
  print(paste("scraping page", i)) 
}
colnames(df_authors) <- c("id_sinta","nama_penulis","id_instansi","id_dept","departemen","subject_list","sinta_score_ovr","jumlah_article_scopus","jumlah_article_gscholar")
head(df_authors)

#Membuat Tabel Departemen
df_departement<-df_authors[!duplicated(df_authors$id_dept),c("id_dept","id_instansi","departemen")]
df_departement <- df_departement %>% distinct(id_dept, id_instansi, .keep_all = T)
colnames(df_departement)<-c('id_dept','id_instansi','nama_departemen')
head(df_departement)

#Scrapping data Instansi
univ_id=as.vector(unique(df_authors$id_instansi))
df_univ = data.frame()
for(i in univ_id){
  url <- paste("https://sinta.kemdikbud.go.id/affiliations/profile/",i,sep="")
  sinta<-read_html(url)
  nama_univ <- sinta %>% html_nodes("h3") %>% html_text2()
  meta_profile <- sinta %>% html_nodes("div.meta-profile") 
  meta_profile <- meta_profile %>% html_nodes("a")
  id_univ <- i
  lokasi <- meta_profile[1] %>% html_text()
  stat_univ<- sinta %>% html_nodes("div.stat-num")  %>% html_text2()
  jumlah_penulis<-stat_univ[1]
  jumlah_penulis<-as.numeric(gsub('[^[:alnum:] ]',"",jumlah_penulis))
  jumlah_departemen<-stat_univ[2]
  jumlah_departemen<-as.numeric(gsub('[^[:alnum:] ]',"",jumlah_departemen))
  jumlah_jurnal<-stat_univ[3]
  jumlah_jurnal<-as.numeric(gsub('[^[:alnum:] ]',"",jumlah_jurnal))
  vektor = c(id_univ,nama_univ,lokasi,jumlah_penulis,jumlah_departemen,jumlah_jurnal)
  df_univ = rbind(df_univ, vektor)
  print(paste("scraping page", i)) 
}
df_instansi<-df_univ
colnames(df_instansi)<-c("id_instansi","nama_instansi","lokasi","jumlah_penulis","jumlah_departemen","jumlah_journals")
head(df_instansi)

#Scrape data paper pada tab garuda
df_cek_id<-subset(df_cek,df_cek[,2]!=0)
id_sinta_jurnal<-as.vector(df_cek_id[,1])
head(id_sinta_jurnal)
jurnal<-function(id){
  url <- paste("https://sinta.kemdikbud.go.id/authors/profile/",id,sep="","/?view=garuda")
  sinta<-read_html(url)
  article<-sinta %>% html_nodes("div.profile-article")
  list_garuda <- article %>% html_nodes("div.ar-list-item.mb-5")
  meta_profile <- sinta %>% html_nodes("div.meta-profile") 
  meta_profile <- meta_profile %>% html_nodes("a")
  id_instansi <- as.character(meta_profile[1] %>% html_attrs()) %>% gsub("https://sinta.kemdikbud.go.id/affiliations/profile/", "", .)
  url_dept <- as.character(meta_profile[2] %>% html_attrs())
  nama_dept <- meta_profile[2] %>% html_text2()
  id_dept <- ifelse(nama_dept=="Unknown",paste("u",id,sep=""),sub('.*/', '', url_dept))
  url_jurnal <- list_garuda %>% html_nodes("div.ar-title")
  id_paper <- html_attr(html_nodes(url_jurnal, "a"), "href") %>% gsub("https://garuda.kemdikbud.go.id/documents/detail/","",.)
  nama_article <- list_garuda %>% html_nodes("div.ar-title")
  nama_article <- nama_article %>% html_text2()
  nama_article <- nama_article %>% gsub("\r","",.) %>% gsub("[^[:alnum:][:blank:]+?&/\\-]", "", .)
  penerbit<-list_garuda %>% html_nodes("div.ar-meta")
  penerbit<-penerbit %>% html_text2()
  odd <- seq(1,length(penerbit),2)
  even <- seq(2,length(penerbit),2)
  nama_penerbit<-str_split(penerbit[odd], "\r \r") 
  nama_penerbit<-t(data.frame(lapply(nama_penerbit, function(i) unlist(i[2]))))
  nama_jurnal<-str_split(penerbit[odd], "\r \r")
  nama_jurnal<-t(data.frame(lapply(nama_jurnal, function(i) unlist(i[3])))) %>% gsub("\r","",.)
  penulis_ke<-penerbit[even] %>% gsub("\r \r","",.) %>% gsub("\r\n","_",.) %>% gsub("\r","_",.)
  penulis_ke<-str_split(penulis_ke, "_")
  penulis_ke<-t(data.frame(lapply(penulis_ke, function(i) unlist(i[1]))))
  penulis_ke<- penulis_ke %>% gsub("Author Order : ","",.)
  penulis_keF<- as.numeric(substr(penulis_ke, 2, 3))
  penulis_keL<- as.numeric(substr(penulis_ke, 7, 7))
  team_penulis<-penerbit[even] %>% gsub("\r \r","",.) %>% gsub("\r\n","_",.) %>% gsub("\r","_",.)
  team_penulis<-str_split(team_penulis, "_")
  team_penulis<-t(data.frame(lapply(team_penulis, function(i) unlist(i[2]))))
  tahun_terbit<-list_garuda %>% html_nodes("div.ar-meta") %>% html_nodes("a.ar-year") %>% html_text2()
  doi<-list_garuda %>% html_nodes("div.ar-meta") %>% html_nodes("a.ar-cited") %>% html_text2() %>% gsub("DOI:","",.)
  accred<-list_garuda %>% html_nodes("div.ar-meta") %>% html_nodes("a.ar-quartile") %>% html_text2() %>% gsub("Accred : ","",.)
  a=data.frame(id_sinta=0,id_instansi=0,id_dept=0,id_paper,judul_paper=0,nama_penerbit=0,nama_journal=0,penulis_ke=0,jumlah_penulis=0,team_penulis=0,tahun_terbit=0,doi=0,accred=0)
  kode=id
  for (i in 1:length(nama_article)){
    for (j in 1:length(kode)){
      a[i,1]=kode[j]
      a[i,2]=id_instansi[j]
      a[i,3]=id_dept[j]
      a[i,4]=id_paper[i]
      a[i,5]=nama_article[i]
      a[i,6]=nama_penerbit[i]
      a[i,7]=nama_jurnal[i]
      a[i,8]=penulis_keF[i]
      a[i,9]=penulis_keL[i]
      a[i,10]=team_penulis[i]
      a[i,11]=tahun_terbit[i]
      a[i,12]=doi[i]
      a[i,13]=accred[i]
    }
  }
  return(a)
}
kode=id_sinta_jurnal
df_jurnal<-data.frame()
for (i in kode){
  paper<-jurnal(i)
  df_jurnal<-rbind(df_jurnal,paper)
}
head(df_jurnal)

#Membuat file csv
#write.csv(df_departement, file='departemen.csv',row.names=F)
#write.csv(df_instansi, file='instansi.csv',row.names=F)
#write.csv(df_authors, file='penulis1.csv',row.names=F)
#write.csv(df_jurnal, file='judul.csv',row.names=F)
