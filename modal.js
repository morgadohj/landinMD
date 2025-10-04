// Mapeo de planes para registro
const packageInfo = {
    basic: { name: "Una Sucursal Mensual", price: "$400.00 MXN / mes" },
    premium: { name: "Multi Sucursal Mensual", price: "$700.00 MXN / mes" },
    basicAnual: { name: "Una Sucursal Anual", price: "$4,880.00 MXN / año" },
    premiumAnual: { name: "Multi Sucursal Anual", price: "$8400.00 MXN / año" },
};

// Abrir modal de registro
function openRegistrationModal(package, period) {
    console.log('openRegistrationModal llamado con:', {package, period});
    console.log('Estado antes de limpiar:', {
        isPurchase: window.isPurchase,
        currentPlanId: window.currentPlanId
    });
    
    // ============================================================================
    // LIMPIAR VARIABLES DE COMPRA PARA PRUEBA GRATUITA
    // ============================================================================
    // Solo limpiar si no es una compra (no se llamó desde openPurchaseModal)
    if (!window.isPurchase) {
        window.isPurchase = false;
        window.currentPlanId = null;
    }
    
    // ============================================================================
    // MAPEO DE PLANES A VALORES DEL ENUM DE LA BASE DE DATOS
    // ============================================================================
    // La base de datos solo acepta estos 4 valores específicos del ENUM
    let packageType;
    
    // LÓGICA DE MAPEO:
    // 1. PLANES DE UNA SUCURSAL (single/basic)
    if (package === "single" || package === "basic") {
        // Si es anual → basicAnual, si es mensual → basic
        packageType = period === "yearly" ? "basicAnual" : "basic";
    } 
    // 2. PLANES DE MÚLTIPLES SUCURSALES (multi/premium)
    else if (package === "multi" || package === "premium") {
        // Si es anual → premiumAnual, si es mensual → premium
        packageType = period === "yearly" ? "premiumAnual" : "premium";
    } 
    // 3. FALLBACK para otros casos (mantener el valor original si ya es válido)
    else {
        packageType = package;
    }

    // ============================================================================
    // OBTENER INFORMACIÓN DEL PLAN PARA MOSTRAR EN EL MODAL
    // ============================================================================
    let planInfo = packageInfo[packageType];
    
    // Si no existe en packageInfo, crear información dinámica
    if (!planInfo) {
        const planName = package === "single" ? "Una Sucursal" : "Múltiples Sucursales";
        const periodText = period === "yearly" ? "Anual" : "Mensual";
        planInfo = {
            name: `${planName} - ${periodText}`,
            price: `Plan ${periodText}`,
        };
    }

    // ============================================================================
    // MOSTRAR INFORMACIÓN DEL PLAN EN EL MODAL
    // ============================================================================
    if (planInfo) {
        // Verificar si el elemento existe antes de acceder a él
        const planInfoElement = document.getElementById("planInfo");
        if (planInfoElement) {
            planInfoElement.innerHTML = `
                        <h5 class="mb-2">Plan Seleccionado: <strong>${planInfo.name}</strong></h5>
                        <p class="mb-0">Precio: <strong>${planInfo.price}</strong></p>
                    `;
        }
    }

    // ============================================================================
    // ESTABLECER EL VALOR DEL CAMPO OCULTO PARA EL FORMULARIO
    // ============================================================================
    // IMPORTANTE: Este valor será enviado a la base de datos y debe ser uno de los 4 valores del ENUM
    
    // VALIDACIÓN FINAL: Asegurar que el valor sea exactamente uno de los 4 valores válidos
    const validPackageTypes = ['basic', 'premium', 'basicAnual', 'premiumAnual'];
    if (!validPackageTypes.includes(packageType)) {
        // Fallback a un valor seguro
        packageType = 'basic';
    }
    
    // Limpiar el valor de espacios y caracteres extra
    packageType = packageType.trim();
    
    // Verificar si el elemento existe antes de acceder a él
    const packageTypeElement = document.getElementById("packageType");
    if (packageTypeElement) {
        packageTypeElement.value = packageType;
    }
    
    // Marcar si es una compra o no
    const isPurchaseElement = document.getElementById("isPurchase");
    if (isPurchaseElement) {
        isPurchaseElement.value = window.isPurchase ? "true" : "false";
    }
    

    console.log('Estado final en openRegistrationModal:', {
        isPurchase: window.isPurchase,
        currentPlanId: window.currentPlanId
    });
    
    // Abrir el modal de registro
    $("#registrationModal").modal("show");
}

