# kel7_mds
Project Akhir MDS 2023

Percobaan Syntax Sql ke Github
Pembuatan tabel jurnal pada database jurnal_sinta

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
