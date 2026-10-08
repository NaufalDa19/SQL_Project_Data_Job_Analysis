/*
    Question: What are the most optimal skills to learn (aka it's in high demand and high-paying skill)?
    - Identify skill in high demand and associated with high average salaries for Data Analyst roles.
    - Concentrates on remote positions with specified salaries.
    - Why? Target skills that offer job security (high demand) and financial benefits (high salaries),
      offering strategic insight for carrer development in data analysis.
*/

/*
==============================================================================
PRACTICE PROBLEM: MOST OPTIMAL SKILLS FOR DATA ANALYST (REMOTE) (Cara Sendiri)
==============================================================================
Tujuan: Menemukan skill yang paling optimal untuk posisi Data Analyst (Remote)
        berdasarkan tingkat permintaan (demand) dan rata-rata gaji tahunan.
Kriteria Filtering:
- Role: Data Analyst (`job_title_short = 'Data Analyst'`)
- Sistem Kerja: Remote/WFH (`job_work_from_home = TRUE`)
- Memiliki Data Gaji: Membuang nilai NULL (`salary_year_avg IS NOT NULL`)
==============================================================================
*/

WITH skill_stats AS (
    -- CTE: Agregasi jumlah kemunculan skill dan rata-rata gajinya per skill_id
    SELECT
        skills_job.skill_id,
        COUNT(*) AS skill_count,                                   -- Menghitung total permintaan/lowongan untuk skill ini
        ROUND(AVG(job_postings.salary_year_avg), 0) AS avg_salary -- Menghitung rata-rata gaji tahunan (dibulatkan)
    FROM
        skills_job_dim AS skills_job
    INNER JOIN job_postings_fact AS job_postings
        ON skills_job.job_id = job_postings.job_id
    WHERE
        job_postings.job_title_short = 'Data Analyst'
        AND job_postings.job_work_from_home = TRUE                 -- Filter posisi remote
        AND job_postings.salary_year_avg IS NOT NULL              -- Hanya sertakan job dengan data gaji yang jelas
    GROUP BY
        skills_job.skill_id                                        -- Pengelompokan berdasarkan ID skill
)

SELECT
    skills.skills AS skill_name,                                   -- Nama skill (diberi alias agar tidak bernama 'skills' saja)
    skill_stats.skill_count,                                       -- Jumlah kemunculan skill (demand)
    skill_stats.avg_salary                                         -- Rata-rata gaji tahunan
FROM 
    skill_stats
INNER JOIN skills_dim AS skills
    ON skill_stats.skill_id = skills.skill_id                     -- Menghubungkan ID skill dengan nama skill
ORDER BY
    skill_stats.skill_count DESC,                                  -- Prioritas 1: Urutkan dari permintaan tertinggi (High Demand)
    skill_stats.avg_salary DESC;                                  -- Prioritas 2: Jika demand sama, urutkan dari gaji tertinggi


-- ============================================================
-- TUJUAN QUERY: (CARA COURSE 1)
-- Mencari skill yang paling banyak diminta (demand) untuk
-- posisi "Data Analyst" yang bisa WFH dan punya data gaji,
-- sekaligus menampilkan rata-rata gajinya.
-- ============================================================

-- ============================================================
-- CTE #1: skills_demand
-- Menghitung berapa banyak lowongan (demand_count) yang
-- membutuhkan tiap skill.
-- ============================================================
WITH skills_demand AS (
    SELECT
        skills.skill_id,                              -- ID unik skill (PK dari skills_dim)
        skills.skills,                                -- Nama skill (mis. "sql", "python")
        COUNT(skills_to_job.job_id) AS demand_count   -- Jumlah lowongan per skill
    FROM
        job_postings_fact AS job_postings             -- Tabel fakta lowongan kerja
    INNER JOIN skills_job_dim AS skills_to_job        -- Tabel jembatan (many-to-many)
        ON job_postings.job_id = skills_to_job.job_id -- Relasi job ↔ skill
    INNER JOIN skills_dim AS skills                   -- Tabel dimensi skill
        ON skills_to_job.skill_id = skills.skill_id   -- Relasi ke nama skill
    WHERE
        job_postings.job_title_short = 'Data Analyst'         -- Filter: hanya Data Analyst
        AND job_postings.salary_year_avg IS NOT NULL          -- Harus ada info gaji tahunan
        AND job_postings.job_work_from_home = TRUE            -- Hanya lowongan WFH
    GROUP BY
        skills.skill_id         -- Cukup skill_id (PK) → skills.skills otomatis ikut unik
),

