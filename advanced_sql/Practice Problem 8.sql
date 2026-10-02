/*
Find job postings from the first quarter that have a salary greater than $70K
- Combine job posting tables from the first quarter of 2023 (Jan-Mar)
- Gets job postings with an average yearly salary > $70,000
*/


/*
==============================================================================
PRACTICE PROBLEM: Q1 DATA ANALYST JOBS WITH SALARY > $70K (Subquery Approach)
==============================================================================
Tujuan: Menampilkan lowongan Data Analyst kuartal 1 (Jan-Mar) dengan gaji > $70k.
Strategi: 
- FILTER EARLY: Memfilter gaji & job title di masing-masing tabel bulanan 
  sebelum digabungkan agar hemat memori dan proses komputasi lebih cepat.
==============================================================================
*/

SELECT
    job_title_short,
    job_location,
    job_via,
    job_posted_date::DATE,               -- Memotong timestamp agar hanya menampilkan tanggal (YYYY-MM-DD)
    salary_year_avg
FROM (
    -- Ambil & filter data Januari langsung dari sumbernya
    SELECT *
    FROM january_jobs
    WHERE salary_year_avg > 70000
      AND job_title_short = 'Data Analyst'

    UNION ALL                            -- Gabungkan baris tanpa proses pengecekan duplikat (lebih cepat)

    -- Ambil & filter data Februari
    SELECT *
    FROM february_jobs
    WHERE salary_year_avg > 70000
      AND job_title_short = 'Data Analyst'

    UNION ALL

    -- Ambil & filter data Maret
    SELECT *
    FROM march_jobs
    WHERE salary_year_avg > 70000
      AND job_title_short = 'Data Analyst'
) AS quarter1_job_postings
ORDER BY
    salary_year_avg DESC;                -- Menampilkan gaji tertinggi di posisi paling atas

/*
==============================================================================
PRACTICE PROBLEM: Q1 DATA ANALYST JOBS WITH SALARY > $70K (Cara 2 - Kursus)
==============================================================================
Tujuan: Menampilkan lowongan Data Analyst kuartal 1 (Jan-Mar) dengan gaji > $70k.
Strategi (Standard Course Approach):
- Menggabungkan SELURUH data Januari, Februari, dan Maret terlebih dahulu tanpa filter.
- Memfilter kriteria gaji (> $70.000) dan job title ('Data Analyst') di klausa WHERE query luar.
==============================================================================
*/


SELECT
    job_title_short,
    job_location,
    job_via,
    job_posted_date::DATE AS posted_date, -- Mengubah format timestamp menjadi tanggal (YYYY-MM-DD)
    salary_year_avg
FROM (
    -- Subquery: Menggabungkan seluruh data mentah Q1 tanpa penyaringan awal
    SELECT *
    FROM january_jobs

    UNION ALL                            -- Menggabungkan seluruh baris data dari Januari, Februari, dan Maret

    SELECT *
    FROM february_jobs

    UNION ALL

    SELECT *
    FROM march_jobs
) AS quarter1_job_postings
WHERE 
    salary_year_avg > 70000              -- Filter dilakukan SETELAH semua data Q1 digabungkan di memori
    AND job_title_short = 'Data Analyst'
ORDER BY
    salary_year_avg DESC;                 -- Mengurutkan hasil akhir dari gaji tertinggi


/*
==============================================================================
PRACTICE PROBLEM: Q1 DATA ANALYST JOBS WITH SALARY > $70K (CTE Approach)
==============================================================================
Tujuan: Menampilkan lowongan Data Analyst kuartal 1 (Jan-Mar) dengan gaji > $70k.
Strategi:
- Menggunakan CTE untuk mengisolasi logika penggabungan & penyaringan awal data Q1.
- Query utama hanya berfokus memilih kolom yang ingin ditampilkan ke layar.
==============================================================================
*/

WITH quarter1_job_postings AS (
    -- CTE: Menggabungkan dan memfilter data Q1 seawal mungkin (Filter Early)
    SELECT *
    FROM january_jobs
    WHERE salary_year_avg > 70000
      AND job_title_short = 'Data Analyst'

    UNION ALL                            -- Menggabungkan seluruh baris hasil filter Q1

    SELECT *
    FROM february_jobs
    WHERE salary_year_avg > 70000
      AND job_title_short = 'Data Analyst'

    UNION ALL

    SELECT *
    FROM march_jobs
    WHERE salary_year_avg > 70000
      AND job_title_short = 'Data Analyst'
)

-- Outer Query: Menampilkan kolom yang dibutuhkan dan mengatur urutan tampilan akhir
SELECT
    job_title_short,
    job_location,
    job_via,
    job_posted_date::DATE AS posted_date, -- Mengubah format timestamp menjadi tanggal & memberi alias
    salary_year_avg
FROM 
    quarter1_job_postings
ORDER BY
    salary_year_avg DESC;                 -- Mengurutkan dari gaji terbesar ke terkecil