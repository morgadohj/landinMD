<?php
require '../config.php'; 
file_put_contents("log_pago.txt", print_r($_GET, true), FILE_APPEND);

// Leer parámetros GET de Mercado Pago
$payment_id = $_GET['payment_id'] ?? null;
$status = $_GET['status'] ?? null;
$payment_type = $_GET['payment_type'] ?? null;
$merchant_order_id = $_GET['merchant_order_id'] ?? null;
$external_reference = $_GET['external_reference'] ?? null;

// Extraer company_id y package_type del external_reference
$company_id = null;
$package_type = null;

if ($external_reference) {
    $reference_parts = explode('|', $external_reference);
    $company_id = $reference_parts[0] ?? null;
    $package_type = $reference_parts[1] ?? null;
}

// Validar si viene todo lo necesario
if ($company_id && $package_type && $status === 'approved' && $payment_id && $payment_type) {
    try {
        // Determinar el intervalo de suscripción según el tipo de paquete
        $interval = (strpos($package_type, 'Anual') !== false || strpos($package_type, 'anual') !== false) ? '1 YEAR' : '1 MONTH';
        
        $stmt = $pdo->prepare("
            UPDATE company_customer 
            SET payment_status = 'approved', 
                status = 'active', 
                payment_reference = ?, 
                payment_method = ?, 
                package_type = ?,
                paid_at = NOW(),
                subscription_expires_at = DATE_ADD(NOW(), INTERVAL $interval)
            WHERE id = ?
        ");
        $stmt->execute([$payment_id, $payment_type, $package_type, $company_id]);
        
        error_log("Success page updated: company_id=$company_id, status=$status, package_type=$package_type");
        
    } catch (PDOException $e) {
        error_log("Error al actualizar estado de pago: " . $e->getMessage());
    }
} else {
    error_log("Datos incompletos o no aprobado: status=$status, company_id=$company_id, package_type=$package_type, payment_id=$payment_id, payment_type=$payment_type");
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pago Aprobado - MDsystems</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #4361ee;
            --secondary-color: #3f37c9;
            --success-color: #4cc9f0;
            --light-color: #f8f9fa;
            --dark-color: #212529;
        }
        
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f5f7ff;
            color: var(--dark-color);
            line-height: 1.6;
        }
        
        .success-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(67, 97, 238, 0.15);
            overflow: hidden;
            transition: transform 0.3s ease;
        }
        
        .success-card:hover {
            transform: translateY(-5px);
        }
        
        .success-icon {
            font-size: 5rem;
            color: var(--primary-color);
            margin-bottom: 1.5rem;
            animation: bounce 1s;
        }
        
        .hero-section {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 4rem 0 3rem;
            clip-path: ellipse(100% 60% at 50% 35%);
            margin-bottom: 3rem;
        }
        
        .feature-card {
            border: none;
            border-radius: 10px;
            background: white;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
            height: 100%;
            padding: 1.5rem;
        }
        
        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(67, 97, 238, 0.1);
        }
        
        .feature-icon {
            font-size: 2.5rem;
            color: var(--primary-color);
            margin-bottom: 1rem;
        }
        
        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            padding: 0.75rem 1.5rem;
            font-weight: 500;
            letter-spacing: 0.5px;
        }
        
        .btn-outline-primary {
            color: var(--primary-color);
            border-color: var(--primary-color);
        }
        
        .btn-outline-primary:hover {
            background-color: var(--primary-color);
        }
        
        .progress-steps {
            display: flex;
            justify-content: space-between;
            position: relative;
            margin: 2rem 0 3rem;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
        }
        
        .progress-steps::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 4px;
            background: #e9ecef;
            z-index: 1;
            transform: translateY(-50%);
        }
        
        .progress-bar {
            position: absolute;
            top: 50%;
            left: 0;
            height: 4px;
            background: var(--primary-color);
            z-index: 2;
            transform: translateY(-50%);
            width: 100%;
            transition: width 0.4s ease;
        }
        
        .step {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: white;
            border: 3px solid #e9ecef;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            z-index: 3;
            font-weight: 600;
            color: #adb5bd;
        }
        
        .step.completed {
            border-color: var(--primary-color);
            background-color: var(--primary-color);
            color: white;
        }
        
        .step.active {
            border-color: var(--primary-color);
            color: var(--primary-color);
        }
        
        .step-label {
            position: absolute;
            top: calc(100% + 10px);
            left: 50%;
            transform: translateX(-50%);
            white-space: nowrap;
            font-size: 0.85rem;
            font-weight: 500;
        }
        
        @keyframes bounce {
            0%, 20%, 50%, 80%, 100% {transform: translateY(0);}
            40% {transform: translateY(-30px);}
            60% {transform: translateY(-15px);}
        }
        
        footer {
            background-color: var(--dark-color);
            color: white;
            padding: 2rem 0;
            margin-top: 4rem;
        }
        
        .whatsapp-float {
            position: fixed;
            bottom: 30px;
            right: 30px;
            width: 60px;
            height: 60px;
            background-color: #25D366;
            color: white;
            border-radius: 50%;
            text-align: center;
            font-size: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            z-index: 100;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }
        
        .whatsapp-float:hover {
            transform: scale(1.1);
            box-shadow: 0 8px 25px rgba(37, 211, 102, 0.3);
        }
    </style>
