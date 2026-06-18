CREATE DATABASE IF NOT EXISTS sipakar360_laporan CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE sipakar360_laporan;

SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS notifications;
DROP TABLE IF EXISTS audit_logs;
DROP TABLE IF EXISTS assessment_details;
DROP TABLE IF EXISTS assessments;
DROP TABLE IF EXISTS peer_assignments;
DROP TABLE IF EXISTS final_results;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS akhlak_values;
DROP TABLE IF EXISTS evaluation_periods;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS roles;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS positions;
DROP TABLE IF EXISTS departments;
SET FOREIGN_KEY_CHECKS=1;

CREATE TABLE departments (
  department_id INT AUTO_INCREMENT PRIMARY KEY,
  department_name VARCHAR(100) NOT NULL,
  department_desc VARCHAR(255) DEFAULT NULL
) ENGINE=InnoDB;

CREATE TABLE positions (
  position_id INT AUTO_INCREMENT PRIMARY KEY,
  position_name VARCHAR(100) NOT NULL,
  position_level VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE employees (
  employee_id INT AUTO_INCREMENT PRIMARY KEY,
  department_id INT NOT NULL,
  position_id INT NOT NULL,
  supervisor_id INT NULL,
  employee_nik VARCHAR(30) NOT NULL UNIQUE,
  employee_name VARCHAR(120) NOT NULL,
  employee_email VARCHAR(120) NOT NULL UNIQUE,
  employee_phone VARCHAR(30) DEFAULT NULL,
  hire_date DATE DEFAULT NULL,
  employee_status VARCHAR(30) DEFAULT 'active',
  CONSTRAINT fk_emp_dept FOREIGN KEY (department_id) REFERENCES departments(department_id),
  CONSTRAINT fk_emp_pos FOREIGN KEY (position_id) REFERENCES positions(position_id),
  CONSTRAINT fk_emp_supervisor FOREIGN KEY (supervisor_id) REFERENCES employees(employee_id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE roles (
  role_id INT AUTO_INCREMENT PRIMARY KEY,
  role_name VARCHAR(50) NOT NULL UNIQUE,
  role_description VARCHAR(255) DEFAULT NULL
) ENGINE=InnoDB;

CREATE TABLE users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  role_id INT NOT NULL,
  employee_id INT NOT NULL UNIQUE,
  username VARCHAR(80) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  last_login DATETIME DEFAULT NULL,
  account_status VARCHAR(30) DEFAULT 'active',
  CONSTRAINT fk_user_role FOREIGN KEY (role_id) REFERENCES roles(role_id),
  CONSTRAINT fk_user_employee FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE evaluation_periods (
  period_id INT AUTO_INCREMENT PRIMARY KEY,
  period_name VARCHAR(120) NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  period_status VARCHAR(30) DEFAULT 'draft'
) ENGINE=InnoDB;

CREATE TABLE akhlak_values (
  akhlak_id INT AUTO_INCREMENT PRIMARY KEY,
  akhlak_name VARCHAR(80) NOT NULL,
  akhlak_description VARCHAR(255) DEFAULT NULL
) ENGINE=InnoDB;

CREATE TABLE questions (
  question_id INT AUTO_INCREMENT PRIMARY KEY,
  akhlak_id INT NOT NULL,
  question_text VARCHAR(500) NOT NULL,
  question_category VARCHAR(80) DEFAULT 'Perilaku',
  question_status VARCHAR(30) DEFAULT 'active',
  CONSTRAINT fk_question_akhlak FOREIGN KEY (akhlak_id) REFERENCES akhlak_values(akhlak_id)
) ENGINE=InnoDB;

CREATE TABLE final_results (
  result_id INT AUTO_INCREMENT PRIMARY KEY,
  employee_id INT NOT NULL,
  period_id INT NOT NULL,
  self_score DECIMAL(5,2) DEFAULT 0,
  peer_score DECIMAL(5,2) DEFAULT 0,
  subordinate_score DECIMAL(5,2) DEFAULT 0,
  supervisor_score DECIMAL(5,2) DEFAULT 0,
  final_score DECIMAL(5,2) DEFAULT 0,
  gap_analysis VARCHAR(500) DEFAULT NULL,
  CONSTRAINT fk_result_employee FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
  CONSTRAINT fk_result_period FOREIGN KEY (period_id) REFERENCES evaluation_periods(period_id),
  UNIQUE KEY uq_result (employee_id, period_id)
) ENGINE=InnoDB;

CREATE TABLE peer_assignments (
  peer_assignment_id INT AUTO_INCREMENT PRIMARY KEY,
  employee_id INT NOT NULL,
  peer_employee_id INT NOT NULL,
  period_id INT NOT NULL,
  approval_status VARCHAR(30) DEFAULT 'pending',
  approved_by VARCHAR(100) DEFAULT NULL,
  CONSTRAINT fk_peer_employee FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
  CONSTRAINT fk_peer_peer FOREIGN KEY (peer_employee_id) REFERENCES employees(employee_id),
  CONSTRAINT fk_peer_period FOREIGN KEY (period_id) REFERENCES evaluation_periods(period_id),
  UNIQUE KEY uq_peer_assignment (employee_id, peer_employee_id, period_id)
) ENGINE=InnoDB;

CREATE TABLE assessments (
  assessment_id INT AUTO_INCREMENT PRIMARY KEY,
  evaluator_id INT NOT NULL,
  evaluatee_id INT NOT NULL,
  period_id INT NOT NULL,
  assessment_type VARCHAR(50) NOT NULL,
  assessment_date DATE DEFAULT NULL,
  assessment_status VARCHAR(30) DEFAULT 'draft',
  CONSTRAINT fk_assess_evaluator FOREIGN KEY (evaluator_id) REFERENCES employees(employee_id),
  CONSTRAINT fk_assess_evaluatee FOREIGN KEY (evaluatee_id) REFERENCES employees(employee_id),
  CONSTRAINT fk_assess_period FOREIGN KEY (period_id) REFERENCES evaluation_periods(period_id),
  UNIQUE KEY uq_assessment_once (evaluator_id, evaluatee_id, period_id, assessment_type)
) ENGINE=InnoDB;

CREATE TABLE assessment_details (
  assessment_detail_id INT AUTO_INCREMENT PRIMARY KEY,
  assessment_id INT NOT NULL,
  question_id INT NOT NULL,
  score INT NOT NULL,
  comment VARCHAR(500) DEFAULT NULL,
  CONSTRAINT fk_detail_assessment FOREIGN KEY (assessment_id) REFERENCES assessments(assessment_id) ON DELETE CASCADE,
  CONSTRAINT fk_detail_question FOREIGN KEY (question_id) REFERENCES questions(question_id),
  CONSTRAINT ck_score_range CHECK (score BETWEEN 1 AND 5),
  UNIQUE KEY uq_answer (assessment_id, question_id)
) ENGINE=InnoDB;

CREATE TABLE audit_logs (
  log_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  activity VARCHAR(255) NOT NULL,
  activity_time DATETIME NOT NULL,
  ip_address VARCHAR(50) DEFAULT NULL,
  CONSTRAINT fk_audit_user FOREIGN KEY (user_id) REFERENCES users(user_id)
) ENGINE=InnoDB;

CREATE TABLE notifications (
  notification_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NULL,
  title VARCHAR(120) NOT NULL,
  message VARCHAR(500) NOT NULL,
  notification_type VARCHAR(50) DEFAULT 'info',
  is_read TINYINT(1) DEFAULT 0,
  created_at DATETIME NOT NULL,
  created_by INT NULL,
  CONSTRAINT fk_notif_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
  CONSTRAINT fk_notif_creator FOREIGN KEY (created_by) REFERENCES users(user_id) ON DELETE SET NULL
) ENGINE=InnoDB;

INSERT INTO departments (department_id, department_name, department_desc) VALUES
(1,'Human Capital','Mengelola administrasi SDM, periode evaluasi, dan pengembangan karyawan'),
(2,'Operations','Mengelola proses operasional dan performansi lapangan'),
(3,'Finance','Mengelola keuangan dan kontrol biaya'),
(4,'Supply Chain','Mengelola pengadaan dan rantai pasok'),
(5,'Management','Manajemen strategis perusahaan');

INSERT INTO positions (position_id, position_name, position_level) VALUES
(1,'Admin HRIS','Admin HR'),
(2,'Staff','Staff'),
(3,'Atasan / Manager','Atasan'),
(4,'Manajemen','Manajemen'),
(5,'HR Development Officer','Admin HR'),
(6,'Procurement Analyst','Staff'),
(7,'Finance Analyst','Staff'),
(8,'Operations Manager','Atasan'),
(9,'Process Engineer','Staff');

INSERT INTO roles (role_id, role_name, role_description) VALUES
(1,'admin_hr','Mengelola master data, periode, pertanyaan, assignment, notifikasi, dan report'),
(2,'staff','Mengisi assessment dan melihat dashboard serta report pribadi'),
(3,'atasan','Memvalidasi penilai, melihat dashboard tim, dan membuat IDP bawahan'),
(4,'manajemen','Melihat dashboard eksekutif, top score, gap, talent mapping, dan laporan perusahaan');

INSERT INTO employees 
(employee_id, department_id, position_id, supervisor_id, employee_nik, employee_name, employee_email, employee_phone, hire_date, employee_status) 
VALUES
(1,1,1,NULL,'PEN-0001','Salsabila Kirana','admin@sipakar.test','081200000001','2023-01-10','active'),
(2,1,5,NULL,'PEN-0002','Rama Pratama','hrd@sipakar.test','081200000002','2023-02-12','active'),
(3,2,8,NULL,'PEN-0003','Dimas Nugraha','atasan@sipakar.test','081200000003','2022-08-01','active'),
(4,2,9,NULL,'PEN-0004','Nadia Maharani','staff@sipakar.test','081200000004','2024-03-15','active'),
(5,4,6,NULL,'PEN-0005','Bima Arya','bima@sipakar.test','081200000005','2024-05-20','active'),
(6,3,7,NULL,'PEN-0006','Intan Wulandari','intan@sipakar.test','081200000006','2023-11-04','active'),
(7,5,4,NULL,'PEN-0007','Muhammad Gifary','manajemen@sipakar.test','081200000007','2021-07-01','active'),
(8,2,2,NULL,'PEN-0008','Daffa Sayyid Zahran','daffa@sipakar.test','081200000008','2024-07-10','active'),
(9,3,5,NULL,'PEN-0009','Anggit','anggit@sipakar.test','09090909090','2026-06-17','active');

UPDATE employees SET supervisor_id = 1 WHERE employee_id = 2;
UPDATE employees SET supervisor_id = 7 WHERE employee_id = 3;
UPDATE employees SET supervisor_id = 3 WHERE employee_id IN (4,5,6,8);
UPDATE employees SET supervisor_id = 1 WHERE employee_id = 9;

INSERT INTO users (user_id, role_id, employee_id, username, password, account_status) VALUES
(1,1,1,'admin_hr','admin123','active'),
(2,1,2,'hrd','hrd123','active'),
(3,3,3,'atasan','atasan123','active'),
(4,2,4,'staff','staff123','active'),
(5,2,5,'bima','staff123','active'),
(6,2,6,'intan','staff123','active'),
(7,4,7,'manajemen','manajemen123','active'),
(8,2,8,'daffa','staff123','active'),
(9,1,9,'anggit','anggit123','active');

INSERT INTO evaluation_periods (period_id, period_name, start_date, end_date, period_status) VALUES
(1,'Evaluasi AKHLAK Semester 1 2026','2026-01-01','2026-06-30','active'),
(2,'Evaluasi AKHLAK Semester 2 2026','2026-07-01','2026-12-31','draft');

INSERT INTO akhlak_values (akhlak_id, akhlak_name, akhlak_description) VALUES
(1,'Amanah','Memegang teguh kepercayaan yang diberikan'),
(2,'Kompeten','Terus belajar dan mengembangkan kapabilitas'),
(3,'Harmonis','Saling peduli dan menghargai perbedaan'),
(4,'Loyal','Berdedikasi dan mengutamakan kepentingan bangsa dan negara'),
(5,'Adaptif','Terus berinovasi dan antusias dalam menggerakkan perubahan'),
(6,'Kolaboratif','Membangun kerja sama yang sinergis');

INSERT INTO questions (question_id, akhlak_id, question_text, question_category, question_status) VALUES
(1,1,'Karyawan menunjukkan integritas dalam menjalankan pekerjaan dan menjaga kepercayaan perusahaan.','Perilaku','active'),
(2,1,'Karyawan bertanggung jawab terhadap hasil kerja dan komitmen yang sudah disepakati.','Perilaku','active'),
(3,2,'Karyawan mampu menyelesaikan pekerjaan sesuai standar kompetensi jabatannya.','Kompetensi','active'),
(4,2,'Karyawan aktif belajar untuk meningkatkan kemampuan kerja.','Kompetensi','active'),
(5,3,'Karyawan mampu menjaga hubungan kerja yang saling menghargai.','Perilaku','active'),
(6,3,'Karyawan peduli terhadap kondisi rekan kerja dan lingkungan kerja.','Perilaku','active'),
(7,4,'Karyawan menunjukkan dedikasi terhadap target dan kepentingan perusahaan.','Perilaku','active'),
(8,4,'Karyawan menjaga nama baik perusahaan dalam aktivitas kerja.','Perilaku','active'),
(9,5,'Karyawan mampu menyesuaikan diri terhadap perubahan proses kerja.','Perilaku','active'),
(10,5,'Karyawan memberikan ide perbaikan atau inovasi pada pekerjaan.','Kompetensi','active'),
(11,6,'Karyawan aktif bekerja sama dengan unit lain untuk menyelesaikan pekerjaan.','Perilaku','active'),
(12,6,'Karyawan terbuka menerima masukan dan mendukung pencapaian target tim.','Perilaku','active');

INSERT INTO peer_assignments (peer_assignment_id, employee_id, peer_employee_id, period_id, approval_status, approved_by) VALUES
(1,4,5,1,'approved','Dimas Nugraha'),
(2,4,6,1,'approved','Dimas Nugraha'),
(3,5,4,1,'approved','Dimas Nugraha'),
(4,6,4,1,'approved','Dimas Nugraha'),
(5,8,4,1,'approved','Dimas Nugraha'),
(6,8,5,1,'pending',NULL),
(7,3,4,1,'approved','Muhammad Gifary'),
(8,3,8,1,'approved','Muhammad Gifary');

INSERT INTO assessments (assessment_id, evaluator_id, evaluatee_id, period_id, assessment_type, assessment_date, assessment_status) VALUES
(1,4,4,1,'self','2026-06-01','submitted'),
(2,5,4,1,'peer','2026-06-02','submitted'),
(3,6,4,1,'peer','2026-06-03','submitted'),
(4,3,4,1,'supervisor','2026-06-04','submitted'),
(5,4,5,1,'peer','2026-06-03','submitted'),
(6,3,5,1,'supervisor','2026-06-04','submitted'),
(7,5,5,1,'self','2026-06-01','submitted'),
(8,3,6,1,'supervisor','2026-06-04','submitted'),
(9,6,6,1,'self','2026-06-01','submitted'),
(10,4,8,1,'peer','2026-06-05','submitted'),
(11,8,8,1,'self','2026-06-05','submitted'),
(12,3,8,1,'supervisor','2026-06-05','submitted'),
(13,4,3,1,'subordinate','2026-06-06','submitted'),
(14,8,3,1,'subordinate','2026-06-06','submitted'),
(15,3,3,1,'self','2026-06-06','submitted');

INSERT INTO assessment_details (assessment_id, question_id, score, comment) VALUES
(1,1,5,''),(1,2,4,''),(1,3,5,''),(1,4,4,''),(1,5,4,''),(1,6,5,''),(1,7,4,''),(1,8,4,''),(1,9,5,''),(1,10,4,''),(1,11,5,''),(1,12,4,''),
(2,1,4,''),(2,2,4,''),(2,3,5,''),(2,4,5,''),(2,5,4,''),(2,6,4,''),(2,7,4,''),(2,8,5,''),(2,9,4,''),(2,10,4,''),(2,11,5,''),(2,12,5,''),
(3,1,5,''),(3,2,5,''),(3,3,4,''),(3,4,4,''),(3,5,4,''),(3,6,5,''),(3,7,5,''),(3,8,4,''),(3,9,4,''),(3,10,5,''),(3,11,4,''),(3,12,5,''),
(4,1,5,''),(4,2,5,''),(4,3,5,''),(4,4,5,''),(4,5,4,''),(4,6,5,''),(4,7,5,''),(4,8,5,''),(4,9,4,''),(4,10,5,''),(4,11,5,''),(4,12,5,''),
(5,1,4,''),(5,2,4,''),(5,3,4,''),(5,4,3,''),(5,5,5,''),(5,6,4,''),(5,7,4,''),(5,8,4,''),(5,9,4,''),(5,10,3,''),(5,11,4,''),(5,12,5,''),
(6,1,4,''),(6,2,4,''),(6,3,4,''),(6,4,4,''),(6,5,5,''),(6,6,4,''),(6,7,4,''),(6,8,4,''),(6,9,4,''),(6,10,4,''),(6,11,4,''),(6,12,5,''),
(7,1,4,''),(7,2,4,''),(7,3,4,''),(7,4,4,''),(7,5,5,''),(7,6,5,''),(7,7,4,''),(7,8,4,''),(7,9,4,''),(7,10,4,''),(7,11,4,''),(7,12,5,''),
(8,1,4,''),(8,2,4,''),(8,3,4,''),(8,4,4,''),(8,5,4,''),(8,6,4,''),(8,7,4,''),(8,8,4,''),(8,9,3,''),(8,10,4,''),(8,11,4,''),(8,12,4,''),
(9,1,4,''),(9,2,4,''),(9,3,4,''),(9,4,4,''),(9,5,4,''),(9,6,4,''),(9,7,4,''),(9,8,4,''),(9,9,4,''),(9,10,4,''),(9,11,4,''),(9,12,4,''),
(10,1,5,''),(10,2,4,''),(10,3,4,''),(10,4,4,''),(10,5,4,''),(10,6,4,''),(10,7,4,''),(10,8,4,''),(10,9,5,''),(10,10,4,''),(10,11,4,''),(10,12,5,''),
(11,1,5,''),(11,2,4,''),(11,3,5,''),(11,4,4,''),(11,5,4,''),(11,6,4,''),(11,7,4,''),(11,8,4,''),(11,9,5,''),(11,10,5,''),(11,11,4,''),(11,12,5,''),
(12,1,5,''),(12,2,5,''),(12,3,5,''),(12,4,5,''),(12,5,4,''),(12,6,4,''),(12,7,5,''),(12,8,5,''),(12,9,5,''),(12,10,5,''),(12,11,5,''),(12,12,5,''),
(13,1,4,''),(13,2,4,''),(13,3,4,''),(13,4,4,''),(13,5,4,''),(13,6,4,''),(13,7,4,''),(13,8,4,''),(13,9,4,''),(13,10,4,''),(13,11,5,''),(13,12,5,''),
(14,1,5,''),(14,2,4,''),(14,3,4,''),(14,4,4,''),(14,5,5,''),(14,6,4,''),(14,7,4,''),(14,8,4,''),(14,9,5,''),(14,10,4,''),(14,11,5,''),(14,12,5,''),
(15,1,4,''),(15,2,4,''),(15,3,4,''),(15,4,5,''),(15,5,4,''),(15,6,4,''),(15,7,5,''),(15,8,4,''),(15,9,4,''),(15,10,4,''),(15,11,4,''),(15,12,4,'');

INSERT INTO final_results (employee_id, period_id, self_score, peer_score, subordinate_score, supervisor_score, final_score, gap_analysis) VALUES
(3,1,4.17,0.00,4.33,0.00,4.28,'Area pengembangan utama: Kompeten. Rekomendasi IDP: penguatan coaching, feedback rutin, dan delegasi berbasis kompetensi.'),
(4,1,4.42,4.50,0.00,4.83,4.70,'Kinerja sangat baik. Fokus pengembangan: konsistensi inovasi dan dokumentasi kolaborasi.'),
(5,1,4.25,4.08,0.00,4.25,4.20,'Kinerja baik. Fokus pengembangan: peningkatan inisiatif adaptif dan kompetensi teknis.'),
(6,1,4.00,0.00,0.00,3.92,3.96,'Kinerja baik. Fokus pengembangan: kecepatan adaptasi dan kolaborasi lintas fungsi.'),
(8,1,4.42,4.33,0.00,4.83,4.66,'Kinerja sangat baik. Fokus pengembangan: persiapan peran talent pool dan penguatan leadership.');

INSERT INTO audit_logs (user_id, activity, activity_time, ip_address) VALUES
(1,'Seed database imported',NOW(),'127.0.0.1'),
(2,'Membuat periode evaluasi AKHLAK',NOW(),'127.0.0.1'),
(3,'Memvalidasi peer assignment tim Operations',NOW(),'127.0.0.1'),
(8,'Mengisi self-assessment',NOW(),'127.0.0.1');

INSERT INTO notifications (user_id, title, message, notification_type, is_read, created_at, created_by) VALUES
(NULL,'Periode Evaluasi Aktif','Periode Evaluasi AKHLAK Semester 1 2026 sedang berlangsung. Harap selesaikan penilaian sesuai batas waktu.','period',0,NOW(),1),
(8,'Reminder Penilaian','Daffa, masih ada penilaian peer yang perlu diselesaikan sebelum periode ditutup.','reminder',0,NOW(),1),
(3,'Validasi Peer Assignment','Terdapat daftar peer assignment yang perlu divalidasi oleh atasan.','approval',0,NOW(),1),
(7,'Laporan Siap Diunduh','Laporan evaluasi AKHLAK semester berjalan sudah dapat diunduh.','report',0,NOW(),1);
