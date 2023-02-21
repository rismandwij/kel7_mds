# Project Akhir MDS 2023

<p align="center">
  <img width="400" height="143" src="http://bsdm.unas.ac.id/wp-content/uploads/2022/08/sinta_logo1.png">
</p>

Project akhir mata kuliah MDS mengambil topik tentang Jurnal atau Paper pada website Sinta Kemendikbud.

Kelompok 7
* G1501221001 Akmarina Khairunnisa
* G1501221026 MEGAWATI
* G1501222040 RAFIKA AUFA HASIBUAN
* G1501222058 L.M. Risman Dwi Jumansyah

## Skema

## ERD

## Create Table
Jurnal

``` sql
CREATE TABLE IF NOT EXISTS public.judul (
    doi character varying(15) NOT NULL,
    judul_paper character varying(100) NOT NULL,
    tahun numeric NOT NULL,
    id_penulis character NOT NULL,
    nama_penulis character varying(50) NOT NULL,
    id_instansi character NOT NULL,
    instansi character NOT NULL,
    jumlah_sitasi integer,
    id_penerbit character NOT NULL,
    penerbit character NOT NULL,
    volume integer,
    PRIMARY KEY (doi) 
)

CREATE TABLE IF NOT EXISTS public.penulis (
    id_penulis character NOT NULL,
    nama_penulis character varying(30) NOT NULL,
    id_instansi character NOT NULL,
    instansi character NOT NULL,
    asal character NOT NULL,
    pendidikan_terakhir character NOT NULL,
    jumlah_publikasi integer,
    PRIMARY KEY (id_penulis) 
)

CREATE TABLE IF NOT EXISTS public.instansi (
    id_instansi character NOT NULL,
    instansi character NOT NULL,
    asal_instansi character NOT NULL,
    PRIMARY KEY (id_instansi)
)

CREATE TABLE IF NOT EXISTS public.jurnal (
    id_jurnal character NOT NULL,
    nama_jurnal character NOT NULL,
    tahun_jurnal character NOT NULL,
    jumlah_paper character NOT NULL,
    akreditasi_jurnal character NOT NULL,
    PRIMARY KEY (id_jurnal)
)

CREATE TABLE IF NOT EXISTS public.jurnal (
    id_jurnal character NOT NULL,
    nama_jurnal character NOT NULL,
    tahun_jurnal character NOT NULL,
    jumlah_paper character NOT NULL,
    akreditasi_jurnal character NOT NULL,
    PRIMARY KEY (id_jurnal)
)

CREATE TABLE IF NOT EXISTS public.penerbit (
    id_penerbit character NOT NULL,
    nama_penerbit character NOT NULL,
    tahun_berdiri character NOT NULL,
    akreditasi character NOT NULL,
    jumlah_jurnal character NOT NULL,
    PRIMARY KEY (id_penerbit)
)

CREATE TABLE IF NOT EXISTS public.kategori (
    id_kategori character NOT NULL,
    kategori character NOT NULL,
    PRIMARY KEY (id_kategori)
)

CREATE TABLE IF NOT EXISTS public.ilmu (
    id_ilmu character NOT NULL,
    bidang_ilmu character NOT NULL,
    PRIMARY KEY (id_ilmu)
)

```
