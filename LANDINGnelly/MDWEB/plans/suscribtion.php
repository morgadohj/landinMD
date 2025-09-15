<?php
// Endpoint para crear una suscripción (PreApproval) usando un plan existente
// Requiere: company_id, package_type, plan_id

require __DIR__ . '/../config.php';

use MercadoPago\Client\PreApproval\PreApprovalClient;
use MercadoPago\Exceptions\MPApiException;

header('Content-Type: application/json');

$company_id = $_POST['company_id'] ?? null;
$package_type = $_POST['package_type'] ?? null;
$plan_id = $_POST['plan_id'] ?? null;

// Utilidad de logging con fallback a error_log
$logDir = __DIR__ . '/../mercadoPagoEvents';
$logFile = $logDir . '/log_subscription.txt';
if (!is_dir($logDir)) {
    @mkdir($logDir, 0775, true);
}
function log_debug($message) {
    global $logFile;
    $line = '[' . date('Y-m-d H:i:s') . '] ' . $message . "\n";
    if (@file_put_contents($logFile, $line, FILE_APPEND) === false) {
        error_log('log_subscription fallback: ' . $message);
    }
}

if (!$company_id || !$package_type || !$plan_id) {
    http_response_code(400);
    echo json_encode(['success' => false, 'error' => 'Faltan parámetros requeridos']);
    exit;
}

try {
    // 1) Obtener el plan activo
    $stmtPlan = $pdo->prepare('SELECT url, name FROM subscription_plans WHERE id = ? AND status = 1');
    $stmtPlan->execute([$plan_id]);
    $plan = $stmtPlan->fetch();

    if (!$plan) {
        log_debug('Plan no encontrado o inactivo. plan_id=' . $plan_id);
        http_response_code(404);
        echo json_encode(['success' => false, 'error' => 'Plan no encontrado o inactivo']);
        exit;
    }

    // 2) Extraer preapproval_plan_id desde la URL guardada
    //    Ejemplo de URL: https://www.mercadopago.com.mx/subscriptions/checkout?preapproval_plan_id=PLAN_ID
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

    // 4) Redirigir al Checkout de Suscripción del plan (sin crear preapproval por API)
    //    El usuario autoriza en MP y tu webhook recibirá el preapproval real.
    log_debug('redirect_to_plan_url: ' . $plan['url']);
    echo json_encode([
        'success' => true,
        'payment_url' => $plan['url'],
    ]);
    exit;

} catch (MPApiException $e) {
    // Error de la API de Mercado Pago: log detallado
    $apiResponse = method_exists($e, 'getApiResponse') ? $e->getApiResponse() : null; // MPResponse
    $statusCode = null;
    $content = null;
    if ($apiResponse) {
        if (method_exists($apiResponse, 'getStatusCode')) {
            $statusCode = $apiResponse->getStatusCode();
        }
        if (method_exists($apiResponse, 'getContent')) {
            $content = $apiResponse->getContent(); // normalmente array
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
    // Cualquier otro error
    log_debug('Exception: ' . $e->getMessage());
    http_response_code(500);
    echo json_encode(['success' => false, 'error' => $e->getMessage()]);
    exit;
}


