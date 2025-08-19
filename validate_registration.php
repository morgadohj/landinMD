<?php
require_once 'config.php';

header('Content-Type: application/json');

// Habilitar reporte de errores para depuración
error_reporting(E_ALL);
ini_set('display_errors', 1);

$email = $_POST['email'] ?? '';
$phone = $_POST['phone'] ?? '';
$company_name = $_POST['company_name'] ?? '';
$rfc = $_POST['rfc'] ?? '';

// Generar alias automáticamente a partir del nombre de la empresa
$alias = strtolower(str_replace(' ', '', $company_name));
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
    // Usar PDO para consistencia con el resto del proyecto
    $pdo = new PDO("mysql:host=" . DB_HOST . ";dbname=" . DB_NAME, DB_USER, DB_PASS);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

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
    $response['error'] = 'Error de conexión a la base de datos: ' . $e->getMessage();
    error_log("Error en validate_registration.php: " . $e->getMessage());
}

echo json_encode($response);