-- ============================================================
-- CTE #2: average_salary
-- Menghitung rata-rata gaji tahunan per skill, dengan filter
-- yang SAMA seperti CTE di atas agar apple-to-apple.
-- ============================================================
average_salary AS (
    SELECT
        skills_to_job.skill_id,                              -- ID skill (dari tabel jembatan)
        ROUND(AVG(job_postings.salary_year_avg), 0) AS avg_salary  -- Rata-rata gaji, dibulatkan
    FROM
        job_postings_fact AS job_postings
    INNER JOIN skills_job_dim AS skills_to_job
        ON job_postings.job_id = skills_to_job.job_id
    INNER JOIN skills_dim AS skills
        ON skills_to_job.skill_id = skills.skill_id
    WHERE
        job_postings.job_title_short = 'Data Analyst'         -- Filter sama
        AND job_postings.salary_year_avg IS NOT NULL          -- Filter sama
        AND job_postings.job_work_from_home = TRUE            -- Filter sama
    GROUP BY
        skills_to_job.skill_id   -- Wajib pakai kolom ini (bukan PK) → jangan SELECT kolom lain
)

-- ============================================================
-- QUERY UTAMA:
-- Gabungkan demand + average salary per skill, lalu urutkan.
-- ============================================================
SELECT
    skills_demand.skill_id,        -- ID skill
    skills_demand.skills,          -- Nama skill
    skills_demand.demand_count,    -- Berapa banyak lowongan minta skill ini
    average_salary.avg_salary      -- Rata-rata gaji untuk skill ini
FROM
    skills_demand
INNER JOIN average_salary                                  -- Gabung 2 CTE via skill_id
    ON skills_demand.skill_id = average_salary.skill_id
WHERE
    skills_demand.demand_count > 10         -- Hanya skill dengan demand "tinggi" (>10 lowongan)
ORDER BY
    average_salary.avg_salary DESC,
    skills_demand.demand_count DESC        -- Urutkan: demand terbanyak dulu
              -- Kalau demand sama, gaji tertinggi dulu
LIMIT 25;                                   -- Ambil top 25 saja


-- ============================================================
-- TUJUAN QUERY: (CARA COURSE 2)
-- Mencari skill yang  paling banyak diminta (demand) untuk
-- posisi "Data Analyst" yang bisa WFH dan punya data gaji,
-- sekaligus menampilkan rata-rata gajinya.
--
-- Bedanya dengan "Cara Course 1":
-- Cara ini TIDAK pakai CTE sama sekali — cukup 1 query saja
-- dengan GROUP BY + HAVING. Jauh lebih ringkas!
-- ============================================================

SELECT
    skills.skill_id,                                        -- ID unik skill
    skills.skills,                                          -- Nama skill (mis. "sql")
    COUNT(skills_job.job_id) AS demand_count,               -- Hitung jumlah lowongan per skill
    ROUND(AVG(job_postings.salary_year_avg), 0) AS average_salary  -- Rata-rata gaji per skill
FROM
    job_postings_fact AS job_postings                       -- Tabel fakta lowongan
INNER JOIN skills_job_dim AS skills_job                     -- Tabel jembatan (job ↔ skill)
    ON job_postings.job_id = skills_job.job_id
INNER JOIN skills_dim AS skills                             -- Tabel dimensi skill
    ON skills_job.skill_id = skills.skill_id
WHERE
    job_postings.job_title_short = 'Data Analyst'           -- Filter: hanya Data Analyst
    AND job_postings.salary_year_avg IS NOT NULL            -- Harus ada info gaji tahunan
    AND job_work_from_home = TRUE                           -- Hanya lowongan WFH
GROUP BY
    skills.skill_id    -- Cukup skill_id (PK) → skills.skills otomatis aman di SELECT
HAVING
    COUNT(skills_job.job_id) > 10   -- Filter SETELAH agregasi: hanya skill dgn demand > 10
ORDER BY
    average_salary DESC,
    demand_count DESC              -- Urutkan: demand terbanyak dulu
                -- Kalau demand sama, gaji tertinggi dulu
LIMIT 25;                           -- Ambil 25 teratas