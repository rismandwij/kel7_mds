# Project Akhir MDS 2023

<p align="center">
  <img width="400" height="143" src="http://bsdm.unas.ac.id/wp-content/uploads/2022/08/sinta_logo1.png">
</p>

Project akhir mata kuliah Manajemen Data Statistika mengambil topik tentang Jurnal atau Paper pada website Sinta Kemendikbud. Project ini mengspesifikasikan pencarian jurnal-jurnal yang berhubungan dengan **statistika** secara umum. Hasil yang diharapkan adalah terbentuknya sebuah platform manajemen database berupa web application yang dapat memudahkan user dalam mencari referensi jurnal untuk sebuah penelitian. 

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

<p align="center">
  <img width="600" height="400" src="https://github.com/rismandwij/kel7_mds/blob/main/ERD.jpeg">
</p>

## Database
### Create Database
```sql
CREATE DATABASE sinta_jurnal
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
```
### Create Table Instansi
```sql
CREATE TABLE IF NOT EXISTS public.instansi (
    id_instansi varchar(10) NOT NULL,
    nama_instansi varchar(100) NOT NULL,
    lokasi varchar(50),
	jumlah_penulis int,
	jumlah_departement int,
	jumlah_journals int,
    PRIMARY KEY (id_instansi)
);
```
### Create Table Departement
```sql
CREATE TABLE IF NOT EXISTS public.departemen (
    id_dept varchar(10) COLLATE pg_catalog."default" NOT NULL,
    id_instansi varchar(10) COLLATE pg_catalog."default" NOT NULL,
    nama_departemen varchar(50),
    CONSTRAINT departemen_pkey PRIMARY KEY (id_dept),
    CONSTRAINT departemen_id_instansi_fkey FOREIGN KEY (id_instansi)
        REFERENCES public.instansi (id_instansi) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
```
### Create Table Penulis
```sql
CREATE TABLE IF NOT EXISTS public.penulis (
    id_sinta varchar(10) COLLATE pg_catalog."default" NOT NULL,
    nama_penulis char(100) NOT NULL, 
    id_instansi varchar(10) COLLATE pg_catalog."default" NOT NULL,
    id_dept varchar(10) COLLATE pg_catalog."default" NOT NULL,
    subject_list varchar(150),
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
    judul_paper char(200) NOT NULL,
    nama_penerbit char(100),
    nama_journal char(100),
    penulis_ke int,
    jumlah_penulis int,
    team_penulis char(100),
    tahun_terbit char(4),
    doi char(50),
    accred char(10),    
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