// Función para abrir el modal de compra (registro) y luego redirigir al link de MercadoPago
// Parámetros:
// - package: tipo de plan ('single', 'multi', 'basic', 'premium')
// - period: período de facturación ('yearly' o 'monthly')
// - url: URL de MercadoPago para redirigir después del registro
// - planId: ID del plan en la base de datos
function openPurchaseModal(package, period, url, planId) {
    console.log('openPurchaseModal llamado con:', {package, period, url, planId});
    
    // Guardar el ID del plan para usar después del registro
    window.currentPlanId = planId;
    
    // Marcar que es una compra para insertar subscription_expires_at
    window.isPurchase = true;
    
    console.log('Variables configuradas:', {
        currentPlanId: window.currentPlanId,
        isPurchase: window.isPurchase
    });
    
    // Abrir el modal de registro con el plan seleccionado
    openRegistrationModal(package, period);
}

// Función para inicializar MercadoPago
function initializeMercadoPago() {
    // Verificar si MercadoPago ya está inicializado
    if (window.mpInitialized) {
        return;
    }
    
    const publicKey = "TEST-8ecea9a2-abbf-48ed-af04-de573e8214ec";
    
    // Verificar si MercadoPago está disponible
    if (typeof MercadoPago === 'undefined') {
        console.error('MercadoPago SDK no está cargado');
        return;
    }
    
    try {
        const mp = new MercadoPago(publicKey);
        const bricksBuilder = mp.bricks();
        
        // Mostrar mensaje de carga
        const container = document.getElementById('walletBrick_container');
        if (container) {
            container.innerHTML = '<div class="text-center p-4"><div class="spinner-border text-primary" role="status"><span class="visually-hidden">Cargando...</span></div><p class="mt-2">Preparando opciones de pago...</p></div>';
        }
        
        // Crear el brick de wallet con preferencia dinámica
        bricksBuilder.create('wallet', 'walletBrick_container', {
            initialization: { 
                preferenceId: window.currentPreferenceId || "2694481333-3124d592-214f-4f84-aec3-68c814066751" 
            },
            customization: {
                texts: { valueProp: 'smart_option' }
            },
            callbacks: {
                onReady: () => {
                    console.log('MercadoPago Wallet Brick listo');
                },
                onSubmit: (param) => {
                    console.log('Formulario enviado:', param);
                },
                onError: (error) => {
                    console.error('Error en MercadoPago:', error);
                    if (container) {
                        container.innerHTML = '<div class="alert alert-warning text-center"><i class="fas fa-exclamation-triangle me-2"></i>Error al cargar las opciones de pago. Por favor, intenta nuevamente.</div>';
                    }
                }
            }
        });
        
        window.mpInitialized = true;
    } catch (error) {
        console.error('Error al inicializar MercadoPago:', error);
        const container = document.getElementById('walletBrick_container');
        if (container) {
            container.innerHTML = '<div class="alert alert-danger text-center"><i class="fas fa-exclamation-triangle me-2"></i>Error al cargar las opciones de pago. Por favor, intenta nuevamente.</div>';
        }
    }
}

// Función para mostrar el modal de pago
function showPaymentModal() {
    // Crear modal de pago dinámicamente
    const paymentModalHtml = `
        <div class="modal fade" id="paymentModal" tabindex="-1" role="dialog" aria-labelledby="paymentModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
                <div class="modal-content border-0 shadow-lg" style="border-radius: 20px; overflow: hidden;">
                    <div class="modal-header border-0" style="background: linear-gradient(135deg, #10b981 0%, #059669 100%); color: white; padding: 2rem;">
                        <h4 class="modal-title text-center w-100" id="paymentModalLabel" style="color: white; font-weight: 600; font-size: 1.5rem;">
                            <i class="fas fa-credit-card me-3" style="color: white;"></i>Completar Pago
                        </h4>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body text-center p-5" style="background: #f8fafc;">
                        <div class="mb-4">
                            <div class="d-inline-flex align-items-center justify-content-center" style="width: 80px; height: 80px; background: linear-gradient(135deg, #10b981 0%, #059669 100%); border-radius: 50%; margin-bottom: 1.5rem;">
                                <i class="fas fa-check" style="font-size: 2rem; color: white;"></i>
                            </div>
                        </div>
                        <div class="alert alert-success border-0 mb-4" style="background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%); border-radius: 12px; padding: 1.5rem;">
                            <h5 class="alert-heading mb-2" style="color: #065f46; font-weight: 600;">
                                <i class="fas fa-check-circle me-2"></i>¡Cuenta Creada Exitosamente!
                            </h5>
                            <p class="mb-0" style="color: #047857; font-size: 1.1rem;">
                                Tu cuenta ha sido registrada correctamente. Ahora completa el pago para activar tu suscripción.
                            </p>
                        </div>
                        <div class="mb-4">
                            <h5 style="color: var(--navy); font-weight: 600; margin-bottom: 1rem;">¿Listo para continuar?</h5>
                            <p class="text-muted mb-4" style="font-size: 1.1rem;">Haz clic en el botón para ir al checkout seguro de MercadoPago:</p>
                            <button type="button" class="btn btn-success btn-lg" onclick="proceedToPayment()" style="border-radius: 12px; padding: 1rem 2rem; font-weight: 600; background: linear-gradient(135deg, #10b981 0%, #059669 100%); border: none; box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);">
                                <i class="fas fa-credit-card me-2"></i>Ir al Checkout de MercadoPago
                            </button>
                        </div>
                        <div class="mt-4 p-3" style="background: #e0f2fe; border-radius: 12px; border-left: 4px solid #0ea5e9;">
                            <small class="text-muted" style="font-size: 0.95rem;">
                                <i class="fas fa-shield-alt me-2" style="color: #0ea5e9;"></i>
                                <strong>Pago 100% Seguro</strong> - Procesado por MercadoPago con encriptación SSL
                            </small>
                        </div>
                    </div>
                    <div class="modal-footer border-0 bg-white p-4">
                        <button type="button" class="btn btn-outline-secondary" onclick="closePaymentModal()" style="border-radius: 12px; padding: 0.75rem 1.5rem; font-weight: 500;">Cancelar</button>
                    </div>
                </div>
            </div>
        </div>
    `;
    
    // Remover modal existente si existe
    const existingModal = document.getElementById('paymentModal');
    if (existingModal) {
        existingModal.remove();
    }
    
    // Agregar nuevo modal
    document.body.insertAdjacentHTML('beforeend', paymentModalHtml);
    
    // Mostrar modal
    $("#paymentModal").modal("show");
}

