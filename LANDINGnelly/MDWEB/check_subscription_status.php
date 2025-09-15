<?php
/**
 * Archivo para verificar el estado de las suscripciones
 * Este archivo se puede ejecutar como cron job para verificar
 * empresas con suscripciones expiradas o próximas a expirar
 */

require 'config.php';

try {
    // Verificar empresas con suscripciones expiradas
    $stmt = $pdo->prepare("
        SELECT id, company_name, subscription_expires_at, payment_status, status
        FROM company_customer 
        WHERE subscription_expires_at IS NOT NULL 
        AND subscription_expires_at < NOW() 
        AND status = 'active'
    ");
    $stmt->execute();
    $expiredSubscriptions = $stmt->fetchAll();
    
    foreach ($expiredSubscriptions as $company) {
        // Actualizar estado a inactivo
        $updateStmt = $pdo->prepare("
            UPDATE company_customer 
            SET status = 'inactive', payment_status = 'expired'
            WHERE id = ?
        ");
        $updateStmt->execute([$company['id']]);
        
        error_log("Subscription expired for company: {$company['company_name']} (ID: {$company['id']})");
    }
    
    // Verificar empresas con suscripciones próximas a expirar (7 días)
    $stmt = $pdo->prepare("
        SELECT id, company_name, subscription_expires_at, payment_status, status
        FROM company_customer 
        WHERE subscription_expires_at IS NOT NULL 
        AND subscription_expires_at BETWEEN NOW() AND DATE_ADD(NOW(), INTERVAL 7 DAY)
        AND status = 'active'
    ");
    $stmt->execute();
    $expiringSoon = $stmt->fetchAll();
    
    foreach ($expiringSoon as $company) {
        error_log("Subscription expiring soon for company: {$company['company_name']} (ID: {$company['id']}) - Expires: {$company['subscription_expires_at']}");
        // Aquí podrías enviar notificaciones por email o WhatsApp
    }
    
    // Verificar empresas con trial expirado
    $stmt = $pdo->prepare("
        SELECT id, company_name, trial_ends_at, payment_status, status
        FROM company_customer 
        WHERE trial_ends_at IS NOT NULL 
        AND trial_ends_at < NOW() 
        AND payment_status = 'pending'
        AND status = 'active'
    ");
    $stmt->execute();
    $expiredTrials = $stmt->fetchAll();
    
    foreach ($expiredTrials as $company) {
        // Actualizar estado a inactivo para trials expirados sin pago
        $updateStmt = $pdo->prepare("
            UPDATE company_customer 
            SET status = 'inactive', payment_status = 'trial_expired'
            WHERE id = ?
        ");
        $updateStmt->execute([$company['id']]);
        
        error_log("Trial expired for company: {$company['company_name']} (ID: {$company['id']})");
    }
    
    echo "Subscription status check completed. " . 
         "Expired: " . count($expiredSubscriptions) . 
         ", Expiring soon: " . count($expiringSoon) . 
         ", Expired trials: " . count($expiredTrials);
         
} catch (Exception $e) {
    error_log("Error checking subscription status: " . $e->getMessage());
    echo "Error: " . $e->getMessage();
}
?>
