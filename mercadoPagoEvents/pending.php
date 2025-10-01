<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pago Pendiente - MDsystems</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #ffc107;
            --secondary-color: #e0a800;
            --success-color: #28a745;
            --light-color: #f8f9fa;
            --dark-color: #212529;
        }
        
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #fffbf0;
            color: var(--dark-color);
            line-height: 1.6;
        }
        
        .pending-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(255, 193, 7, 0.15);
            overflow: hidden;
            transition: transform 0.3s ease;
        }
        
        .pending-card:hover {
            transform: translateY(-5px);
        }
        
        .pending-icon {
            font-size: 5rem;
            color: var(--primary-color);
            margin-bottom: 1.5rem;
            animation: pulse 2s infinite;
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
            box-shadow: 0 10px 25px rgba(255, 193, 7, 0.1);
        }
        
        .feature-icon {
            font-size: 2.5rem;
            color: var(--primary-color);
            margin-bottom: 1rem;
        }
        
        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            color: var(--dark-color);
            padding: 0.75rem 1.5rem;
            font-weight: 500;
            letter-spacing: 0.5px;
        }
        
        .btn-primary:hover {
            background-color: var(--secondary-color);
            border-color: var(--secondary-color);
            color: var(--dark-color);
        }
        
        .btn-outline-primary {
            color: var(--primary-color);
            border-color: var(--primary-color);
        }
        
        .btn-outline-primary:hover {
            background-color: var(--primary-color);
            color: var(--dark-color);
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
            width: 50%;
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
            color: var(--dark-color);
        }
        
        .step.active {
            border-color: var(--primary-color);
            color: var(--primary-color);
            animation: pulse 2s infinite;
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
        
        @keyframes pulse {
            0% {transform: scale(1);}
            50% {transform: scale(1.1);}
            100% {transform: scale(1);}
        }
        
        footer {
            background-color: var(--dark-color);
            color: white;
            padding: 2rem 0;
            margin-top: 4rem;
        }
        
     
    
    </style>
</head>
<body>

    <!-- Hero Section -->
    <div class="hero-section text-center">
        <div class="container">
            <div class="animate__animated animate__bounceIn">
                <i class="fas fa-clock pending-icon"></i>
                <h1 class="display-4 fw-bold mb-3">¡Pago en Proceso!</h1>
                <p class="lead mb-4">Tu pago está siendo procesado por MercadoPago</p>
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
                <span class="step-label">Procesando</span>
            </div>
            <div class="step">
                <span>4</span>
                <span class="step-label">Activación</span>
            </div>
        </div>
    </div>

    <!-- Content Section -->
    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <div class="card pending-card">
                    <div class="card-body p-5">
                        <div class="text-center mb-5">
                            <h3 class="fw-bold mb-3">Procesando tu pago</h3>
                            <p class="lead text-muted">Tu pago está siendo procesado por MercadoPago. Esto puede tomar unos minutos. Te notificaremos cuando se complete.</p>
                        </div>
                        
                        <div class="row g-4">
                            <div class="col-md-4">
                                <div class="feature-card text-center">
                                    <i class="fas fa-envelope feature-icon"></i>
                                    <h5>Notificación por Email</h5>
                                    <p class="text-muted">Recibirás una confirmación cuando el pago se complete exitosamente.</p>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="feature-card text-center">
                                    <i class="fas fa-user-check feature-icon"></i>
                                    <h5>Cuenta Temporal</h5>
                                    <p class="text-muted">Tu cuenta se activará automáticamente cuando se confirme el pago.</p>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="feature-card text-center">
                                    <i class="fas fa-shield-alt feature-icon"></i>
                                    <h5>Datos Seguros</h5>
                                    <p class="text-muted">Tu información está protegida y el proceso es completamente seguro.</p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="text-center mt-5 pt-4">
                            <h4 class="mb-4">¿Qué puedes hacer mientras tanto?</h4>
                            <div class="d-flex flex-wrap justify-content-center gap-3">
                                <a href="../index.php" class="btn btn-primary btn-lg">
                                    <i class="fas fa-home me-2"></i>Volver al Inicio
                                </a>
                                <a href="../about.php" class="btn btn-outline-primary btn-lg">
                                    <i class="fas fa-info-circle me-2"></i>Conocer Más
                                </a>
                            </div>
                            
                            <div class="mt-5 pt-3">
                                <div class="alert alert-light d-inline-block">
                                    <i class="fas fa-clock me-2 text-primary"></i>
                                    Tiempo estimado: <strong>5-10 minutos</strong> | <a href="../soporte" class="text-primary fw-bold">¿Tienes dudas?</a>
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
                progressBar.style.width = '50%';
            }, 300);
        });
    </script>
</body>
</html> 