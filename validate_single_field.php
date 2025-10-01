<?php
// Validación de campos individuales para validación en tiempo real
error_reporting(0);
ini_set('display_errors', 0);

require_once 'config.php';

header('Content-Type: application/json');

// Obtener el campo y valor a validar
$fieldName = $_POST['field_name'] ?? null;
$fieldValue = $_POST['field_value'] ?? null;

if (!$fieldName || !$fieldValue) {
    http_response_code(400);
    echo json_encode(['error' => 'Campo o valor faltante']);
    exit;
}

// Sanitizar el valor según el tipo de campo
$sanitizedValue = null;
switch ($fieldName) {
    case 'email':
        $sanitizedValue = filter_var($fieldValue, FILTER_SANITIZE_EMAIL);
        break;
    case 'phone':
        $sanitizedValue = filter_var($fieldValue, FILTER_SANITIZE_STRING);
        break;
    case 'company_name':
        $sanitizedValue = filter_var($fieldValue, FILTER_SANITIZE_STRING);
        break;
    case 'rfc':
        $sanitizedValue = strtoupper(trim(filter_var($fieldValue, FILTER_SANITIZE_STRING)));
        break;
    default:
        http_response_code(400);
        echo json_encode(['error' => 'Campo no válido']);
        exit;
}

// Validaciones básicas de formato
if ($fieldName === 'email' && !filter_var($sanitizedValue, FILTER_VALIDATE_EMAIL)) {
    http_response_code(400);
    echo json_encode(['error' => 'Formato de email inválido']);
    exit;
}

if ($fieldName === 'phone' && !preg_match('/^[\+]?[0-9\s\-\(\)]{10,15}$/', $sanitizedValue)) {
    http_response_code(400);
    echo json_encode(['error' => 'Formato de teléfono inválido']);
    exit;
}

if ($fieldName === 'rfc' && !preg_match('/^[A-ZÑ&]{3,4}[0-9]{6}[A-Z0-9]{3}$/', $sanitizedValue)) {
    http_response_code(400);
    echo json_encode(['error' => 'Formato de RFC inválido']);
    exit;
}

$response = [
    'email_exists' => false,
    'phone_exists' => false,
    'alias_exists' => false,
    'company_name_exists' => false,
    'rfc_exists' => false,
    'error' => null
];

try {
    // Verificar según el tipo de campo
    switch ($fieldName) {
        case 'email':
            $stmt = $pdo->prepare("SELECT 1 FROM users WHERE email = ?");
            $stmt->execute([$sanitizedValue]);
            $response['email_exists'] = $stmt->rowCount() > 0;
            break;
            
        case 'phone':
            $stmt = $pdo->prepare("SELECT 1 FROM users WHERE mobile = ?");
            $stmt->execute([$sanitizedValue]);
            $response['phone_exists'] = $stmt->rowCount() > 0;
            break;
            
        case 'company_name':
            $stmt = $pdo->prepare("SELECT 1 FROM company_customer WHERE company_name = ?");
            $stmt->execute([$sanitizedValue]);
            $response['company_name_exists'] = $stmt->rowCount() > 0;
            break;
            
        case 'rfc':
            $stmt = $pdo->prepare("SELECT 1 FROM company_customer WHERE rfc = ?");
            $stmt->execute([$sanitizedValue]);
            $response['rfc_exists'] = $stmt->rowCount() > 0;
            break;
    }

} catch (PDOException $e) {
    error_log("Error en validate_single_field.php: " . $e->getMessage());
    $response['error'] = 'Error interno del servidor. Por favor, intente más tarde.';
    http_response_code(500);
}

echo json_encode($response);
?>