// Función para proceder al pago
function proceedToPayment() {
    if (window.currentPaymentUrl) {
        window.open(window.currentPaymentUrl, '_blank');
        // Cerrar el modal después de un breve delay
        setTimeout(() => {
            closePaymentModal();
        }, 1000);
    } else {
        alert('Error: No se encontró la URL de pago. Por favor, intenta nuevamente.');
    }
}

// Función para inicializar el brick de pago
function initializePaymentBrick() {
    const publicKey = "TEST-8ecea9a2-abbf-48ed-af04-de573e8214ec";
    
    if (typeof MercadoPago === 'undefined') {
        console.error('MercadoPago SDK no está cargado');
        return;
    }
    
    try {
        const mp = new MercadoPago(publicKey);
        const bricksBuilder = mp.bricks();
        
        // Crear el brick de wallet
        bricksBuilder.create('wallet', 'paymentBrick_container', {
            initialization: { 
                preferenceId: window.currentPreferenceId 
            },
            customization: {
                texts: { valueProp: 'smart_option' }
            },
            callbacks: {
                onReady: () => {
                    console.log('MercadoPago Payment Brick listo');
                },
                onSubmit: (param) => {
                    console.log('Formulario de pago enviado:', param);
                },
                onError: (error) => {
                    console.error('Error en MercadoPago Payment:', error);
                }
            }
        });
    } catch (error) {
        console.error('Error al inicializar MercadoPago Payment:', error);
    }
}

// Función para cerrar el modal de pago
function closePaymentModal() {
    $("#paymentModal").modal("hide");
    // Limpiar variables
    window.isPurchase = false;
    window.currentPlanId = null;
    window.currentPreferenceId = null;
    window.currentPaymentUrl = null;
    window.mpInitialized = false;
}

// Función para generar preferencia de pago después del registro
function generatePaymentPreference(companyId, packageType, planId) {
    // Validar que tenemos un plan válido
    if (!planId || planId === 'undefined' || planId === null) {
        console.error('No se puede generar enlace de pago: planId inválido', planId);
        alert('Error: No se pudo identificar el plan seleccionado. Por favor, intenta nuevamente.');
        return;
    }
    
    // Mostrar indicador de carga
    const loadingModal = document.createElement('div');
    loadingModal.className = 'modal fade';
    loadingModal.innerHTML = `
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-body text-center">
                    <div class="spinner-border text-primary mb-3" role="status">
                        <span class="visually-hidden">Cargando...</span>
                    </div>
                    <p>Creando suscripción automática...</p>
                </div>
            </div>
        </div>
    `;
    document.body.appendChild(loadingModal);
    $(loadingModal).modal('show');
    
    // Crear suscripción automáticamente usando la API de MercadoPago
    console.log('Creando suscripción automáticamente con:', { companyId, packageType, planId });
    
    fetch('create_subscription.php', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: `company_id=${companyId}&package_type=${packageType}&plan_id=${planId}`
    })
    .then(response => {
        console.log('Respuesta del servidor:', response.status);
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        return response.json();
    })
    .then(data => {
        console.log('Datos recibidos:', data);
        $(loadingModal).modal('hide');
        document.body.removeChild(loadingModal);
        
        if (data.success && data.payment_url) {
            console.log('URL de pago obtenida:', data.payment_url);
            // Guardar la URL de pago para usar en el modal
            window.currentPaymentUrl = data.payment_url;
            window.currentPreferenceId = data.preference_id;
            
            // Mostrar el modal de pago
            $("#registrationModal").modal("hide");
            
            // Crear modal de pago
            showPaymentModal();
        } else {
            console.error('Error en respuesta:', data);
            alert('Error al crear la suscripción: ' + (data.error || 'Error desconocido'));
        }
    })
    .catch(error => {
        console.error('Error en fetch:', error);
        $(loadingModal).modal('hide');
        document.body.removeChild(loadingModal);
        alert('Error de conexión al crear la suscripción: ' + error.message);
    });
}

