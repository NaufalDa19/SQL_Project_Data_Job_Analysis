-- Find the average of salary_year_avg and salary_hour_avg
-- For job postings that were posted after June 1, 2023
-- Group the result by job_schedule_type

SELECT
    job_schedule_type,                              -- tipe jadwal kerja (Full-time, Part-time, dll)
    AVG(salary_year_avg) AS average_yearly_salary,   -- rata-rata gaji tahunan per tipe jadwal
    AVG(salary_hour_avg) AS average_hourly_salary    -- rata-rata gaji per jam per tipe jadwal
FROM
    job_postings_fact
WHERE
    job_posted_date::DATE > '2023-06-01'
    -- cast ke DATE dulu (buang bagian jam/waktu) supaya perbandingan tanggal murni,
    -- tidak terpengaruh komponen timestamp yang mungkin ada di kolom job_posted_date
GROUP BY
    job_schedule_type;
    -- kelompokkan per tipe jadwal, supaya AVG dihitung terpisah untuk tiap kategori


-- Count the number of job_postings for each month in 2023
-- Adjusting the job_posted_date to be in 'America/New York' time zone before extracting the month. Assumed the job_posted_date is stored in UTC
-- Group By and Order by the month

SELECT
    COUNT(job_id) AS job_posted_count,   -- jumlah job posting di bulan tersebut
    EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') AS month
    -- job_posted_date diasumsikan tersimpan dalam UTC ("AT TIME ZONE 'UTC'" menandai zona asalnya),
    -- lalu dikonversi ke waktu New York ("AT TIME ZONE 'America/New_York'"),
    -- baru diambil angka bulannya (1-12) pakai EXTRACT(MONTH FROM ...)
FROM
    job_postings_fact
WHERE
    EXTRACT(YEAR FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') = 2023
    -- filter cuma tahun 2023, TAPI perhitungan tahunnya tetap berdasarkan
    -- waktu SETELAH dikonversi ke New York (bukan tahun versi UTC mentah)
    -- penting karena konversi zona waktu bisa menggeser tanggal/bulan/tahun
    -- di sekitar pergantian hari/tahun
GROUP BY
    month
    -- kelompokkan per bulan (hasil dari EXTRACT), supaya COUNT dihitung per bulan
ORDER BY
    month;
    -- urutkan dari bulan 1 (Januari) sampai bulan 12 (Desember)


-- Find company_name that have posted jobs offering health insurance
-- Filter in the second quartal of 2023 (Use date extraction to filter by quarter)

SELECT DISTINCT
    companies.name AS company_name
    -- DISTINCT dipakai karena 1 perusahaan bisa posting BANYAK job yang sesuai kriteria,
    -- jadi tanpa DISTINCT nama company yang sama akan muncul berkali-kali
FROM
    company_dim AS companies
INNER JOIN job_postings_fact AS job_postings 
    ON companies.company_id = job_postings.company_id
    -- INNER JOIN dipakai karena cuma butuh company yang PUNYA relasi job posting
    -- yang valid (company tanpa job posting otomatis tidak relevan untuk soal ini)
WHERE
    job_health_insurance = TRUE                      -- cuma job yang menawarkan health insurance
    AND EXTRACT(YEAR FROM job_posted_date) = 2023     -- cuma tahun 2023
    AND EXTRACT(QUARTER FROM job_posted_date) = 2;
    -- cuma kuartal ke-2 (Q2 = bulan April, Mei, Juni)
    -- EXTRACT(QUARTER FROM ...) otomatis mengelompokkan bulan jadi 4 kuartal (1-4),
    -- jadi tidak perlu manual cek "bulan antara 4 dan 6"