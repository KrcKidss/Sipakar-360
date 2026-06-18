<?php
session_start();
date_default_timezone_set('Asia/Jakarta');

/* Import database/schema.sql ke phpMyAdmin terlebih dahulu. */
define('DB_HOST', '127.0.0.1');
define('DB_NAME', 'sipakar360_laporan');
define('DB_USER', 'root');
define('DB_PASS', '');

function db(){
    static $pdo = null;
    if($pdo === null){
        $dsn = 'mysql:host='.DB_HOST.';dbname='.DB_NAME.';charset=utf8mb4';
        $pdo = new PDO($dsn, DB_USER, DB_PASS, [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
        ]);
    }
    return $pdo;
}
function h($v){ return htmlspecialchars((string)$v, ENT_QUOTES, 'UTF-8'); }
function q($sql,$params=[]){ $s=db()->prepare($sql); $s->execute($params); return $s; }
function one($sql,$params=[]){ $r=q($sql,$params)->fetch(); return $r ?: null; }
function all($sql,$params=[]){ return q($sql,$params)->fetchAll(); }
function val($sql,$params=[]){ $r=one($sql,$params); return $r ? array_values($r)[0] : null; }
function redirect_to($page){ header('Location: ?page='.urlencode($page)); exit; }
function flash($msg,$type='ok'){ $_SESSION['flash']=['message'=>$msg,'type'=>$type]; }
function get_flash(){ if(!isset($_SESSION['flash'])) return null; $f=$_SESSION['flash']; unset($_SESSION['flash']); return $f; }