// Función para cambiar de plan
function changePlan() {
    $("#registrationModal").modal("hide");
    // Hacer scroll suave a la sección de planes
    $("html, body").animate(
        {
            scrollTop: $("#pricing").offset().top - 100,
        },
        800
    );
}

// Toggle de visibilidad de contraseña
document.addEventListener("DOMContentLoaded", function () {
    const togglePassword = document.getElementById("togglePassword");
    const password = document.getElementById("password");
    const toggleIcon = document.getElementById("toggleIcon");

    if (togglePassword && password && toggleIcon) {
        togglePassword.addEventListener("click", function () {
            const type =
                password.getAttribute("type") === "password" ? "text" : "password";
            password.setAttribute("type", type);
            toggleIcon.classList.toggle("fa-eye");
            toggleIcon.classList.toggle("fa-eye-slash");
        });
    }

    // Validación en tiempo real del formulario
    const form = document.getElementById("registrationForm");
    if (form) {
        // Validar campos en tiempo real
        const inputs = form.querySelectorAll("input, select");
        inputs.forEach((input) => {
            input.addEventListener("blur", function () {
                validateField(this);
            });

            input.addEventListener("input", function () {
                // Limpiar mensajes de error al escribir
                if (this.classList.contains("is-invalid")) {
                    this.classList.remove("is-invalid");
                    this.classList.add("is-valid");
                    
                    // Ocultar mensaje de error específico
                    const errorDiv = this.parentNode.querySelector(".invalid-feedback");
                    if (errorDiv) {
                        errorDiv.style.display = "none";
                    }
                }
                
                // Validar campo si ya estaba marcado como inválido
                if (this.classList.contains("is-invalid")) {
                    validateField(this);
                }
            });
        });

        // Validar RFC en tiempo real
        const rfcInput = document.getElementById("rfc");
        if (rfcInput) {
            rfcInput.addEventListener("input", function () {
                this.value = this.value.toUpperCase();
                
                // Limpiar errores al escribir
                if (this.classList.contains("is-invalid")) {
                    this.classList.remove("is-invalid");
                    this.classList.add("is-valid");
                    const errorDiv = this.parentNode.querySelector(".invalid-feedback");
                    if (errorDiv) {
                        errorDiv.style.display = "none";
                    }
                }
            });
            
            // Validar formato de RFC al perder el foco
            rfcInput.addEventListener("blur", function() {
                const rfcRegex = /^[A-ZÑ&]{3,4}[0-9]{6}[A-Z0-9]{3}$/;
                if (this.value && !rfcRegex.test(this.value)) {
                    this.classList.add('is-invalid');
                    this.classList.remove('is-valid');
                    let errorDiv = this.parentNode.querySelector(".invalid-feedback");
                    if (errorDiv) {
                        errorDiv.textContent = "Formato de RFC inválido (ej: ABC123456DEF)";
                        errorDiv.style.display = "block";
                    }
                } else if (this.value) {
                    this.classList.remove('is-invalid');
                    this.classList.add('is-valid');
                    const errorDiv = this.parentNode.querySelector(".invalid-feedback");
                    if (errorDiv) {
                        errorDiv.style.display = "none";
                    }
                }
            });
        }

        // Validar código postal en tiempo real
        const cpInput = document.getElementById("address");
        if (cpInput) {
            cpInput.addEventListener("input", function () {
                this.value = this.value.replace(/\D/g, "");
                if (this.value.length > 5) {
                    this.value = this.value.slice(0, 5);
                }
            });
        }

        // Validar teléfono en tiempo real
        const phoneInput = document.getElementById("phone");
        if (phoneInput) {
            phoneInput.addEventListener("input", function () {
                let value = this.value.replace(/\D/g, "");
                if (value.startsWith("52")) {
                    value = "+52 " + value.substring(2);
                } else if (value.length === 10) {
                    value = value;
                }
                this.value = value;
                
                // Limpiar errores al escribir
                if (this.classList.contains("is-invalid")) {
                    this.classList.remove("is-invalid");
                    this.classList.add("is-valid");
                    const errorDiv = this.parentNode.querySelector(".invalid-feedback");
                    if (errorDiv) {
                        errorDiv.style.display = "none";
                    }
                }
            });
            
            // Validar formato de teléfono al perder el foco
            phoneInput.addEventListener("blur", function() {
                const phoneRegex = /^[\+]?[0-9\s\-\(\)]{10,15}$/;
                if (this.value && !phoneRegex.test(this.value)) {
                    this.classList.add('is-invalid');
                    this.classList.remove('is-valid');
                    let errorDiv = this.parentNode.querySelector(".invalid-feedback");
                    if (errorDiv) {
                        errorDiv.textContent = "Formato de teléfono inválido";
                        errorDiv.style.display = "block";
                    }
                } else if (this.value) {
                    this.classList.remove('is-invalid');
                    this.classList.add('is-valid');
                    const errorDiv = this.parentNode.querySelector(".invalid-feedback");
                    if (errorDiv) {
                        errorDiv.style.display = "none";
                    }
                }
            });
        }

        // Validar contraseña en tiempo real
        const passwordInput = document.getElementById("password");
        if (passwordInput) {
            passwordInput.addEventListener("input", function() {
                // Limpiar errores al escribir
                if (this.classList.contains("is-invalid")) {
                    this.classList.remove("is-invalid");
                    this.classList.add("is-valid");
                    const errorDiv = this.parentNode.querySelector(".invalid-feedback");
                    if (errorDiv) {
                        errorDiv.style.display = "none";
                    }
                }
            });
            
            passwordInput.addEventListener("blur", function() {
                if (this.value && this.value.length < 8) {
                    this.classList.add('is-invalid');
                    this.classList.remove('is-valid');
                    let errorDiv = this.parentNode.querySelector(".invalid-feedback");
                    if (errorDiv) {
                        errorDiv.textContent = "La contraseña debe tener al menos 8 caracteres";
                        errorDiv.style.display = "block";
                    }
                } else if (this.value) {
                    this.classList.remove('is-invalid');
                    this.classList.add('is-valid');
                    const errorDiv = this.parentNode.querySelector(".invalid-feedback");
                    if (errorDiv) {
                        errorDiv.style.display = "none";
                    }
                }
            });
        }

        // Validación en tiempo real para campos críticos (solo al perder el foco)
        const criticalFields = ["email", "phone", "rfc"];
        criticalFields.forEach((fieldName) => {
            const field = document.getElementById(fieldName);
            if (field) {
                // Limpiar errores al escribir
                field.addEventListener("input", function () {
                    if (this.classList.contains("is-invalid")) {
                        this.classList.remove("is-invalid");
                        this.classList.add("is-valid");
                        const errorDiv = this.parentNode.querySelector(".invalid-feedback");
                        if (errorDiv) {
                            errorDiv.style.display = "none";
                        }
                    }
                });
                
                // Solo validar cuando el usuario termine de escribir (blur)
                field.addEventListener("blur", function () {
                    // Agregar un pequeño delay para evitar validaciones mientras el usuario está escribiendo
                    setTimeout(() => {
                        validateFieldUniqueness(this);
                    }, 500);
                });
            }
        });
    }
});

