<?php
/**
 * 
 * 
 * 
 * ESTRUCTURA DE LA BASE DE DATOS (subscription_plans):
 * 
 * Ejemplos de la tabla:
 * - ID 1: "1 sucursal mensual" - unaSucursal/mensual - 0% descuento - $400.00
 * - ID 2: "1 sucursal mensual -10%" - unaSucursal/mensual - 10% descuento - $360.00 (precio oferta)
 * - ID 3: "1 sucursal anual" - unaSucursal/anual - 0% descuento - $4800.00
 * - ID 4: "1 sucursal anual -20%" - unaSucursal/anual - 20% descuento - $3840.00 (precio oferta)
 * - ID 5: "Multi sucursal mensual" - multiSucursal/mensual - 0% descuento - $700.00
 * - ID 6: "Multi sucursal mensual -10%" - multiSucursal/mensual - 10% descuento - $630.00 (precio oferta)
 * - ID 7: "Multi sucursal anual" - multiSucursal/anual - 0% descuento - $8400.00
 * - ID 8: "Multi sucursal anual -20%" - multiSucursal/anual - 20% descuento - $6720.00 (precio oferta)
 * 
 * LÓGICA DEL SISTEMA:
 * 1. Obtiene todos los planes activos (status = 1)
 * 2. Para cada combinación tipo/frecuencia, selecciona el plan con mayor descuento
 * 3. Muestra automáticamente los mejores precios disponibles
 * 4. Los tabs "Mensual" y "Anual" cambian dinámicamente los precios y links
 */

require_once 'config.php';

/**
 * Obtiene todos los planes de suscripción activos desde la base de datos
 * 
 * @param PDO $pdo Conexión a la base de datos
 * @return array Array de planes ordenados por tipo, frecuencia y descuento descendente
 * 
 * Ejemplo de resultado:
 * [
 *   ['id' => 2, 'type' => 'unaSucursal', 'frequency' => 'mensual', 'discount' => 10, 'price_base' => 400, 'price_offer' => 360],
 *   ['id' => 1, 'type' => 'unaSucursal', 'frequency' => 'mensual', 'discount' => 0, 'price_base' => 400, 'price_offer' => null],
 *   ['id' => 4, 'type' => 'unaSucursal', 'frequency' => 'anual', 'discount' => 20, 'price_base' => 4800, 'price_offer' => 3840],
 *   // ... etc
 * ]
 */
function getSubscriptionPlans($pdo) {
    $query = "SELECT * FROM subscription_plans WHERE status = 1 ORDER BY type, frequency, discount DESC";
    $stmt = $pdo->prepare($query);
    $stmt->execute();
    return $stmt->fetchAll();
}

/**
 * Formatea un precio en formato de pesos mexicanos
 * 
 * @param float $price Precio a formatear
 * @return string Precio formateado con símbolo de peso y separadores de miles
 * 
 * Ejemplos:
 * - formatPrice(400) → "$400"
 * - formatPrice(3600) → "$3,600"
 * - formatPrice(4800) → "$4,800"
 */
function formatPrice($price) {
    return '$' . number_format($price, 0, '.', ',');
}

