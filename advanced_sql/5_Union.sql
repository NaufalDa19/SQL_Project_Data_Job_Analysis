-- ============================================
-- UNION
-- ============================================
-- UNION menggabungkan hasil beberapa SELECT jadi SATU hasil (ditumpuk ke bawah),
-- dan otomatis MEMBUANG baris duplikat (baris yang seluruh kolomnya sama persis).
--
-- Aturan wajib UNION / UNION ALL:
--   1. Jumlah kolom di setiap SELECT harus SAMA
--   2. Urutan dan tipe data kolomnya harus cocok
--   3. Nama kolom di hasil akhir mengikuti SELECT yang PERTAMA

-- Get jobs and companies from January
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    january_jobs

UNION

-- Get jobs and companies from February
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    february_jobs

UNION

-- Get jobs and companies from March
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    march_jobs;


-- ============================================
-- UNION ALL
-- ============================================
-- UNION ALL juga menumpuk hasil beberapa SELECT, tapi TIDAK membuang duplikat:
-- semua baris dari semua SELECT ditampilkan apa adanya.
--
-- Perbandingan:
--   UNION     -> buang duplikat (butuh proses tambahan untuk cek duplikat, lebih lambat)
--   UNION ALL -> pertahankan semua baris (lebih cepat karena tidak cek duplikat)
--
-- Kapan pakai yang mana:
--   - UNION ALL: kalau duplikat memang valid/ingin dihitung, atau kamu yakin
--     tidak akan ada duplikat (misal tiap tabel berisi bulan yang berbeda)
--   - UNION: kalau butuh daftar yang benar-benar unik

-- Get jobs and companies from January
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    january_jobs

UNION ALL

-- Get jobs and companies from February
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    february_jobs

UNION ALL

-- Get jobs and companies from March
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    march_jobs;


/*
    Practice

    ? Question
    - Get the corresponding skill and skill type for each job posting in q1
    - includes those without any skills, too
    - Why? Look at the skills and the type for each job in the first quarter that has
      a salary > $70,000
*/

/*
==============================================================================
PRACTICE: SKILLS FOR Q1 JOBS WITH SALARY > $70,000
==============================================================================
Tujuan: Menampilkan skill & tipe skill untuk lowongan kerja Q1 dengan gaji > $70k,
        termasuk lowongan yang tidak membutuhkan skill sama sekali (LEFT JOIN).
==============================================================================
*/

WITH q1_jobs AS (
    -- CTE: Filter lowongan kerja Q1 yang gajinya > $70.000 SEAWAL MUNGKIN
    SELECT *
    FROM january_jobs
    WHERE salary_year_avg > 70000
    UNION ALL
    SELECT *
    FROM february_jobs
    WHERE salary_year_avg > 70000
    UNION ALL
    SELECT *
    FROM march_jobs
    WHERE salary_year_avg > 70000
)

SELECT
    q1_jobs.job_id,
    q1_jobs.job_title_short,
    q1_jobs.salary_year_avg,       -- Opsional: ditampilkan agar bisa verifikasi gaji > $70k
    skills.skills AS skill_name,   -- Alias agar lebih rapi
    skills.type AS skill_type
FROM q1_jobs
-- Menggunakan LEFT JOIN agar lowongan yang TIDAK punya skill tetap muncul (tidak terbuang)
LEFT JOIN skills_job_dim AS skills_to_job 
    ON q1_jobs.job_id = skills_to_job.job_id
LEFT JOIN skills_dim AS skills 
    ON skills_to_job.skill_id = skills.skill_id
ORDER BY
    q1_jobs.salary_year_avg DESC;  -- Opsional: diurutkan dari gaji tertinggi