// Función para validar unicidad de campos críticos
function validateFieldUniqueness(field) {
    const fieldName = field.name;
    const fieldValue = field.value.trim();

    // No validar campos vacíos o con menos de 3 caracteres
    if (!fieldValue || fieldValue.length < 3) {
        return;
    }

    // Validar formato básico antes de enviar
    if (fieldName === 'email' && !fieldValue.includes('@')) {
        return; // No validar emails sin @
    }
    
    if (fieldName === 'phone' && fieldValue.length < 10) {
        return; // No validar teléfonos muy cortos
    }
    
    if (fieldName === 'rfc' && fieldValue.length < 10) {
        return; // No validar RFCs muy cortos
    }

    // Crear FormData solo con el campo a validar
    const formData = new FormData();
    formData.append('field_name', fieldName);
    formData.append('field_value', fieldValue);
    

    // Validar solo este campo
    fetch("validate_single_field.php", {
        method: "POST",
        body: formData,
    })
        .then((response) => {
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            return response.json();
        })
        .then((result) => {
            console.log('Resultado de validación:', result);
            if (result.error) {
                console.error('Error de validación:', result.error);
                return;
            }

            // Verificar si el campo ya existe
            let exists = false;
            let message = "";

            switch (fieldName) {
                case "email":
                    exists = result.email_exists;
                    message = "Este correo electrónico ya está registrado";
                    break;
                case "phone":
                    exists = result.phone_exists;
                    message = "Este teléfono ya está registrado";
                    break;
                case "rfc":
                    exists = result.rfc_exists;
                    message = "Este RFC ya está registrado";
                    break;
            }

            if (exists) {
                // Marcar campo como inválido
                field.classList.remove("is-valid");
                field.classList.add("is-invalid");

                // Mostrar mensaje de error personalizado
                let errorDiv = field.parentNode.querySelector(".invalid-feedback");
                if (errorDiv) {
                    errorDiv.textContent = message;
                    errorDiv.style.display = "block";
                }
            } else {
                // Campo es válido
                field.classList.remove("is-invalid");
                field.classList.add("is-valid");
                
                // Ocultar mensaje de error
                let errorDiv = field.parentNode.querySelector(".invalid-feedback");
                if (errorDiv) {
                    errorDiv.style.display = "none";
                }
            }
        })
        .catch((error) => {
            console.error('Error en validación de campo:', error);
        });
}

