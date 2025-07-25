<?php
require_once 'config.php'; // Ajusta la ruta según tu estructura

header('Content-Type: application/json');

$email = $_POST['email'] ?? '';
$phone = $_POST['phone'] ?? '';
$alias = $_POST['alias'] ?? '';
$company_name = $_POST['company_name'] ?? '';
$database_handle = '_pos_' . $alias;

$response = [
    'email_exists' => false,
    'phone_exists' => false,
    'alias_exists' => false,
    'company_name_exists' => false
];

// Conexión a la base de datos (ajusta según tu config)
$conn = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);
if ($conn->connect_error) {
    echo json_encode(['error' => 'DB connection failed']);
    exit;
}

// Verificar email
$stmt = $conn->prepare("SELECT 1 FROM users WHERE email = ?");
$stmt->bind_param("s", $email);
$stmt->execute();
$stmt->store_result();
$response['email_exists'] = $stmt->num_rows > 0;
$stmt->close();

// Verificar teléfono
$stmt = $conn->prepare("SELECT 1 FROM users WHERE mobile = ?");
$stmt->bind_param("s", $phone);
$stmt->execute();
$stmt->store_result();
$response['phone_exists'] = $stmt->num_rows > 0;
$stmt->close();

// Verificar alias
$stmt = $conn->prepare("SELECT 1 FROM company_customer WHERE database_handle = ?");
$stmt->bind_param("s", $database_handle);
$stmt->execute();
$stmt->store_result();
$response['alias_exists'] = $stmt->num_rows > 0;
$stmt->close();

//verificar nombre de la empresa
$stmt = $conn->prepare("SELECT 1 FROM company_customer WHERE company_name = ?");
$stmt->bind_param("s", $company_name);
$stmt->execute();
$stmt->store_result();
$response['company_name_exists'] = $stmt->num_rows > 0;
$stmt->close();

$conn->close();

echo json_encode($response);
