<?php
require '../config.php';
use MercadoPago\Client\PreApproval\PreApprovalClient;

$preApprovalClient = new PreApprovalClient();

$input = file_get_contents('php://input');
file_put_contents("log_webhook.txt", "[" . date('Y-m-d H:i:s') . "] " . $input . "\n", FILE_APPEND); // Para debug

$data = json_decode($input, true);

if (!$data) {
    error_log("Webhook: No se pudo decodificar JSON: " . $input);
    http_response_code(400);
    echo "Invalid JSON";
    exit;
}

// Log de la notificación recibida
error_log("Webhook received: " . json_encode($data));

// Manejar diferentes tipos de notificaciones de MercadoPago
$entity = $data['entity'] ?? null;
$action = $data['action'] ?? null;
$id = $data['id'] ?? null;

// Para notificaciones de suscripciones, usar 'preapproval' como topic
$topic = ($entity === 'preapproval') ? 'preapproval' : null;

try {
    if ($topic === 'preapproval') {
        error_log("Processing preapproval notification for ID: $id");
        
        // Verificar si es una notificación de prueba (ID ficticio)
        if ($id === '123456') {
            error_log("Webhook: Received test notification with ID 123456 - this is expected for testing");
            http_response_code(200);
            echo "Test notification received successfully";
            exit;
        }
        
        // Para suscripciones reales: obtener detalles y actualizar expiración
        try {
            $preApproval = $preApprovalClient->get($id);
            $external_ref = $preApproval->external_reference ?? null;
            
            error_log("PreApproval details - ID: $id, Status: {$preApproval->status}, External Ref: $external_ref");
            
            if ($external_ref) {
                // Extraer company_id y package_type de external_reference
                $reference_parts = explode('|', $external_ref);
                $company_id = $reference_parts[0] ?? null;
                $package_type = $reference_parts[1] ?? null;
                
                error_log("Parsed external reference - Company ID: $company_id, Package Type: $package_type");
                
                if ($company_id && $package_type) {
                    // Determinar el intervalo de suscripción según el tipo de paquete
                    $interval = (strpos($package_type, 'Anual') !== false || strpos($package_type, 'anual') !== false) ? '1 YEAR' : '1 MONTH';
                    
                    // Actualiza la tabla company_customer según el estado de la suscripción
                    $stmt = $pdo->prepare("
                        UPDATE company_customer
                        SET payment_status = ?, 
                            status = ?, 
                            payment_reference = ?, 
                            payment_method = ?,
                            paid_at = NOW(),
                            subscription_expires_at = DATE_ADD(NOW(), INTERVAL $interval)
                        WHERE id = ?
                    ");
                    $stmt->execute([
                        $preApproval->status, 
                        $preApproval->status === 'authorized' ? 'active' : 'pending', 
                        $preApproval->id,
                        'subscription',
                        $company_id
                    ]);
                    
                    error_log("Webhook subscription updated successfully: company_id=$company_id, status={$preApproval->status}, package_type=$package_type, interval=$interval");
                } else {
                    error_log("Webhook: Invalid external reference format: $external_ref");
                }
            } else {
                error_log("Webhook: No external reference found for preapproval ID: $id");
            }
        } catch (Exception $apiError) {
            error_log("Webhook: Error getting preapproval details for ID $id: " . $apiError->getMessage());
            // No lanzar excepción, solo loggear el error
        }
    } else {
        error_log("Webhook received unsupported entity: $entity (topic: $topic)");
    }
    
    http_response_code(200);
    echo "OK";
    
} catch (Exception $e) {
    error_log("Error webhook: " . $e->getMessage());
    error_log("Error webhook trace: " . $e->getTraceAsString());
    http_response_code(500);
    echo "Error: " . $e->getMessage();
}