// Función para validar campos individuales
function validateField(field) {
    const isValid = field.checkValidity();

    if (isValid) {
        field.classList.remove("is-invalid");
        field.classList.add("is-valid");
        
        // Ocultar mensaje de error si existe
        const errorDiv = field.parentNode.querySelector(".invalid-feedback");
        if (errorDiv) {
            errorDiv.style.display = "none";
        }
    } else {
        field.classList.remove("is-valid");
        field.classList.add("is-invalid");
        
        // Mostrar mensaje de error si existe
        const errorDiv = field.parentNode.querySelector(".invalid-feedback");
        if (errorDiv) {
            errorDiv.style.display = "block";
        }
    }

    return isValid;
}

// Función para validar todo el formulario
function validateForm() {
    const form = document.getElementById("registrationForm");
    const inputs = form.querySelectorAll("input, select");
    let isValid = true;

    inputs.forEach((input, index) => {
        if (!validateField(input)) {
            isValid = false;
        }
    });

    return isValid;
}

// Función para limpiar todos los mensajes de error
function clearAllErrorMessages() {
    // Limpiar clases de validación
    const inputs = document.querySelectorAll(".is-valid, .is-invalid");
    inputs.forEach((input) => {
        input.classList.remove("is-valid", "is-invalid");
    });

    // Ocultar todos los mensajes de error
    const errorMessages = document.querySelectorAll(".invalid-feedback");
    errorMessages.forEach((errorDiv) => {
        errorDiv.style.display = "none";
    });

    // Limpiar mensajes de error generales
    const registrationError = document.getElementById("registrationError");
    if (registrationError) {
        registrationError.style.display = "none";
    }

    const validationInfo = document.getElementById("validationInfo");
    if (validationInfo) {
        validationInfo.style.display = "none";
    }
}

// Limpiar el formulario cuando se cierre el modal
$("#registrationModal").on("hidden.bs.modal", function () {
    // Solo limpiar la URL si no se completó el registro exitosamente
    // La URL se limpiará manualmente después de la redirección exitosa
    if (window.purchaseRedirectUrl && !window.registrationCompleted) {
        window.purchaseRedirectUrl = null;
    }
    
    // Limpiar variables de compra
    window.isPurchase = false;
    window.currentPlanId = null;
    
    document.getElementById("registrationForm").reset();
    
    // Limpiar todos los mensajes de error
    clearAllErrorMessages();
});

