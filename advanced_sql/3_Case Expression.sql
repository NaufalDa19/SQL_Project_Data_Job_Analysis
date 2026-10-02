/*
    Label new column as follows:
    - 'Anywhere' jobs as 'Remote'
    - 'New York, NY' jobs as 'Local'
    - Otherwise 'Onsite'
*/

SELECT
    COUNT(job_id),
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM
    job_postings_fact
WHERE
    job_title_short ='Data Analyst'
GROUP BY
    location_category;


/*
    Practice
*/

-- ==============================================================================
-- CARA PERTAMA: Memfilter data NULL (Rekomendasi Utama untuk Analisis Gaji)
-- Tujuan: Menampilkan detail postingan (ID, judul, rata-rata gaji) yang memiliki data gaji 
--         serta mengelompokkannya ke dalam kategori gaji dari yang tertinggi.
-- ==============================================================================
SELECT
    job_id,
    job_title_short,
    salary_year_avg,
    CASE
        WHEN salary_year_avg > 110000 THEN 'High'
        WHEN salary_year_avg BETWEEN 65000 AND 110000 THEN 'Standard'
        ELSE 'Low' -- Mengategorikan sisa angka di bawah 65.000 sebagai Low
    END AS salary_category
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst' -- Memfilter khusus untuk peran Data Analyst
    AND salary_year_avg IS NOT NULL  -- Mengabaikan data NULL agar statistik rentang gaji valid
ORDER BY
    salary_year_avg DESC;            -- Mengurutkan dari gaji tertinggi ke terendah


-- ==============================================================================
-- CARA KEDUA: Mempertahankan data NULL (Rekomendasi untuk Audit Kelengkapan Data)
-- Tujuan: Menampilkan seluruh postingan Data Analyst beserta identifikasinya, 
--         termasuk memberi label khusus untuk postingan yang tidak mencantumkan gaji.
-- ==============================================================================
SELECT
    job_id,
    job_title_short,
    salary_year_avg,
    CASE
        WHEN salary_year_avg > 110000 THEN 'High'
        WHEN salary_year_avg BETWEEN 65000 AND 110000 THEN 'Standard'
        WHEN salary_year_avg < 65000 THEN 'Low'
        ELSE 'No Salary Data'        -- Penanganan khusus untuk nilai NULL agar tidak terlabel 'Low'
    END AS salary_category
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
ORDER BY
    salary_year_avg DESC NULLS LAST; -- Memastikan nilai NULL berada di baris paling bawah