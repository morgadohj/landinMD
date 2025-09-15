// ============================================================================
// SISTEMA DE MAPEO DE PLANES PARA REGISTRO
// ============================================================================
// 
// La base de datos tiene un ENUM con estos 4 valores válidos:
// - 'basic'      = Una Sucursal Mensual
// - 'premium'    = Multi Sucursal Mensual  
// - 'basicAnual' = Una Sucursal Anual
// - 'premiumAnual' = Multi Sucursal Anual
//
// Esta función mapea cualquier combinación de plan + período a estos valores válidos
// ============================================================================

// Información de los planes disponibles en la base de datos
// IMPORTANTE: Estos valores deben coincidir exactamente con el ENUM de la tabla company_customer
const packageInfo = {
    basic: { name: "Una Sucursal Mensual", price: "$400.00 MXN / mes" },
    premium: { name: "Multi Sucursal Mensual", price: "$700.00 MXN / mes" },
    basicAnual: { name: "Una Sucursal Anual", price: "$4,880.00 MXN / año" },
    premiumAnual: { name: "Multi Sucursal Anual", price: "$8400.00 MXN / año" },
};

// Función para abrir el modal de registro
// Parámetros:
// - package: tipo de plan ('single', 'multi', 'basic', 'premium')
// - period: período de facturación ('yearly' o 'monthly')
function openRegistrationModal(package, period) {
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
    // Guardar el ID del plan para usar después del registro
    window.currentPlanId = planId;
    
    // Marcar que es una compra para insertar subscription_expires_at
    window.isPurchase = true;
    
    // Abrir el modal de registro con el plan seleccionado
    openRegistrationModal(package, period);
}

// Función para generar preferencia de pago después del registro
function generatePaymentPreference(companyId, packageType, planId) {
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
                    <p>Generando enlace de pago...</p>
                </div>
            </div>
        </div>
    `;
    document.body.appendChild(loadingModal);
    $(loadingModal).modal('show');
    
    // Generar suscripción (PreApproval) basada en el plan seleccionado
    fetch('plans/suscribtion.php', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: `company_id=${companyId}&package_type=${packageType}&plan_id=${planId}`
    })
    .then(response => response.json())
    .then(data => {
        $(loadingModal).modal('hide');
        document.body.removeChild(loadingModal);
        
        if (data.success) {
            // Redirigir al enlace de pago
            window.open(data.payment_url, '_blank');
            window.registrationCompleted = false;
        } else {
            alert('Error al generar el enlace de pago: ' + (data.error || 'Error desconocido'));
        }
    })
    .catch(error => {
        $(loadingModal).modal('hide');
        document.body.removeChild(loadingModal);
        console.error('Error:', error);
        alert('Error de conexión al generar el enlace de pago');
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
            });
        }

        // Validación en tiempo real para campos críticos
        const criticalFields = ["email", "phone", "rfc"];
        criticalFields.forEach((fieldName) => {
            const field = document.getElementById(fieldName);
            if (field) {
                field.addEventListener("blur", function () {
                    validateFieldUniqueness(this);
                });
            }
        });
    }
});

// Función para validar unicidad de campos críticos
function validateFieldUniqueness(field) {
    const fieldName = field.name;
    const fieldValue = field.value;

    if (!fieldValue) return; // No validar campos vacíos

    // Crear FormData solo con el campo a validar
    const formData = new FormData();
    formData.append(fieldName, fieldValue);
    
    // Verificar que el token CSRF esté disponible
    if (!window.csrfToken) {
        console.error('Token CSRF no encontrado para validación en tiempo real');
        return;
    }
    formData.append('csrf_token', window.csrfToken);

    // Validar solo este campo
    fetch("validate_registration.php", {
        method: "POST",
        body: formData,
    })
        .then((response) => response.json())
        .then((result) => {
            if (result.error) {
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
                }
            } else {
                // Campo es válido
                field.classList.remove("is-invalid");
                field.classList.add("is-valid");
            }
        })
        .catch((error) => {
            // Error silencioso en producción
        });
}

// Función para validar campos individuales
function validateField(field) {
    const isValid = field.checkValidity();

    if (isValid) {
        field.classList.remove("is-invalid");
        field.classList.add("is-valid");
    } else {
        field.classList.remove("is-valid");
        field.classList.add("is-invalid");
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

// Limpiar el formulario cuando se cierre el modal
$("#registrationModal").on("hidden.bs.modal", function () {
    // Solo limpiar la URL si no se completó el registro exitosamente
    // La URL se limpiará manualmente después de la redirección exitosa
    if (window.purchaseRedirectUrl && !window.registrationCompleted) {
        window.purchaseRedirectUrl = null;
    }
    
    document.getElementById("registrationForm").reset();
    // Limpiar clases de validación
    const inputs = document.querySelectorAll(".is-valid, .is-invalid");
    inputs.forEach((input) => {
        input.classList.remove("is-valid", "is-invalid");
    });

    // Limpiar mensajes de error
    document.getElementById("registrationError").style.display = "none";

    // Limpiar mensaje de validación
    document.getElementById("validationInfo").style.display = "none";
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
        
        // Agregar token CSRF
        if (!window.csrfToken) {
            console.error('Token CSRF no encontrado');
            return;
        }
        formData.append('csrf_token', window.csrfToken);
        
        // Debug: mostrar el token que se está enviando
        console.log('Token CSRF enviado:', window.csrfToken);

        // Mostrar loading en el botón
        const submitBtn = document.getElementById("submitBtn");
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
            .then((response) => response.json())
            .then((validationResult) => {
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
                submitBtn.innerHTML =
                    '<i class="fas fa-spinner fa-spin me-2"></i>Creando cuenta...';

                // Actualizar mensaje de validación
                document.getElementById("validationMessage").textContent =
                    "Creando tu cuenta en el sistema...";

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
                    
                    // Ocultar modal de registro
                    $("#registrationModal").modal("hide");
                    
                    // Generar preferencia de pago
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
                document.getElementById("registrationError").textContent =
                    error.message || "Error de conexión. Intenta nuevamente.";
                document.getElementById("registrationError").style.display = "block";
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
        if (index + 1 <= currentStep) {
            indicator.classList.add('active');
        } else {
            indicator.classList.remove('active');
        }
    });
}

// Función para actualizar la barra de progreso
function updateProgressBar() {
    const progress = (currentStep / totalSteps) * 100;
    document.getElementById('progressBar').style.width = progress + '%';
}

// Función para actualizar los botones de navegación
function updateNavigationButtons() {
    const prevBtn = document.getElementById('prevBtn');
    const nextBtn = document.getElementById('nextBtn');
    const submitBtn = document.getElementById('submitBtn');
    
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
    } else {
        nextBtn.style.display = 'block';
        submitBtn.style.display = 'none';
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
    
    // Limpiar validaciones
    const inputs = document.querySelectorAll('.is-valid, .is-invalid');
    inputs.forEach(input => {
        input.classList.remove('is-valid', 'is-invalid');
    });
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