// Manejar el envío del formulario
document
    .getElementById("registrationForm")
    .addEventListener("submit", function (e) {
        e.preventDefault();

        // Validar formulario antes de enviar
        if (!validateForm()) {
            // Mostrar primer error
            const firstInvalid = document.querySelector(".is-invalid");
            if (firstInvalid) {
                firstInvalid.scrollIntoView({ behavior: "smooth", block: "center" });
                firstInvalid.focus();
            }
            return;
        }

        // Obtener el formulario
        const form = document.getElementById("registrationForm");

        // Crear FormData para validación
        const formData = new FormData(form);
        

        // Mostrar loading en el botón
        const submitBtn = document.getElementById("submitBtn");
        if (!submitBtn) {
            console.error('Botón submit no encontrado');
            return;
        }
        const originalText = submitBtn.innerHTML;
        submitBtn.innerHTML =
            '<i class="fas fa-spinner fa-spin me-2"></i>Validando datos...';
        submitBtn.disabled = true;

        // Ocultar mensajes de error previos
        document.getElementById("registrationError").style.display = "none";

        // Mostrar mensaje de validación
        document.getElementById("validationInfo").style.display = "block";
        document.getElementById("validationMessage").textContent =
            "Validando que no existan datos duplicados...";

        // Primero validar datos duplicados
        fetch("validate_registration.php", {
            method: "POST",
            body: formData,
        })
            .then((response) => {
                console.log('Respuesta de validación:', response.status);
                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }
                return response.json();
            })
            .then((validationResult) => {
                console.log('Resultado de validación:', validationResult);
                // Verificar si hay errores de validación
                if (validationResult.error) {
                    throw new Error(validationResult.error);
                }

                // Verificar datos duplicados
                let hasDuplicates = false;
                let duplicateMessage = "";

                if (validationResult.email_exists) {
                    duplicateMessage += "El correo electrónico ya está registrado. ";
                    hasDuplicates = true;
                }

                if (validationResult.phone_exists) {
                    duplicateMessage += "El teléfono ya está registrado. ";
                    hasDuplicates = true;
                }

                if (validationResult.company_name_exists) {
                    duplicateMessage += "El nombre de la empresa ya está registrado. ";
                    hasDuplicates = true;
                }

                if (validationResult.rfc_exists) {
                    duplicateMessage += "El RFC ya está registrado. ";
                    hasDuplicates = true;
                }

                if (validationResult.alias_exists) {
                    duplicateMessage += "El alias generado ya está en uso. ";
                    hasDuplicates = true;
                }

                if (hasDuplicates) {
                    throw new Error(duplicateMessage);
                }

                // Si no hay duplicados, proceder con el registro
                if (window.isPurchase) {
                    submitBtn.innerHTML =
                        '<i class="fas fa-spinner fa-spin me-2"></i>Creando cuenta y preparando pago...';
                    document.getElementById("validationMessage").textContent =
                        "Creando tu cuenta y preparando el proceso de pago...";
                } else {
                    submitBtn.innerHTML =
                        '<i class="fas fa-spinner fa-spin me-2"></i>Creando cuenta...';
                    document.getElementById("validationMessage").textContent =
                        "Creando tu cuenta en el sistema...";
                }

                // Enviar datos al registro
                return fetch("registerHandler.php", {
                    method: "POST",
                    body: formData,
                });
            })
            .then((response) => {
                return response.text();
            })
            .then((data) => {
                // Limpiar cualquier error previo
                document.getElementById("registrationError").style.display = "none";
                
                // Verificar si es una respuesta JSON (compra) o texto simple (prueba gratuita)
                let responseData;
                try {
                    responseData = JSON.parse(data);
                } catch (e) {
                    responseData = data;
                }
                
                console.log('Datos de respuesta:', responseData);
                console.log('Es compra?', window.isPurchase);
                console.log('Plan ID:', window.currentPlanId);
                
                if (responseData === "ok" || (responseData.success && !responseData.external_reference)) {
                    // Registro de prueba gratuita exitoso
                    window.registrationCompleted = true;
                    
                    // Éxito - mostrar modal de bienvenida
                    $("#registrationModal").modal("hide");
                    $("#welcomeModal").modal("show");
                    
                    // Reset del flag
                    window.registrationCompleted = false;
                } else if (responseData.success && responseData.external_reference) {
                    // Registro de compra exitoso - generar preferencia de pago
                    window.registrationCompleted = true;
                    
                    // Generar preferencia de pago (esto mostrará el modal de pago)
                    generatePaymentPreference(responseData.company_id, responseData.package_type, window.currentPlanId);
                } else {
                    // Error - mostrar mensaje
                    document.getElementById("registrationError").textContent = data;
                    document.getElementById("registrationError").style.display = "block";
                    // Hacer scroll al error
                    document
                        .getElementById("registrationError")
                        .scrollIntoView({ behavior: "smooth" });
                }
            })
            .catch((error) => {
                console.error('Error en el registro:', error);
                let errorMessage = "Error de conexión. Intenta nuevamente.";
                
                if (error.message) {
                    errorMessage = error.message;
                } else if (error.response) {
                    errorMessage = "Error del servidor. Por favor, intenta nuevamente.";
                }
                
                document.getElementById("registrationError").textContent = errorMessage;
                document.getElementById("registrationError").style.display = "block";
                
                // Hacer scroll al error
                document.getElementById("registrationError").scrollIntoView({ 
                    behavior: "smooth", 
                    block: "center" 
                });
            })
            .finally(() => {
                // Restaurar botón
                submitBtn.innerHTML = originalText;
                submitBtn.disabled = false;

                // Ocultar mensaje de validación
                document.getElementById("validationInfo").style.display = "none";
            });
    });

// Función para mostrar errores de forma clara y visible
function showError(message) {
    var errorDiv = document.getElementById("registrationError");
    errorDiv.innerText = message;
    errorDiv.style.display = "block";
}

// ============================================================================
// FUNCIONALIDAD DEL FORMULARIO POR PASOS
// ============================================================================

let currentStep = 1;
const totalSteps = 4;

// Función para ir al siguiente paso
function nextStep() {
    if (validateCurrentStep()) {
        if (currentStep < totalSteps) {
            currentStep++;
            updateStepDisplay();
        }
    }
}

// Función para ir al paso anterior
function prevStep() {
    if (currentStep > 1) {
        currentStep--;
        updateStepDisplay();
    }
}

// Función para validar el paso actual
function validateCurrentStep() {
    const currentStepElement = document.getElementById(`step${currentStep}`);
    const inputs = currentStepElement.querySelectorAll('input[required], select[required]');
    let isValid = true;
    
    inputs.forEach(input => {
        if (!input.checkValidity()) {
            input.classList.add('is-invalid');
            isValid = false;
        } else {
            input.classList.remove('is-invalid');
            input.classList.add('is-valid');
        }
    });
    
    if (!isValid) {
        showError('Por favor, completa todos los campos obligatorios del paso actual.');
        return false;
    }
    
    // Si es el último paso, preparar la revisión
    if (currentStep === totalSteps - 1) {
        prepareReview();
    }
    
    return true;
}

// Función para actualizar la visualización del paso
function updateStepDisplay() {
    // Ocultar todos los pasos
    for (let i = 1; i <= totalSteps; i++) {
        const stepElement = document.getElementById(`step${i}`);
        if (stepElement) {
            stepElement.classList.remove('active');
            stepElement.style.display = 'none';
        }
    }
    
    // Mostrar el paso actual
    const currentStepElement = document.getElementById(`step${currentStep}`);
    if (currentStepElement) {
        currentStepElement.classList.add('active');
        currentStepElement.style.display = 'block';
    }
    
    // Actualizar indicadores de paso
    updateStepIndicators();
    
    // Actualizar barra de progreso
    updateProgressBar();
    
    // Actualizar botones de navegación
    updateNavigationButtons();
}