/**
 * Obtiene el plan con mayor descuento para cada combinación tipo/frecuencia
 * 
 * @param array $plans Array de planes desde la base de datos
 * @return array Array asociativo con los mejores planes por categoría
 * 
 * LÓGICA:
 * - Para cada combinación tipo_frecuencia, selecciona el plan con mayor descuento
 * - Si no hay descuento, usa el plan con descuento 0%
 * 
 * Ejemplo de resultado basado en la tabla:
 * [
 *   'unaSucursal_mensual' => ['id' => 2, 'discount' => 10, 'price_offer' => 360], // Plan con 10% descuento
 *   'unaSucursal_anual' => ['id' => 4, 'discount' => 20, 'price_offer' => 3840],  // Plan con 20% descuento
 *   'multiSucursal_mensual' => ['id' => 6, 'discount' => 10, 'price_offer' => 630], // Plan con 10% descuento
 *   'multiSucursal_anual' => ['id' => 8, 'discount' => 20, 'price_offer' => 6720]   // Plan con 20% descuento
 * ]
 * 
 * Esto significa que:
 * - Para "una sucursal mensual" se mostrará el plan ID 2 ($360 en lugar de $400)
 * - Para "una sucursal anual" se mostrará el plan ID 4 ($3,840 en lugar de $4,800)
 * - Para "multi sucursal mensual" se mostrará el plan ID 6 ($630 en lugar de $700)
 * - Para "multi sucursal anual" se mostrará el plan ID 8 ($6,720 en lugar de $8,400)
 */
function getBestPlans($plans) {
    $bestPlans = [];
    
    foreach ($plans as $plan) {
        $key = $plan['type'] . '_' . $plan['frequency'];
        
        if (!isset($bestPlans[$key]) || $plan['discount'] > $bestPlans[$key]['discount']) {
            $bestPlans[$key] = $plan;
        }
    }
    
    return $bestPlans;
}

// Función para obtener el descuento máximo por tipo y frecuencia
function getMaxDiscounts($plans) {
    $maxDiscounts = [];
    
    foreach ($plans as $plan) {
        $key = $plan['type'] . '_' . $plan['frequency'];
        
        if (!isset($maxDiscounts[$key]) || $plan['discount'] > $maxDiscounts[$key]) {
            $maxDiscounts[$key] = $plan['discount'];
        }
    }
    
    return $maxDiscounts;
}

/**
 * PROCESAMIENTO PRINCIPAL DE PLANES
 * 
 * En esta sección se obtienen y procesan todos los planes para generar
 * las variables que se usarán en el HTML y JavaScript.
 */

try {
    // 1. Obtener todos los planes activos desde la BD
    $plans = getSubscriptionPlans($pdo);
    
    // 2. Seleccionar los mejores planes (con mayor descuento) para cada categoría
    $bestPlans = getBestPlans($plans);
    
    // 3. Obtener los descuentos máximos para mostrar en los tabs
    $maxDiscounts = getMaxDiscounts($plans);
    
    // 4. Asignar los mejores planes a variables específicas
    // Basado en tu tabla, esto resultará en:
    $singleMonthly = $bestPlans['unaSucursal_mensual'] ?? null;  // ID 2: $360 (10% descuento)
    $singleYearly = $bestPlans['unaSucursal_anual'] ?? null;     // ID 4: $3,840 (20% descuento)
    $multiMonthly = $bestPlans['multiSucursal_mensual'] ?? null; // ID 6: $630 (10% descuento)
    $multiYearly = $bestPlans['multiSucursal_anual'] ?? null;    // ID 8: $6,720 (20% descuento)
    
    // 5. Calcular descuentos máximos para mostrar en los tabs
    // Ejemplo: Si hay 10% en mensual y 20% en anual, se mostrará:
    $monthlyMaxDiscount = max($maxDiscounts['unaSucursal_mensual'] ?? 0, $maxDiscounts['multiSucursal_mensual'] ?? 0); // = 10%
    $yearlyMaxDiscount = max($maxDiscounts['unaSucursal_anual'] ?? 0, $maxDiscounts['multiSucursal_anual'] ?? 0);     // = 20%
    
} catch (Exception $e) {
    // En caso de error de conexión a la BD, usar valores por defecto
    // Esto asegura que la página siempre se muestre, aunque sin datos reales
    $singleMonthly = null;
    $singleYearly = null;
    $multiMonthly = null;
    $multiYearly = null;
    $monthlyMaxDiscount = 10;
    $yearlyMaxDiscount = 20;
}
?>

