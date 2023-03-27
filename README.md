
<p align="center">
  <img width="400" height="143" src="http://bsdm.unas.ac.id/wp-content/uploads/2022/08/sinta_logo1.png">
</p>

<div align="center">

# Database Jurnal Statistika

[Tentang](#scroll-tentang)
•
[Screenshot](#rice_scene-screenshot)
•
[Demo](#dvd-demo)
•
[Dokumentasi](#blue_book-dokumentasi)

</div>

## :bookmark_tabs: Menu

- [Tentang](#scroll-tentang)
- [Screenshot](#rice_scene-screenshot)
- [Demo](#dvd-demo)
- [Dokumentasi](#blue_book-dokumentasi)
- [Requirements](#exclamation-requirements)
- [Skema Database](#floppy_disk-skema-database)
- [ERD](#rotating_light-erd)
- [Deskripsi Data](#heavy_check_mark-deskripsi-data)
- [Struktur Folder](#open_file_folder-struktur-folder)
- [Tim Pengembang](#smiley_cat-tim-pengembang)

## :scroll: Tentang

Project akhir mata kuliah Manajemen Data Statistika mengambil topik tentang Jurnal atau Paper pada website Sinta Kemendikbud. Project ini mengspesifikasikan pencarian jurnal-jurnal yang berhubungan dengan **statistika** secara umum. Hasil yang diharapkan adalah terbentuknya sebuah platform manajemen database berupa web application yang dapat memudahkan user dalam mencari referensi jurnal untuk sebuah penelitian. User dapat mencari jurnal berdasarkan kategori yang di inginkan, misalnya pencarian berdasarkan sinta jurnal, instansi penulis, hingga tahun terbit jurnal terkait.

## :rice_scene: Screenshot

![Logo](https://via.placeholder.com/750x500)

## :dvd: Demo

Berikut merupakan link untuk shinnyapps atau dashboard dari project kami:
https://akmarinak98.shinyapps.io/database_publikasi_statistika/

## :blue_book: Dokumentasi 

Dokumentasi penggunaan aplikasi database. Anda dapat juga membuat dokumentasi lives menggunakan readthedocs.org (opsional).

## :exclamation: Requirements

- Scrapping data menggunakan package R yaitu `rvest` dengan pendukung package lainnya seperti `tidyverse`,`rio`,`kableExtra` dan `stingr`  
- RDBMS yang digunakan adalah PostgreSQL dan ElephantSQL
- Dashboard menggunakan `shinny`, `shinnythemes`, `bs4Dash`, `DT`, dan `dplyr` dari package R

## :floppy_disk: Skema Database

Menggambarkan struktur *primary key* **judul**, **penulis**, **instansi** dan **departemen** dengan masing-masing *foreign key* dalam membangun relasi antara tabel atau entitas.
<p align="center">
  <img width="600" height="400" src="https://github.com/rismandwij/kel7_mds/blob/main/Skema.png">
</p>


## :rotating_light: ERD

ERD (Entity Relationship Diagram) menampilkan hubungan antara entitas dengan atribut. Pada project ini, entitas judul terdapat tiga atribut yang berhubungan dengan atribut pada entitas lain, yaitu id_sinta berhubungan dengan entitas penulis, id_instansi berhubungan dengan entitas instansi, id_dept berhubungan dengan entitas departemen.

Selanjutnya, entitas penulis terdapat dua atribut yang berhubungan dengan atribut pada entitas lain, yaitu id_instansi berhubungan dengan entitas instansi, id_dept bergubungan dengan entitas departemen.

Selain itu, entitas departemen dan entitas instansi saling berhubungan pada atribut id_instansi.

<p align="center">
  <img width="600" height="400" src="https://github.com/rismandwij/kel7_mds/blob/main/ERD.jpg">
</p>

## :heavy_check_mark: Deskripsi Data

Berisi tentang tabel-tabel yang digunakan berikut dengan sintaks SQL DDL (CREATE).

Contoh:

### 1. Tabel *yo_user*

Tabel *yo_user* merupakan tabel yang memuat data demografi panelis, adapun detail atribut dan deskripsi dari masing-masing adalah sebagai berikut:

| Attribute    | Type                  | Description                     |
|:-------------|:----------------------|:--------------------------------|
| id           | character varying(10) | Id panelis                      |
| uid          | character varying(8)  | Unique id panelis               |
| username     | character varying(30) | Username                        |
| firstname    | character varying(15) | Firstname                       |
| lastname     | character varying(15) | Lastname                        |
| gender       | smallint              | Jenis kelamin                   |
| province_id  | character varying(10) | Asal provinsi                   |
| city_id      | character varying(10) | Asal kota                       |
| birthdate    | timestamp             | Tanggal lahir                   |
| linkshare_id | character varying(10) | Informasi join melalui campaign |

### Create Database
Databse Sinta Jurnal menyimpan informasi yang mewakili atribut data yang saling berhubungan untuk kemudian dianalisis.
```sql
CREATE DATABASE sinta_jurnal
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
```
### Create Table Instansi
Table instansi memberikan informasi kepada user mengenai lembaga asal penulis jurnal sinta, sehingga user dapat mengetahui id instansi penulis, nama instansi penulis, jumlah penulis pada instansi tersebut, jumlah departemen pada instansi dan jumlah jurnal yang telah diterbitkan oleh setiap instansi. Berikut deskripsi untuk setiap tabel instansi.
| Attribute          | Type                  | Description                     |
|:-------------------|:----------------------|:--------------------------------|
| id_instansi        | character varying(10) | Id Instansi                     |
| nama_instansi      | character varying(10) | Nama Instansi                   |
| lokasi             | character varying(50) | Lokasi                          |
| jumlah_penulis     | smallint 	     | Jumlah Penulis                  |
| jumlah_depaetemen  | smallint		     | Jumlah Departemen               |
| jumlah_journals    | smallint              | Jumlah Jurnal yang Diterbitkan  |

dengan script SQL sebagai berikut:
```sql
CREATE TABLE IF NOT EXISTS public.instansi (
    id_instansi varchar(10) NOT NULL,
    nama_instansi varchar(100) NOT NULL,
    lokasi varchar(200),
	jumlah_penulis int,
	jumlah_departement int,
	jumlah_journals int,
    PRIMARY KEY (id_instansi)
);
```
### Create Table Departement
Table departemen memberikan informasi yang memudahkan user mengetahui asal penulis melalui id departemen penulis, id instansi penulis dan nama departemen penulis terkait. Id departemen adalah kode yang digunakan untuk membedakan nama departemen yang sama pada tiap instansi. Berikut deskripsi untuk setiap tabel departemen.
| Attribute          | Type                  | Description                     |
|:-------------------|:----------------------|:--------------------------------|
| id_dept            | character varying(10) | Id Departemen                   |
| id_instansi        | character varying(10) | Id Instansi                     |
| nama_instansi      | character varying(50) | Nama Instansi                   |

dengan script SQL sebagai berikut:
```sql
CREATE TABLE IF NOT EXISTS public.departemen (
    id_dept varchar(10) COLLATE pg_catalog."default" NOT NULL,
    id_instansi varchar(10) COLLATE pg_catalog."default" NOT NULL,
    nama_departemen varchar(100),
    CONSTRAINT departemen_pkey PRIMARY KEY (id_dept),
    CONSTRAINT departemen_id_instansi_fkey FOREIGN KEY (id_instansi)
        REFERENCES public.instansi (id_instansi) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
```
### Create Table Penulis
Table penulis memberikan informasi kepada user mengenai beberapa identitas penulis jurnal. User dapat mengetahui id sinta dari penulis, nama penulis jurnal, asal penulis melalui id instnasi dan id departemen. Selain itu, terdapat informasi mengenai jumlah artikel yang telah diterbitkan oleh penulis baik terindeks scopus maupun google scholar. Berikut deskripsi untuk setiap tabel penulis.
| Attribute                  | Type                  | Description                     		       |
|:---------------------------|:----------------------|:------------------------------------------------|
| id_sinta                   | character varying(10) | Id Sinta                       		       |
| nama_penulis               | character varying(100)| Nama Penulis                   		       |
| id_instansi                | character varying(10) | Id Instansi                     		       |	
| id_dept                    | character varying(10) | Id Departemen                 		       |
| subject_list               | character varying(150)| Bidang Ilmu yang Dikuasai Penulis               |
| sinta_score_ovr    	     | smallint              | Jumlah Skor Sinta                               |
| jumlah_article_scopus      | smallint		     | Jumlah Artikel yang Terbitkan oleh Scopus       |
| jumlah_article_gscholar    | smallint              | Jumlah Artikel yang Terbitkan oleh Google Sholar|

dengan script SQL sebagai berikut:
```sql
CREATE TABLE IF NOT EXISTS public.penulis (
    id_sinta varchar(10) COLLATE pg_catalog."default" NOT NULL,
    nama_penulis char(100) NOT NULL, 
    id_instansi varchar(10) COLLATE pg_catalog."default" NOT NULL,
    id_dept varchar(10) COLLATE pg_catalog."default" NOT NULL,
    subject_list varchar(200),
    sinta_score_ovr int,
    jumlah_article_scopus int,
    jumlah_article_gscholar int,
    CONSTRAINT penulis_pkey PRIMARY KEY (id_sinta),
    CONSTRAINT penulis_id_instansi_fkey FOREIGN KEY (id_instansi)
        REFERENCES public.instansi (id_instansi) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT penulis_id_departemen_fkey FOREIGN KEY (id_dept)
        REFERENCES public.departemen (id_dept) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
```
### Create Table Judul
Table judul menyajikan informasi lengkap mengenai sebuah artikel. Selain dapat mengetahui judul, user juga akan mendapatkan informasi doi dan tahun terbit sebuah artikel. Nama penulis, team penulis hingga urutan penulis tersaji pada table ini. Tidak hanya itu, akan ditampilkan pula nama penerbit dan nama jurnal yang dipercayakan penulis untuk mempublikasikan karyanya. Lebih lanjut, informasi spesifik mengenai id sinta, id departemen, id instansi dan id paper dapat diketahui melalui table ini.  Berikut deskripsi untuk setiap tabel judul.
| Attribute                  | Type                  | Description                     		       |
|:---------------------------|:----------------------|:------------------------------------------------|
| id_sinta                   | character varying(10) | Id Sinta                       		       |
| id_instansi                | character varying(10) | Id Instansi                  		       |
| id_dept                    | character varying(10) | Id Departemen                   		       |	
| id_paper                   | character varying(10) | Id Jurnal/Artikel                	       |
| judul_paper                | character varying(200)| Judul Paper                                     |
| nama_penerbit    	     | character varying(100)| Nama Penerbit                                   |
| nama_journal               | character varying(100)| nama_journal     			       |
| jenulis_ke		     | smallint              | Urutan Nama Penulis pada Jurnal		       |
| jumlah_penulis             | smallint		     | Jumlah Penulis                    	       |
| team_penulis               | character varying(100)| Nama-Nama Penulis                               |
| tahun_terbit    	     | character varying(4)  | Tahun Terbit                                    |
| doi	                     | character varying(50) | Tautan Persisten yang Menghubungkan ke Jurnal   |
| accred		     | character varying(10) | Akreditasi            			       |

dengan script SQL sebagai berikut:              
```sql
CREATE TABLE IF NOT EXISTS public.judul (
    id_sinta varchar(10) COLLATE pg_catalog."default" NOT NULL,
    id_instansi varchar(10) COLLATE pg_catalog."default" NOT NULL,
    id_dept varchar(10) COLLATE pg_catalog."default" NOT NULL, 
    id_paper varchar(10) COLLATE pg_catalog."default" NOT NULL,  
    judul_paper char(500) NOT NULL,
    nama_penerbit char(500),
    nama_journal char(500),
    penulis_ke int,
    jumlah_penulis int,
    team_penulis char(500),
    tahun_terbit char(4),
    doi char(100),
    accred char(50),    
    CONSTRAINT judul_pkey PRIMARY KEY (id_paper),
    CONSTRAINT judul_id_penulis_fkey FOREIGN KEY (id_sinta)
        REFERENCES public.penulis (id_sinta) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT judul_id_instansi_fkey FOREIGN KEY (id_instansi)
        REFERENCES public.instansi (id_instansi) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT judul_id_dept_fkey FOREIGN KEY (id_dept)
        REFERENCES public.departemen (id_dept) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
    );
```

## :open_file_folder: Struktur Folder

```
.
├── app           # ShinyApps
│   ├── css
│   │   ├── **/*.css
│   ├── server.R
│   └── ui.R
├── data 
│   ├── csv
│   │   ├── **/*.css
│   └── sql
|       └── db.sql
├── src           # Project source code
├── doc           # Doc for the project
├── .gitignore
├── LICENSE
└── README.md
```

## :smiley_cat: Tim Pengembang

- Frontend Developer: [Akmarina Khairunnisa](https://github.com/akmarinak) (G1501221001)
- Backend Developer: [Rafika Aufa Hasibuan](https://github.com/rafikaaufa) (G1501222040)
- Technical Writer: [Megawati](https://github.com/akmarinak) (G1501221026)
- Database Manager: [L.M. Risman Dwi Jumansyah](https://github.com/rismandwij) (G1501221058)

