/*
    Question: What skills are required for the top-paying data analyst jobs?
    - Use the top 10 highest-paying Data Analyst jobs from first query.
    - Add the specific skills required for these roles.
    - Why? It porvides a detailed look at which high-paying jobs demand certain skills,
      helping job seekers understand which skills to develop that align with top salaries 
*/

-- ============================================
-- CTE: ambil 10 job Data Analyst dengan gaji tertinggi, yang bisa dikerjakan remote
-- ============================================
WITH top_paying_jobs AS (
    SELECT
        job_postings.job_id,
        job_postings.job_title,
        companies.name AS company_name,
        job_postings.salary_year_avg
    FROM
        job_postings_fact AS job_postings
    LEFT JOIN company_dim AS companies 
        ON job_postings.company_id = companies.company_id
        -- LEFT JOIN supaya job tetap tampil meski company_id-nya tidak ketemu
        -- di company_dim (company_name jadi NULL, job-nya tidak hilang)
    WHERE
        job_postings.job_title_short = 'Data Analyst'   -- cuma role Data Analyst
        AND job_postings.salary_year_avg IS NOT NULL     -- buang yang gajinya kosong
        AND job_postings.job_location = 'Anywhere'        -- cuma yang remote
    ORDER BY
        job_postings.salary_year_avg DESC                 -- urutkan dari gaji tertinggi
    LIMIT 10                                               -- ambil 10 teratas
)

-- ============================================
-- Query utama: tempelkan skill untuk tiap job dari CTE di atas
-- ============================================
SELECT
    top_paying_jobs.*,     -- semua kolom dari CTE (job_id, job_title, company_name, salary_year_avg)
    skills.skills           -- nama skill yang dibutuhkan
FROM
    top_paying_jobs
INNER JOIN skills_job_dim AS skills_to_job
    ON top_paying_jobs.job_id = skills_to_job.job_id
INNER JOIN skills_dim AS skills
    ON skills_to_job.skill_id = skills.skill_id
    -- INNER JOIN di sini: job yang TIDAK punya skill tercatat di skills_job_dim
    -- akan HILANG dari hasil akhir (lihat catatan di bawah)
ORDER BY
    top_paying_jobs.salary_year_avg DESC;
    -- urutkan hasil akhir tetap dari gaji tertinggi ke terendah



