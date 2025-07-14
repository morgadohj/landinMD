<?php
require 'config.php';

// Configurar zona horaria para México (ajusta según tu ubicación)
date_default_timezone_set('America/Mexico_City');

// Recibe los datos del formulario
$company_name = $_POST['company_name'];
$alias = strtolower(str_replace(' ', '', $_POST['alias']));
$username = $_POST['username'];
$email = $_POST['email'];
$password = password_hash($_POST['password'], PASSWORD_BCRYPT);
$phone = $_POST['phone'];
$package_type = $_POST['package_type'];

$database_handle = '_pos_' . $alias;

try {
    // Establecer fechas de creación y fin de prueba con zona horaria correcta
    $created_at = date('Y-m-d H:i:s');
    $trial_ends_at = date('Y-m-d H:i:s', strtotime('+15 days'));

    // Insertar en company_customer con trial activo
    $stmt1 = $pdo->prepare("
        INSERT INTO company_customer (
            company_name, database_handle, termns_conditions, user, pass,
            status, payment_status, package_type, created_at, trial_ends_at
        ) VALUES (
            :company_name, :database_handle, 0, :user, :pass,
            'pending', 'pending', :package_type, :created_at, :trial_ends_at
        )
    ");
    
    $stmt1->execute([
        ':company_name' => $company_name,
        ':database_handle' => $database_handle,
        ':user' => $username,
        ':pass' => $password,
        ':package_type' => $package_type,
        ':created_at' => $created_at,
        ':trial_ends_at' => $trial_ends_at
    ]);

    $company_id = $pdo->lastInsertId();

    // Insertar en users (usuario admin principal)
    $stmt2 = $pdo->prepare("
        INSERT INTO users (
            group_id, company_id, username, email, mobile, dob, sex, password, created_at, updated_at
        ) VALUES (
            1, ?, ?, ?, ?, '1990-01-01', 'M', ?, NOW(), NOW()
        )
    ");
    $stmt2->execute([$company_id, $username, $email, $phone, $password]);

    // No redirigir, solo responder
    echo "ok";
    exit;

} catch (PDOException $e) {
    echo "Error al registrar: " . $e->getMessage();
}
?>
