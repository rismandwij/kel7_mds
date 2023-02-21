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

<p align="center">
  <img width="600" height="400" src="https://github.com/rismandwij/Data/raw/main/Screenshot%20(99).png">
</p>

## ERD

<p align="center">
  <img width="600" height="400" src="https://github.com/rismandwij/Data/raw/main/Screenshot%20(100).png">
</p>

## Create Table

``` sql
CREATE TABLE IF NOT EXISTS public.instansi (
    id_instansi smallint NOT NULL,
    nama_instansi varchar(50) NOT NULL,
    asal_instansi varchar(50) NOT NULL,
    PRIMARY KEY (id_instansi)
)

CREATE TABLE IF NOT EXISTS public.penulis (
    id_penulis smallint pg_catalog."default" NOT NULL,
    id_instansi smallint pg_catalog."default" NOT NULL,
    nama_penulis varchar(50) NOT NULL,
    asal_penulis varchar(20) NOT NULL,
    pendidikan_terakhir varchar(50) NOT NULL,
    jumlah_publikasi integer,
    CONSTRAINT penulis_pkey PRIMARY KEY (id_penulis),
    CONSTRAINT penulis_id_instansi_fkey FOREIGN KEY (id_instansi)
        REFERENCES public.instansi (id_instansi) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
  )

CREATE TABLE IF NOT EXISTS public.kamar_untuk_pasien(
    id_kamar character varying(10) COLLATE pg_catalog."default" NOT NULL,
    id_pasien character varying(20) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT kamar_untuk_pasien_pkey PRIMARY KEY (id_kamar, id_pasien),
    CONSTRAINT kamar_untuk_pasien_id_kamar_fkey FOREIGN KEY (id_kamar)
        REFERENCES public.kamar (id_kamar) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT kamar_untuk_pasien_id_pasien_fkey FOREIGN KEY (id_pasien)
        REFERENCES public.pasien (id_pasien) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE TABLE IF NOT EXISTS public.penerbit (
    id_penerbit smallint NOT NULL,
    nama_penerbit varchar(50) NOT NULL,
    tahun_berdiri num NOT NULL,
    akreditasi varchar(2) NOT NULL,
    jumlah_jurnal int NOT NULL,
    PRIMARY KEY (id_penerbit)
)

CREATE TABLE IF NOT EXISTS public.jurnal (
    id_jurnal smallint pg_catalog."default" NOT NULL,
    id_penerbit smallint pg_catalog."default" NOT NULL,
    nama_jurnal varchar(100) NOT NULL,
    tahun_jurnal num NOT NULL,
    jumlah_paper integer NOT NULL,
    akreditasi_jurnal varchar(2) NOT NULL,
    CONSTRAINT jurnal_pkey PRIMARY KEY (id_jurnal),
    CONSTRAINT jurnal_id_penerbit_fkey FOREIGN KEY (id_penerbit)
        REFERENCES public.penerbit (id_penerbit) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

CREATE TABLE IF NOT EXISTS public.judul (
    doi character varying(15) pg_catalog."default" NOT NULL,
    id_penulis smallint pg_catalog."default" NOT NULL,
    id_instansi smallint pg_catalog."default" NOT NULL,
    id_penerbit smallint pg_catalog."default" NOT NULL,
    id_jurnal smallint pg_catalog."default" NOT NULL,
    judul_paper varchar(100) NOT NULL,
    tahun_paper num NOT NULL,
    jumlah_sitasi integer,
    hal_paper varchar(10),
    CONSTRAINT judul_pkey PRIMARY KEY (doi),
    CONSTRAINT judul_id_penulis_fkey FOREIGN KEY (id_penulis)
        REFERENCES public.penulis (id_penulis) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT judul_id_instansi_fkey FOREIGN KEY (id_instansi)
        REFERENCES public.instansi (id_instansi) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT judul_id_penerbit_fkey FOREIGN KEY (id_penerbit)
        REFERENCES public.penerbit (id_penerbit) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT judul_id_jurnal_fkey FOREIGN KEY (id_jurnal)
        REFERENCES public.jurnal (id_jurnal) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION    
)
;
```