<!-- 
  SECCIÓN DE PRECIOS - GENERADA DINÁMICAMENTE
  =============================================
  
  Esta sección se genera automáticamente desde la base de datos.
  Los precios, descuentos y links se actualizan dinámicamente.
  
  ESTRUCTURA DE LOS TABS:
  - Tab "Pago Mensual": Muestra precios mensuales con descuentos aplicados
  - Tab "Pago Anual": Muestra precios anuales con descuentos aplicados
  
  Los descuentos se muestran automáticamente basándose en los datos de la BD.
  Ejemplo: Si hay 10% de descuento en mensual, se muestra "Pago Mensual -10%"
-->

<section id="precios" class="pricing" aria-labelledby="precios-title">
  <div class="container">
    <h2 id="precios-title" class="center">Planes y precios</h2>
    
    <!-- TABS DE SELECCIÓN MENSUAL/ANUAL -->
    <div
      class="switch"
      role="tablist"
      aria-label="Selecciona periodo de pago"
    >
      <div class="seg">
        <!-- Tab Pago Mensual - Activo por defecto -->
        <button id="tabM" class="active" type="button">
          Pago Mensual 
          <?php if ($monthlyMaxDiscount > 0): ?>
            <span class="discount">-<?= $monthlyMaxDiscount ?>%</span>
          <?php endif; ?>
        </button>
        
        <!-- Tab Pago Anual -->
        <button id="tabA" type="button">
          Pago Anual 
          <?php if ($yearlyMaxDiscount > 0): ?>
            <span class="discount">-<?= $yearlyMaxDiscount ?>%</span>
          <?php endif; ?>
        </button>
      </div>
    </div>
    <!-- GRID DE CARDS DE PRECIOS -->
    <div class="grid-price">
      
      <!-- 
        CARD 1: PLAN UNA SUCURSAL
        ===========================
        
        Este card se genera dinámicamente basándose en los datos de la BD.
        
        LÓGICA DE PRECIOS:
        - Si hay descuento: Muestra precio tachado + precio con descuento
        - Si no hay descuento: Solo muestra el precio base
        
        EJEMPLO CON TU TABLA:
        - Tab "Mensual": Muestra $400 tachado y $360 (plan ID 2 con 10% descuento)
        - Tab "Anual": Muestra $4,800 tachado y $3,840 (plan ID 4 con 20% descuento)
        
        Los IDs de los elementos son importantes para el JavaScript:
        - sOld: Precio tachado (solo visible si hay descuento)
        - sNew: Precio principal (con descuento aplicado)
        - sUnit: Unidad de tiempo (mes/año)
      -->
      <article class="tier">
        <h3>
          Una sucursal <span class="ribbon">Todos los beneficios</span>
        </h3>
        <div class="meta">Ideal para empezar con control total.</div>
        
        <!-- LÍNEA DE PRECIOS DINÁMICA -->
        <div class="price-line">
          <!-- Elemento de precio tachado - siempre presente pero puede estar oculto -->
          <span class="strike" id="sOld" style="display: none;"><?= $singleMonthly ? formatPrice($singleMonthly['price_base']) : '$400' ?></span>
          
          <!-- Precio principal -->
          <span class="amount" id="sNew"><?= $singleMonthly ? formatPrice($singleMonthly['price_offer'] ?: $singleMonthly['price_base']) : '$400' ?></span>
          
          <!-- Unidad de tiempo -->
          <span class="meta" id="sUnit">MXN / mes</span>
        </div>
        <ul class="benefits">
          <li>Usuarios ilimitados</li>
          <li>POS, inventario, compras, ventas y reportes</li>
          <li>Facturación CFDI 4.0</li>
          <li>Actualizaciones constantes</li>
        </ul>
        <div class="cta-col">
          <!-- Botón Probar Gratis - Abre modal de registro -->
          <button
            class="btn btn-cta"
            type="button"
            onclick="openRegistrationModal('single', '<?= $singleMonthly ? ($singleMonthly['frequency'] === 'anual' ? 'yearly' : 'monthly') : 'monthly' ?>')"
            data-utm="true"
            data-utm-content="cta_precio_single_prueba"
            >Probar gratis</button
          >
          
          <!-- Botón Comprar Ahora - Abre modal y luego redirige al link de MercadoPago -->
          <button
            class="btn btn-light"
            type="button"
            id="link-single"
            data-utm="true"
            data-utm-content="cta_precio_single_compra"
            data-plan-id="<?= $singleMonthly ? $singleMonthly['id'] : '' ?>"
            data-plan-url="<?= $singleMonthly ? $singleMonthly['url'] : '#' ?>"
            data-plan-type="single"
            data-plan-period="<?= $singleMonthly ? ($singleMonthly['frequency'] === 'anual' ? 'yearly' : 'monthly') : 'monthly' ?>"
            <?= !$singleMonthly ? 'style="opacity: 0.5; pointer-events: none;"' : '' ?>
            onclick="openPurchaseModal('single', '<?= $singleMonthly ? ($singleMonthly['frequency'] === 'anual' ? 'yearly' : 'monthly') : 'monthly' ?>', '<?= $singleMonthly ? $singleMonthly['url'] : '#' ?>', '<?= $singleMonthly ? $singleMonthly['id'] : '' ?>');"
            >Comprar ahora</button
          >
        </div>
      </article>
      
      <!-- Plan Múltiples Sucursales -->
      <article class="tier">
        <h3>
          Múltiples sucursales <span class="ribbon">Más popular</span>
        </h3>
        <div class="meta">Para negocios con control por tienda.</div>
        <div class="price-line">
          <!-- Elemento de precio tachado - siempre presente pero puede estar oculto -->
          <span class="strike" id="mOld" style="display: none;"><?= $multiMonthly ? formatPrice($multiMonthly['price_base']) : '$700' ?></span>
          
          <!-- Precio principal -->
          <span class="amount" id="mNew"><?= $multiMonthly ? formatPrice($multiMonthly['price_offer'] ?: $multiMonthly['price_base']) : '$700' ?></span>
          
          <!-- Unidad de tiempo -->
          <span class="meta" id="mUnit">MXN / mes</span>
        </div>
        <ul class="benefits">
          <li>Todas las funciones del plan anterior</li>
          <li>Consolidación de reportes por tienda</li>
          <li>Traspasos entre sucursales</li>
          <li>Actualizaciones constantes</li>
        </ul>
        <div class="cta-col">
          <!-- Botón Probar Gratis - Abre modal de registro -->
          <button
            class="btn btn-cta"
            type="button"
            onclick="openRegistrationModal('multi', '<?= $multiMonthly ? ($multiMonthly['frequency'] === 'anual' ? 'yearly' : 'monthly') : 'monthly' ?>')"
            data-utm="true"
            data-utm-content="cta_precio_multi_prueba"
            >Probar gratis</button
          >
          
          <!-- Botón Comprar Ahora - Abre modal y luego redirige al link de MercadoPago -->
          <button
            class="btn btn-light"
            type="button"
            id="link-multi"
            data-utm="true"
            data-utm-content="cta_precio_multi_compra"
            data-plan-id="<?= $multiMonthly ? $multiMonthly['id'] : '' ?>"
            data-plan-url="<?= $multiMonthly ? $multiMonthly['url'] : '#' ?>"
            data-plan-type="multi"
            data-plan-period="<?= $multiMonthly ? ($multiMonthly['frequency'] === 'anual' ? 'yearly' : 'monthly') : 'monthly' ?>"
            <?= !$multiMonthly ? 'style="opacity: 0.5; pointer-events: none;"' : '' ?>
            onclick="openPurchaseModal('multi', '<?= $multiMonthly ? ($multiMonthly['frequency'] === 'anual' ? 'yearly' : 'monthly') : 'monthly' ?>', '<?= $multiMonthly ? $multiMonthly['url'] : '#' ?>', '<?= $multiMonthly ? $multiMonthly['id'] : '' ?>');"
            >Comprar ahora</button
          >
        </div>
      </article>
      
    </div>
    
    <!-- Nota de precios anuales -->
    <p class="small center note">
      * Precios anuales promocionales: 
      <?php if ($singleYearly && $singleYearly['discount'] > 0): ?>
        <?= formatPrice($singleYearly['price_offer']) ?> (Una sucursal) 
      <?php else: ?>
        <?= $singleYearly ? formatPrice($singleYearly['price_base']) : '$4,800' ?> (Una sucursal)
      <?php endif; ?>
      y 
      <?php if ($multiYearly && $multiYearly['discount'] > 0): ?>
        <?= formatPrice($multiYearly['price_offer']) ?> (Múltiples).
      <?php else: ?>
        <?= $multiYearly ? formatPrice($multiYearly['price_base']) : '$8,400' ?> (Múltiples).
      <?php endif; ?>
      Regulares: 
      <?= $singleYearly ? formatPrice($singleYearly['price_base']) : '$4,800' ?> y 
      <?= $multiYearly ? formatPrice($multiYearly['price_base']) : '$8,400' ?> MXN.
    </p>
  </div>
