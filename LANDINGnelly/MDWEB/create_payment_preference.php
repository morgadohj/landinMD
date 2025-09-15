<?php
/**
 * Archivo para crear preferencias de pago con external_reference
 * Este archivo se usa para generar links de pago que incluyan el company_id
 * y package_type en el external_reference para poder rastrear los pagos.
 */

require 'config.php';
use MercadoPago\Client\Preference\PreferenceClient;

// Verificar que se reciban los parámetros necesarios
$company_id = $_POST['company_id'] ?? null;
$package_type = $_POST['package_type'] ?? null;
$plan_id = $_POST['plan_id'] ?? null;

if (!$company_id || !$package_type || !$plan_id) {
    http_response_code(400);
    echo json_encode(['error' => 'Faltan parámetros requeridos']);
    exit;
}

try {
    // Obtener información del plan desde la base de datos
    $stmt = $pdo->prepare("SELECT * FROM subscription_plans WHERE id = ? AND status = 1");
    $stmt->execute([$plan_id]);
    $plan = $stmt->fetch();
    
    if (!$plan) {
        http_response_code(404);
        echo json_encode(['error' => 'Plan no encontrado']);
        exit;
    }
    
    // Crear el external_reference con formato: company_id|package_type
    $external_reference = $company_id . '|' . $package_type;
    
    // Crear la preferencia de pago
    $client = new PreferenceClient();
    
    $request = [
        "items" => [
            [
                "title" => $plan['name'],
                "quantity" => 1,
                "unit_price" => $plan['price_offer'] ?: $plan['price_base'],
                "currency_id" => "MXN"
            ]
        ],
        "external_reference" => $external_reference,
        "back_urls" => [
            "success" => "https://8eb2c463aced.ngrok-free.app/landing/landinMD/LANDINGnelly/MDWEB/mercadoPagoEvents/success.php",
            "pending" => "https://8eb2c463aced.ngrok-free.app/landing/landinMD/LANDINGnelly/MDWEB/mercadoPagoEvents/pending.php",
            "failure" => "https://8eb2c463aced.ngrok-free.app/landing/landinMD/LANDINGnelly/MDWEB/mercadoPagoEvents/failure.php"
        ],
        "notification_url" => "https://8eb2c463aced.ngrok-free.app/landing/landinMD/LANDINGnelly/MDWEB/mercadoPagoEvents/webhook.php",
        "auto_return" => "approved",
        "payment_methods" => [
            "excluded_payment_methods" => [],
            "excluded_payment_types" => [],
            "installments" => 12
        ]
    ];
    
    $preference = $client->create($request);
    
    // Retornar la URL de pago
    echo json_encode([
        'success' => true,
        'payment_url' => $preference->init_point,
        'preference_id' => $preference->id
    ]);
    
} catch (Exception $e) {
    error_log("Error creating payment preference: " . $e->getMessage());
    http_response_code(500);
    echo json_encode(['error' => 'Error interno del servidor']);
}
?>