function current_user(){
    if(!isset($_SESSION['user_id'])) return null;
    return one("SELECT u.*, r.role_name, r.role_description, e.employee_name, e.employee_email, e.department_id, e.position_id, e.supervisor_id, e.employee_nik, e.employee_status, d.department_name, p.position_name, p.position_level, sp.employee_name AS supervisor_name
                FROM users u
                JOIN roles r ON r.role_id=u.role_id
                JOIN employees e ON e.employee_id=u.employee_id
                JOIN departments d ON d.department_id=e.department_id
                JOIN positions p ON p.position_id=e.position_id
                LEFT JOIN employees sp ON sp.employee_id=e.supervisor_id
                WHERE u.user_id=?", [$_SESSION['user_id']]);
}
function role_label($role){
    $map=['admin_hr'=>'Admin HR','staff'=>'Karyawan','atasan'=>'Atasan','manajemen'=>'Manajemen'];
    return $map[$role] ?? ucfirst($role);
}
function badge($status){
    $s=strtolower((string)$status); $cls='neutral';
    if(in_array($s,['active','submitted','approved','read'])) $cls='good';
    if(in_array($s,['draft','pending','unread'])) $cls='warn';
    if(in_array($s,['inactive','rejected','closed'])) $cls='risk';
    return '<span class="badge '.$cls.'">'.h($status).'</span>';
}
function role_allows($u,$roles){ return $u && in_array($u['role_name'], $roles); }
function can_admin($u){ return role_allows($u,['admin_hr']); }
function can_manage_all($u){ return role_allows($u,['admin_hr','manajemen']); }
function can_report($u){ return role_allows($u,['admin_hr','atasan','manajemen','staff']); }
function add_audit($activity){
    if(!isset($_SESSION['user_id'])) return;
    q("INSERT INTO audit_logs(user_id,activity,activity_time,ip_address) VALUES(?,?,NOW(),?)", [$_SESSION['user_id'],$activity,$_SERVER['REMOTE_ADDR'] ?? '127.0.0.1']);
}
function active_period(){
    $p=one("SELECT * FROM evaluation_periods WHERE period_status='active' ORDER BY period_id DESC LIMIT 1");
    return $p ?: one("SELECT * FROM evaluation_periods ORDER BY period_id DESC LIMIT 1");
}
function idp_recommendation($score){
    if($score >= 4.50) return 'Talent pool: kandidat potensial untuk mentoring, project leadership, dan penugasan strategis.';
    if($score >= 4.00) return 'Pertahankan performa melalui coaching rutin dan target peningkatan perilaku AKHLAK.';
    if($score >= 3.50) return 'Perlu IDP terarah: pelatihan perilaku AKHLAK, evaluasi bulanan, dan pendampingan atasan.';
    return 'Prioritas pengembangan: coaching intensif, rencana perbaikan perilaku, dan monitoring HR.';
}
function type_label($t){
    $m=['self'=>'Self Assessment','peer'=>'Peer Assessment','supervisor'=>'Penilaian Atasan','subordinate'=>'Penilaian Bawahan'];
    return $m[$t] ?? ucfirst($t);
}
function scope_where($u,$alias='fr'){
    if($u['role_name']==='staff') return ["WHERE $alias.employee_id=?", [$u['employee_id']]];
    if($u['role_name']==='atasan') return ["JOIN employees se ON se.employee_id=$alias.employee_id WHERE se.supervisor_id=? OR se.employee_id=?", [$u['employee_id'],$u['employee_id']]];
    return ['',[]];
}
function report_rows($u){
    [$scope,$params]=scope_where($u,'fr');
    return all("SELECT fr.*, e.employee_nik, e.employee_name, d.department_name, p.position_name, ep.period_name
                FROM final_results fr
                JOIN employees e ON e.employee_id=fr.employee_id
                JOIN departments d ON d.department_id=e.department_id
                JOIN positions p ON p.position_id=e.position_id
                JOIN evaluation_periods ep ON ep.period_id=fr.period_id
                $scope
                ORDER BY fr.final_score DESC", $params);
}
function akhlak_scores($employee_id=null,$period_id=null){
    $where="WHERE a.assessment_status='submitted'"; $params=[];
    if($employee_id){ $where.=" AND a.evaluatee_id=?"; $params[]=$employee_id; }
    if($period_id){ $where.=" AND a.period_id=?"; $params[]=$period_id; }
    return all("SELECT av.akhlak_name, ROUND(AVG(ad.score),2) AS avg_score
                FROM assessment_details ad
                JOIN assessments a ON a.assessment_id=ad.assessment_id
                JOIN questions qn ON qn.question_id=ad.question_id
                JOIN akhlak_values av ON av.akhlak_id=qn.akhlak_id
                $where
                GROUP BY av.akhlak_id,av.akhlak_name
                ORDER BY avg_score DESC", $params);
}
function visible_notifications($u){
    return all("SELECT n.*, cu.username AS creator
                FROM notifications n
                LEFT JOIN users cu ON cu.user_id=n.created_by
                WHERE n.user_id IS NULL OR n.user_id=?
                ORDER BY n.created_at DESC LIMIT 12", [$u['user_id']]);
}
function create_notification($user_id,$title,$message,$type='info'){
    $creator=$_SESSION['user_id'] ?? null;
    q("INSERT INTO notifications(user_id,title,message,notification_type,is_read,created_at,created_by) VALUES(?,?,?,?,0,NOW(),?)", [$user_id ?: null,$title,$message,$type,$creator]);
}
function score_fmt($v){ return $v && $v > 0 ? number_format((float)$v,2) : 'N/A'; }
function recalc_final_result($employee_id,$period_id){
    $weights=['self'=>0.10,'peer'=>0.20,'subordinate'=>0.30,'supervisor'=>0.40];
    $scores=['self'=>0,'peer'=>0,'subordinate'=>0,'supervisor'=>0];
    foreach($scores as $type=>$v){
        $avg=val("SELECT AVG(ad.score) FROM assessments a JOIN assessment_details ad ON ad.assessment_id=a.assessment_id WHERE a.evaluatee_id=? AND a.period_id=? AND a.assessment_type=? AND a.assessment_status='submitted'", [$employee_id,$period_id,$type]);
        $scores[$type]=$avg ? round((float)$avg,2) : 0;
    }
    $weighted=0; $used=0;
    foreach($scores as $type=>$s){ if($s>0){ $weighted += $s*$weights[$type]; $used += $weights[$type]; } }
    $final = $used>0 ? round($weighted/$used,2) : 0;
    $weak=one("SELECT av.akhlak_name, AVG(ad.score) avg_score
               FROM assessments a
               JOIN assessment_details ad ON ad.assessment_id=a.assessment_id
               JOIN questions qn ON qn.question_id=ad.question_id
               JOIN akhlak_values av ON av.akhlak_id=qn.akhlak_id
               WHERE a.evaluatee_id=? AND a.period_id=? AND a.assessment_status='submitted'
               GROUP BY av.akhlak_id,av.akhlak_name ORDER BY avg_score ASC LIMIT 1", [$employee_id,$period_id]);
    $gap = $weak ? 'Area pengembangan utama: '.$weak['akhlak_name'].' dengan skor rata-rata '.round($weak['avg_score'],2).'. '.idp_recommendation($final) : 'Belum ada data assessment lengkap.';
    $id=val("SELECT result_id FROM final_results WHERE employee_id=? AND period_id=?", [$employee_id,$period_id]);
    if($id){
        q("UPDATE final_results SET self_score=?, peer_score=?, subordinate_score=?, supervisor_score=?, final_score=?, gap_analysis=? WHERE result_id=?", [$scores['self'],$scores['peer'],$scores['subordinate'],$scores['supervisor'],$final,$gap,$id]);
    } else {
        q("INSERT INTO final_results(employee_id,period_id,self_score,peer_score,subordinate_score,supervisor_score,final_score,gap_analysis) VALUES(?,?,?,?,?,?,?,?)", [$employee_id,$period_id,$scores['self'],$scores['peer'],$scores['subordinate'],$scores['supervisor'],$final,$gap]);
    }
}
function ensure_assessment($evaluator_id,$evaluatee_id,$period_id,$type){
    $id=val("SELECT assessment_id FROM assessments WHERE evaluator_id=? AND evaluatee_id=? AND period_id=? AND assessment_type=?", [$evaluator_id,$evaluatee_id,$period_id,$type]);
    if($id) return (int)$id;
    q("INSERT INTO assessments(evaluator_id,evaluatee_id,period_id,assessment_type,assessment_date,assessment_status) VALUES(?,?,?,?,CURDATE(),'draft')", [$evaluator_id,$evaluatee_id,$period_id,$type]);
    return (int)db()->lastInsertId();
}
function assessment_targets($u,$period){
    $targets=[];
    if(!$period) return $targets;
    $pid=$period['period_id']; $eid=$u['employee_id'];
    $targets[]=['evaluatee_id'=>$eid,'name'=>$u['employee_name'],'type'=>'self','reason'=>'Penilaian diri sendiri'];
    $peers=all("SELECT pa.*, e.employee_name FROM peer_assignments pa JOIN employees e ON e.employee_id=pa.employee_id WHERE pa.peer_employee_id=? AND pa.period_id=? AND pa.approval_status='approved'", [$eid,$pid]);
    foreach($peers as $p) $targets[]=['evaluatee_id'=>$p['employee_id'],'name'=>$p['employee_name'],'type'=>'peer','reason'=>'Penilaian rekan sejawat'];
    $subs=all("SELECT employee_id, employee_name FROM employees WHERE supervisor_id=? AND employee_status='active'", [$eid]);
    foreach($subs as $s) $targets[]=['evaluatee_id'=>$s['employee_id'],'name'=>$s['employee_name'],'type'=>'supervisor','reason'=>'Atasan menilai bawahan'];
    if(!empty($u['supervisor_id'])){
        $sp=one("SELECT employee_id, employee_name FROM employees WHERE employee_id=?", [$u['supervisor_id']]);
        if($sp) $targets[]=['evaluatee_id'=>$sp['employee_id'],'name'=>$sp['employee_name'],'type'=>'subordinate','reason'=>'Bawahan menilai atasan'];
    }
    return $targets;
}
function render_simple_pdf($rows){
    $lines=['SIPAKAR - Laporan Evaluasi AKHLAK','PT Energi Nusantara','Generated: '.date('Y-m-d H:i:s'),''];
    foreach($rows as $i=>$r){
        $lines[] = ($i+1).'. '.$r['employee_name'].' | '.$r['department_name'].' | Final: '.$r['final_score'].' | Top/IDP: '.substr($r['gap_analysis'],0,110);
    }
    $content="BT /F1 10 Tf 40 790 Td 14 TL ";
    foreach($lines as $line){ $content.='('.str_replace(['\\','(',')'],['\\\\','\\(','\\)'],$line).') Tj T* '; }
    $content.='ET';
    $objs=[];
    $objs[]="1 0 obj << /Type /Catalog /Pages 2 0 R >> endobj\n";
    $objs[]="2 0 obj << /Type /Pages /Kids [3 0 R] /Count 1 >> endobj\n";
    $objs[]="3 0 obj << /Type /Page /Parent 2 0 R /MediaBox [0 0 595 842] /Resources << /Font << /F1 4 0 R >> >> /Contents 5 0 R >> endobj\n";
    $objs[]="4 0 obj << /Type /Font /Subtype /Type1 /BaseFont /Helvetica >> endobj\n";
    $objs[]="5 0 obj << /Length ".strlen($content)." >> stream\n$content\nendstream endobj\n";
    $pdf="%PDF-1.4\n"; $offsets=[0];
    foreach($objs as $o){ $offsets[]=strlen($pdf); $pdf.=$o; }
    $xref=strlen($pdf); $pdf.="xref\n0 ".(count($objs)+1)."\n0000000000 65535 f \n";
    for($i=1;$i<=count($objs);$i++) $pdf.=sprintf('%010d 00000 n ', $offsets[$i])."\n";
    $pdf.="trailer << /Size ".(count($objs)+1)." /Root 1 0 R >>\nstartxref\n$xref\n%%EOF";
    return $pdf;
}

/* download export */
if(isset($_GET['download'])){
    $u=current_user(); if(!$u) exit('Unauthorized');
    $rows=report_rows($u); $fmt=$_GET['download'];
    if($fmt==='csv'){
        header('Content-Type: text/csv; charset=utf-8'); header('Content-Disposition: attachment; filename="sipakar_report.csv"');
        $out=fopen('php://output','w'); fputcsv($out,['NIK','Nama','Departemen','Jabatan','Periode','Self','Peer','Subordinate','Supervisor','Final','Gap/IDP']);
        foreach($rows as $r) fputcsv($out,[$r['employee_nik'],$r['employee_name'],$r['department_name'],$r['position_name'],$r['period_name'],$r['self_score'],$r['peer_score'],$r['subordinate_score'],$r['supervisor_score'],$r['final_score'],$r['gap_analysis']]);
        exit;
    }
    if($fmt==='excel'){
        header('Content-Type: application/vnd.ms-excel; charset=utf-8'); header('Content-Disposition: attachment; filename="sipakar_report.xls"');
        echo '<table border="1"><tr><th>NIK</th><th>Nama</th><th>Departemen</th><th>Jabatan</th><th>Periode</th><th>Self</th><th>Peer</th><th>Subordinate</th><th>Supervisor</th><th>Final</th><th>Gap/IDP</th></tr>';
        foreach($rows as $r) echo '<tr><td>'.h($r['employee_nik']).'</td><td>'.h($r['employee_name']).'</td><td>'.h($r['department_name']).'</td><td>'.h($r['position_name']).'</td><td>'.h($r['period_name']).'</td><td>'.$r['self_score'].'</td><td>'.$r['peer_score'].'</td><td>'.$r['subordinate_score'].'</td><td>'.$r['supervisor_score'].'</td><td>'.$r['final_score'].'</td><td>'.h($r['gap_analysis']).'</td></tr>';
        echo '</table>'; exit;
    }
    if($fmt==='pdf'){
        header('Content-Type: application/pdf'); header('Content-Disposition: attachment; filename="sipakar_report.pdf"');
        echo render_simple_pdf($rows); exit;
    }
}

$page=$_GET['page'] ?? 'dashboard';
$public=['login'];
if(!in_array($page,$public) && !current_user()) redirect_to('login');
$u=current_user();

/* Login/logout */
if($page==='login' && $_SERVER['REQUEST_METHOD']==='POST'){
    $username=trim($_POST['username'] ?? ''); $password=trim($_POST['password'] ?? '');
    $user=one("SELECT u.*, r.role_name FROM users u JOIN roles r ON r.role_id=u.role_id WHERE u.username=? AND u.password=? AND u.account_status='active'", [$username,$password]);
    if($user){
        $_SESSION['user_id']=$user['user_id'];
        q("UPDATE users SET last_login=NOW() WHERE user_id=?", [$user['user_id']]);
        add_audit('Login berhasil sebagai '.role_label($user['role_name']));
        redirect_to('dashboard');
    }
    flash('Username atau password salah, atau akun tidak aktif.','error'); redirect_to('login');
}
if($page==='logout'){
    add_audit('Logout dari sistem'); session_destroy(); session_start(); flash('Logout berhasil.','ok'); redirect_to('login');
}

/* Actions */
if($_SERVER['REQUEST_METHOD']==='POST' && $u){
    $action=$_POST['action'] ?? '';
    try{
        if($action==='save_employee' && can_admin($u)){
            $id_raw=trim($_POST['employee_id'] ?? '');
            $id=null;
            if($id_raw!==''){
                $id=(int)$id_raw;
                if($id<=0) throw new Exception('ID karyawan tidak valid.');
                $exists=(int)val("SELECT COUNT(*) FROM employees WHERE employee_id=?", [$id]);
                if(!$exists) throw new Exception('ID karyawan tidak ditemukan. Klik tombol Edit dari tabel untuk mengubah data; untuk tambah karyawan baru biarkan ID kosong.');
            }
            $dep=(int)$_POST['department_id']; $pos=(int)$_POST['position_id'];
            $supervisor_id=($_POST['supervisor_id'] ?? '')!=='' ? (int)$_POST['supervisor_id'] : null;
            $nik=trim($_POST['employee_nik']); $name=trim($_POST['employee_name']); $email=trim($_POST['employee_email']); $phone=trim($_POST['employee_phone']); $hire=$_POST['hire_date']; $status=$_POST['employee_status'];
            $role_id=(int)($_POST['role_id'] ?? 2); $username=trim($_POST['username'] ?? ''); $password=trim($_POST['password'] ?? '');
            // Transactional: simpan employees + users atomically
            try{
                db()->beginTransaction();
                if($id){
                    if($supervisor_id && $supervisor_id==(int)$id) $supervisor_id=null;
                    q("UPDATE employees SET department_id=?, position_id=?, supervisor_id=?, employee_nik=?, employee_name=?, employee_email=?, employee_phone=?, hire_date=?, employee_status=? WHERE employee_id=?", [$dep,$pos,$supervisor_id,$nik,$name,$email,$phone,$hire,$status,$id]);
                    $uid=val("SELECT user_id FROM users WHERE employee_id=?", [$id]);
                    if($uid){
                        $sql="UPDATE users SET role_id=?, username=?, account_status=?"; $params=[$role_id,$username ?: strtolower(strtok($email,'@')),$status];
                        if($password!==''){ $sql.=', password=?'; $params[]=$password; }
                        $sql.=' WHERE employee_id=?'; $params[]=$id; q($sql,$params);
                    } else {
                        q("INSERT INTO users(role_id,employee_id,username,password,account_status) VALUES(?,?,?,?,?)", [$role_id,$id,$username ?: strtolower(strtok($email,'@')),$password ?: 'password123',$status]);
                    }
                    db()->commit();
                    flash('Data karyawan dan akun user berhasil diupdate.'); add_audit('Update karyawan '.$name);
                } else {
                    q("INSERT INTO employees(department_id,position_id,supervisor_id,employee_nik,employee_name,employee_email,employee_phone,hire_date,employee_status) VALUES(?,?,?,?,?,?,?,?,?)", [$dep,$pos,$supervisor_id,$nik,$name,$email,$phone,$hire,$status]);
                    $newId=(int)db()->lastInsertId();
                    q("INSERT INTO users(role_id,employee_id,username,password,account_status) VALUES(?,?,?,?,?)", [$role_id,$newId,$username ?: strtolower(strtok($email,'@')),$password ?: 'password123',$status]);
                    db()->commit();
                    create_notification(null,'Karyawan Baru Ditambahkan',$name.' telah ditambahkan ke database SIPAKAR.','employee');
                    flash('Karyawan berhasil ditambahkan dan akun user otomatis dibuat.'); add_audit('Tambah karyawan '.$name);
                }
            } catch(Exception $e){ db()->rollBack(); throw $e; }
            redirect_to('employees');
        }
        if($action==='delete_employee' && can_admin($u)){
            q("UPDATE employees SET employee_status='inactive' WHERE employee_id=?", [(int)$_POST['employee_id']]);
            q("UPDATE users SET account_status='inactive' WHERE employee_id=?", [(int)$_POST['employee_id']]);
            flash('Karyawan dan akun user dinonaktifkan agar riwayat assessment tetap aman.'); add_audit('Nonaktifkan karyawan'); redirect_to('employees');
        }
        // Soft delete periode: ubah status menjadi closed/inactive
        if($action==='delete_period' && can_admin($u)){
            $pid=(int)$_POST['period_id'];
            q("UPDATE evaluation_periods SET period_status='closed' WHERE period_id=?", [$pid]);
            flash('Periode evaluasi ditutup (soft delete). Riwayat assessment tetap aman.'); add_audit('Tutup periode evaluasi'); redirect_to('periods');
        }
        // Soft delete pertanyaan: ubah status menjadi inactive
        if($action==='delete_question' && can_admin($u)){
            $qid=(int)$_POST['question_id'];
            q("UPDATE questions SET question_status='inactive' WHERE question_id=?", [$qid]);
            flash('Pertanyaan AKHLAK dinonaktifkan. Riwayat assessment tetap aman.'); add_audit('Nonaktifkan pertanyaan AKHLAK'); redirect_to('questions');
        }
        // Delete/cancel peer assignment: hard delete jika aman, atau ubah status
        if($action==='delete_assignment' && can_admin($u)){
            $aid=(int)$_POST['peer_assignment_id'];
            // Cek apakah sudah ada assessment yang pakai assignment ini
            $used=val("SELECT COUNT(*) FROM assessments WHERE period_id=(SELECT period_id FROM peer_assignments WHERE peer_assignment_id=?) AND assessment_type='peer' AND assessment_status='submitted'", [$aid]);
            if($used){
                q("UPDATE peer_assignments SET approval_status='cancelled' WHERE peer_assignment_id=?", [$aid]);
                flash('Peer assignment dibatalkan (status diubah ke cancelled karena sudah ada assessment).');
            } else {
                q("DELETE FROM peer_assignments WHERE peer_assignment_id=?", [$aid]);
                flash('Peer assignment dihapus dari database.');
            }
            add_audit('Hapus/batalkan peer assignment'); redirect_to('assignments');
        }
        if($action==='save_period' && can_admin($u)){
            $id_raw=trim($_POST['period_id'] ?? '');
            $id=null;
            if($id_raw!==''){
                $id=(int)$id_raw;
                if($id<=0) throw new Exception('ID periode tidak valid.');
                $exists=(int)val("SELECT COUNT(*) FROM evaluation_periods WHERE period_id=?", [$id]);
                if(!$exists) throw new Exception('ID periode tidak ditemukan. Klik tombol Edit dari tabel untuk mengubah data; untuk tambah periode baru biarkan ID otomatis.');
            }

            $period_name=trim($_POST['period_name'] ?? '');
            $start_date=$_POST['start_date'] ?? '';
            $end_date=$_POST['end_date'] ?? '';
            $period_status=$_POST['period_status'] ?? 'draft';
            $allowed_status=['draft','active','closed'];
            if($period_name==='') throw new Exception('Nama periode wajib diisi.');
            if(!in_array($period_status,$allowed_status,true)) throw new Exception('Status periode tidak valid.');
            if($start_date==='' || $end_date==='') throw new Exception('Tanggal mulai dan tanggal selesai wajib diisi.');
            if(strtotime($end_date) < strtotime($start_date)) throw new Exception('Tanggal selesai tidak boleh lebih awal dari tanggal mulai.');

            if($id){
                q("UPDATE evaluation_periods SET period_name=?, start_date=?, end_date=?, period_status=? WHERE period_id=?", [$period_name,$start_date,$end_date,$period_status,$id]);
                flash('Periode evaluasi berhasil diperbarui.');
                add_audit('Update periode evaluasi '.$period_name);
            } else {
                q("INSERT INTO evaluation_periods(period_name,start_date,end_date,period_status) VALUES(?,?,?,?)", [$period_name,$start_date,$end_date,$period_status]);
                flash('Periode evaluasi berhasil ditambahkan.');
                add_audit('Tambah periode evaluasi '.$period_name);
            }
            if($period_status==='active') create_notification(null,'Periode Evaluasi Aktif','Periode '.$period_name.' telah dibuka.','period');
            redirect_to('periods');
        }
        if($action==='save_question' && can_admin($u)){
            $id_raw=trim($_POST['question_id'] ?? '');
            $id=null;
            if($id_raw!==''){
                $id=(int)$id_raw;
                if($id<=0) throw new Exception('ID pertanyaan tidak valid.');
                $exists=(int)val("SELECT COUNT(*) FROM questions WHERE question_id=?", [$id]);
                if(!$exists) throw new Exception('ID pertanyaan tidak ditemukan. Klik tombol Edit dari tabel untuk mengubah data; untuk tambah pertanyaan baru biarkan ID otomatis.');
            }

            $akhlak_id=(int)($_POST['akhlak_id'] ?? 0);
            $question_text=trim($_POST['question_text'] ?? '');
            $question_category=trim($_POST['question_category'] ?? 'Perilaku');
            $question_status=$_POST['question_status'] ?? 'active';
            $allowed_status=['active','inactive'];

            if($akhlak_id<=0 || !(int)val("SELECT COUNT(*) FROM akhlak_values WHERE akhlak_id=?", [$akhlak_id])) throw new Exception('Nilai AKHLAK tidak valid.');
            if($question_text==='') throw new Exception('Isi pertanyaan wajib diisi.');
            if($question_category==='') $question_category='Perilaku';
            if(!in_array($question_status,$allowed_status,true)) throw new Exception('Status pertanyaan tidak valid.');

            if($id){
                q("UPDATE questions SET akhlak_id=?, question_text=?, question_category=?, question_status=? WHERE question_id=?", [$akhlak_id,$question_text,$question_category,$question_status,$id]);
                flash('Pertanyaan AKHLAK berhasil diperbarui.');
                add_audit('Update pertanyaan AKHLAK');
            } else {
                q("INSERT INTO questions(akhlak_id,question_text,question_category,question_status) VALUES(?,?,?,?)", [$akhlak_id,$question_text,$question_category,$question_status]);
                flash('Pertanyaan AKHLAK berhasil ditambahkan.');
                add_audit('Tambah pertanyaan AKHLAK');
            }
            redirect_to('questions');
        }
        if($action==='save_assignment' && can_admin($u)){
            $aid_raw=trim($_POST['peer_assignment_id'] ?? '');
            $aid=null;
            if($aid_raw!==''){
                $aid=(int)$aid_raw;
                if($aid<=0) throw new Exception('ID peer assignment tidak valid.');
                $exists=(int)val("SELECT COUNT(*) FROM peer_assignments WHERE peer_assignment_id=?", [$aid]);
                if(!$exists) throw new Exception('ID peer assignment tidak ditemukan. Klik tombol Edit dari tabel untuk mengubah data; untuk tambah assignment baru biarkan ID otomatis.');
            }

            $emp_id=$aid ? (int)($_POST['employee_id_hidden'] ?? 0) : (int)($_POST['employee_id'] ?? 0);
            $peer_id=(int)($_POST['peer_employee_id'] ?? 0);
            $period_id=(int)($_POST['period_id'] ?? 0);
            $approval_status=$_POST['approval_status'] ?? 'pending';
            $approved_by=trim($_POST['approved_by'] ?? '');
            $approved_by=$approved_by!=='' ? $approved_by : null;
            $allowed_status=['pending','approved','rejected','cancelled'];

            if($emp_id<=0 || !(int)val("SELECT COUNT(*) FROM employees WHERE employee_id=?", [$emp_id])) throw new Exception('Karyawan yang dinilai tidak valid.');
            if($peer_id<=0 || !(int)val("SELECT COUNT(*) FROM employees WHERE employee_id=?", [$peer_id])) throw new Exception('Peer penilai tidak valid.');
            if($emp_id===$peer_id) throw new Exception('Karyawan yang dinilai dan peer penilai tidak boleh orang yang sama.');
            if($period_id<=0 || !(int)val("SELECT COUNT(*) FROM evaluation_periods WHERE period_id=?", [$period_id])) throw new Exception('Periode evaluasi tidak valid.');
            if(!in_array($approval_status,$allowed_status,true)) throw new Exception('Status approval tidak valid.');

            if($aid){
                q("UPDATE peer_assignments SET employee_id=?, peer_employee_id=?, period_id=?, approval_status=?, approved_by=? WHERE peer_assignment_id=?", [$emp_id,$peer_id,$period_id,$approval_status,$approved_by,$aid]);
                flash('Peer assignment berhasil diperbarui.'); add_audit('Update peer assignment');
            } else {
                q("INSERT INTO peer_assignments(employee_id,peer_employee_id,period_id,approval_status,approved_by) VALUES(?,?,?,?,?) ON DUPLICATE KEY UPDATE approval_status=VALUES(approval_status), approved_by=VALUES(approved_by)", [$emp_id,$peer_id,$period_id,$approval_status,$approved_by]);
                flash('Peer assignment berhasil ditambahkan atau diperbarui jika datanya sudah ada.'); add_audit('Tambah peer assignment');
            }
            create_notification(null,'Peer Assignment Diperbarui','Admin HR memperbarui daftar penilai silang.','assignment');
            redirect_to('assignments');
        }
        if($action==='validate_assignment' && role_allows($u,['atasan','admin_hr'])){
            q("UPDATE peer_assignments SET approval_status=?, approved_by=? WHERE peer_assignment_id=?", [$_POST['approval_status'],$u['employee_name'],$_POST['peer_assignment_id']]);
            flash('Status peer assignment diperbarui.'); add_audit('Validasi peer assignment'); redirect_to('assignments');
        }
        if($action==='send_notification' && can_admin($u)){
            $target=$_POST['user_id']==='' ? null : (int)$_POST['user_id'];
            create_notification($target,$_POST['title'],$_POST['message'],$_POST['notification_type']);
            flash('Notifikasi berhasil dibuat.'); add_audit('Membuat notifikasi'); redirect_to('notifications');
        }
        if($action==='mark_read'){
            q("UPDATE notifications SET is_read=1 WHERE notification_id=? AND (user_id IS NULL OR user_id=?)", [$_POST['notification_id'],$u['user_id']]);
            redirect_to('notifications');
        }
        if($action==='submit_assessment'){
            $period=active_period(); if(!$period) throw new Exception('Belum ada periode aktif.');
            $target=(int)$_POST['evaluatee_id']; $type=$_POST['assessment_type'];
            $allowed=false; foreach(assessment_targets($u,$period) as $t){ if((int)$t['evaluatee_id']===$target && $t['type']===$type) $allowed=true; }
            if(!$allowed && !can_admin($u)) throw new Exception('Target penilaian tidak sesuai assignment atau hierarki.');
            $assessment_id=ensure_assessment($u['employee_id'],$target,$period['period_id'],$type);
            q("DELETE FROM assessment_details WHERE assessment_id=?", [$assessment_id]);
            foreach($_POST['score'] ?? [] as $qid=>$score){
                $score=max(1,min(5,(int)$score)); $comment=trim($_POST['comment'][$qid] ?? '');
                q("INSERT INTO assessment_details(assessment_id,question_id,score,comment) VALUES(?,?,?,?)", [$assessment_id,$qid,$score,$comment]);
            }
            q("UPDATE assessments SET assessment_date=CURDATE(), assessment_status='submitted' WHERE assessment_id=?", [$assessment_id]);
            recalc_final_result($target,$period['period_id']);
            create_notification(null,'Assessment Submitted',$u['employee_name'].' telah mengirim '.type_label($type).' untuk '.val('SELECT employee_name FROM employees WHERE employee_id=?',[$target]).'.','assessment');
            flash('Penilaian berhasil disimpan ke ASSESSMENTS dan ASSESSMENT_DETAILS.'); add_audit('Submit assessment '.type_label($type)); redirect_to('assessment');
        }
    } catch(Exception $e){ flash($e->getMessage(),'error'); redirect_to($page); }
}

function layout_start($u,$title){
    $flash=get_flash();
    $nav=[
        'dashboard'=>'Dashboard',
        'employees'=>'Master Karyawan',
        'periods'=>'Periode',
        'questions'=>'Pertanyaan AKHLAK',
        'assignments'=>'Peer Assignment',
        'assessment'=>'Isi Assessment',
        'reports'=>'Report & IDP',
        'notifications'=>'Notifikasi',
        'audit'=>'Audit Trail'
    ];
    echo '<!doctype html><html><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>SIPAKAR</title><link rel="stylesheet" href="assets/app.css"></head><body>';
    echo '<div class="app-shell"><aside class="sidebar"><div class="brand"><div class="brand-mark small">S</div><div><b>SIPAKAR</b><span>PT Energi Nusantara</span></div></div><nav>';
    foreach($nav as $p=>$label){
        if($p==='employees' && !can_admin($u)) continue;
        if(in_array($p,['periods','questions']) && !can_admin($u)) continue;
        if($p==='audit' && !can_admin($u)) continue;
        if($p==='assignments' && !role_allows($u,['admin_hr','atasan'])) continue;
        echo '<a class="nav-link '.(($_GET['page']??'dashboard')===$p?'active':'').'" href="?page='.$p.'"><span class="icon">●</span>'.$label.'</a>';
    }
    echo '<a class="nav-link danger" href="?page=logout"><span class="icon">●</span>Logout</a></nav></aside><main class="content">';
    echo '<div class="topbar"><div><p class="eyebrow">PT ENERGI NUSANTARA</p><h1>'.h($title).'</h1></div><div class="user-pill"><div class="avatar">'.h(strtoupper(substr($u['employee_name'],0,1))).'</div><div><b>'.h($u['employee_name']).'</b><span>'.role_label($u['role_name']).'</span></div></div></div>';
    if($flash) echo '<div class="toast '.($flash['type']==='error'?'error':'').'">'.h($flash['message']).'</div>';
}
function layout_end(){ echo '</main></div><script src="assets/app.js"></script></body></html>'; }

if($page==='login'){
    $flash=get_flash();
    echo '<!doctype html><html><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Login SIPAKAR</title><link rel="stylesheet" href="assets/app.css"></head><body class="auth-body"><div class="auth-card"><section class="auth-hero"><div class="brand-mark">S</div><p class="eyebrow">PT Energi Nusantara</p><h1>SIPAKAR 360</h1><p>Sistem Penilaian AKHLAK Karyawan berbasis role, assessment 360 derajat, dashboard analitik, IDP, talent mapping, dan audit trail.</p><div class="auth-chips"><span>Admin HR</span><span>Karyawan</span><span>Atasan</span><span>Manajemen</span></div></section><section class="auth-form"><h2>Login SSO Prototype</h2>';
    if($flash) echo '<div class="toast '.($flash['type']==='error'?'error':'').'">'.h($flash['message']).'</div>';
    echo '<form method="post"><label>Username</label><input name="username" placeholder="admin_hr / daffa / atasan / manajemen" required><label>Password</label><input name="password" type="password" placeholder="admin123 / staff123 / atasan123" required><button class="btn primary" type="submit">Masuk Sistem</button></form><div class="demo-box"><b>Akun dummy:</b><br>admin_hr/admin123 · daffa/staff123 · atasan/atasan123 · manajemen/manajemen123<br><br><b>Catatan:</b> ini simulasi SSO lokal untuk praktikum.</div></section></div></body></html>'; exit;
}

if(!$u) redirect_to('login');

if($page==='dashboard'){
    layout_start($u,'Dashboard '.role_label($u['role_name']));
    $period=active_period(); $pid=$period ? $period['period_id'] : null;
    if($u['role_name']==='staff'){
        $result=one("SELECT * FROM final_results WHERE employee_id=? AND period_id=?", [$u['employee_id'],$pid]);
        $tasks=assessment_targets($u,$period);
        $submitted=val("SELECT COUNT(*) FROM assessments WHERE evaluator_id=? AND period_id=? AND assessment_status='submitted'", [$u['employee_id'],$pid]);
        echo '<div class="metric-grid"><div class="metric"><span>Final Score Pribadi</span><b>'.($result?score_fmt($result['final_score']):'N/A').'</b><small>Hanya menampilkan nilai milik user login</small></div><div class="metric"><span>Tugas Assessment</span><b>'.count($tasks).'</b><small>Self, peer, atasan/bawahan sesuai assignment</small></div><div class="metric"><span>Sudah Submit</span><b>'.$submitted.'</b><small>Assessment yang sudah dikirim</small></div><div class="metric"><span>Periode Aktif</span><b>'.h($period['period_name'] ?? '-').'</b><small>'.h(($period['start_date'] ?? '').' - '.($period['end_date'] ?? '')).'</small></div></div>';
        echo '<div class="grid-2"><div class="panel"><h2>Top Score AKHLAK Pribadi</h2><p class="muted">Dihitung dari ASSESSMENT_DETAILS → QUESTIONS → AKHLAK_VALUES untuk employee login.</p>'; render_akhlak_bars(akhlak_scores($u['employee_id'],$pid)); echo '</div><div class="panel"><h2>Ringkasan IDP Pribadi</h2><p>'.h($result['gap_analysis'] ?? 'Belum ada hasil final pada periode aktif.').'</p></div></div>';
    } elseif($u['role_name']==='atasan'){
        $team=all("SELECT e.*, fr.final_score FROM employees e LEFT JOIN final_results fr ON fr.employee_id=e.employee_id AND fr.period_id=? WHERE e.supervisor_id=? ORDER BY fr.final_score DESC", [$pid,$u['employee_id']]);
        $pending=val("SELECT COUNT(*) FROM peer_assignments pa JOIN employees e ON e.employee_id=pa.employee_id WHERE e.supervisor_id=? AND pa.approval_status='pending'", [$u['employee_id']]);
        $avg=val("SELECT AVG(fr.final_score) FROM final_results fr JOIN employees e ON e.employee_id=fr.employee_id WHERE e.supervisor_id=? AND fr.period_id=?", [$u['employee_id'],$pid]);
        echo '<div class="metric-grid"><div class="metric"><span>Jumlah Bawahan</span><b>'.count($team).'</b><small>Berdasarkan supervisor_id</small></div><div class="metric"><span>Rata-rata Tim</span><b>'.score_fmt($avg).'</b><small>Final result bawahan</small></div><div class="metric"><span>Validasi Pending</span><b>'.$pending.'</b><small>Peer assignment perlu ditinjau</small></div><div class="metric"><span>Top Score Tim</span><b>'.score_fmt($team[0]['final_score'] ?? 0).'</b><small>'.h($team[0]['employee_name'] ?? '-').'</small></div></div>';
        echo '<div class="grid-2"><div class="panel"><h2>Top Score AKHLAK Unit</h2>'; render_akhlak_bars(akhlak_scores(null,$pid)); echo '</div><div class="panel"><h2>Daftar Bawahan</h2>'; render_employee_score_table($team); echo '</div></div>';
    } else {
        $totalEmp=val("SELECT COUNT(*) FROM employees WHERE employee_status='active'");
        $submitted=val("SELECT COUNT(*) FROM assessments WHERE period_id=? AND assessment_status='submitted'", [$pid]);
        $avg=val("SELECT AVG(final_score) FROM final_results WHERE period_id=?", [$pid]);
        $top=one("SELECT e.employee_name, fr.final_score FROM final_results fr JOIN employees e ON e.employee_id=fr.employee_id WHERE fr.period_id=? ORDER BY fr.final_score DESC LIMIT 1", [$pid]);
        echo '<div class="metric-grid"><div class="metric"><span>Total Karyawan Aktif</span><b>'.$totalEmp.'</b><small>Data dari EMPLOYEES</small></div><div class="metric"><span>Assessment Submitted</span><b>'.$submitted.'</b><small>Jawaban tersimpan di DB</small></div><div class="metric"><span>Rata-rata Organisasi</span><b>'.score_fmt($avg).'</b><small>Final result periode aktif</small></div><div class="metric"><span>Top Talent</span><b>'.score_fmt($top['final_score'] ?? 0).'</b><small>'.h($top['employee_name'] ?? '-').'</small></div></div>';
        echo '<div class="grid-2"><div class="panel"><h2>Top Score AKHLAK Organisasi</h2>'; render_akhlak_bars(akhlak_scores(null,$pid)); echo '</div><div class="panel"><h2>Distribusi Departemen</h2>'; render_department_scores($pid); echo '</div></div>';
    }
    echo '<div class="panel"><h2>Notifikasi Terbaru</h2>'; render_notifications_list(visible_notifications($u)); echo '</div>';
    layout_end(); exit;
}
function render_akhlak_bars($rows){
    if(!$rows){ echo '<p class="muted">Belum ada data nilai AKHLAK.</p>'; return; }
    foreach($rows as $r){ $pct=min(100,((float)$r['avg_score']/5)*100); echo '<div class="value-row"><b>'.h($r['akhlak_name']).'</b><span>'.score_fmt($r['avg_score']).'</span></div><div class="bar"><i style="width:'.$pct.'%"></i></div>'; }
}
function render_employee_score_table($rows){
    echo '<div class="table-wrap"><table><tr><th>Nama</th><th>Status</th><th>Final Score</th></tr>';
    foreach($rows as $r) echo '<tr><td><b>'.h($r['employee_name']).'</b></td><td>'.badge($r['employee_status']).'</td><td>'.score_fmt($r['final_score'] ?? 0).'</td></tr>';
    echo '</table></div>';
}
function render_department_scores($pid){
    $rows=all("SELECT d.department_name, ROUND(AVG(fr.final_score),2) avg_score FROM final_results fr JOIN employees e ON e.employee_id=fr.employee_id JOIN departments d ON d.department_id=e.department_id WHERE fr.period_id=? GROUP BY d.department_id,d.department_name ORDER BY avg_score DESC", [$pid]);
    render_akhlak_bars(array_map(function($r){ return ['akhlak_name'=>$r['department_name'],'avg_score'=>$r['avg_score']]; }, $rows));
}
function render_notifications_list($rows){
    if(!$rows){ echo '<p class="muted">Belum ada notifikasi.</p>'; return; }
    echo '<div class="timeline">'; foreach($rows as $n){ echo '<div><b>'.h($n['title']).'</b> '.badge($n['is_read']?'read':'unread').'<p>'.h($n['message']).'</p><small>'.h($n['notification_type']).' · '.h($n['created_at']).'</small></div>'; } echo '</div>';
}

if($page==='employees' && can_admin($u)){
    layout_start($u,'Master Data Karyawan');
    $departments=all('SELECT * FROM departments ORDER BY department_name'); $positions=all('SELECT * FROM positions ORDER BY position_level, position_name'); $roles=all('SELECT * FROM roles ORDER BY role_id');
    $emps=all("SELECT e.*, d.department_name, p.position_name, p.position_level, sp.employee_name supervisor_name, r.role_name, us.username FROM employees e JOIN departments d ON d.department_id=e.department_id JOIN positions p ON p.position_id=e.position_id LEFT JOIN employees sp ON sp.employee_id=e.supervisor_id LEFT JOIN users us ON us.employee_id=e.employee_id LEFT JOIN roles r ON r.role_id=us.role_id ORDER BY e.employee_id");
    // Populate form dengan data edit jika ada GET param edit_id
    $edit_id=$_GET['edit_id'] ?? null;
    $edit_data=null;
    if($edit_id){
        $edit_data=one("SELECT e.*, u.role_id, u.username FROM employees e LEFT JOIN users u ON u.employee_id=e.employee_id WHERE e.employee_id=?", [(int)$edit_id]);
    }
    echo '<div class="panel"><h2>'.($edit_data ? 'Edit Karyawan & Akun User' : 'Tambah Karyawan & Akun User').'</h2><p class="muted">Jika data karyawan disimpan, sistem otomatis membuat atau memperbarui akun pada tabel USERS.</p><form method="post" class="form-grid"><input type="hidden" name="action" value="save_employee"><input type="hidden" name="employee_id" value="'.($edit_data?(int)$edit_data['employee_id']:'').'"><input value="'.($edit_data?'ID Karyawan: '.(int)$edit_data['employee_id']:'ID karyawan otomatis saat disimpan').'" readonly><input name="employee_nik" placeholder="NIK" required value="'.($edit_data?h($edit_data['employee_nik']):'').'"><input name="employee_name" placeholder="Nama" required value="'.($edit_data?h($edit_data['employee_name']):'').'"><input name="employee_email" placeholder="Email" required value="'.($edit_data?h($edit_data['employee_email']):'').'"><input name="employee_phone" placeholder="Telepon" value="'.($edit_data?h($edit_data['employee_phone']):'').'"><input type="date" name="hire_date" value="'.($edit_data?$edit_data['hire_date']:date('Y-m-d')).'"><select name="employee_status"><option value="active" '.($edit_data && $edit_data['employee_status']==='active' ? 'selected' : '').'>active</option><option value="inactive" '.($edit_data && $edit_data['employee_status']==='inactive' ? 'selected' : '').'>inactive</option></select><select name="department_id">';
    foreach($departments as $d) echo '<option value="'.$d['department_id'].'" '.($edit_data && $edit_data['department_id']==$d['department_id'] ? 'selected' : '').'>'.h($d['department_name']).'</option>'; echo '</select><select name="position_id">';
    foreach($positions as $p) echo '<option value="'.$p['position_id'].'" '.($edit_data && $edit_data['position_id']==$p['position_id'] ? 'selected' : '').'>'.h($p['position_name']).' - '.h($p['position_level']).'</option>'; echo '</select><select name="supervisor_id"><option value="" '.($edit_data && !$edit_data['supervisor_id'] ? 'selected' : '').'>Tanpa atasan</option>'; foreach($emps as $e) echo '<option value="'.$e['employee_id'].'" '.($edit_data && $edit_data['supervisor_id']==$e['employee_id'] ? 'selected' : '').'>'.h($e['employee_name']).'</option>'; echo '</select><select name="role_id">'; foreach($roles as $r) echo '<option value="'.$r['role_id'].'" '.($edit_data && $edit_data['role_id']==$r['role_id'] ? 'selected' : '').'>'.role_label($r['role_name']).'</option>'; echo '</select><input name="username" placeholder="Username akun, kosongkan = dari email" value="'.($edit_data?h($edit_data['username']):'').'"><input name="password" placeholder="Password akun, kosongkan = jika edit, tidak ubah password"><button class="btn primary full">'.($edit_data ? 'Perbarui Karyawan' : 'Tambah Karyawan').'</button>'.($edit_data?'<a class="btn ghost full" href="?page=employees">Batal Edit</a>':'').'</form></div>';
    echo '<div class="panel"><h2>Daftar Karyawan</h2><div class="table-wrap"><table><tr><th>ID</th><th>NIK</th><th>Nama</th><th>Departemen</th><th>Jabatan/Role</th><th>Atasan</th><th>Email</th><th>Status</th><th>Aksi</th></tr>';
    foreach($emps as $e){ echo '<tr><td>'.$e['employee_id'].'</td><td>'.h($e['employee_nik']).'</td><td><b>'.h($e['employee_name']).'</b><br><small>'.h($e['username'] ?? 'belum ada akun').'</small></td><td>'.h($e['department_name']).'</td><td>'.h($e['position_name']).'<br><small>'.role_label($e['role_name'] ?? '-').'</small></td><td>'.h($e['supervisor_name'] ?? 'Tanpa atasan').'</td><td>'.h($e['employee_email']).'</td><td>'.badge($e['employee_status']).'</td><td><a class="btn small primary" href="?page=employees&edit_id='.$e['employee_id'].'">Edit</a> <form method="post" style="display:inline" onsubmit="return confirm(\'Nonaktifkan karyawan dan user?\')"><input type="hidden" name="action" value="delete_employee"><input type="hidden" name="employee_id" value="'.$e['employee_id'].'"><button class="btn small ghost">Nonaktifkan</button></form></td></tr>'; }
    echo '</table></div></div>'; layout_end(); exit;
}

if($page==='periods' && can_admin($u)){
    layout_start($u,'Periode Evaluasi');
    $periods=all('SELECT * FROM evaluation_periods ORDER BY period_id DESC');
    $edit_id=$_GET['edit_id'] ?? null;
    $edit_data=null;
    if($edit_id){
        $edit_data=one("SELECT * FROM evaluation_periods WHERE period_id=?", [(int)$edit_id]);
    }
    echo '<div class="panel"><h2>'.($edit_data ? 'Edit Periode Evaluasi' : 'Tambah Periode Evaluasi').'</h2><form class="form-grid" method="post"><input type="hidden" name="action" value="save_period"><input type="hidden" name="period_id" value="'.($edit_data?(int)$edit_data['period_id']:'').'"><input value="'.($edit_data?'ID Periode: '.(int)$edit_data['period_id']:'ID periode otomatis saat disimpan').'" readonly><input name="period_name" placeholder="Nama periode" required value="'.($edit_data?h($edit_data['period_name']):'').'"><input type="date" name="start_date" required value="'.($edit_data?$edit_data['start_date']:date('Y-m-d')).'"><input type="date" name="end_date" required value="'.($edit_data?$edit_data['end_date']:date('Y-m-d', strtotime('+3 months'))).'"><select name="period_status"><option value="draft" '.(!$edit_data || $edit_data['period_status']==='draft' ? 'selected' : '').'>draft</option><option value="active" '.($edit_data && $edit_data['period_status']==='active' ? 'selected' : '').'>active</option><option value="closed" '.($edit_data && $edit_data['period_status']==='closed' ? 'selected' : '').'>closed</option></select><button class="btn primary full">'.($edit_data ? 'Perbarui Periode' : 'Tambah Periode').'</button>'.($edit_data?'<a class="btn ghost full" href="?page=periods">Batal Edit</a>':'').'</form></div>';
    echo '<div class="panel"><h2>Daftar Periode</h2><div class="table-wrap"><table><tr><th>ID</th><th>Nama</th><th>Tanggal Mulai</th><th>Tanggal Selesai</th><th>Status</th><th>Aksi</th></tr>';
    foreach($periods as $p){ echo '<tr><td>'.$p['period_id'].'</td><td><b>'.h($p['period_name']).'</b></td><td>'.$p['start_date'].'</td><td>'.$p['end_date'].'</td><td>'.badge($p['period_status']).'</td><td><a class="btn small primary" href="?page=periods&edit_id='.$p['period_id'].'">Edit</a> <form method="post" style="display:inline" onsubmit="return confirm(\'Tutup periode ini? Riwayat assessment tetap aman.\')"><input type="hidden" name="action" value="delete_period"><input type="hidden" name="period_id" value="'.$p['period_id'].'"><button class="btn small ghost">Tutup</button></form></td></tr>'; }
    echo '</table></div></div>'; layout_end(); exit;
}

if($page==='questions' && can_admin($u)){
    layout_start($u,'Pertanyaan AKHLAK'); $values=all('SELECT * FROM akhlak_values');
    $questions=all('SELECT q.*, av.akhlak_name FROM questions q JOIN akhlak_values av ON av.akhlak_id=q.akhlak_id ORDER BY q.question_id');
    $edit_id=$_GET['edit_id'] ?? null;
    $edit_data=null;
    if($edit_id){
        $edit_data=one("SELECT * FROM questions WHERE question_id=?", [(int)$edit_id]);
    }
    echo '<div class="panel"><h2>'.($edit_data ? 'Edit Pertanyaan AKHLAK' : 'Tambah Pertanyaan AKHLAK').'</h2><form class="form-grid" method="post"><input type="hidden" name="action" value="save_question"><input type="hidden" name="question_id" value="'.($edit_data?(int)$edit_data['question_id']:'').'"><input value="'.($edit_data?'ID Pertanyaan: '.(int)$edit_data['question_id']:'ID pertanyaan otomatis saat disimpan').'" readonly><select name="akhlak_id" required>'; foreach($values as $v) echo '<option value="'.$v['akhlak_id'].'" '.($edit_data && $edit_data['akhlak_id']==$v['akhlak_id'] ? 'selected' : '').'>'.h($v['akhlak_name']).'</option>'; echo '</select><input name="question_category" placeholder="Kategori" value="'.($edit_data?h($edit_data['question_category']):'Perilaku').'"><select name="question_status"><option value="active" '.($edit_data && $edit_data['question_status']==='active' ? 'selected' : '').'>active</option><option value="inactive" '.($edit_data && $edit_data['question_status']==='inactive' ? 'selected' : '').'>inactive</option></select><textarea name="question_text" placeholder="Isi pertanyaan" required>'.($edit_data?h($edit_data['question_text']):'').'</textarea><button class="btn primary full">'.($edit_data ? 'Perbarui Pertanyaan' : 'Tambah Pertanyaan').'</button>'.($edit_data?'<a class="btn ghost full" href="?page=questions">Batal Edit</a>':'').'</form></div>';
    echo '<div class="panel"><h2>Bank Soal AKHLAK</h2><div class="table-wrap"><table><tr><th>ID</th><th>AKHLAK</th><th>Pertanyaan</th><th>Kategori</th><th>Status</th><th>Aksi</th></tr>';
    foreach($questions as $q){ echo '<tr><td>'.$q['question_id'].'</td><td><b>'.h($q['akhlak_name']).'</b></td><td>'.h($q['question_text']).'</td><td>'.$q['question_category'].'</td><td>'.badge($q['question_status']).'</td><td><a class="btn small primary" href="?page=questions&edit_id='.$q['question_id'].'">Edit</a> <form method="post" style="display:inline" onsubmit="return confirm(\'Nonaktifkan pertanyaan ini? Riwayat assessment tetap aman.\')"><input type="hidden" name="action" value="delete_question"><input type="hidden" name="question_id" value="'.$q['question_id'].'"><button class="btn small ghost">Nonaktifkan</button></form></td></tr>'; }
    echo '</table></div></div>'; layout_end(); exit;
}

if($page==='assignments' && role_allows($u,['admin_hr','atasan'])){
    layout_start($u,'Peer Assignment dan Validasi'); $period=active_period();
    $emps=all("SELECT employee_id, employee_name FROM employees WHERE employee_status='active' ORDER BY employee_name"); $periods=all('SELECT * FROM evaluation_periods ORDER BY period_id DESC');
    $edit_id=$_GET['edit_id'] ?? null;
    $edit_data=null;
    if($edit_id && can_admin($u)){
        $edit_data=one("SELECT * FROM peer_assignments WHERE peer_assignment_id=?", [(int)$edit_id]);
    }
    if(can_admin($u)){
        echo '<div class="panel"><h2>'.($edit_data ? 'Edit Peer Assignment' : 'Tambah Peer Assignment').'</h2><form class="form-grid" method="post"><input type="hidden" name="action" value="save_assignment"><input type="hidden" name="peer_assignment_id" value="'.($edit_data?(int)$edit_data['peer_assignment_id']:'').'"><input value="'.($edit_data?'ID Assignment: '.(int)$edit_data['peer_assignment_id']:'ID assignment otomatis saat disimpan').'" readonly><select name="employee_id" '.($edit_data ? 'disabled' : '').'required>'; foreach($emps as $e) echo '<option value="'.$e['employee_id'].'" '.($edit_data && $edit_data['employee_id']==$e['employee_id'] ? 'selected' : '').'>Dinilai: '.h($e['employee_name']).'</option>'; echo '</select><input type="hidden" name="employee_id_hidden" value="'.($edit_data?(int)$edit_data['employee_id']:'').'"><select name="peer_employee_id" required>'; foreach($emps as $e) echo '<option value="'.$e['employee_id'].'" '.($edit_data && $edit_data['peer_employee_id']==$e['employee_id'] ? 'selected' : '').'>Peer: '.h($e['employee_name']).'</option>'; echo '</select><select name="period_id" required>'; foreach($periods as $p) echo '<option value="'.$p['period_id'].'" '.($edit_data && $edit_data['period_id']==$p['period_id'] ? 'selected' : '').'>'.h($p['period_name']).'</option>'; echo '</select><select name="approval_status"><option value="pending" '.(!$edit_data || $edit_data['approval_status']==='pending' ? 'selected' : '').'>pending</option><option value="approved" '.($edit_data && $edit_data['approval_status']==='approved' ? 'selected' : '').'>approved</option><option value="rejected" '.($edit_data && $edit_data['approval_status']==='rejected' ? 'selected' : '').'>rejected</option><option value="cancelled" '.($edit_data && $edit_data['approval_status']==='cancelled' ? 'selected' : '').'>cancelled</option></select><input name="approved_by" placeholder="Approved by, opsional" value="'.($edit_data?h($edit_data['approved_by']):'').'"><button class="btn primary full">'.($edit_data ? 'Perbarui Assignment' : 'Tambah Assignment').'</button>'.($edit_data?'<a class="btn ghost full" href="?page=assignments">Batal Edit</a>':'').'</form></div>';
    }
    $where=''; $params=[]; if($u['role_name']==='atasan'){ $where='WHERE e.supervisor_id=?'; $params[]=$u['employee_id']; }
    $rows=all("SELECT pa.*, e.employee_name employee_name, pe.employee_name peer_name, ep.period_name FROM peer_assignments pa JOIN employees e ON e.employee_id=pa.employee_id JOIN employees pe ON pe.employee_id=pa.peer_employee_id JOIN evaluation_periods ep ON ep.period_id=pa.period_id $where ORDER BY pa.peer_assignment_id DESC", $params);
    echo '<div class="panel"><h2>Daftar Assignment</h2><div class="table-wrap"><table><tr><th>ID</th><th>Dinilai</th><th>Peer</th><th>Periode</th><th>Status</th><th>Approved By</th><th>Aksi</th></tr>';
    foreach($rows as $r){ echo '<tr><td>'.$r['peer_assignment_id'].'</td><td>'.h($r['employee_name']).'</td><td>'.h($r['peer_name']).'</td><td>'.h($r['period_name']).'</td><td>'.badge($r['approval_status']).'</td><td>'.h($r['approved_by'] ?? '-').'</td><td>';
        if($u['role_name']==='atasan' && in_array($r['approval_status'],['pending','rejected'])){
            echo '<form method="post" style="display:inline"><input type="hidden" name="action" value="validate_assignment"><input type="hidden" name="peer_assignment_id" value="'.$r['peer_assignment_id'].'"><select name="approval_status" style="width:100px"><option value="approved">Approve</option><option value="rejected">Reject</option></select><button class="btn small primary">Update</button></form>';
        } else {
            echo '<form method="post" style="display:inline"><input type="hidden" name="action" value="validate_assignment"><input type="hidden" name="peer_assignment_id" value="'.$r['peer_assignment_id'].'"><select name="approval_status" style="width:100px"><option value="approved" '.($r['approval_status']==='approved'?'selected':'').'>approved</option><option value="rejected" '.($r['approval_status']==='rejected'?'selected':'').'>rejected</option><option value="pending" '.($r['approval_status']==='pending'?'selected':'').'>pending</option></select><button class="btn small primary">Update</button></form>';
        }
        if(can_admin($u)){
            echo ' <a class="btn small primary" href="?page=assignments&edit_id='.$r['peer_assignment_id'].'">Edit</a> <form method="post" style="display:inline" onsubmit="return confirm(\'Hapus assignment ini?\')"><input type="hidden" name="action" value="delete_assignment"><input type="hidden" name="peer_assignment_id" value="'.$r['peer_assignment_id'].'"><button class="btn small ghost">Hapus</button></form>';
        }
        echo '</td></tr>';
    }
    echo '</table></div></div>'; layout_end(); exit;
}

if($page==='assessment'){
    layout_start($u,'Isi Assessment 360°'); $period=active_period(); $questions=all("SELECT q.*, av.akhlak_name FROM questions q JOIN akhlak_values av ON av.akhlak_id=q.akhlak_id WHERE q.question_status='active' ORDER BY q.question_id"); $targets=assessment_targets($u,$period);
    echo '<div class="panel"><h2>Target Penilaian Periode Aktif</h2><p class="muted">Target ditentukan dari self-assessment, peer assignment yang approved, supervisor_id, dan hubungan bawahan-atasan.</p><div class="cards">';
    foreach($targets as $i=>$t) echo '<a class="mini-card" href="?page=assessment&target='.$t['evaluatee_id'].'&type='.$t['type'].'"><span>'.h(type_label($t['type'])).'</span><b>'.h($t['name']).'</b><p>'.h($t['reason']).'</p></a>'; echo '</div></div>';
    $target=$_GET['target'] ?? ($targets[0]['evaluatee_id'] ?? null); $type=$_GET['type'] ?? ($targets[0]['type'] ?? 'self');
    if($target){
        echo '<div class="panel"><h2>Form '.h(type_label($type)).' untuk '.h(val('SELECT employee_name FROM employees WHERE employee_id=?',[$target])).'</h2><form method="post"><input type="hidden" name="action" value="submit_assessment"><input type="hidden" name="evaluatee_id" value="'.h($target).'"><input type="hidden" name="assessment_type" value="'.h($type).'">';
        foreach($questions as $qrow){ echo '<div class="question"><span>'.h($qrow['akhlak_name']).'</span><p><b>'.h($qrow['question_text']).'</b></p><div class="likert"><span>Skor</span><div>'; for($i=1;$i<=5;$i++) echo '<label><input type="radio" name="score['.$qrow['question_id'].']" value="'.$i.'" '.($i==4?'checked':'').'><em>'.$i.'</em></label>'; echo '</div></div><textarea name="comment['.$qrow['question_id'].']" placeholder="Komentar opsional"></textarea></div>'; }
        echo '<button class="btn primary full" type="submit">Submit Assessment ke Database</button></form></div>';
    }
    layout_end(); exit;
}

if($page==='reports' && can_report($u)){
    layout_start($u,'Report & IDP'); $rows=report_rows($u);
    echo '<div class="panel"><h2>Export Laporan</h2><p class="muted">Karyawan hanya melihat report dirinya sendiri. Atasan melihat bawahannya. Admin HR dan Manajemen melihat seluruh data.</p><div class="actions"><a class="btn primary" href="?download=pdf">Download PDF</a><a class="btn ghost" href="?download=excel">Download Excel</a><a class="btn ghost" href="?download=csv">Download CSV</a></div></div>';
    echo '<div class="panel"><h2>Hasil Evaluasi dan IDP</h2><div class="table-wrap"><table><tr><th>NIK</th><th>Nama</th><th>Departemen</th><th>Self</th><th>Peer</th><th>Bawahan</th><th>Atasan</th><th>Final</th><th>Gap Analysis / IDP</th></tr>';
    foreach($rows as $r) echo '<tr><td>'.h($r['employee_nik']).'</td><td><b>'.h($r['employee_name']).'</b></td><td>'.h($r['department_name']).'</td><td>'.score_fmt($r['self_score']).'</td><td>'.score_fmt($r['peer_score']).'</td><td>'.score_fmt($r['subordinate_score']).'</td><td>'.score_fmt($r['supervisor_score']).'</td><td><b>'.score_fmt($r['final_score']).'</b></td><td>'.h($r['gap_analysis']).'</td></tr>';
    echo '</table></div></div>'; layout_end(); exit;
}

if($page==='notifications'){
    layout_start($u,'Notifikasi');
    if(can_admin($u)){
        $users=all("SELECT u.user_id, e.employee_name, r.role_name FROM users u JOIN employees e ON e.employee_id=u.employee_id JOIN roles r ON r.role_id=u.role_id ORDER BY e.employee_name");
        echo '<div class="panel"><h2>Create Notice / Reminder</h2><form class="form-grid" method="post"><input type="hidden" name="action" value="send_notification"><select name="user_id"><option value="">Semua pengguna</option>'; foreach($users as $usr) echo '<option value="'.$usr['user_id'].'">'.h($usr['employee_name']).' - '.role_label($usr['role_name']).'</option>'; echo '</select><input name="title" placeholder="Judul notifikasi" required><select name="notification_type"><option>info</option><option>period</option><option>reminder</option><option>approval</option><option>report</option></select><textarea name="message" placeholder="Isi pesan notifikasi" required></textarea><button class="btn primary full">Kirim Notifikasi</button></form></div>';
    }
    echo '<div class="panel"><h2>Daftar Notifikasi</h2>'; render_notifications_list(visible_notifications($u)); echo '</div>'; layout_end(); exit;
}

if($page==='audit' && can_admin($u)){
    layout_start($u,'Audit Trail');
    $rows=all("SELECT al.*, e.employee_name, r.role_name FROM audit_logs al JOIN users u ON u.user_id=al.user_id JOIN employees e ON e.employee_id=u.employee_id JOIN roles r ON r.role_id=u.role_id ORDER BY al.activity_time DESC LIMIT 100");
    render_simple_table('Log Aktivitas', $rows); layout_end(); exit;
}

function render_simple_table($title,$rows){
    echo '<div class="panel"><h2>'.h($title).'</h2><div class="table-wrap"><table>';
    if(!$rows){ echo '<tr><td class="muted">Belum ada data.</td></tr></table></div></div>'; return; }
    echo '<tr>'; foreach(array_keys($rows[0]) as $k) echo '<th>'.h($k).'</th>'; echo '</tr>';
    foreach($rows as $r){ echo '<tr>'; foreach($r as $v) echo '<td>'.(is_string($v)&&strlen($v)<40?badge_or_text($v):h($v)).'</td>'; echo '</tr>'; }
    echo '</table></div></div>';
}
function badge_or_text($v){ $s=strtolower($v); if(in_array($s,['active','inactive','draft','pending','approved','rejected','closed','submitted'])) return badge($v); return h($v); }

layout_start($u,'Halaman tidak ditemukan'); echo '<div class="panel"><h2>404</h2><p>Halaman tidak tersedia atau akses role tidak sesuai.</p></div>'; layout_end();
