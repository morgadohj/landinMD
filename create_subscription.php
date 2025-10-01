<?php
// Crear suscripciones automáticamente usando la API de MercadoPago
require __DIR__ . '/config.php';

use MercadoPago\Client\PreApproval\PreApprovalClient;
use MercadoPago\Exceptions\MPApiException;

header('Content-Type: application/json');
header('X-Content-Type-Options: nosniff');
header('X-Frame-Options: DENY');
header('X-XSS-Protection: 1; mode=block');

// Validar y sanitizar datos de entrada
$company_id = filter_input(INPUT_POST, 'company_id', FILTER_VALIDATE_INT);
$package_type = filter_input(INPUT_POST, 'package_type', FILTER_SANITIZE_STRING);
$plan_id = filter_input(INPUT_POST, 'plan_id', FILTER_VALIDATE_INT);

// Validar que los datos sean válidos
if (!$company_id || !$package_type || !$plan_id) {
    log_debug('Datos de entrada inválidos: company_id=' . ($company_id ?? 'NULL') . ', package_type=' . ($package_type ?? 'NULL') . ', plan_id=' . ($plan_id ?? 'NULL'));
    http_response_code(400);
    echo json_encode(['success' => false, 'error' => 'Datos de entrada inválidos']);
    exit;
}

// Logging
$logDir = __DIR__ . '/mercadoPagoEvents';
$logFile = $logDir . '/log_subscription.txt';
if (!is_dir($logDir)) {
    @mkdir($logDir, 0775, true);
}

function log_debug($message) {
    global $logFile;
    $line = '[' . date('Y-m-d H:i:s') . '] ' . $message . "\n";
    @file_put_contents($logFile, $line, FILE_APPEND);
}

// Validación ya realizada arriba

try {
    log_debug('Iniciando creación de suscripción para: company_id=' . $company_id . ', package_type=' . $package_type . ', plan_id=' . $plan_id);
    
    // 1) Obtener el plan activo
    $stmtPlan = $pdo->prepare('SELECT url, name, price_offer, price_base FROM subscription_plans WHERE id = ? AND status = 1');
    $stmtPlan->execute([$plan_id]);
    $plan = $stmtPlan->fetch();
    
    log_debug('Plan encontrado: ' . ($plan ? 'Sí' : 'No') . ' - ' . json_encode($plan));

    if (!$plan) {
        log_debug('Plan no encontrado o inactivo. plan_id=' . $plan_id);
        http_response_code(404);
        echo json_encode(['success' => false, 'error' => 'Plan no encontrado o inactivo']);
        exit;
    }

    // 2) Extraer preapproval_plan_id desde la URL guardada
    $preapproval_plan_id = null;
    $urlParts = parse_url($plan['url']);
    if (!empty($urlParts['query'])) {
        parse_str($urlParts['query'], $queryParts);
        if (!empty($queryParts['preapproval_plan_id'])) {
            $preapproval_plan_id = $queryParts['preapproval_plan_id'];
        }
    }

    if (!$preapproval_plan_id) {
        log_debug('No se pudo extraer preapproval_plan_id desde URL: ' . ($plan['url'] ?? 'NULL'));
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => 'No se pudo obtener preapproval_plan_id del plan']);
        exit;
    }

    // 3) Obtener email del payer (admin de la empresa)
    $stmtUser = $pdo->prepare('SELECT email FROM users WHERE company_id = ? ORDER BY id ASC LIMIT 1');
    $stmtUser->execute([$company_id]);
    $user = $stmtUser->fetch();
    $payer_email = $user['email'] ?? null;

    if (!$payer_email) {
        log_debug('Email de usuario no encontrado para company_id=' . $company_id);
        http_response_code(400);
        echo json_encode(['success' => false, 'error' => 'No se encontró email del usuario para la empresa']);
        exit;
    }

    // 4) Crear la suscripción (PreApproval) usando la API de MercadoPago
    $preApprovalClient = new PreApprovalClient();
    
    // Determinar el precio a usar (precio oferta si existe, sino precio base)
    $amount = $plan['price_offer'] ?: $plan['price_base'];
    
    // Determinar la frecuencia según el tipo de paquete
    $frequency = (strpos($package_type, 'Anual') !== false || strpos($package_type, 'anual') !== false) ? 12 : 1;
    $frequency_type = 'months';
    
    // Crear la suscripción
    $preApprovalData = [
        'reason' => $plan['name'],
        'external_reference' => $company_id . '|' . $package_type,
        'payer_email' => $payer_email,
        'auto_recurring' => [
            'frequency' => $frequency,
            'frequency_type' => $frequency_type,
            'transaction_amount' => (float)$amount,
            'currency_id' => 'MXN',
            'start_date' => date('Y-m-d\TH:i:s.000\Z', strtotime('+1 minute')),
            'end_date' => date('Y-m-d\TH:i:s.000\Z', strtotime('+1 year'))
        ],
        'back_url' => BASE_URL . '/mercadoPagoEvents/success.php',
        'status' => 'pending'
    ];

    log_debug('Creando suscripción con datos: ' . json_encode($preApprovalData));
    
    $preApproval = $preApprovalClient->create($preApprovalData);
    
    log_debug('Suscripción creada exitosamente: ID=' . $preApproval->id . ', Status=' . $preApproval->status);
    
    // 5) Actualizar la base de datos con la información de la suscripción
    $stmt = $pdo->prepare("
        UPDATE company_customer 
        SET payment_status = ?, 
            payment_reference = ?, 
            payment_method = 'subscription',
            subscription_id = ?
        WHERE id = ?
    ");
    $stmt->execute([
        $preApproval->status,
        $preApproval->id,
        $preApproval->id,
        $company_id
    ]);
    
    log_debug('Base de datos actualizada para company_id=' . $company_id . ' con subscription_id=' . $preApproval->id);
    
    // 6) Obtener la URL de autorización de la suscripción
    $init_point = $preApproval->init_point ?? null;
    
    if (!$init_point) {
        log_debug('No se obtuvo init_point de la suscripción creada');
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => 'No se pudo obtener la URL de autorización de la suscripción']);
        exit;
    }
    
    log_debug('Suscripción creada exitosamente. URL de autorización: ' . $init_point);
    
    echo json_encode([
        'success' => true,
        'subscription_id' => $preApproval->id,
        'payment_url' => $init_point,
        'status' => $preApproval->status
    ]);
    
} catch (MPApiException $e) {
    // Error de la API de Mercado Pago
    $apiResponse = method_exists($e, 'getApiResponse') ? $e->getApiResponse() : null;
    $statusCode = null;
    $content = null;
    if ($apiResponse) {
        if (method_exists($apiResponse, 'getStatusCode')) {
            $statusCode = $apiResponse->getStatusCode();
        }
        if (method_exists($apiResponse, 'getContent')) {
            $content = $apiResponse->getContent();
        }
    }
    log_debug('MPApiException: statusCode=' . ($statusCode ?? 'NULL') . ' content=' . json_encode($content) . ' message=' . $e->getMessage());
    http_response_code(500);
    $errorMessage = $e->getMessage();
    if (is_array($content) && isset($content['message'])) {
        $errorMessage = $content['message'];
    }
    echo json_encode(['success' => false, 'error' => $errorMessage, 'status' => $statusCode, 'details' => $content]);
    exit;
} catch (Exception $e) {
    log_debug('Exception: ' . $e->getMessage());
    http_response_code(500);
    echo json_encode(['success' => false, 'error' => $e->getMessage()]);
    exit;
}
