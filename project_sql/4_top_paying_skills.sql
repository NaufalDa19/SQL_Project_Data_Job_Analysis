/*
    Question: What are the top skills based on salary?
    - Look at the average salary associated with each skill for Data Analyst position.
    - Focuses on roles with specified salaries, regardless of location.
    - Why? it reveals how different skills impact salary levels for Data Analysts and
      helps identify the most financially rewarding skills to acquire or imporve 
*/


-- Cari 25 skill dengan RATA-RATA gaji tertinggi, untuk role Data Analyst
SELECT
    skills.skills,
    ROUND(AVG(job_postings.salary_year_avg), 2) AS avg_salary
    -- AVG dihitung dari SEMUA job yang membutuhkan skill ini (bukan dibatasi duluan),
    -- ROUND(..., 2) membulatkan hasil ke 2 angka desimal biar lebih rapi dibaca
FROM
    job_postings_fact AS job_postings
INNER JOIN skills_job_dim AS skills_to_job
    ON job_postings.job_id = skills_to_job.job_id
INNER JOIN skills_dim AS skills
    ON skills_to_job.skill_id = skills.skill_id
WHERE
    job_postings.job_title_short = 'Data Analyst'   -- cuma role Data Analyst
    AND job_postings.salary_year_avg IS NOT NULL    -- buang yang gajinya kosong
    --AND job_work_from_home = TRUE                   -- jika diperlukan
GROUP BY
    skills.skills
    -- kelompokkan SEMUA data per skill DULU, sebelum dihitung rata-ratanya
ORDER BY
    avg_salary DESC
LIMIT 25;
    -- BARU di sini dibatasi ke 25 teratas -- SETELAH AVG dihitung dari data lengkap,
    -- bukan sebelum -- ini yang bikin hasilnya akurat mewakili rata-rata sesungguhnya


/*
    Insight — Top 25 skill berdasarkan rata-rata gaji (Data Analyst):

    - Version Control & Tools Development Khusus: Rata-rata gaji tertinggi justru datang dari tools version control dan 
      development niche (svn, gitlab, bitbucket), menunjukkan bahwa penguasaan tooling kolaborasi kode punya nilai 
      tambah signifikan di luar skill analisis data konvensional.
    - DevOps & Otomasi Infrastructure: Kehadiran terraform, ansible, puppet, dan vmware di jajaran atas mengindikasikan 
      perpaduan yang menguntungkan antara data analysis dan infrastructure engineering — kemampuan mengotomasi dan 
      mengelola environment turut mendongkrak nilai gaji.
    - Machine Learning & AI Framework: Skill seperti pytorch, tensorflow, keras, dan hugging face konsisten muncul 
      di rentang gaji tinggi, mencerminkan bahwa kemampuan predictive modeling dan deep learning tetap jadi salah satu 
      kompetensi paling bernilai bagi Data Analyst yang merangkap ke ranah ML.
*/


/*
    Insight — Top 25 skill berdasarkan rata-rata gaji (Data Analyst, remote/WFH):

    - Big Data & Cloud Processing: Skill tertinggi dipegang oleh pyspark ($208K) dan databricks ($142K), mencerminkan 
      bahwa kemampuan mengolah data berskala besar di lingkungan cloud menjadi pembeda gaji paling signifikan untuk 
      posisi remote.
    - DevOps & Version Control: bitbucket ($189K), gitlab ($155K), kubernetes ($133K), dan jenkins ($125K) konsisten 
      muncul di jajaran atas, menunjukkan bahwa remote Data Analyst yang juga menguasai tooling deployment dan 
      kolaborasi kode dibayar lebih tinggi — kemungkinan karena perannya merangkap tanggung jawab engineering.
    - Python Data Science Stack: pandas ($152K), numpy ($144K), scikit-learn ($126K), bersama jupyter ($153K) tetap 
      jadi fondasi kuat, menandakan bahwa kombinasi Python untuk analisis dan machine learning tetap sangat dihargai 
      di posisi remote, bukan cuma SQL/BI tools dasar.
*/