<?php
// Configuración de producción - deshabilitar logs de depuración
error_reporting(0);
ini_set('display_errors', 0);

require_once 'config.php';
require_once 'csrf_protection.php';

header('Content-Type: application/json');

// Verificar token CSRF
if (!isset($_POST['csrf_token']) || !verifyCSRFToken($_POST['csrf_token'])) {
    http_response_code(403);
    echo json_encode(['error' => 'Token de seguridad inválido']);
    exit;
}

// Sanitizar y validar entradas
$email = filter_input(INPUT_POST, 'email', FILTER_SANITIZE_EMAIL);
$phone = filter_input(INPUT_POST, 'phone', FILTER_SANITIZE_STRING);
$company_name = filter_input(INPUT_POST, 'company_name', FILTER_SANITIZE_STRING);
$rfc = strtoupper(trim(filter_input(INPUT_POST, 'rfc', FILTER_SANITIZE_STRING)));

// Log para debug
error_log("Validación - Email: " . ($email ?: 'NULL') . ", Phone: " . ($phone ?: 'NULL') . ", Company: " . ($company_name ?: 'NULL') . ", RFC: " . ($rfc ?: 'NULL'));

// Validaciones adicionales de formato (solo si los campos no están vacíos y tienen formato mínimo)
if ($email && strlen($email) > 3 && !filter_var($email, FILTER_VALIDATE_EMAIL)) {
    error_log("Error: Email inválido - " . $email);
    http_response_code(400);
    echo json_encode(['error' => 'Formato de email inválido']);
    exit;
}

if ($phone && strlen($phone) >= 10 && !preg_match('/^[\+]?[0-9\s\-\(\)]{10,15}$/', $phone)) {
    error_log("Error: Teléfono inválido - " . $phone);
    http_response_code(400);
    echo json_encode(['error' => 'Formato de teléfono inválido']);
    exit;
}

if ($rfc && strlen($rfc) >= 10 && !preg_match('/^[A-ZÑ&]{3,4}[0-9]{6}[A-Z0-9]{3}$/', $rfc)) {
    error_log("Error: RFC inválido - " . $rfc);
    http_response_code(400);
    echo json_encode(['error' => 'Formato de RFC inválido']);
    exit;
}

// Validar que los campos requeridos no estén vacíos
if (empty($email) || empty($phone) || empty($company_name) || empty($rfc)) {
    http_response_code(400);
    echo json_encode(['error' => 'Todos los campos son requeridos']);
    exit;
}

// Validar formato de email
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    http_response_code(400);
    echo json_encode(['error' => 'Formato de email inválido']);
    exit;
}

// Generar alias automáticamente a partir del nombre de la empresa
$alias = strtolower(preg_replace('/[^a-zA-Z0-9]/', '', $company_name));
$database_handle = '_pos_' . $alias;

$response = [
    'email_exists' => false,
    'phone_exists' => false,
    'alias_exists' => false,
    'company_name_exists' => false,
    'rfc_exists' => false,
    'error' => null
];

try {
    // Usar la conexión PDO unificada de config.php
    // $pdo ya está disponible desde require_once 'config.php'

    // Verificar email
    $stmt = $pdo->prepare("SELECT 1 FROM users WHERE email = ?");
    $stmt->execute([$email]);
    $response['email_exists'] = $stmt->rowCount() > 0;
    $stmt->closeCursor();

    // Verificar teléfono
    $stmt = $pdo->prepare("SELECT 1 FROM users WHERE mobile = ?");
    $stmt->execute([$phone]);
    $response['phone_exists'] = $stmt->rowCount() > 0;
    $stmt->closeCursor();

    // Verificar alias (database_handle)
    $stmt = $pdo->prepare("SELECT 1 FROM company_customer WHERE database_handle = ?");
    $stmt->execute([$database_handle]);
    $response['alias_exists'] = $stmt->rowCount() > 0;
    $stmt->closeCursor();

    // Verificar nombre de la empresa
    $stmt = $pdo->prepare("SELECT 1 FROM company_customer WHERE company_name = ?");
    $stmt->execute([$company_name]);
    $response['company_name_exists'] = $stmt->rowCount() > 0;
    $stmt->closeCursor();

    // Verificar RFC
    $stmt = $pdo->prepare("SELECT 1 FROM company_customer WHERE rfc = ?");
    $stmt->execute([$rfc]);
    $response['rfc_exists'] = $stmt->rowCount() > 0;
    $stmt->closeCursor();

} catch (PDOException $e) {
    // Log del error para administradores (no mostrar al usuario)
    error_log("Error en validate_registration.php: " . $e->getMessage());
    $response['error'] = 'Error interno del servidor. Por favor, intente más tarde.';
    http_response_code(500);
}

echo json_encode($response);
