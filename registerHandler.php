<?php
// Habilitar reporte de errores para depuración
error_reporting(E_ALL);
ini_set('display_errors', 1);

require 'config.php';

// Configurar zona horaria para México (ajusta según tu ubicación)
date_default_timezone_set('America/Mexico_City');

// Log de datos recibidos
error_log("Datos POST recibidos: " . print_r($_POST, true));

// Recibe los datos del formulario
$company_name = $_POST['company_name'];
// Generar alias automáticamente a partir del nombre de la empresa
$alias = strtolower(str_replace(' ', '', $company_name));
$username = $_POST['username'];
$email = $_POST['email'];
$password = password_hash($_POST['password'], PASSWORD_BCRYPT);
$phone = $_POST['phone'];
$regimen_fiscal = $_POST['regimen_fiscal'];
$rfc = strtoupper($_POST['rfc']);
$address = $_POST['address'];
$package_type = $_POST['package_type'];

$database_handle = '_pos_' . $alias;

try {
    error_log("Iniciando proceso de registro...");
    
    // Establecer fechas de creación y fin de prueba con zona horaria correcta
    $created_at = date('Y-m-d H:i:s');
    $trial_ends_at = date('Y-m-d H:i:s', strtotime('+15 days'));
    
    error_log("Fechas generadas - created_at: $created_at, trial_ends_at: $trial_ends_at");

    // Insertar en company_customer con trial activo
    $stmt1 = $pdo->prepare("
        INSERT INTO company_customer (
            company_name, database_handle, termns_conditions, user, pass,
            status, payment_status, package_type, id_regimen_fiscal, rfc, address, created_at, trial_ends_at
        ) VALUES (
            :company_name, :database_handle, 0, :user, :pass,
            'pending', 'pending', :package_type, :regimen_fiscal, :rfc, :address, :created_at, :trial_ends_at
        )
    ");
    
    error_log("Preparando inserción en company_customer...");
    
    $stmt1->execute([
        ':company_name' => $company_name,
        ':database_handle' => $database_handle,
        ':user' => $username,
        ':pass' => $password,
        ':package_type' => $package_type,
        ':regimen_fiscal' => $regimen_fiscal,
        ':rfc' => $rfc,
        ':address' => $address,
        ':created_at' => $created_at,
        ':trial_ends_at' => $trial_ends_at
    ]);

    $company_id = $pdo->lastInsertId();
    error_log("Company ID generado: $company_id");

    // Insertar en users (usuario admin principal)
    error_log("Preparando inserción en users...");
    
    $stmt2 = $pdo->prepare("
        INSERT INTO users (
            group_id, company_id, username, email, mobile, dob, sex, password, created_at, updated_at
        ) VALUES (
            1, ?, ?, ?, ?, '1990-01-01', 'M', ?, NOW(), NOW()
        )
    ");
    $stmt2->execute([$company_id, $username, $email, $phone, $password]);
    
    error_log("Usuario admin insertado exitosamente");

    // No redirigir, solo responder
    error_log("Registro completado exitosamente - enviando respuesta 'ok'");
    echo "ok";
    exit;

} catch (PDOException $e) {
    echo "Error al registrar: " . $e->getMessage();
}
?>