/*
    Skill paling sering muncul:

    - SQL — muncul di 8 dari 8 job (100%). Mutlak wajib di semua role top-paying Data Analyst.
    - Python — 7 dari 8 job (87.5%)
    - Tableau — 6 dari 8 job (75%)
    - R — 4 dari 8 job (50%)
    - Pandas, Excel, Snowflake — masing-masing 3 dari 8 job

    [
        {
            "job_id": 552322,
            "job_title": "Associate Director- Data Insights",
            "company_name": "AT&T",
            "salary_year_avg": "255829.5",
            "skills": "sql"
        },
        {
            "job_id": 552322,
            "job_title": "Associate Director- Data Insights",
            "company_name": "AT&T",
            "salary_year_avg": "255829.5",
            "skills": "python"
        },
        {
            "job_id": 552322,
            "job_title": "Associate Director- Data Insights",
            "company_name": "AT&T",
            "salary_year_avg": "255829.5",
            "skills": "r"
        },
        {
            "job_id": 552322,
            "job_title": "Associate Director- Data Insights",
            "company_name": "AT&T",
            "salary_year_avg": "255829.5",
            "skills": "azure"
        },
        {
            "job_id": 552322,
            "job_title": "Associate Director- Data Insights",
            "company_name": "AT&T",
            "salary_year_avg": "255829.5",
            "skills": "databricks"
        },
        {
            "job_id": 552322,
            "job_title": "Associate Director- Data Insights",
            "company_name": "AT&T",
            "salary_year_avg": "255829.5",
            "skills": "aws"
        },
        {
            "job_id": 552322,
            "job_title": "Associate Director- Data Insights",
            "company_name": "AT&T",
            "salary_year_avg": "255829.5",
            "skills": "pandas"
        },
        {
            "job_id": 552322,
            "job_title": "Associate Director- Data Insights",
            "company_name": "AT&T",
            "salary_year_avg": "255829.5",
            "skills": "pyspark"
        },
        {
            "job_id": 552322,
            "job_title": "Associate Director- Data Insights",
            "company_name": "AT&T",
            "salary_year_avg": "255829.5",
            "skills": "jupyter"
        },
        {
            "job_id": 552322,
            "job_title": "Associate Director- Data Insights",
            "company_name": "AT&T",
            "salary_year_avg": "255829.5",
            "skills": "excel"
        },
        {
            "job_id": 552322,
            "job_title": "Associate Director- Data Insights",
            "company_name": "AT&T",
            "salary_year_avg": "255829.5",
            "skills": "tableau"
        },
        {
            "job_id": 552322,
            "job_title": "Associate Director- Data Insights",
            "company_name": "AT&T",
            "salary_year_avg": "255829.5",
            "skills": "power bi"
        },
        {
            "job_id": 552322,
            "job_title": "Associate Director- Data Insights",
            "company_name": "AT&T",
            "salary_year_avg": "255829.5",
            "skills": "powerpoint"
        },
        {
            "job_id": 99305,
            "job_title": "Data Analyst, Marketing",
            "company_name": "Pinterest Job Advertisements",
            "salary_year_avg": "232423.0",
            "skills": "sql"
        },
        {
            "job_id": 99305,
            "job_title": "Data Analyst, Marketing",
            "company_name": "Pinterest Job Advertisements",
            "salary_year_avg": "232423.0",
            "skills": "python"
        },
        {
            "job_id": 99305,
            "job_title": "Data Analyst, Marketing",
            "company_name": "Pinterest Job Advertisements",
            "salary_year_avg": "232423.0",
            "skills": "r"
        },
        {
            "job_id": 99305,
            "job_title": "Data Analyst, Marketing",
            "company_name": "Pinterest Job Advertisements",
            "salary_year_avg": "232423.0",
            "skills": "hadoop"
        },
        {
            "job_id": 99305,
            "job_title": "Data Analyst, Marketing",
            "company_name": "Pinterest Job Advertisements",
            "salary_year_avg": "232423.0",
            "skills": "tableau"
        },
        {
            "job_id": 1021647,
            "job_title": "Data Analyst (Hybrid/Remote)",
            "company_name": "Uclahealthcareers",
            "salary_year_avg": "217000.0",
            "skills": "sql"
        },
        {
            "job_id": 1021647,
            "job_title": "Data Analyst (Hybrid/Remote)",
            "company_name": "Uclahealthcareers",
            "salary_year_avg": "217000.0",
            "skills": "crystal"
        },
        {
            "job_id": 1021647,
            "job_title": "Data Analyst (Hybrid/Remote)",
            "company_name": "Uclahealthcareers",
            "salary_year_avg": "217000.0",
            "skills": "oracle"
        },
        {
            "job_id": 1021647,
            "job_title": "Data Analyst (Hybrid/Remote)",
            "company_name": "Uclahealthcareers",
            "salary_year_avg": "217000.0",
            "skills": "tableau"
        },
        {
            "job_id": 1021647,
            "job_title": "Data Analyst (Hybrid/Remote)",
            "company_name": "Uclahealthcareers",
            "salary_year_avg": "217000.0",
            "skills": "flow"
        },
        {
            "job_id": 168310,
            "job_title": "Principal Data Analyst (Remote)",
            "company_name": "SmartAsset",
            "salary_year_avg": "205000.0",
            "skills": "sql"
        },
        {
            "job_id": 168310,
            "job_title": "Principal Data Analyst (Remote)",
            "company_name": "SmartAsset",
            "salary_year_avg": "205000.0",
            "skills": "python"
        },
        {
            "job_id": 168310,
            "job_title": "Principal Data Analyst (Remote)",
            "company_name": "SmartAsset",
            "salary_year_avg": "205000.0",
            "skills": "go"
        },
        {
            "job_id": 168310,
            "job_title": "Principal Data Analyst (Remote)",
            "company_name": "SmartAsset",
            "salary_year_avg": "205000.0",
            "skills": "snowflake"
        },
        {
            "job_id": 168310,
            "job_title": "Principal Data Analyst (Remote)",
            "company_name": "SmartAsset",
            "salary_year_avg": "205000.0",
            "skills": "pandas"
        },
        {
            "job_id": 168310,
            "job_title": "Principal Data Analyst (Remote)",
            "company_name": "SmartAsset",
            "salary_year_avg": "205000.0",
            "skills": "numpy"
        },
        {
            "job_id": 168310,
            "job_title": "Principal Data Analyst (Remote)",
            "company_name": "SmartAsset",
            "salary_year_avg": "205000.0",
            "skills": "excel"
        },
        {
            "job_id": 168310,
            "job_title": "Principal Data Analyst (Remote)",
            "company_name": "SmartAsset",
            "salary_year_avg": "205000.0",
            "skills": "tableau"
        },
        {
            "job_id": 168310,
            "job_title": "Principal Data Analyst (Remote)",
            "company_name": "SmartAsset",
            "salary_year_avg": "205000.0",
            "skills": "gitlab"
        },
        {
            "job_id": 731368,
            "job_title": "Director, Data Analyst - HYBRID",
            "company_name": "Inclusively",
            "salary_year_avg": "189309.0",
            "skills": "sql"
        },
        {
            "job_id": 731368,
            "job_title": "Director, Data Analyst - HYBRID",
            "company_name": "Inclusively",
            "salary_year_avg": "189309.0",
            "skills": "python"
        },
        {
            "job_id": 731368,
            "job_title": "Director, Data Analyst - HYBRID",
            "company_name": "Inclusively",
            "salary_year_avg": "189309.0",
            "skills": "azure"
        },
        {
            "job_id": 731368,
            "job_title": "Director, Data Analyst - HYBRID",
            "company_name": "Inclusively",
            "salary_year_avg": "189309.0",
            "skills": "aws"
        },
        {
            "job_id": 731368,
            "job_title": "Director, Data Analyst - HYBRID",
            "company_name": "Inclusively",
            "salary_year_avg": "189309.0",
            "skills": "oracle"
        },
        {
            "job_id": 731368,
            "job_title": "Director, Data Analyst - HYBRID",
            "company_name": "Inclusively",
            "salary_year_avg": "189309.0",
            "skills": "snowflake"
        },
        {
            "job_id": 731368,
            "job_title": "Director, Data Analyst - HYBRID",
            "company_name": "Inclusively",
            "salary_year_avg": "189309.0",
            "skills": "tableau"
        },
        {
            "job_id": 731368,
            "job_title": "Director, Data Analyst - HYBRID",
            "company_name": "Inclusively",
            "salary_year_avg": "189309.0",
            "skills": "power bi"
        },
        {
            "job_id": 731368,
            "job_title": "Director, Data Analyst - HYBRID",
            "company_name": "Inclusively",
            "salary_year_avg": "189309.0",
            "skills": "sap"
        },
        {
            "job_id": 731368,
            "job_title": "Director, Data Analyst - HYBRID",
            "company_name": "Inclusively",
            "salary_year_avg": "189309.0",
            "skills": "jenkins"
        },
        {
            "job_id": 731368,
            "job_title": "Director, Data Analyst - HYBRID",
            "company_name": "Inclusively",
            "salary_year_avg": "189309.0",
            "skills": "bitbucket"
        },
        {
            "job_id": 731368,
            "job_title": "Director, Data Analyst - HYBRID",
            "company_name": "Inclusively",
            "salary_year_avg": "189309.0",
            "skills": "atlassian"
        },
        {
            "job_id": 731368,
            "job_title": "Director, Data Analyst - HYBRID",
            "company_name": "Inclusively",
            "salary_year_avg": "189309.0",
            "skills": "jira"
        },
        {
            "job_id": 731368,
            "job_title": "Director, Data Analyst - HYBRID",
            "company_name": "Inclusively",
            "salary_year_avg": "189309.0",
            "skills": "confluence"
        },
        {
            "job_id": 310660,
            "job_title": "Principal Data Analyst, AV Performance Analysis",
            "company_name": "Motional",
            "salary_year_avg": "189000.0",
            "skills": "sql"
        },
        {
            "job_id": 310660,
            "job_title": "Principal Data Analyst, AV Performance Analysis",
            "company_name": "Motional",
            "salary_year_avg": "189000.0",
            "skills": "python"
        },
        {
            "job_id": 310660,
            "job_title": "Principal Data Analyst, AV Performance Analysis",
            "company_name": "Motional",
            "salary_year_avg": "189000.0",
            "skills": "r"
        },
        {
            "job_id": 310660,
            "job_title": "Principal Data Analyst, AV Performance Analysis",
            "company_name": "Motional",
            "salary_year_avg": "189000.0",
            "skills": "git"
        },
        {
            "job_id": 310660,
            "job_title": "Principal Data Analyst, AV Performance Analysis",
            "company_name": "Motional",
            "salary_year_avg": "189000.0",
            "skills": "bitbucket"
        },
        {
            "job_id": 310660,
            "job_title": "Principal Data Analyst, AV Performance Analysis",
            "company_name": "Motional",
            "salary_year_avg": "189000.0",
            "skills": "atlassian"
        },
        {
            "job_id": 310660,
            "job_title": "Principal Data Analyst, AV Performance Analysis",
            "company_name": "Motional",
            "salary_year_avg": "189000.0",
            "skills": "jira"
        },
        {
            "job_id": 310660,
            "job_title": "Principal Data Analyst, AV Performance Analysis",
            "company_name": "Motional",
            "salary_year_avg": "189000.0",
            "skills": "confluence"
        },
        {
            "job_id": 1749593,
            "job_title": "Principal Data Analyst",
            "company_name": "SmartAsset",
            "salary_year_avg": "186000.0",
            "skills": "sql"
        },
        {
            "job_id": 1749593,
            "job_title": "Principal Data Analyst",
            "company_name": "SmartAsset",
            "salary_year_avg": "186000.0",
            "skills": "python"
        },
        {
            "job_id": 1749593,
            "job_title": "Principal Data Analyst",
            "company_name": "SmartAsset",
            "salary_year_avg": "186000.0",
            "skills": "go"
        },
        {
            "job_id": 1749593,
            "job_title": "Principal Data Analyst",
            "company_name": "SmartAsset",
            "salary_year_avg": "186000.0",
            "skills": "snowflake"
        },
        {
            "job_id": 1749593,
            "job_title": "Principal Data Analyst",
            "company_name": "SmartAsset",
            "salary_year_avg": "186000.0",
            "skills": "pandas"
        },
        {
            "job_id": 1749593,
            "job_title": "Principal Data Analyst",
            "company_name": "SmartAsset",
            "salary_year_avg": "186000.0",
            "skills": "numpy"
        },
        {
            "job_id": 1749593,
            "job_title": "Principal Data Analyst",
            "company_name": "SmartAsset",
            "salary_year_avg": "186000.0",
            "skills": "excel"
        },
        {
            "job_id": 1749593,
            "job_title": "Principal Data Analyst",
            "company_name": "SmartAsset",
            "salary_year_avg": "186000.0",
            "skills": "tableau"
        },
        {
            "job_id": 1749593,
            "job_title": "Principal Data Analyst",
            "company_name": "SmartAsset",
            "salary_year_avg": "186000.0",
            "skills": "gitlab"
        },
        {
            "job_id": 387860,
            "job_title": "ERM Data Analyst",
            "company_name": "Get It Recruit - Information Technology",
            "salary_year_avg": "184000.0",
            "skills": "sql"
        },
        {
            "job_id": 387860,
            "job_title": "ERM Data Analyst",
            "company_name": "Get It Recruit - Information Technology",
            "salary_year_avg": "184000.0",
            "skills": "python"
        },
        {
            "job_id": 387860,
            "job_title": "ERM Data Analyst",
            "company_name": "Get It Recruit - Information Technology",
            "salary_year_avg": "184000.0",
            "skills": "r"
        }
    ]

*/