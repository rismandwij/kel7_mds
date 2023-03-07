# Project Akhir MDS 2023

<p align="center">
  <img width="400" height="143" src="http://bsdm.unas.ac.id/wp-content/uploads/2022/08/sinta_logo1.png">
</p>

Project akhir mata kuliah Manajemen Data Statistika mengambil topik tentang Jurnal atau Paper pada website Sinta Kemendikbud. Project ini mengspesifikasikan pencarian jurnal-jurnal yang berhubungan dengan **statistika** secara umum. Hasil yang diharapkan adalah terbentuknya sebuah platform manajemen database berupa web application yang dapat memudahkan user dalam mencari referensi jurnal untuk sebuah penelitian. User dapat mencari jurnal berdasarkan kategori yang di inginkan, misalnya pencarian berdasarkan sinta jurnal, instansi penulis, hingga tahun terbit jurnal terkait.



Kelompok 7
* **Akmarina Khairunnisa** (G1501221001) Sebagai **Frontend Developer**
* **Megawati** (G1501221026) Sebagai **Techincal Writer**
* **Rafika Aufa Hasibuan** (G1501222040) Sebagai **Backend Developer**
* **L.M. Risman Dwi Jumansyah** (G1501222040) Sebagai **Database Manager**

## Skema
Tabel **Judul** merupakan _primamry key_ yang digunakan untuk membantu menggabungkan informasi dari tabel **Penulis**, **Instansi**, dan **Departemen**
<p align="center">
  <img width="600" height="400" src="https://github.com/rismandwij/kel7_mds/blob/main/Skema.png">
</p>

## ERD

ERD (Entity Relationship Diagram) menampilkan hubungan antara entitas dengan atribut. Pada project ini, entitas judul terdapat tiga atribut yang berhubungan dengan atribut pada entitas lain, yaitu id_sinta berhubungan dengan entitas penulis, id_instansi berhubungan dengan entitas instansi, id_dept berhubungan dengan entitas departemen.

Selanjutnya, entitas penulis terdapat dua atribut yang berhubungan dengan atribut pada entitas lain, yaitu id_instansi berhubungan dengan entitas instansi, id_dept bergubungan dengan entitas departemen.

Selain itu, entitas departemen dan entitas instansi saling berhubungan pada atribut id_instansi.

<p align="center">
  <img width="600" height="400" src="https://github.com/rismandwij/kel7_mds/blob/main/ERD.jpeg">
</p>

## Database
### Create Database
Databse sinta_jurnal menyimpan informasi yang mewakili atribut data yang saling berhubungan untuk kemudian dianalisis.
```sql
CREATE DATABASE sinta_jurnal
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
```
### Create Table Instansi
Table instansi memberikan informasi kepada user mengenai lembaga asal penulis jurnal sinta, sehingga user dapat mengetahui id instansi penulis, nama instansi penulis, jumlah penulis pada instansi tersebut, jumlah departemen pada instansi dan jumlah jurnal yang telah diterbitkan oleh setiap instansi.
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
Table departemen memberikan informasi yang memudahkan user mengetahui asal penulis melalui id departemen penulis, id instansi penulis dan nama departemen penulis terkait. Id departemen adalah kode yang digunakan untuk membedakan nama departemen yang sama pada tiap instansi.
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
Table penulis memberikan informasi kepada user mengenai beberapa identitas penulis jurnal. User dapat mengetahui id sinta dari penulis, nama penulis jurnal, asal penulis melalui id instnasi dan id departemen. Selain itu, terdapat informasi mengenai jumlah artikel yang telah diterbitkan oleh penulis baik terindeks scopus maupun google scholar.
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
