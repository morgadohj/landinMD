<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pago Fallido - MDsystems</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #dc3545;
            --secondary-color: #c82333;
            --success-color: #28a745;
            --light-color: #f8f9fa;
            --dark-color: #212529;
        }
        
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #fff5f5;
            color: var(--dark-color);
            line-height: 1.6;
        }
        
        .failure-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(220, 53, 69, 0.15);
            overflow: hidden;
            transition: transform 0.3s ease;
        }
        
        .failure-card:hover {
            transform: translateY(-5px);
        }
        
        .failure-icon {
            font-size: 5rem;
            color: var(--primary-color);
            margin-bottom: 1.5rem;
            animation: shake 1s;
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
            box-shadow: 0 10px 25px rgba(220, 53, 69, 0.1);
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
            width: 33%;
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
        
        @keyframes shake {
            0%, 100% {transform: translateX(0);}
            10%, 30%, 50%, 70%, 90% {transform: translateX(-10px);}
            20%, 40%, 60%, 80% {transform: translateX(10px);}
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
                <i class="fas fa-times-circle failure-icon"></i>
                <h1 class="display-4 fw-bold mb-3">¡Pago Fallido!</h1>
                <p class="lead mb-4">No se pudo procesar tu pago, pero no te preocupes</p>
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
            <div class="step active">
                <span>2</span>
                <span class="step-label">Pago</span>
            </div>
            <div class="step">
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
                <div class="card failure-card">
                    <div class="card-body p-5">
                        <div class="text-center mb-5">
                            <h3 class="fw-bold mb-3">Tu registro está seguro</h3>
                            <p class="lead text-muted">Aunque el pago no se completó, tu información se ha guardado correctamente. Puedes intentar nuevamente o contactarnos para asistencia.</p>
                        </div>
                        
                        <div class="row g-4">
                            <div class="col-md-4">
                                <div class="feature-card text-center">
                                    <i class="fas fa-credit-card feature-icon"></i>
                                    <h5>Reintentar Pago</h5>
                                    <p class="text-muted">Puedes intentar el pago nuevamente con un método de pago diferente.</p>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="feature-card text-center">
                                    <i class="fas fa-headset feature-icon"></i>
                                    <h5>Soporte Técnico</h5>
                                    <p class="text-muted">Nuestro equipo te ayudará a resolver cualquier problema con el pago.</p>
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
                                <a href="../index.php" class="btn btn-primary btn-lg">
                                    <i class="fas fa-redo me-2"></i>Reintentar Pago
                                </a>
                                <a href="../index.php" class="btn btn-outline-primary btn-lg">
                                    <i class="fas fa-home me-2"></i>Volver al Inicio
                                </a>
                                <a href="mailto:soporte@mdsystems.com.mx" class="btn btn-outline-secondary btn-lg">
                                    <i class="fas fa-envelope me-2"></i>Contactar Soporte
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
                progressBar.style.width = '33%';
            }, 300);
        });
    </script>
</body>
</html> 