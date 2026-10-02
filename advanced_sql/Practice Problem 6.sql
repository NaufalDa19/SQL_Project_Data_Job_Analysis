-- January Table
CREATE TABLE january_jobs AS
    -- Bikin tabel baru berisi SEMUA kolom (SELECT *) dari job_postings_fact,
    -- tapi cuma baris yang job_posted_date-nya jatuh di bulan Januari (bulan ke-1)
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1;


-- February Table
CREATE TABLE february_jobs AS
    -- Sama seperti di atas, tapi filter bulan ke-2 (Februari)
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2;


-- March Table
CREATE TABLE march_jobs AS
    -- Filter bulan ke-3 (Maret)
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3;


-- April Table
CREATE TABLE april_jobs AS
    -- Filter bulan ke-4 (April)
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 4;


-- May Table
CREATE TABLE may_jobs AS
    -- Filter bulan ke-5 (Mei)
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 5;


-- June Table
CREATE TABLE june_jobs AS
    -- Filter bulan ke-6 (Juni)
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 6;


-- July Table
CREATE TABLE july_jobs AS
    -- Filter bulan ke-7 (Juli)
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 7;


-- August Table
CREATE TABLE august_jobs AS
    -- Filter bulan ke-8 (Agustus)
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 8;


-- September Table
CREATE TABLE september_jobs AS
    -- Filter bulan ke-9 (September)
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 9;


-- October Table
CREATE TABLE october_jobs AS
    -- Filter bulan ke-10 (Oktober)
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 10;


-- November Table
CREATE TABLE november_jobs AS
    -- Filter bulan ke-11 (November)
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 11;


-- December Table
CREATE TABLE december_jobs AS
    -- Filter bulan ke-12 (Desember)
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 12;


-- Check if the query works
SELECT
    job_posted_date
FROM
    march_jobs;
    -- Verifikasi: cek isi tabel march_jobs, pastikan semua job_posted_date
    -- yang muncul memang berasal dari bulan Maret