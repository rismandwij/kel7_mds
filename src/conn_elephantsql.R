library(RPostgreSQL)
library(DBI)
driver <- dbDriver('PostgreSQL')
DB <- dbConnect(
  driver,
  dbname="gxhvvifq", # User & Default database
  host="topsy.db.elephantsql.com", # Server
  # port=5433,
  user="gxhvvifq", # User & Default database
  password="naY2KJEmWUNOWvuOwEutRtwlqE4iLH3L" # Password
)

dbhost<-dbConnect(
  driver, 
  dbname="sinta_jurnal", 
  host="localhost",
  port=5432,
  user="postgres",
  password="risman1998"
)

# select departemen dari table departemen
dep=dbReadTable(dbhost,'departemen')
jud=dbReadTable(dbhost,'judul')
ins=dbReadTable(dbhost,'instansi')
pen=dbReadTable(dbhost,'penulis')
dbWriteTable(DB,'departemen',dep,overwrite=T,row.names=F)
dbWriteTable(DB,'judul',jud,overwrite=T,row.names=F)
dbWriteTable(DB,'instansi',ins,overwrite=T,row.names=F)
dbWriteTable(DB,'penulis',pen,overwrite=T,row.names=F)