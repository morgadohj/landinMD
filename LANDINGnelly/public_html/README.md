# MDsystems Landing Page - Sistema de Registro y Pagos

## 📋 Descripción General

Sistema completo de landing page para MDsystems que incluye registro de usuarios, integración con MercadoPago para pagos recurrentes, y gestión de planes de suscripción. El sistema está diseñado para ofrecer una experiencia de usuario fluida y segura.

## 🚀 Características Principales

### ✨ Funcionalidades del Usuario

- **Registro por pasos**: Formulario dividido en 4 pasos para mejor UX
- **Validación en tiempo real**: Verificación instantánea de datos
- **Prueba gratuita**: 15 días de acceso sin costo
- **Pagos recurrentes**: Integración completa con MercadoPago
- **Planes flexibles**: Opciones mensuales y anuales con descuentos

### 🔒 Seguridad

- **Protección CSRF**: Tokens de seguridad en todos los formularios
- **Validación de datos**: Sanitización y validación robusta
- **Encriptación de contraseñas**: Hash seguro con bcrypt
- **Validación de formatos**: RFC, email, teléfono con regex

### 💳 Integración de Pagos

- **MercadoPago**: Suscripciones automáticas
- **Webhooks**: Procesamiento automático de pagos
- **Múltiples planes**: Una sucursal y múltiples sucursales
- **Descuentos**: Sistema de promociones automático

## 📁 Estructura del Proyecto

```
public_html/
├── config.php                 # Configuración principal y base de datos
├── csrf_protection.php        # Sistema de protección CSRF
├── index.php                  # Página principal con formularios
├── registerHandler.php        # Procesamiento de registros
├── validate_registration.php  # Validación de datos únicos
├── modal.js                   # Lógica JavaScript del frontend
├── styles.css                 # Estilos principales
├── pricing_cards.php          # Generación dinámica de precios
├── plans/
│   ├── plan.php              # Creación de planes en MercadoPago
│   └── suscribtion.php       # Generación de enlaces de pago
└── mercadoPagoEvents/
    ├── webhook.php           # Procesamiento de webhooks
    ├── success.php           # Página de pago exitoso
    ├── failure.php           # Página de pago fallido
    └── log_*.txt            # Archivos de log
```

## 🛠️ Instalación y Configuración

### Requisitos del Sistema

- PHP 7.4 o superior
- MySQL 5.7 o superior
- Servidor web (Apache/Nginx)
- Composer para dependencias

### 1. Configuración de Base de Datos

```sql
-- Tabla principal de empresas
CREATE TABLE company_customer (
    id INT AUTO_INCREMENT PRIMARY KEY,
    company_name VARCHAR(255) NOT NULL,
    database_handle VARCHAR(100) UNIQUE NOT NULL,
    termns_conditions TINYINT DEFAULT 0,
    user VARCHAR(100) NOT NULL,
    pass VARCHAR(255) NOT NULL,
    status ENUM('active', 'inactive', 'pending') DEFAULT 'pending',
    payment_status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    package_type ENUM('basic', 'premium', 'basicAnual', 'premiumAnual') NOT NULL,
    id_regimen_fiscal VARCHAR(10) NOT NULL,
    rfc VARCHAR(13) UNIQUE NOT NULL,
    address VARCHAR(5) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    trial_ends_at TIMESTAMP NULL,
    paid_at TIMESTAMP NULL,
    payment_reference VARCHAR(255) NULL,
    payment_method VARCHAR(50) NULL,
    subscription_expires_at TIMESTAMP NULL
);

-- Tabla de usuarios
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    group_id INT DEFAULT 1,
    company_id INT NOT NULL,
    username VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    mobile VARCHAR(20) UNIQUE NOT NULL,
    dob DATE DEFAULT '1990-01-01',
    sex ENUM('M', 'F') DEFAULT 'M',
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (company_id) REFERENCES company_customer(id)
);

-- Tabla de planes de suscripción
CREATE TABLE subscription_plans (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    type ENUM('unaSucursal', 'multiSucursal') NOT NULL,
    frequency ENUM('mensual', 'anual') NOT NULL,
    discount INT DEFAULT 0,
    price_base DECIMAL(10,2) NOT NULL,
    price_offer DECIMAL(10,2) NULL,
    url TEXT NOT NULL,
    status TINYINT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### 2. Configuración de MercadoPago

1. **Obtener credenciales**:
   - Acceder a [MercadoPago Developers](https://www.mercadopago.com.mx/developers)
   - Crear aplicación y obtener Access Token

2. **Configurar webhook**:
   - URL: `https://tudominio.com/mercadoPagoEvents/webhook.php`
   - Eventos: `subscription_preapproval`

3. **Actualizar configuración**:

   ```php
   // En config.php
   $MP_ACCESS_TOKEN = 'TU_ACCESS_TOKEN_AQUI';
   $base_url = 'https://tudominio.com';
   ```

### 3. Instalación de Dependencias

```bash
composer install
```

### 4. Configuración de Entorno

```php
// En config.php - Cambiar según el entorno
$environment = 'production'; // 'development' o 'production'
```

## 🔧 Configuración Avanzada

### Variables de Entorno

