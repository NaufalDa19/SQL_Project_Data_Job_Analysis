-- ============================================
-- CREATE TABLE: bikin tabel job_applied dari nol
-- ============================================
CREATE TABLE job_applied
  (
     job_id                 INT,              -- ID job yang dilamar
     application_sent_date  DATE,              -- tanggal lamaran dikirim
     custom_resume          BOOLEAN,           -- apakah resume dikustomisasi khusus untuk job ini
     resume_file_name       VARCHAR(255),      -- nama file resume
     cover_letter_sent      BOOLEAN,           -- apakah cover letter dikirim
     cover_letter_file_name VARCHAR(255),      -- nama file cover letter (NULL jika tidak dikirim)
     status                 VARCHAR(50)        -- status lamaran (submitted, rejected, dll)
  ); 

-- ============================================
-- INSERT: masukkan 5 data lamaran kerja sekaligus
-- ============================================
INSERT INTO job_applied
            (job_id,
             application_sent_date,
             custom_resume,
             resume_file_name,
             cover_letter_sent,
             cover_letter_file_name,
             status)
VALUES      (1,
             '2024-02-01',
             true,
             'resume_01.pdf',
             true,
             'cover_letter_01.pdf',
             'submitted'),
            (2,
             '2024-02-02',
             false,
             'resume_02.pdf',
             false,
             NULL,                         -- tidak kirim cover letter, jadi NULL
             'interview scheduled'),
            (3,
             '2024-02-03',
             true,
             'resume_03.pdf',
             true,
             'cover_letter_03.pdf',
             'ghosted'),
            (4,
             '2024-02-04',
             true,
             'resume_04.pdf',
             false,
             NULL,
             'submitted'),
            (5,
             '2024-02-05',
             false,
             'resume_05.pdf',
             true,
             'cover_letter_05.pdf',
             'rejected'); 

-- ============================================
-- ALTER TABLE ... ADD: tambah kolom baru ke tabel yang sudah ada
-- ============================================
ALTER TABLE job_applied
ADD contact VARCHAR(50);
-- kolom baru ini otomatis terisi NULL untuk SEMUA baris yang sudah ada,
-- karena belum ada nilai yang diisikan

-- ============================================
-- UPDATE: isi kolom contact untuk tiap baris satu per satu
-- ============================================
UPDATE job_applied
SET    contact = 'Erlich Bachman'
WHERE  job_id = 1;

UPDATE job_applied
SET    contact = 'Dinesh Chugtai'
WHERE  job_id = 2;

UPDATE job_applied
SET    contact = 'Bertram Gilfoyle'
WHERE  job_id = 3;

UPDATE job_applied
SET    contact = 'Jian Yang'
WHERE  job_id = 4;

UPDATE job_applied
SET    contact = 'Big Head'
WHERE  job_id = 5; 
-- WHERE job_id = ... wajib ada di tiap UPDATE, supaya cuma 1 baris spesifik
-- yang ter-update -- tanpa WHERE, SEMUA baris akan ketimpa nilai yang sama

-- ============================================
-- ALTER TABLE ... RENAME COLUMN: ganti nama kolom
-- ============================================
ALTER TABLE job_applied
RENAME COLUMN contact TO contact_name;
-- isi datanya TETAP sama, cuma nama kolomnya yang berubah dari "contact" jadi "contact_name"

-- ============================================
-- ALTER TABLE ... ALTER COLUMN TYPE: ganti tipe data kolom
-- ============================================
ALTER TABLE job_applied
ALTER COLUMN contact_name TYPE TEXT;
-- ubah tipe data contact_name dari VARCHAR(50) jadi TEXT
-- (TEXT di PostgreSQL = tanpa batas panjang karakter, beda dengan VARCHAR(n) yang dibatasi n karakter)

-- ============================================
-- ALTER TABLE ... DROP COLUMN: hapus satu kolom
-- ============================================
ALTER TABLE job_applied
DROP COLUMN contact_name;
-- kolom contact_name DIHAPUS PERMANEN, beserta SEMUA data di dalamnya
-- kolom lain (job_id, status, dll) tetap aman/tidak terpengaruh

-- ============================================
-- DROP TABLE: hapus seluruh tabel
-- ============================================
DROP TABLE job_applied;
-- tabel job_applied beserta SELURUH strukturnya (semua kolom) dan SELURUH datanya
-- DIHAPUS PERMANEN -- aksi ini TIDAK BISA DIBATALKAN (tidak ada "undo")