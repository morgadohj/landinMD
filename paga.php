<?php
require 'config.php';
require 'vendor/autoload.php';

// SDK de Mercado Pago
use MercadoPago\MercadoPagoConfig;
use MercadoPago\Exceptions\MPApiException;

// Agrega credenciales
// la de prueba :
MercadoPagoConfig::setAccessToken("APP_USR-5071081104051116-070702-58c62396305b87b6412a2ef5c836655a-2537830851");
// la real :
//MercadoPagoConfig::setAccessToken("APP_USR-4029351939566313-070700-316297e8b3d5fa06fca67b3539599229-2537727051"); 
// Set environment (optional, but recommended)
MercadoPagoConfig::setRuntimeEnviroment(MercadoPagoConfig::LOCAL);

// Recibe los datos necesarios
$company_id = $_POST['company_id'] ?? $_GET['company_id'] ?? null;
$package_type = $_POST['package_type'] ?? $_GET['package_type'] ?? 'basic';
$email = $_POST['email'] ?? $_GET['email'] ?? '';

if (!$company_id) {
    echo "Error: No se proporcionó company_id";
    exit;
}

// Definir precios según el tipo de paquete (incluyendo IVA y comisión de Mercado Pago)
$prices = [
    'basic' => 600.00,  // 600.00, puse $1 para pruebas
    'premium' => 1200.00, // 1200.00, puse $2 para pruebas
    'basicAnual' => 6480.00,   // 6480.00, puse $3 para pruebas
    'premiumAnual' => 12960.00 // 12960.00, puse $4 para pruebas
];

$unit_price = $prices[$package_type] ?? $prices['basic'];

// Definir nombres para Mercado Pago
$package_names = [
    'basic' => 'Básico Mensual',
    'premium' => 'Premium Mensual',
    'basicAnual' => 'Básico Anual',
    'premiumAnual' => 'Premium Anual'
];

$package_name = $package_names[$package_type] ?? 'Básico Mensual';

// Crear preferencia de pago usando PreferenceClient
$client = new MercadoPago\Client\Preference\PreferenceClient();

$request = [
    "items" => [
        [
            "title" => "Suscripción MDsystems - " . $package_name,
            "quantity" => 1,
            "unit_price" => $unit_price
        ]
    ],
    "back_urls" => [
        "failure" => "https://7c18ca02aa4d.ngrok-free.app/landing/landinMD/mercadoPagoEvents/failure.php",
        "pending" => "https://7c18ca02aa4d.ngrok-free.app/landing/landinMD/mercadoPagoEvents/pending.php",
        "success" => "https://7c18ca02aa4d.ngrok-free.app/landing/landinMD/mercadoPagoEvents/success.php",
    ],
    "auto_return" => "approved",
    "payer" => [
        "email" => $email  
    ],
    "external_reference" => $company_id . "|" . $package_type
];

try {
    $preference = $client->create($request);

    if (!isset($preference->init_point)) {
        throw new Exception("No se generó el init_point.");
    }

    // Redirigir a Mercado Pago
    header("Location: " . $preference->init_point);
    exit;

} catch (MercadoPago\Exceptions\MPApiException $e) {
    echo "MercadoPago API Error:<br>";
    echo "Status code: " . $e->getApiResponse()->getStatusCode() . "<br>";
    echo "Content: <pre>" . print_r($e->getApiResponse()->getContent(), true) . "</pre>";
    exit;
} catch (Exception $e) {
    echo "General Error: " . $e->getMessage();
    exit;
}
?> 