<?php
require __DIR__ . '/vendor/autoload.php';

use MercadoPago\MercadoPagoConfig;

// ============================================================================
// CONFIGURACIÓN DE ENTORNO
// ============================================================================
// Cambiar a 'development' para desarrollo local, 'production' para producción
$environment = 'development'; // Cambiar a 'production' en producción

if ($environment === 'development') {
    // CONFIGURACIÓN DE DESARROLLO
    $MP_ACCESS_TOKEN = 'TEST-8150074147758897-090711-4fe937019f4a54cad537c4c50938372b-2537727051';
    $base_url = 'https://a5abf3d77b51.ngrok-free.app';
    
    define('DB_HOST', 'localhost');
    define('DB_PORT', '3306');
    define('DB_NAME', 'u631631460_MainBasePOS');
    define('DB_USER', 'root');
    define('DB_PASS', '');
    
    // Configurar MercadoPago para desarrollo
    MercadoPagoConfig::setAccessToken($MP_ACCESS_TOKEN);

} else {
    // CONFIGURACIÓN DE PRODUCCIÓN
    //acces de la empresa $MP_ACCESS_TOKEN = 'APP_USR-7333534419911855-091519-422c030a27e7b99d01a76845bd9ba461-2093626681';
    $MP_ACCESS_TOKEN = 'APP_USR-8150074147758897-090711-539325561b33e56ea7de1247ed74e5af-2537727051';
    $base_url = 'https://mdsystems.com.mx';
    
    define('DB_HOST', 'localhost');
    define('DB_PORT', '3306');
    define('DB_NAME', 'u631631460_MainBasePOS');
    define('DB_USER', 'u631631460_MainBasePOS');
    define('DB_PASS', 'Guino2025$');
    
    // Configurar MercadoPago para producción
    MercadoPagoConfig::setAccessToken($MP_ACCESS_TOKEN);
    MercadoPagoConfig::setRuntimeEnviroment(MercadoPagoConfig::SERVER);
}

// Definir URLs base para el entorno actual
define('BASE_URL', $base_url);
define('ENVIRONMENT', $environment);


try {
    $pdo = new PDO("mysql:host=" . DB_HOST . ";port=" . DB_PORT . ";dbname=" . DB_NAME . ";charset=utf8mb4", DB_USER, DB_PASS);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
    $pdo->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);
} catch (PDOException $e) {
    die("Error de conexión: " . $e->getMessage());
}
