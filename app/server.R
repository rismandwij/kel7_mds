library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(RPostgreSQL)
library(DBI)
library(DT)
library(bs4Dash)
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
# Query 1: Tabel Judul dengan Informasi Bidang Ilmu

q1 <- print(
  "SELECT judul.id_sinta,penulis.nama_penulis,judul_paper,
nama_penerbit,nama_journal,tahun_terbit,accred,
CASE WHEN lower(subject_list) in ('statistics','statistik','statistika','statistic') then 'Statistika'
WHEN lower(subject_list) like '%pendidikan%' or 
     lower(subject_list) like '%education%' or 
     lower(subject_list) like '%pembelajaran%' or
     lower(subject_list) like '%pgsd%' or 
     lower(subject_list) like '%paud%' or
     lower(subject_list) like '%instrumen%' or
     lower(subject_list) like '%assessment%' or
     lower(subject_list) like '%measurement%' or
     lower(subject_list) like '%asesmen%' or
     lower(subject_list) like '%program linier%' or
     lower(subject_list) like '%pengukuran dan evaluasi%' or
     lower(subject_list) like '%analisa vektor%' or
     lower(subject_list) like '%kurikulum%' then 'Statistika Pendidikan'
WHEN lower(subject_list) like '%komputasi%' or
     lower(subject_list) like '%web%' or
     lower(subject_list) like '%computation%' or 
     lower(subject_list) like '%computer%' or
     lower(subject_list) like '%iot%' or
     lower(subject_list) like '%software%' or
     lower(subject_list) like '%ui%' or
     lower(subject_list) like '%ux%' or
     lower(subject_list) like '%kriptografi%' or
     lower(subject_list) like '%teknologi%' or
     lower(subject_list) like '%information%' or
     lower(subject_list) like '%processing%' or
     lower(subject_list) like '%cryptography%' or
     lower(subject_list) like '%programming%' or
     lower(subject_list) like '%remote sensing%' or 
     lower(subject_list) like '%business analytics%' or
     lower(subject_list) like '%wavelet%' or
     lower(subject_list) like '%neural network%' or
     lower(subject_list) like '%anfis%' or
     lower(subject_list) like '%big data%' or
     lower(subject_list) like '%artificial neural network%' or
     lower(subject_list) like '%decision support system%' or
     lower(subject_list) like '%predictive analytics%' or
     lower(subject_list) like '%kecerdasan buatan%' or
     lower(subject_list) like '%imaging sciences%' or
     lower(subject_list) like '%sistem pakar%' or
     lower(subject_list) like '%networking%' or
     lower(subject_list) like '%sistem informasi%' or
     lower(subject_list) like '%basis data%' or
     lower(subject_list) like '%onformatika%' or
     lower(subject_list) like '%data mining%' then 'Statistika Komputasi'
WHEN lower(subject_list) like '%ilmu kehidupan dan biostatistik%' or
     lower(subject_list) like '%biologi%' or
     lower(subject_list) like '%kimia%' or
     lower(subject_list) like '%biokimia%' or
     lower(subject_list) like '%bioinformatics%' or
     lower(subject_list) like '%genetika%' or
     lower(subject_list) like '%animal%' or
     lower(subject_list) like '%biostatistics%' or
     lower(subject_list) like '%plant%' or
     lower(subject_list) like '%forest%' or
     lower(subject_list) like '%mangrove%' or
     lower(subject_list) like '%climatology%' or
     lower(subject_list) like '%food technology%' or
     lower(subject_list) like '%geology%' or
     lower(subject_list) like '%epidemoilogi%' or
     lower(subject_list) like '%peternakan%' or
     lower(subject_list) like '%ilmu gulma%' or
     lower(subject_list) like '%virology%' then 'Statistika Kehidupan dan Biostatistik'
 WHEN lower(subject_list) like '%ekonomi dan bisnis%' or
     lower(subject_list) like '%business%' or
     lower(subject_list) like '%econometrics%' or
     lower(subject_list) like '%ekonomi%' or
     lower(subject_list) like '%pemasaran%' or
     lower(subject_list) like '%marketing%' or
     lower(subject_list) like '%auditing%' or
     lower(subject_list) like '%financial%' or
     lower(subject_list) like '%akturia%' or
     lower(subject_list) like '%agribusiness%' or
     lower(subject_list) like '%economics%' or
     lower(subject_list) like '%keuangan%' or
     lower(subject_list) like '%asuransi%' or
     lower(subject_list) like '%akutansi%' or
     lower(subject_list) like '%kewirausahaan%' or
     lower(subject_list) like '%manajemen%' or
     lower(subject_list) like '%shares%' or
     lower(subject_list) like '%finance%' or
     lower(subject_list) like '%pasar modal%' or
     lower(subject_list) like '%actuarial science%' or
     lower(subject_list) like '%ekonometrika%' or
     lower(subject_list) like '%bioeconomic%' or
     lower(subject_list) like '%economic%' or
     lower(subject_list) like '%accounting%' or
     lower(subject_list) like '%aktuaria%' or
     lower(subject_list) like '%econometric%' or
     lower(subject_list) like '%management%' or
     lower(subject_list) like '%strategic management%' or
     lower(subject_list) like '%technopreneurship%' or
     lower(subject_list) like '%komputer akuntansi%' or
     lower(subject_list) like '%agribisnis%' or
     lower(subject_list) like '%otomasi sistem produksi%' or
     lower(subject_list) like '%bisnis%' or
     lower(subject_list) like '%entrepreneurship%' or
     lower(subject_list) like '%quantitative management%' then 'Statistika Ekonomi dan Bisnis'
WHEN lower(subject_list) like '%sosial%' or
     lower(subject_list) like '%demografi%' or
     lower(subject_list) like '%geografi%' or
     lower(subject_list) like '%social%' or
     lower(subject_list) like '%regional%' or
     lower(subject_list) like '%populational%' or
     lower(subject_list) like '%kebijakan%' or
     lower(subject_list) like '%konsumen%' or
     lower(subject_list) like '%layanan%' or
     lower(subject_list) like '%demography%' or
     lower(subject_list) like '%pariwisata%' or
     lower(subject_list) like '%fiscal%' or
     lower(subject_list) like '%political%' or
     lower(subject_list) like '%sociology%' or
     lower(subject_list) like '%disaster%' or
     lower(subject_list) like '%consumer behavior%' or
     lower(subject_list) like '%bencana%' or
     lower(subject_list) like '%international relations%' or
     lower(subject_list) like '%tourism%' or
     lower(subject_list) like '%hospitality%' or
     lower(subject_list) like '%pemerintahan%' or
     lower(subject_list) like '%transportasi%' or
     lower(subject_list) like '%lingkungan%' or
     lower(subject_list) like '%urban%' or
     lower(subject_list) like '%poverty%' or
     lower(subject_list) like '%geoinformatics%' or
     lower(subject_list) like '%msdm%' or
     lower(subject_list) like '%sumber daya manusia%' or
     lower(subject_list) like '%geostatistik%' or
     lower(subject_list) like '%penelitian operasional%' or
     lower(subject_list) like '%human resources management%' or
     lower(subject_list) like 'ergonomic%' or
     lower(subject_list) like '%research metodology%' or
     lower(subject_list) like '%human resources%' or
     lower(subject_list) like '%marine protected area%' or
     lower(subject_list) like '%environmental%' or
     lower(subject_list) like '%sdm%' or
     lower(subject_list) like '%msdm%' or
     lower(subject_list) like '%ketahanan nasional%' then 'Statistika Sosial'
WHEN lower(subject_list) like '%industri dan keteknikan%' or
     lower(subject_list) like '%engineering%' or
     lower(subject_list) like '%quality control%' or
     lower(subject_list) like '%teknik%' or
     lower(subject_list) like '%industri%' or
     lower(subject_list) like '%supply chain%' or
     lower(subject_list) like '%machine%' or
     lower(subject_list) like '%industrial%' or
     lower(subject_list) like '%logistik%' or
     lower(subject_list) like '%forecasting%' or
     lower(subject_list) like '%fisika statistik%' or
     lower(subject_list) like '%instructional technology%' or
     lower(subject_list) like '%elektro%' or
     lower(subject_list) like '%telekomunikasi%' or
     lower(subject_list) like '%enginering%' or
     lower(subject_list) like '%scm%' or
     lower(subject_list) like '%analisa perancang kerja%' or
     lower(subject_list) like '%operation%' then 'Statistika Industri dan Keteknikan'
WHEN lower(subject_list) like '%kesehatan%' or
     lower(subject_list) like '%medical%' or
     lower(subject_list) like '%health%' or
     lower(subject_list) like '%ergonomics%' or
     lower(subject_list) like '%kedokteran%' or
     lower(subject_list) like '%anatomy%' or
     lower(subject_list) like '%epidemiology%' or
     lower(subject_list) like '%penyakit%' or
     lower(subject_list) like '%pharmacy%' or
     lower(subject_list) like '%energy%' or
     lower(subject_list) like '%management agroindustry%' or
     lower(subject_list) like '%disease%' then 'Statistika kesehatan'
WHEN lower(subject_list) like '%budaya dan bahasa%' or
     lower(subject_list) like '%tefl%' or
     lower(subject_list) like '%tesol%' or
     lower(subject_list) like '%english%' or
     lower(subject_list) like '%budaya%' then 'Statistika Budaya dan Bahasa'
WHEN lower(subject_list) like '%keagamaan%' or
     lower(subject_list) like '%islamic%' or
     lower(subject_list) like '%islam%' or
     lower(subject_list) like '%dakwah%' or
     lower(subject_list) like '%syariah%' or
     lower(subject_list) like '%sharia%' or
     lower(subject_list) like '%kristen%' or
     lower(subject_list) like '%teologi%' then 'Statistika Keagamaan'
WHEN lower(subject_list) like '%tennis%' then 'Statistika Olahraga' 
WHEN lower(subject_list) like '%pertanian%' or
     lower(subject_list) like '%agricultural%' or
     lower(subject_list) like '%agribusiness%' or
     lower(subject_list) like '%pertanian%' or
     lower(subject_list) like '%pascapanen%' or
     lower(subject_list) like '%agriculture%' then 'Statistika Pertanian'
WHEN lower(subject_list) like '%psikologi%' or
     lower(subject_list) like '%psychology%' or
     lower(subject_list) like '%psychometrics%' or
     lower(subject_list) like '%psikometri%' or
     lower(subject_list) like '%jiwa%' or
     lower(subject_list) like '%psychometry%' or
     lower(subject_list) like '%bimbingan konseling%' or
     lower(subject_list) like '%neurosains%' then 'Statistika Psikologi'
WHEN lower(subject_list) like '%probability%' or
     lower(subject_list) like '%survival analysis%' or
     lower(subject_list) like '%research method%' or
     lower(subject_list) like '%optimization%' or
     lower(subject_list) like '%modelling%' or
     lower(subject_list) like '%kalkulus%' or
     lower(subject_list) like '%metodologi penelitian%' or
     lower(subject_list) like '%spasial%' or
     lower(subject_list) like '%forecasting%' or
     lower(subject_list) like '%survey%' or
     lower(subject_list) like '%bayesian%' or
     lower(subject_list) like '%research methodology%' or
     lower(subject_list) like '%spatial statistics%' or
     lower(subject_list) like '%rancangan percobaan%' or
     lower(subject_list) like '%riset operasi%' or
     lower(subject_list) like '%matematika diskrit%' or
     lower(subject_list) like '%teori graf%' or
     lower(subject_list) like '%logika matematika%' or
     lower(subject_list) like '%sampling%' or
     lower(subject_list) like '%logistic regression%' or
     lower(subject_list) like '%literasi matematika%' or
     lower(subject_list) like '%optimisasi%' or
     lower(subject_list) like '%time series analysis%' or
     lower(subject_list) like '%matematika terapan%' or
     lower(subject_list) like '%ipa%' or
     lower(subject_list) like '%aljabar linier%' or
     lower(subject_list) like '%aljabar%' or
     lower(subject_list) like '%data analysis%' or
     lower(subject_list) like '%analysist statistic%' or
     lower(subject_list) like '%clustering analysis%' or
     lower(subject_list) like '%spatial%' or
     lower(subject_list) like '%time series%' or
     lower(subject_list) like '%data%' or
     lower(subject_list) like '%aljabar linier%' or
     lower(subject_list) like '%fisika dasar%' or
     lower(subject_list) like '%applied mathematics%' or
     lower(subject_list) like '%aplied mathematics%' or
     lower(subject_list) like '%analisis survival%' or
     lower(subject_list) like '%analisis runtun waktu%' or
     lower(subject_list) like '%data classification%' or
     lower(subject_list) like '%penelitian%' or
     lower(subject_list) like '%math%' or
     lower(subject_list) like '%metologi penelitian kuantitatif%' or
     lower(subject_list) like '%pure mathematics%' or
     lower(subject_list) like '%spatial analysis%' or
     lower(subject_list) like '%spatial area%' or
     lower(subject_list) like '%metode penelitian%' or
     lower(subject_list) like '%matematika%' or
     lower(subject_list) like '%statistika, statistics%' or
     lower(subject_list) like '%mathematics%' then 'Statistika'
    ELSE 'Non-Statistik' END AS bidang_ilmu
FROM penulis 
INNER JOIN judul ON penulis.id_sinta=judul.id_sinta")
#-----------------------------------------------------------------------------#
# Query 2: Tabel Penulis & Instansi dengan Informasi Bidang Ilmu
q2 <- print(
  "SELECT id_sinta,nama_penulis,instansi.nama_instansi,
departemen.nama_departemen,subject_list,
CASE WHEN lower(subject_list) in ('statistics','statistik','statistika','statistic') then 'Statistika'
WHEN lower(subject_list) like '%pendidikan%' or 
     lower(subject_list) like '%education%' or 
     lower(subject_list) like '%pembelajaran%' or
     lower(subject_list) like '%pgsd%' or 
     lower(subject_list) like '%paud%' or
     lower(subject_list) like '%instrumen%' or
     lower(subject_list) like '%assessment%' or
     lower(subject_list) like '%measurement%' or
     lower(subject_list) like '%asesmen%' or
     lower(subject_list) like '%program linier%' or
     lower(subject_list) like '%pengukuran dan evaluasi%' or
     lower(subject_list) like '%analisa vektor%' or
     lower(subject_list) like '%kurikulum%' then 'Statistika Pendidikan'
WHEN lower(subject_list) like '%komputasi%' or
     lower(subject_list) like '%web%' or
     lower(subject_list) like '%computation%' or 
     lower(subject_list) like '%computer%' or
     lower(subject_list) like '%iot%' or
     lower(subject_list) like '%software%' or
     lower(subject_list) like '%ui%' or
     lower(subject_list) like '%ux%' or
     lower(subject_list) like '%kriptografi%' or
     lower(subject_list) like '%teknologi%' or
     lower(subject_list) like '%information%' or
     lower(subject_list) like '%processing%' or
     lower(subject_list) like '%cryptography%' or
     lower(subject_list) like '%programming%' or
     lower(subject_list) like '%remote sensing%' or 
     lower(subject_list) like '%business analytics%' or
     lower(subject_list) like '%wavelet%' or
     lower(subject_list) like '%neural network%' or
     lower(subject_list) like '%anfis%' or
     lower(subject_list) like '%big data%' or
     lower(subject_list) like '%artificial neural network%' or
     lower(subject_list) like '%decision support system%' or
     lower(subject_list) like '%predictive analytics%' or
     lower(subject_list) like '%kecerdasan buatan%' or
     lower(subject_list) like '%imaging sciences%' or
     lower(subject_list) like '%sistem pakar%' or
     lower(subject_list) like '%networking%' or
     lower(subject_list) like '%sistem informasi%' or
     lower(subject_list) like '%basis data%' or
     lower(subject_list) like '%onformatika%' or
     lower(subject_list) like '%data mining%' then 'Statistika Komputasi'
WHEN lower(subject_list) like '%ilmu kehidupan dan biostatistik%' or
     lower(subject_list) like '%biologi%' or
     lower(subject_list) like '%kimia%' or
     lower(subject_list) like '%biokimia%' or
     lower(subject_list) like '%bioinformatics%' or
     lower(subject_list) like '%genetika%' or
     lower(subject_list) like '%animal%' or
     lower(subject_list) like '%biostatistics%' or
     lower(subject_list) like '%plant%' or
     lower(subject_list) like '%forest%' or
     lower(subject_list) like '%mangrove%' or
     lower(subject_list) like '%climatology%' or
     lower(subject_list) like '%food technology%' or
     lower(subject_list) like '%geology%' or
     lower(subject_list) like '%epidemoilogi%' or
     lower(subject_list) like '%peternakan%' or
     lower(subject_list) like '%ilmu gulma%' or
     lower(subject_list) like '%virology%' then 'Statistika Kehidupan dan Biostatistik'
 WHEN lower(subject_list) like '%ekonomi dan bisnis%' or
     lower(subject_list) like '%business%' or
     lower(subject_list) like '%econometrics%' or
     lower(subject_list) like '%ekonomi%' or
     lower(subject_list) like '%pemasaran%' or
     lower(subject_list) like '%marketing%' or
     lower(subject_list) like '%auditing%' or
     lower(subject_list) like '%financial%' or
     lower(subject_list) like '%akturia%' or
     lower(subject_list) like '%agribusiness%' or
     lower(subject_list) like '%economics%' or
     lower(subject_list) like '%keuangan%' or
     lower(subject_list) like '%asuransi%' or
     lower(subject_list) like '%akutansi%' or
     lower(subject_list) like '%kewirausahaan%' or
     lower(subject_list) like '%manajemen%' or
     lower(subject_list) like '%shares%' or
     lower(subject_list) like '%finance%' or
     lower(subject_list) like '%pasar modal%' or
     lower(subject_list) like '%actuarial science%' or
     lower(subject_list) like '%ekonometrika%' or
     lower(subject_list) like '%bioeconomic%' or
     lower(subject_list) like '%economic%' or
     lower(subject_list) like '%accounting%' or
     lower(subject_list) like '%aktuaria%' or
     lower(subject_list) like '%econometric%' or
     lower(subject_list) like '%management%' or
     lower(subject_list) like '%strategic management%' or
     lower(subject_list) like '%technopreneurship%' or
     lower(subject_list) like '%komputer akuntansi%' or
     lower(subject_list) like '%agribisnis%' or
     lower(subject_list) like '%otomasi sistem produksi%' or
     lower(subject_list) like '%bisnis%' or
     lower(subject_list) like '%entrepreneurship%' or
     lower(subject_list) like '%quantitative management%' then 'Statistika Ekonomi dan Bisnis'
WHEN lower(subject_list) like '%sosial%' or
     lower(subject_list) like '%demografi%' or
     lower(subject_list) like '%geografi%' or
     lower(subject_list) like '%social%' or
     lower(subject_list) like '%regional%' or
     lower(subject_list) like '%populational%' or
     lower(subject_list) like '%kebijakan%' or
     lower(subject_list) like '%konsumen%' or
     lower(subject_list) like '%layanan%' or
     lower(subject_list) like '%demography%' or
     lower(subject_list) like '%pariwisata%' or
     lower(subject_list) like '%fiscal%' or
     lower(subject_list) like '%political%' or
     lower(subject_list) like '%sociology%' or
     lower(subject_list) like '%disaster%' or
     lower(subject_list) like '%consumer behavior%' or
     lower(subject_list) like '%bencana%' or
     lower(subject_list) like '%international relations%' or
     lower(subject_list) like '%tourism%' or
     lower(subject_list) like '%hospitality%' or
     lower(subject_list) like '%pemerintahan%' or
     lower(subject_list) like '%transportasi%' or
     lower(subject_list) like '%lingkungan%' or
     lower(subject_list) like '%urban%' or
     lower(subject_list) like '%poverty%' or
     lower(subject_list) like '%geoinformatics%' or
     lower(subject_list) like '%msdm%' or
     lower(subject_list) like '%sumber daya manusia%' or
     lower(subject_list) like '%geostatistik%' or
     lower(subject_list) like '%penelitian operasional%' or
     lower(subject_list) like '%human resources management%' or
     lower(subject_list) like 'ergonomic%' or
     lower(subject_list) like '%research metodology%' or
     lower(subject_list) like '%human resources%' or
     lower(subject_list) like '%marine protected area%' or
     lower(subject_list) like '%environmental%' or
     lower(subject_list) like '%sdm%' or
     lower(subject_list) like '%msdm%' or
     lower(subject_list) like '%ketahanan nasional%' then 'Statistika Sosial'
WHEN lower(subject_list) like '%industri dan keteknikan%' or
     lower(subject_list) like '%engineering%' or
     lower(subject_list) like '%quality control%' or
     lower(subject_list) like '%teknik%' or
     lower(subject_list) like '%industri%' or
     lower(subject_list) like '%supply chain%' or
     lower(subject_list) like '%machine%' or
     lower(subject_list) like '%industrial%' or
     lower(subject_list) like '%logistik%' or
     lower(subject_list) like '%forecasting%' or
     lower(subject_list) like '%fisika statistik%' or
     lower(subject_list) like '%instructional technology%' or
     lower(subject_list) like '%elektro%' or
     lower(subject_list) like '%telekomunikasi%' or
     lower(subject_list) like '%enginering%' or
     lower(subject_list) like '%scm%' or
     lower(subject_list) like '%analisa perancang kerja%' or
     lower(subject_list) like '%operation%' then 'Statistika Industri dan Keteknikan'
WHEN lower(subject_list) like '%kesehatan%' or
     lower(subject_list) like '%medical%' or
     lower(subject_list) like '%health%' or
     lower(subject_list) like '%ergonomics%' or
     lower(subject_list) like '%kedokteran%' or
     lower(subject_list) like '%anatomy%' or
     lower(subject_list) like '%epidemiology%' or
     lower(subject_list) like '%penyakit%' or
     lower(subject_list) like '%pharmacy%' or
     lower(subject_list) like '%energy%' or
     lower(subject_list) like '%management agroindustry%' or
     lower(subject_list) like '%disease%' then 'Statistika kesehatan'
WHEN lower(subject_list) like '%budaya dan bahasa%' or
     lower(subject_list) like '%tefl%' or
     lower(subject_list) like '%tesol%' or
     lower(subject_list) like '%english%' or
     lower(subject_list) like '%budaya%' then 'Statistika Budaya dan Bahasa'
WHEN lower(subject_list) like '%keagamaan%' or
     lower(subject_list) like '%islamic%' or
     lower(subject_list) like '%islam%' or
     lower(subject_list) like '%dakwah%' or
     lower(subject_list) like '%syariah%' or
     lower(subject_list) like '%sharia%' or
     lower(subject_list) like '%kristen%' or
     lower(subject_list) like '%teologi%' then 'Statistika Keagamaan'
WHEN lower(subject_list) like '%tennis%' then 'Statistika Olahraga' 
WHEN lower(subject_list) like '%pertanian%' or
     lower(subject_list) like '%agricultural%' or
     lower(subject_list) like '%agribusiness%' or
     lower(subject_list) like '%pertanian%' or
     lower(subject_list) like '%pascapanen%' or
     lower(subject_list) like '%agriculture%' then 'Statistika Pertanian'
WHEN lower(subject_list) like '%psikologi%' or
     lower(subject_list) like '%psychology%' or
     lower(subject_list) like '%psychometrics%' or
     lower(subject_list) like '%psikometri%' or
     lower(subject_list) like '%jiwa%' or
     lower(subject_list) like '%psychometry%' or
     lower(subject_list) like '%bimbingan konseling%' or
     lower(subject_list) like '%neurosains%' then 'Statistika Psikologi'
WHEN lower(subject_list) like '%probability%' or
     lower(subject_list) like '%survival analysis%' or
     lower(subject_list) like '%research method%' or
     lower(subject_list) like '%optimization%' or
     lower(subject_list) like '%modelling%' or
     lower(subject_list) like '%kalkulus%' or
     lower(subject_list) like '%metodologi penelitian%' or
     lower(subject_list) like '%spasial%' or
     lower(subject_list) like '%forecasting%' or
     lower(subject_list) like '%survey%' or
     lower(subject_list) like '%bayesian%' or
     lower(subject_list) like '%research methodology%' or
     lower(subject_list) like '%spatial statistics%' or
     lower(subject_list) like '%rancangan percobaan%' or
     lower(subject_list) like '%riset operasi%' or
     lower(subject_list) like '%matematika diskrit%' or
     lower(subject_list) like '%teori graf%' or
     lower(subject_list) like '%logika matematika%' or
     lower(subject_list) like '%sampling%' or
     lower(subject_list) like '%logistic regression%' or
     lower(subject_list) like '%literasi matematika%' or
     lower(subject_list) like '%optimisasi%' or
     lower(subject_list) like '%time series analysis%' or
     lower(subject_list) like '%matematika terapan%' or
     lower(subject_list) like '%ipa%' or
     lower(subject_list) like '%aljabar linier%' or
     lower(subject_list) like '%aljabar%' or
     lower(subject_list) like '%data analysis%' or
     lower(subject_list) like '%analysist statistic%' or
     lower(subject_list) like '%clustering analysis%' or
     lower(subject_list) like '%spatial%' or
     lower(subject_list) like '%time series%' or
     lower(subject_list) like '%data%' or
     lower(subject_list) like '%aljabar linier%' or
     lower(subject_list) like '%fisika dasar%' or
     lower(subject_list) like '%applied mathematics%' or
     lower(subject_list) like '%aplied mathematics%' or
     lower(subject_list) like '%analisis survival%' or
     lower(subject_list) like '%analisis runtun waktu%' or
     lower(subject_list) like '%data classification%' or
     lower(subject_list) like '%penelitian%' or
     lower(subject_list) like '%math%' or
     lower(subject_list) like '%metologi penelitian kuantitatif%' or
     lower(subject_list) like '%pure mathematics%' or
     lower(subject_list) like '%spatial analysis%' or
     lower(subject_list) like '%spatial area%' or
     lower(subject_list) like '%metode penelitian%' or
     lower(subject_list) like '%matematika%' or
     lower(subject_list) like '%statistika, statistics%' or
     lower(subject_list) like '%mathematics%' then 'Statistika'
    ELSE 'Non-Statistik' END AS bidang_ilmu
FROM penulis 
INNER JOIN instansi ON penulis.id_instansi=instansi.id_instansi 
INNER JOIN departemen ON instansi.id_instansi=departemen.id_instansi")
#-----------------------------------------------------------------------------#
# Query 3: Leaderboard Instansi berdasarkan Sinta Score
q3 <- print(
  "with dt1 as (
SELECT *,split_part(lokasi, '-', 1) AS kota_kab,
         split_part(lokasi, '-', 2) AS provinsi
FROM instansi ),
dt2 as(
SELECT *,REGEXP_REPLACE(provinsi, ', ID', '') AS prov
FROM dt1
),
dt3 as 
(SELECT id_sinta,dt2.id_instansi,dt2.nama_instansi,dt2.prov,dt2,kota_kab,
sinta_score_ovr,jumlah_article_scopus
FROM penulis
INNER JOIN dt2 ON penulis.id_instansi=dt2.id_instansi
),
dt4 as
(SELECT id_instansi,nama_instansi,INITCAP(prov) AS provinsi,
INITCAP(kota_kab) AS kab_kota,sinta_score_ovr as sinta_score_ovr,
jumlah_article_scopus 
FROM dt3
),
dt5 as(
SELECT id_instansi,nama_instansi,sinta_score_ovr
FROM dt4
)
SELECT nama_instansi,SUM(sinta_score_ovr)as sinta_score FROM dt5
GROUP BY id_instansi,nama_instansi
ORDER BY sinta_score DESC
LIMIT 10"
)
#-----------------------------------------------------------------------------#
# Query 4: Leaderboard Instansi berdasarkan Banyaknya Jurnal
q4 <- print(
  "with dt1 as (
SELECT *,split_part(lokasi, '-', 1) AS kota_kab,
         split_part(lokasi, '-', 2) AS provinsi
FROM instansi ),
dt2 as(
SELECT *,REGEXP_REPLACE(provinsi, ', ID', '') AS prov
FROM dt1
),
dt3 as 
(SELECT id_sinta,dt2.id_instansi,dt2.nama_instansi,dt2.prov,dt2,kota_kab,
sinta_score_ovr,jumlah_article_scopus
FROM penulis
INNER JOIN dt2 ON penulis.id_instansi=dt2.id_instansi
),
dt4 as
(SELECT id_instansi,nama_instansi,INITCAP(prov) AS provinsi,
INITCAP(kota_kab) AS kab_kota,sinta_score_ovr as sinta_score_ovr,
jumlah_article_scopus as jumlah_article_scopus 
FROM dt3
),
dt5 as(
SELECT id_instansi,nama_instansi, jumlah_article_scopus
FROM dt4
)
SELECT nama_instansi, SUM(jumlah_article_scopus) as jumlah_article_scopus FROM dt5
GROUP BY id_instansi,nama_instansi
ORDER BY jumlah_article_scopus DESC
LIMIT 10"
)
#-----------------------------------------------------------------------------#
# Query 5: Leaderboard Penulis berdasarkan Sinta Score
q5 <- print(
  "with dt1 as (SELECT *,
CASE WHEN departemen.nama_departemen='Unknown' then 'Unknown'
     ELSE split_part(departemen.nama_departemen, '- ', 2) END
     AS nama_dept
FROM penulis
INNER JOIN instansi ON penulis.id_instansi=instansi.id_instansi
INNER JOIN departemen ON penulis.id_dept=departemen.id_dept
),
dt2 as(
 SELECT id_sinta,INITCAP(nama_penulis) AS nama_penulis,nama_dept,nama_instansi,
 sinta_score_ovr as sinta_score_ovr,jumlah_article_scopus 
FROM dt1
),
dt3 as(
 SELECT id_sinta,nama_penulis,sinta_score_ovr
FROM dt2
)
SELECT id_sinta,nama_penulis, SUM(sinta_score_ovr)as sinta_score FROM dt3
GROUP BY id_sinta,nama_penulis
ORDER BY sinta_score DESC
LIMIT 10"
)
#-----------------------------------------------------------------------------#
# Query 6: Leaderboard Penulis berdasarkan Banyaknya Jurnal
q6 <- print(
  "with dt1 as 
(SELECT *,
CASE WHEN departemen.nama_departemen='Unknown' then 'Unknown'
     ELSE split_part(departemen.nama_departemen, '- ', 2) END
     AS nama_dept
FROM penulis
INNER JOIN instansi ON penulis.id_instansi=instansi.id_instansi
INNER JOIN departemen ON penulis.id_dept=departemen.id_dept
),
dt2 as(
 SELECT id_sinta,INITCAP(nama_penulis) AS nama_penulis,nama_dept,nama_instansi,
 sinta_score_ovr as sinta_score_ovr,jumlah_article_scopus as jumlah_article_scopus
FROM dt1
),
dt3 as(
 SELECT id_sinta,nama_penulis,jumlah_article_scopus
FROM dt2
)
SELECT id_sinta,nama_penulis, SUM(jumlah_article_scopus)as jumlah_article_scopus FROM dt3
GROUP BY id_sinta,nama_penulis
ORDER BY jumlah_article_scopus DESC
LIMIT 10"
)

