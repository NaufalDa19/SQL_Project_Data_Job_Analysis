-- ============================================
-- SUBQUERY (query di dalam kurung, langsung di tempat dipakai)
-- ============================================
-- Cara kerja: query "dalam" ditulis LANGSUNG di dalam kurung, di titik
-- dia dibutuhkan (di sini di bagian FROM), lalu WAJIB dikasih alias
-- (di sini "january_jobs") supaya query luar bisa merujuk ke hasilnya.
--
-- Cocok untuk: kasus sederhana, cuma dipakai SEKALI dalam query.
-- Kekurangan: kalau query-nya panjang/dipakai berkali-kali, jadi
-- "bertumpuk" (nested) dan lebih susah dibaca.
SELECT *
FROM (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
    -- filter cuma job posting bulan Januari (bulan ke-1)
) AS january_jobs;


-- ============================================
-- CTE / Common Table Expression (pakai WITH ... AS)
-- ============================================
-- Cara kerja: "tabel sementara" DIDEFINISIKAN DULU di bagian atas
-- pakai WITH nama_cte AS (...), baru DIPAKAI di query utama di bawahnya
-- -- seolah-olah nama_cte itu tabel biasa.
--
-- Cocok untuk: kasus yang lebih kompleks, terutama kalau perlu
-- BEBERAPA tahap logika, atau hasil query yang sama mau DIPAKAI
-- BERKALI-KALI dalam satu query besar (tidak perlu tulis ulang).
-- Juga mendukung WITH RECURSIVE untuk query rekursif (subquery TIDAK bisa).
--
-- Kelebihan dibanding subquery: lebih rapi & mudah dibaca, karena
-- alurnya jelas seperti "langkah demi langkah" (nama CTE = nama tahap).
WITH january_jobs AS (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
    -- filter cuma job posting bulan Januari (bulan ke-1)
)

SELECT *
FROM january_jobs;
-- di sini january_jobs dipanggil layaknya nama tabel biasa


-- SUBQUERY di dalam WHERE, pakai operator IN
-- Cari nama-nama company yang PERNAH memposting job dengan
-- "no degree mention" (job yang tidak mensyaratkan gelar tertentu)
SELECT
    company_id,
    name AS company_name
FROM
    company_dim
WHERE
    company_id IN (
        -- subquery ini menghasilkan DAFTAR company_id yang relevan
        -- (dari job_postings_fact yang job_no_degree_mention-nya TRUE)
        SELECT
            company_id
        FROM
            job_postings_fact
        WHERE 
            job_no_degree_mention = TRUE
    );
    -- company_id di query utama dicocokkan: apakah dia ADA di dalam
    -- daftar company_id hasil subquery di atas?


-- CTE (Common Table Expression) Contoh
/*
Find the companies that have the most job openings.
- Get the total number of job postings per company id (job_postings_fact)
- Return the total number of jobs with the company name (company_dim)
*/

-- ==============================================================================
-- COMPARISON & BEST PRACTICE ANALYSIS
-- ==============================================================================
-- CARA 1 (Early Join & Group BY Text Name):
--  Performa kurang optimal karena melakukan JOIN ke tabel dimensi sebelum
--   data diringkas (agregasi). Selain itu, 'GROUP BY company_name' berisiko
--   menggabungkan dua perusahaan berbeda yang memiliki nama sama persis.
--  'RIGHT JOIN' kurang umum digunakan dalam standar industri karena alur
--   bacanya kurang intuitif dibanding LEFT JOIN/INNER JOIN.
--
-- CARA 2 (Pre-Aggregation BY ID - RECOMMENDED BEST PRACTICE):
--  Performa jauh lebih cepat dan efisien. Meringkas data angka (company_id)
--   terlebih dahulu di CTE, baru menarik teks (company_name) setelahnya.
--  Menggunakan 'GROUP BY company_id' menjamin akurasi karena ID bersifat unik.
-- ==============================================================================


-- ==============================================================================
-- CARA PERTAMA (Cara Kurang Efisien - Join Terlebih Dahulu)
-- ==============================================================================
WITH company_job_count AS (
    SELECT
        COUNT(job_postings.company_id) AS total_jobs,
        companies.name AS company_name
    FROM 
        company_dim AS companies
    RIGHT JOIN job_postings_fact AS job_postings 
        ON companies.company_id = job_postings.company_id
    GROUP BY
        company_name -- Risk: Jika ada nama perusahaan duplikat, datanya akan tergabung
)