| Variable | Desarrollo | Producción | Descripción |
|----------|------------|------------|-------------|
| `$environment` | development | production | Entorno de ejecución |
| `$MP_ACCESS_TOKEN` | TEST-xxx | APP_USR-xxx | Token de MercadoPago |
| `$base_url` | ngrok URL | Dominio real | URL base del sistema |

### Configuración de Base de Datos

```php
// Desarrollo
define('DB_HOST', 'localhost');
define('DB_NAME', 'u631631460_MainBasePOS');
define('DB_USER', 'root');
define('DB_PASS', '');

// Producción
define('DB_HOST', 'localhost');
define('DB_NAME', 'u631631460_MainBasePOS');
define('DB_USER', 'u631631460_MainBasePOS');
define('DB_PASS', 'Guino2025$');
```

## 📊 Flujo de Usuario

### 1. Registro de Prueba Gratuita

```

Usuario → Selecciona "Probar Gratis" → Modal de registro → 
Validación → Creación de cuenta → 15 días de prueba
```

### 2. Compra de Plan

```
Usuario → Selecciona "Comprar Ahora" → Modal de registro → 
Validación → Creación de cuenta → Redirección a MercadoPago → 
Pago → Webhook → Activación de suscripción
```

### 3. Procesamiento de Pagos

```
MercadoPago → Webhook → Validación → Actualización de BD → 
Email de confirmación → Acceso al sistema
```

## 🎨 Personalización

### Modificar Planes de Precios

1. **Editar planes en `plans/plan.php`**:

   ```php
   $plans = [
       [
           "name" => "1 Sucursal mensual",
           "type" => "unaSucursal",
           "frequency" => "mensual",
           "discount" => 0,
           "price_base" => 400,
           "price_offer" => null,
           "amount" => 400,
           "freq" => 1,
           "freq_type" => "months"
       ],
       // ... más planes
   ];
   ```

2. **Ejecutar script de creación**:

   ```bash
   php plans/plan.php
   ```

### Personalizar Estilos

Los estilos principales están en `styles.css` con variables CSS:

```css
:root {
  --navy: #0c3c60;        /* Color principal */
  --amber: #fecf2f;       /* Color de acento */
  --radius: 16px;         /* Radio de bordes */
  --shadow-md: 0 10px 30px rgba(2, 6, 23, 0.12);
}
```

## 🔍 Monitoreo y Logs

### Archivos de Log

- `mercadoPagoEvents/log_webhook.txt`: Webhooks recibidos
- `mercadoPagoEvents/log_subscription.txt`: Suscripciones generadas
- `error_log`: Errores del servidor PHP

### Monitoreo de Pagos

```php
// Verificar estado de pagos
SELECT 
    company_name,
    payment_status,
    package_type,
    created_at,
    paid_at
FROM company_customer 
WHERE payment_status = 'approved'
ORDER BY created_at DESC;
```

## 🚨 Solución de Problemas

### Problemas Comunes

1. **Error de CSRF**:
   - Verificar que `session_start()` esté en `csrf_protection.php`
   - Limpiar caché del navegador

2. **Webhook no funciona**:
   - Verificar URL en configuración de MercadoPago
   - Revisar logs en `log_webhook.txt`
   - Verificar que el servidor sea accesible desde internet

3. **Pagos no se procesan**:
   - Verificar token de MercadoPago
   - Revisar configuración de entorno
   - Verificar logs de error

### Debug Mode

```php
// En config.php para desarrollo
error_reporting(E_ALL);
ini_set('display_errors', 1);
```

## 📈 Optimizaciones Implementadas

### Rendimiento

- ✅ Validación en tiempo real sin recargar página
- ✅ Carga asíncrona de datos
- ✅ Optimización de consultas SQL
- ✅ Compresión de assets

### Seguridad

- ✅ Protección CSRF en todos los formularios
- ✅ Sanitización de datos de entrada
- ✅ Validación robusta de formatos
- ✅ Encriptación de contraseñas

### Experiencia de Usuario

- ✅ Formulario por pasos intuitivo
- ✅ Validación visual en tiempo real
- ✅ Mensajes de error claros
- ✅ Páginas de éxito/error informativas

## 🔄 Mantenimiento

### Tareas Regulares

1. **Monitoreo de logs** (diario):
   - Revisar `log_webhook.txt`
   - Verificar errores en `error_log`

2. **Limpieza de datos** (semanal):
   - Eliminar registros de prueba antiguos
   - Limpiar logs antiguos

3. **Backup de base de datos** (diario):

   ```bash
   mysqldump -u usuario -p base_datos > backup_$(date +%Y%m%d).sql
   ```

### Actualizaciones

1. **MercadoPago SDK**:

   ```bash
   composer update mercadopago/dx-php
   ```

2. **Planes de precios**:
   - Modificar `plans/plan.php`
   - Ejecutar script de actualización

## 📞 Soporte

Para soporte técnico o consultas:

- **Email**: soporte@mdsystems.com.mx
- **Documentación**: Este README
- **Logs**: Revisar archivos de log para debugging

## 📄 Licencia

Este proyecto es propiedad de MDsystems. Todos los derechos reservados.

---

**Versión**: 1.0.0  
**Última actualización**: Enero 2025  
**Mantenido por**: Equipo de Desarrollo MDsystems