#--------------------------Pembentukan Dataframe-------------------------------#
# Ubah dataset yang ditarik dari database menjadi bentuk Dataframe
DB <- connectDB()
tabel01 <- data.frame(dbGetQuery(DB, q1))
tabel02 <- data.frame(dbGetQuery(DB, q2))
tabel03 <- data.frame(dbGetQuery(DB, q3))
tabel04 <- data.frame(dbGetQuery(DB, q4))
tabel05 <- data.frame(dbGetQuery(DB, q5))
tabel06 <- data.frame(dbGetQuery(DB, q6))
dbDisconnect(DB)


#============================= SERVER (back-end) ==============================#
function(input, output){
  #----------------------Tab Beranda-------------------------#
  # Filter Tahun
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
  # Filter Akreditasi
  output$filter_2 <- renderUI({
    selectInput(
      inputId = "in_acc",
      label = "Pilih Akreditasi",
      multiple = TRUE,
      choices = sort(as.character(tabel01$accred))
    )
  })
  # Filter Bidang Ilmu
  output$filter_3 <- renderUI({
    selectInput(
      inputId = "in_sub1",
      label = "Pilih Bidang Ilmu",
      multiple = TRUE,
      choices = sort(as.character(tabel01$bidang_ilmu))
    )
  })
  # Definisi Data
  data1 <- reactive({
    tabel01 %>% filter(tahun_terbit >= input$in_year[1],
                       tahun_terbit <= input$in_year[2],
                       accred %in% input$in_acc,
                       bidang_ilmu %in% input$in_sub1)
  })
  # Render Tabel Data
  output$out_tbl1 <- renderDataTable({
    data1()
  })
  #----------------------Tab Penulis-------------------------#
  # Filter Instansi
  output$filter_4 <- renderUI({
    selectInput(
      inputId = "in_instansi",
      label = "Pilih Instansi",
      selected = "",
      choices = sort(tabel02$nama_instansi)
    )
  })
  # Filter Bidang Ilmu
  output$filter_5 <- renderUI({
    selectInput(
      inputId = "in_sub2",
      label = "Pilih Bidang Ilmu",
      multiple = TRUE,
      choices = sort(as.character(tabel02$bidang_ilmu))
    )
  })
  # Definisi Data
  data2 <- reactive({
    tabel02 %>% filter(nama_instansi %in% input$in_instansi,
                       bidang_ilmu %in% input$in_sub2)
  })
  # Render Tabel Data
  output$out_tbl2 <- renderDataTable({
    data2()
  })
  #----------------------Tab Statistik-------------------------#
  # Render Tabel Data Leaderboard (Instansi-Sinta)
  output$out_tbl3 <- renderTable(tabel03)
  # Render Tabel Data Leaderboard (Instansi-Scopus)
  output$out_tbl4 <- renderTable(tabel04)
  # Render Tabel Data Leaderboard (Penulis-Sinta)
  output$out_tbl5 <- renderTable(tabel05)
  # Render Tabel Data Leaderboard (Penulis-Scopus)
  output$out_tbl6 <- renderTable(tabel06)
}