SELECT *
FROM company_job_count
ORDER BY
    total_jobs DESC;


-- ==============================================================================
-- CARA KEDUA (Cara Rekomendasi / Best Practice - Agregasi Dulu, Join Belakangan)
-- ==============================================================================
WITH company_job_count AS (
    SELECT
        company_id,
        COUNT(*) AS total_jobs -- Menghitung postingan berbasis ID jauh lebih cepat di memori
    FROM
        job_postings_fact
    GROUP BY
        company_id -- Mengelompokkan ID unik memastikan tidak ada perusahaan yang tertukar
)

SELECT
    companies.name AS company_name,
    company_job_count.total_jobs
FROM company_job_count
LEFT JOIN company_dim AS companies 
    ON company_job_count.company_id = companies.company_id -- JOIN dilakukan setelah baris data menyusut
ORDER BY
    total_jobs DESC;


/* 
    Practice 1 (Subquery)

    ? Question
    - Identify the top 5 skills that are most frequently mentioned in job postings.
    - Use subquery to find skill ID's with the highest counts in the skills_job_dim table
    - Then join this result with the skills_dim table to get the skill name
*/

-- ==============================================================================
-- MENCARI TOP 5 SKILL YANG PALING BANYAK DIBUTUHKAN DI JOB POSTINGS
-- Tujuan: Menghitung frekuensi kemunculan setiap skill_id di tabel transaksi,
--         mengambil 5 teratas, lalu menarik nama skill dari tabel dimensi.
-- ==============================================================================

SELECT
    skills.skills AS skill_name,      -- Nama skill (misal: "SQL", "Python", "Excel")
    top_skills.total_job_postings     -- Jumlah job posting yang membutuhkan skill tersebut
FROM (
    -- SUBQUERY: Menghitung total job posting untuk setiap skill_id
    SELECT
        skill_id,
        COUNT(job_id) AS total_job_postings
    FROM
        skills_job_dim
    GROUP BY
        skill_id
    ORDER BY
        total_job_postings DESC       -- WAJIB: Urutkan dulu dari yang terbanyak agar LIMIT 5 mengambil Top 5 yang benar
    LIMIT 5                           -- Mengambil hanya 5 skill paling populer
) AS top_skills
INNER JOIN skills_dim AS skills 
    ON top_skills.skill_id = skills.skill_id -- Menerjemahkan skill_id (angka) menjadi nama skill (teks)
ORDER BY
    top_skills.total_job_postings DESC;      -- Memastikan urutan di hasil akhir tetap konsisten dari yang tertinggi


/*
    Practice 2 (Subquery)

    ? Question
    - Determine the size category ("Small", "Medium", or "Large") for each company by first identifying
      the number of job postings they have
    - Use subquery to calculate the total job postings per company
    - A company is considered 'Small' if it has less than  10 job postings,
      "Medium" if the number of job postings is between 10 and  50, and
      "Large" if it has more than 50 job postings
    - Implement a subquery to aggregate job counts per company before classifying them based on size 
*/

-- ==============================================================================
-- PRACTICE 2: COMPANY SIZE CATEGORIZATION (Subquery Approach)
-- Tujuan: Mengategorikan ukuran perusahaan (Small, Medium, Large) berdasarkan 
--         jumlah postingan lowongan kerja yang mereka miliki.
-- ==============================================================================

SELECT
    companies.name AS company_name,
    company_job_counts.total_job_postings,
    CASE
        WHEN company_job_counts.total_job_postings < 10 THEN 'Small'
        WHEN company_job_counts.total_job_postings BETWEEN 10 AND 50 THEN 'Medium'
        ELSE 'Large' -- Kategori untuk postingan > 50
    END AS company_size_category
FROM (
    -- Subquery: Hanya mengagregasi ID & jumlah postingan agar eksekusi ringan di memori
    SELECT
        company_id,
        COUNT(job_id) AS total_job_postings
    FROM
        job_postings_fact
    GROUP BY
        company_id
) AS company_job_counts -- Alias diubah agar menggambarkan isi data (ringkasan jumlah postingan)
INNER JOIN company_dim AS companies 
    ON company_job_counts.company_id = companies.company_id -- Menarik nama perusahaan di outer query
ORDER BY
    total_job_postings DESC; -- Mengurutkan hasil dari postingan terbanyak ke tersedikit (atau ASC jika ingin dari terkecil)