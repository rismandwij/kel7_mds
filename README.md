# kel7_mds
Project Akhir MDS 2023

Kelompok 7
* G1501221001 Akmarina Khairunnisa
* G1501221026 MEGAWATI
* G1501222040 RAFIKA AUFA HASIBUAN
* G1501222058 L.M. Risman Dwi Jumansyah

![Sinta Kemendikbud ><](http://bsdm.unas.ac.id/wp-content/uploads/2022/08/sinta_logo1.png)
<p align="center">
  <img width="460" height="300" src="http://bsdm.unas.ac.id/wp-content/uploads/2022/08/sinta_logo1.png">
</p>

Project akhir mata kuliah MDS mengambil topik tentang Jurnal atau Paper pada website Sinta Kemendikbud.

## Create Table
Jurnal

``` sql
CREATE TABLE IF NOT EXISTS public.jurnal (
    doi character varying(15) NOT NULL,
    judul_paper character varying(50) NOT NULL,
    tahun integer NOT NULL,
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
```
