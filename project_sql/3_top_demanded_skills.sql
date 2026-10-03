/*
    Question: What are the most in-demand skills for data analysts?
    - Join job postings to inner join table similar to query 2.
    - Identify the top 5 in-demand skills for a data analyst.
    - Focus on all job postings.
    - Why? Retreive the top 5 skill with the highest demand in the job market,
      providing insights into the most valuable skills for job seekers.
*/


-- ============================================================================
-- Cara 1: agregasi per skill_id DULU, baru JOIN ke skills_dim untuk ambil nama
-- ============================================================================
WITH top_demanded_skill AS (
    SELECT
        skills_to_job.skill_id,
        COUNT(*) AS skill_count        -- hitung jumlah baris (= jumlah job yang butuh skill ini)
    FROM
        skills_job_dim AS skills_to_job
    INNER JOIN job_postings_fact AS job_postings
        ON skills_to_job.job_id = job_postings.job_id
        -- JOIN ke job_postings_fact supaya bisa filter job_title_short
    WHERE
        job_postings.job_title_short = 'Data Analyst'   -- cuma role Data Analyst
    GROUP BY
        skills_to_job.skill_id          -- kelompokkan per skill_id (masih berupa angka)
    ORDER BY
        skill_count DESC
    LIMIT 5                              -- ambil 5 skill_id teratas DI SINI
)

SELECT
    skills.skills,
    top_demanded_skill.skill_count
FROM
    top_demanded_skill
INNER JOIN skills_dim AS skills
    ON top_demanded_skill.skill_id = skills.skill_id
    -- JOIN ke skills_dim CUMA untuk 5 baris hasil CTE, bukan semua data
ORDER BY
    top_demanded_skill.skill_count DESC;


-- ===============================================================================================
-- Cara 2 (dari kursus online): JOIN ketiga tabel DULU (semua baris), baru agregasi per nama skill
-- ===============================================================================================
SELECT
    skills.skills,
    COUNT(skills_to_job.job_id) AS demand_count
    -- hitung job_id (bukan skill_id) -- hasilnya SAMA karena tidak ada NULL
    -- di titik ini (sudah difilter lewat INNER JOIN)
FROM
    job_postings_fact AS job_postings
INNER JOIN skills_job_dim AS skills_to_job
    ON job_postings.job_id = skills_to_job.job_id
INNER JOIN skills_dim AS skills
    ON skills_to_job.skill_id = skills.skill_id
    -- JOIN ke skills_dim dilakukan untuk SEMUA baris Data Analyst + skill,
    -- sebelum di-GROUP BY (beda dengan Cara 1 yang JOIN belakangan)
WHERE
    job_postings.job_title_short = 'Data Analyst'
GROUP BY
    skills.skills                        -- kelompokkan langsung per NAMA skill (teks)
ORDER BY
    demand_count DESC
LIMIT 5;                                  -- LIMIT di sini, SETELAH semua data diproses

