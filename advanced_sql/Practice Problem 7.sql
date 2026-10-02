/*
    Practice Problem 7 (CTE)

    ? Question
    Find the count of the number of remote job postings per skill
        - Display the top 5 skills by their demand in remote jobs
        - Including skill ID, name, and count of postings requiring the skill
*/

/*
==============================================================================
PRACTICE PROBLEM 7: TOP 5 REMOTE SKILLS (Optimized CTE Approach)
==============================================================================
Tujuan: Menampilkan 5 skill paling diminati pada lowongan kerja remote.
Output: skill_id, nama skill, dan total postingan pekerjaan remote.
==============================================================================
*/

WITH remote_job_count AS (
    -- CTE: Filter pekerjaan remote, hitung total postingan per skill_id, 
    --      dan ambil Top 5 ID teratas secara efisien di dalam memori.
    SELECT
        COUNT(*) AS skill_count,
        skills_to_job.skill_id
    FROM
        job_postings_fact AS job_postings
    INNER JOIN skills_job_dim AS skills_to_job 
        ON job_postings.job_id = skills_to_job.job_id
    WHERE
        job_postings.job_work_from_home = TRUE              -- Memfilter khusus pekerjaan remote 
        AND job_postings.job_title_short = 'Data Analyst'   -- Memfilter job_title_short = 'Data Analyst'
    GROUP BY
        skills_to_job.skill_id
    ORDER BY
        skill_count DESC                        -- WAJIB: Menentukan 5 skill mana yang berhak lolos LIMIT 5
    LIMIT 5
)

SELECT
    skills.skill_id,
    skills.skills AS skill_name,               -- Mengambil nama skill dari tabel dimensi
    remote_job_count.skill_count
FROM
    remote_job_count
INNER JOIN skills_dim AS skills 
    ON remote_job_count.skill_id = skills.skill_id -- JOIN hanya dilakukan pada 5 baris hasil CTE
ORDER BY
    remote_job_count.skill_count DESC;          -- WAJIB: Menjamin tampilan akhir tetap terurut presisi setelah proses JOIN