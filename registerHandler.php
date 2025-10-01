<?php
// Configuración de producción - deshabilitar logs de depuración
error_reporting(0);
ini_set('display_errors', 0);

require 'config.php';

// Configurar zona horaria para México (ajusta según tu ubicación)
date_default_timezone_set('America/Mexico_City');

// Recibe y sanitiza los datos del formulario
$company_name = trim($_POST['company_name'] ?? '');
$username = trim($_POST['username'] ?? '');
$email = trim($_POST['email'] ?? '');
$password = $_POST['password'] ?? ''; // No sanitizar contraseñas antes del hash
$phone = trim($_POST['phone'] ?? '');
$regimen_fiscal = $_POST['regimen_fiscal'] ?? '';
$rfc = strtoupper(trim($_POST['rfc'] ?? ''));
$address = $_POST['address'] ?? '';
$package_type = $_POST['package_type'] ?? '';

// Validaciones adicionales de formato
if ($email && !filter_var($email, FILTER_VALIDATE_EMAIL)) {
    http_response_code(400);
    echo "Error: Formato de email inválido";
    exit;
}

if ($phone && !preg_match('/^[\+]?[0-9\s\-\(\)]{10,15}$/', $phone)) {
    http_response_code(400);
    echo "Error: Formato de teléfono inválido";
    exit;
}

if ($rfc && !preg_match('/^[A-ZÑ&]{3,4}[0-9]{6}[A-Z0-9]{3}$/', $rfc)) {
    http_response_code(400);
    echo "Error: Formato de RFC inválido";
    exit;
}

if ($password && strlen($password) < 8) {
    http_response_code(400);
    echo "Error: La contraseña debe tener al menos 8 caracteres";
    exit;
}

// Validar que los campos requeridos no estén vacíos
if (empty($company_name) || empty($username) || empty($email) || empty($password) || empty($phone) || empty($regimen_fiscal) || empty($rfc) || empty($address) || empty($package_type)) {
    http_response_code(400);
    echo "Error: Todos los campos son requeridos";
    exit;
}

// Validar formato de email
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    http_response_code(400);
    echo "Error: Formato de email inválido";
    exit;
}

// Generar alias automáticamente a partir del nombre de la empresa
$alias = strtolower(preg_replace('/[^a-zA-Z0-9]/', '', $company_name));
$database_handle = '_pos_' . $alias;

try {
    // Establecer fechas de creación y fin de prueba con zona horaria correcta
    $created_at = date('Y-m-d H:i:s');
    $trial_ends_at = date('Y-m-d H:i:s', strtotime('+15 days'));

    // Insertar en company_customer con trial activo
    // Verificar si es una compra
    $isPurchase = isset($_POST['is_purchase']) && $_POST['is_purchase'] === 'true';
    $status = 'active'; // Siempre activo para el trial, el webhook actualizará el payment_status
    
    $stmt1 = $pdo->prepare("
        INSERT INTO company_customer (
            company_name, database_handle, termns_conditions, user, pass,
            status, payment_status, package_type, id_regimen_fiscal, rfc, address, created_at, trial_ends_at
        ) VALUES (
            :company_name, :database_handle, 0, :user, :pass,
            :status, 'pending', :package_type, :regimen_fiscal, :rfc, :address, :created_at, :trial_ends_at
        )
    ");
    
    $stmt1->execute([
        ':company_name' => $company_name,
        ':database_handle' => $database_handle,
        ':user' => $username,
        ':pass' => password_hash($password, PASSWORD_BCRYPT),
        ':package_type' => $package_type,
        ':regimen_fiscal' => $regimen_fiscal,
        ':rfc' => $rfc,
        ':address' => $address,
        ':created_at' => $created_at,
        ':trial_ends_at' => $trial_ends_at,
        ':status' => $status
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
    $stmt2->execute([$company_id, $username, $email, $phone, password_hash($password, PASSWORD_BCRYPT)]);
    
    
    // Si es una compra, generar el external_reference para el pago
    if ($isPurchase) {
        $external_reference = $company_id . '|' . $package_type;
        echo json_encode([
            'success' => true,
            'company_id' => $company_id,
            'external_reference' => $external_reference,
            'package_type' => $package_type
        ]);
    } else {
        // Para registros de prueba gratuita
        echo "ok";
    }
    exit;

} catch (PDOException $e) {
    // Log del error para administradores (no mostrar al usuario)
    error_log("Error en registro: " . $e->getMessage());
    http_response_code(500);
    echo "Error interno del servidor. Por favor, intente más tarde.";
}
?>
