/*
    Question: What are the top-paying Data Analyst job?
    - Identify the top 10 highest-paying Data Analyst role that are available remotely.
    - Focuses on job postings with specified salaries (remove-nulss).
    - Why? Highlight the top-paying opportunities for Data Analysts, offering inside into employment options and location flexiblity.
    - BONUS: Include company names of top 10 roles
*/

-- Cari 10 job Data Analyst dengan gaji tertinggi, yang bisa dikerjakan remote,
-- lengkap dengan nama company-nya
SELECT
    job_postings.job_id,
    job_postings.job_title,
    companies.name AS company_name,         -- nama company (bonus yang diminta soal)
    job_postings.job_location,
    job_postings.job_schedule_type,
    job_postings.salary_year_avg,
    job_postings.job_posted_date
FROM
    job_postings_fact AS job_postings
LEFT JOIN company_dim AS companies 
    ON job_postings.company_id = companies.company_id
    -- LEFT JOIN dipakai supaya job tetap tampil meski company_id-nya
    -- kebetulan tidak ketemu di company_dim (company_name jadi NULL,
    -- bukan job-nya yang hilang dari hasil)
WHERE
    job_title_short = 'Data Analyst'        -- cuma role Data Analyst
    AND job_location = 'Anywhere'            -- "Anywhere" = penanda remote di dataset ini
    AND salary_year_avg IS NOT NULL          -- buang yang gajinya tidak diisi (sesuai "remove nulls")
ORDER BY
    salary_year_avg DESC                     -- urutkan dari gaji TERTINGGI
LIMIT 10;                                    -- ambil 10 teratas