</head>
<body>

    <!-- Hero Section -->
    <div class="hero-section text-center">
        <div class="container">
            <div class="animate__animated animate__bounceIn">
                <i class="fas fa-check-circle success-icon"></i>
                <h1 class="display-4 fw-bold mb-3">¡Pago Aprobado!</h1>
                <p class="lead mb-4">Tu suscripción a MDsystems ha sido activada exitosamente</p>
            </div>
        </div>
    </div>

    <!-- Progress Steps -->
    <div class="container">
        <div class="progress-steps">
            <div class="progress-bar"></div>
            <div class="step completed">
                <span>1</span>
                <span class="step-label">Registro</span>
            </div>
            <div class="step completed">
                <span>2</span>
                <span class="step-label">Pago</span>
            </div>
            <div class="step active">
                <span>3</span>
                <span class="step-label">Activación</span>
            </div>
            <div class="step">
                <span>4</span>
                <span class="step-label">Uso</span>
            </div>
        </div>
    </div>

    <!-- Content Section -->
    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <div class="card success-card">
                    <div class="card-body p-5">
                        <div class="text-center mb-5">
                            <h3 class="fw-bold mb-3">¡Estás listo para comenzar!</h3>
                            <p class="lead text-muted">Tu cuenta ha sido activada y ya puedes acceder a todas las funcionalidades de MDsystems.</p>
                        </div>
                        
                        <div class="row g-4">
                            <div class="col-md-4">
                                <div class="feature-card text-center">
                                    <i class="fas fa-rocket feature-icon"></i>
                                    <h5>Acceso Inmediato</h5>
                                    <p class="text-muted">Tu cuenta está lista para usarse ahora mismo con todas las funciones activadas.</p>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="feature-card text-center">
                                    <i class="fas fa-file-invoice-dollar feature-icon"></i>
                                    <h5>Recibo Electrónico</h5>
                                    <p class="text-muted">Hemos enviado el comprobante de pago a tu email registrado.</p>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="feature-card text-center">
                                    <i class="fas fa-shield-alt feature-icon"></i>
                                    <h5>Datos Protegidos</h5>
                                    <p class="text-muted">Tu información está segura y no se ha perdido ningún dato del registro.</p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="text-center mt-5 pt-4">
                            <h4 class="mb-4">¿Qué te gustaría hacer ahora?</h4>
                            <div class="d-flex flex-wrap justify-content-center gap-3">
                                <a href="http://localhost/SistemaPos/" class="btn btn-primary btn-lg">
                                    <i class="fas fa-sign-in-alt me-2"></i>Ir al Sistema
                                </a>
             
                          
                            </div>
                            
                            <div class="mt-5 pt-3">
                                <div class="alert alert-light d-inline-block">
                                    <i class="fas fa-question-circle me-2 text-primary"></i>
                                    ¿Necesitas ayuda? <a href="../soporte" class="text-primary fw-bold">Contacta a nuestro equipo</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    

 

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Animación progresiva de la barra de progreso
        document.addEventListener('DOMContentLoaded', () => {
            const progressBar = document.querySelector('.progress-bar');
            setTimeout(() => {
                progressBar.style.width = '66%';
            }, 300);
        });
    </script>
</body>
</html>