</section>

<script>
/**
 * JAVASCRIPT PARA MANEJO DINÁMICO DE PRECIOS
 * ===========================================
 * 
 * Este script maneja la funcionalidad de cambio entre tabs mensual/anual,
 * actualizando dinámicamente precios, unidades de tiempo y links de compra.
 * 
 * FUNCIONALIDADES:
 * 1. Cambio de precios al hacer clic en los tabs
 * 2. Actualización de unidades de tiempo (mes/año)
 * 3. Cambio de links de compra según el plan seleccionado
 * 4. Manejo de precios con y sin descuento
 * 5. Estado visual consistente de los tabs
 */

document.addEventListener('DOMContentLoaded', function() {
    // Referencias a los elementos del DOM
    const tabM = document.getElementById('tabM');
    const tabA = document.getElementById('tabA');
    
    /**
     * ESTRUCTURA DE PLANES DESDE PHP
     * ===============================
     * 
     * Los planes se pasan desde PHP a JavaScript usando json_encode.
     * Esto permite que el JS tenga acceso a todos los datos de la BD.
     * 
     * Ejemplo de estructura basada en tu tabla:
     * plans = {
     *   single: {
     *     monthly: {id: 2, discount: 10, price_base: 400, price_offer: 360, url: "..."},
     *     yearly: {id: 4, discount: 20, price_base: 4800, price_offer: 3840, url: "..."}
     *   },
     *   multi: {
     *     monthly: {id: 6, discount: 10, price_base: 700, price_offer: 630, url: "..."},
     *     yearly: {id: 8, discount: 20, price_base: 8400, price_offer: 6720, url: "..."}
     *   }
     * }
     */
    const plans = {
        single: {
            monthly: <?= $singleMonthly ? json_encode($singleMonthly) : 'null' ?>,
            yearly: <?= $singleYearly ? json_encode($singleYearly) : 'null' ?>
        },
        multi: {
            monthly: <?= $multiMonthly ? json_encode($multiMonthly) : 'null' ?>,
            yearly: <?= $multiYearly ? json_encode($multiYearly) : 'null' ?>
        }
    };
    
    /**
     * FUNCIÓN PRINCIPAL: ACTUALIZAR PRECIOS
     * =====================================
     * 
     * Esta función actualiza dinámicamente todos los elementos de precios
     * cuando se cambia entre tabs mensual/anual.
     * 
     * @param {string} frequency - 'mensual' o 'anual'
     * 
     * FUNCIONAMIENTO:
     * 1. Determina si es plan anual o mensual
     * 2. Obtiene el plan correspondiente desde la estructura de datos
     * 3. Actualiza precios, unidades de tiempo y links
     * 4. Maneja la visualización de precios con/sin descuento
     * 
     * EJEMPLO DE USO:
     * - updatePrices('mensual') → Muestra precios mensuales (ej: $360, $630)
     * - updatePrices('anual') → Muestra precios anuales (ej: $3,840, $6,720)
     */
    function updatePrices(frequency) {
        const isYearly = frequency === 'anual';
        
        // ACTUALIZAR PRECIOS DE UNA SUCURSAL
        if (plans.single[isYearly ? 'yearly' : 'monthly']) {
            const plan = plans.single[isYearly ? 'yearly' : 'monthly'];
            
            // Obtener elementos del DOM con validación
            const priceElement = document.getElementById('sNew');
            const unitElement = document.getElementById('sUnit');
            const linkElement = document.getElementById('link-single');
            const oldPriceElement = document.getElementById('sOld');
            
            // Verificar que todos los elementos existan antes de usarlos
            if (priceElement && unitElement && linkElement && oldPriceElement) {
                // LÓGICA DE PRECIOS CON/SIN DESCUENTO
                if (plan.discount > 0) {
                    // CON DESCUENTO: Muestra precio tachado + precio oferta
                    // Ejemplo: $400 tachado, $360 como precio principal
                    oldPriceElement.style.display = 'inline';
                    oldPriceElement.textContent = formatPrice(plan.price_base);
                    priceElement.textContent = formatPrice(plan.price_offer);
                } else {
                    // SIN DESCUENTO: Solo muestra precio base, oculta precio tachado
                    oldPriceElement.style.display = 'none';
                    priceElement.textContent = formatPrice(plan.price_base);
                }
                
                // ACTUALIZAR UNIDAD DE TIEMPO Y BOTÓN DE COMPRA
                unitElement.textContent = `MXN / ${isYearly ? 'año' : 'mes'}`;
                linkElement.setAttribute('data-plan-id', plan.id);
                linkElement.setAttribute('data-plan-url', plan.url);
                linkElement.setAttribute('data-plan-period', isYearly ? 'yearly' : 'monthly');
                linkElement.style.opacity = '1';
                linkElement.style.pointerEvents = 'auto';
                
                // ACTUALIZAR EL EVENTO ONCLICK DEL BOTÓN
                const period = isYearly ? 'yearly' : 'monthly';
                linkElement.onclick = () => openPurchaseModal('single', period, plan.url, plan.id);
                
                // ACTUALIZAR BOTÓN "PROBAR GRATIS" CON EL PERÍODO CORRECTO
                const tryButton = document.querySelector('.tier:first-child .btn-cta');
                if (tryButton) {
                    const period = isYearly ? 'yearly' : 'monthly';
                    tryButton.onclick = () => openRegistrationModal('single', period);
                }
            }
        }
        
        // ACTUALIZAR PRECIOS DE MÚLTIPLES SUCURSALES
        if (plans.multi[isYearly ? 'yearly' : 'monthly']) {
            const plan = plans.multi[isYearly ? 'yearly' : 'monthly'];
            
            // Obtener elementos del DOM con validación
            const priceElement = document.getElementById('mNew');
            const unitElement = document.getElementById('mUnit');
            const linkElement = document.getElementById('link-multi');
            const oldPriceElement = document.getElementById('mOld');
            
            // Verificar que todos los elementos existan antes de usarlos
            if (priceElement && unitElement && linkElement && oldPriceElement) {
                // LÓGICA DE PRECIOS CON/SIN DESCUENTO
                if (plan.discount > 0) {
                    // CON DESCUENTO: Muestra precio tachado + precio oferta
                    oldPriceElement.style.display = 'inline';
                    oldPriceElement.textContent = formatPrice(plan.price_base);
                    priceElement.textContent = formatPrice(plan.price_offer);
                } else {
                    // SIN DESCUENTO: Solo muestra precio base, oculta precio tachado
                    oldPriceElement.style.display = 'none';
                    priceElement.textContent = formatPrice(plan.price_base);
                }
                
                // ACTUALIZAR UNIDAD DE TIEMPO Y BOTÓN DE COMPRA
                unitElement.textContent = `MXN / ${isYearly ? 'año' : 'mes'}`;
                linkElement.setAttribute('data-plan-id', plan.id);
                linkElement.setAttribute('data-plan-url', plan.url);
                linkElement.setAttribute('data-plan-period', isYearly ? 'yearly' : 'monthly');
                linkElement.style.opacity = '1';
                linkElement.style.pointerEvents = 'auto';
                
                // ACTUALIZAR EL EVENTO ONCLICK DEL BOTÓN
                const period = isYearly ? 'yearly' : 'monthly';
                linkElement.onclick = () => openPurchaseModal('multi', period, plan.url, plan.id);
                
                // ACTUALIZAR BOTÓN "PROBAR GRATIS" CON EL PERÍODO CORRECTO
                const tryButton = document.querySelector('.tier:last-child .btn-cta');
                if (tryButton) {
                    const period = isYearly ? 'yearly' : 'monthly';
                    tryButton.onclick = () => openRegistrationModal('multi', period);
                }
            }
        }
    }
    
    function formatPrice(price) {
        return '$' + new Intl.NumberFormat('es-MX').format(price);
    }
    

    
    // Event listeners para los tabs
    tabM.addEventListener('click', function() {
        tabM.classList.add('active');
        tabA.classList.remove('active');
        updatePrices('mensual');
    });
    
    tabA.addEventListener('click', function() {
        tabA.classList.add('active');
        tabM.classList.remove('active');
        updatePrices('anual');
    });
    
    /**
     * INICIALIZACIÓN DEL SISTEMA
     * ==========================
     * 
     * Esta sección asegura que el sistema esté en un estado consistente
     * desde el momento en que se carga la página.
     */
    

    
    // 1. ESTADO VISUAL INICIAL CONSISTENTE
    // Asegura que el tab "Mensual" esté marcado como activo
    // y que coincida con los precios mostrados por defecto
    tabM.classList.add('active');
    tabA.classList.remove('active');
    
    // 2. INICIALIZAR CON PRECIOS MENSUALES
    // Por defecto se muestran los precios mensuales (plan mensual activo)
    // Esto llama a updatePrices('mensual') que actualiza todos los elementos
    updatePrices('mensual');
    
    // 3. MANEJO INICIAL DE PRECIOS TACHADOS
    // Si no hay descuento en los planes mensuales, oculta los elementos de precio tachado
    // Esto evita mostrar elementos vacíos o con precios incorrectos
    if (plans.single.monthly && plans.single.monthly.discount === 0) {
        const sOldElement = document.getElementById('sOld');
        if (sOldElement) sOldElement.style.display = 'none';
    }
    if (plans.multi.monthly && plans.multi.monthly.discount === 0) {
        const mOldElement = document.getElementById('mOld');
        if (mOldElement) mOldElement.style.display = 'none';
    }
    
    /**
     * RESUMEN DEL FLUJO DE INICIALIZACIÓN:
     * ====================================
     * 
     * 1. Se carga la página → Tab "Mensual" marcado como activo
     * 2. Se ejecuta updatePrices('mensual') → Se muestran precios mensuales
     * 3. Se ocultan elementos de precio tachado si no hay descuento
     * 4. El usuario ve precios mensuales con el tab correcto marcado
     * 
     * RESULTADO FINAL:
     * - Tab "Mensual" aparece en azul (active)
     * - Se muestran precios mensuales: $360 (una sucursal) y $630 (multi sucursal)
     * - Los links apuntan a los planes mensuales con descuento
     * - Estado visual y funcional son consistentes
     */
});
</script>