// Función para actualizar los indicadores de paso
function updateStepIndicators() {
    const indicators = document.querySelectorAll('.step-indicator');
    indicators.forEach((indicator, index) => {
        const circle = indicator.querySelector('.step-circle');
        const label = indicator.querySelector('.step-label');
        
        if (index + 1 <= currentStep) {
            indicator.classList.add('active');
            if (circle) {
                circle.style.background = 'linear-gradient(135deg, var(--amber) 0%, #f59e0b 100%)';
                circle.style.color = 'white';
                circle.style.boxShadow = '0 4px 12px rgba(245, 158, 11, 0.3)';
            }
            if (label) {
                label.style.color = 'var(--navy)';
            }
        } else {
            indicator.classList.remove('active');
            if (circle) {
                circle.style.background = '#e2e8f0';
                circle.style.color = '#64748b';
                circle.style.boxShadow = 'none';
            }
            if (label) {
                label.style.color = '#64748b';
            }
        }
    });
}

// Función para actualizar la barra de progreso
function updateProgressBar() {
    const progress = (currentStep / totalSteps) * 100;
    document.getElementById('progressBar').style.width = progress + '%';
    
    // Actualizar contador de pasos
    const stepCounter = document.getElementById('stepCounter');
    if (stepCounter) {
        stepCounter.textContent = `Paso ${currentStep} de ${totalSteps}`;
    }
}

// Función para actualizar los botones de navegación
function updateNavigationButtons() {
    const prevBtn = document.getElementById('prevBtn');
    const nextBtn = document.getElementById('nextBtn');
    const submitBtn = document.getElementById('submitBtn');
    const walletContainer = document.getElementById('walletBrick_container');
    
    // Botón anterior
    if (currentStep === 1) {
        prevBtn.style.display = 'none';
    } else {
        prevBtn.style.display = 'block';
    }
    
    // Botón siguiente/enviar
    if (currentStep === totalSteps) {
        nextBtn.style.display = 'none';
        submitBtn.style.display = 'block';
        
        // Actualizar texto del botón según el tipo de acción
        if (window.isPurchase) {
            submitBtn.innerHTML = '<i class="fas fa-credit-card me-2"></i>Completar Compra';
        } else {
            submitBtn.innerHTML = '<i class="fas fa-check me-2"></i>Completar Registro';
        }
        
        // Mostrar MercadoPago solo si es una compra
        if (window.isPurchase && walletContainer) {
            walletContainer.style.display = 'block';
            // Inicializar MercadoPago si es necesario
            initializeMercadoPago();
        } else if (walletContainer) {
            walletContainer.style.display = 'none';
        }
    } else {
        nextBtn.style.display = 'block';
        submitBtn.style.display = 'none';
        if (walletContainer) {
            walletContainer.style.display = 'none';
        }
    }
}

// Función para preparar la revisión
function prepareReview() {
    const companyName = document.getElementById('company_name').value;
    const username = document.getElementById('username').value;
    const email = document.getElementById('email').value;
    const phone = document.getElementById('phone').value;
    const regimenFiscal = document.getElementById('regimen_fiscal');
    const rfc = document.getElementById('rfc').value;
    const address = document.getElementById('address').value;
    
    const regimenText = regimenFiscal.options[regimenFiscal.selectedIndex].text;
    
    document.getElementById('review-company').textContent = companyName;
    document.getElementById('review-admin').textContent = `${username} | ${email} | ${phone}`;
    document.getElementById('review-fiscal').textContent = `${regimenText} | RFC: ${rfc} | CP: ${address}`;
}

// Función para resetear el formulario por pasos
function resetFormSteps() {
    currentStep = 1;
    updateStepDisplay();
    
    // Limpiar todos los mensajes de error
    clearAllErrorMessages();
}

// Event listeners para el formulario por pasos
$(document).ready(function() {
    // Botón siguiente
    $(document).on('click', '#nextBtn', function() {
        nextStep();
    });
    
    // Botón anterior
    $(document).on('click', '#prevBtn', function() {
        prevStep();
    });
    
    // Inicializar el formulario por pasos
    setTimeout(function() {
        updateStepDisplay();
    }, 100);
    
    // Event listener para cuando se cierre el modal de bienvenida
    $("#welcomeModal").on("hidden.bs.modal", function() {
        // Limpiar flag de compra
        window.isPurchase = false;
    });
    
    // Event listener para cuando se abra el modal de registro
    $("#registrationModal").on("shown.bs.modal", function() {
        // Asegurar que solo se muestre el primer paso
        currentStep = 1;
        updateStepDisplay();
    });
});
