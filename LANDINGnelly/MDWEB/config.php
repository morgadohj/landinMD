<?php
require __DIR__ . '/vendor/autoload.php';

use MercadoPago\MercadoPagoConfig;

//credenciales de prueba
//$MP_ACCESS_TOKEN = 'TEST-8150074147758897-090711-4fe937019f4a54cad537c4c50938372b-2537727051';
//credencial de produccion pero de usuario de prueba
$MP_ACCESS_TOKEN = 'APP_USR-2866572969653498-091418-05dd47c86a6295984e6392e615cfe9ce-2537830851';
//credenciales de producción
//$MP_ACCESS_TOKEN = 'APP_USR-8150074147758897-090711-539325561b33e56ea7de1247ed74e5af-2537727051';

MercadoPagoConfig::setAccessToken($MP_ACCESS_TOKEN);
MercadoPagoConfig::setRuntimeEnviroment(MercadoPagoConfig::LOCAL);


define('DB_HOST', 'localhost');
define('DB_PORT', '3310');
define('DB_NAME', 'u631631460_MainBasePOS');
define('DB_USER', 'root');
define('DB_PASS', '');


try {
    $pdo = new PDO("mysql:host=" . DB_HOST . ";port=" . DB_PORT . ";dbname=" . DB_NAME . ";charset=utf8mb4", DB_USER, DB_PASS);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
    $pdo->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);
} catch (PDOException $e) {
    die("Error de conexión: " . $e->getMessage());
}
