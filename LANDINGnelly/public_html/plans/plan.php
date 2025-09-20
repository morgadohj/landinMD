<?php

/*
Este archivo crea los planes de suscripción en Mercado Pago.
por lo que al actualizar al token de la empresa se debe ejecutar nuevamente.
funciona de la siguiente manera:
1. Se crea el plan en Mercado Pago.
2. Se guarda el plan en la base de datos.
3. Se actualiza el estado del plan en la base de datos.
4. Se actualiza el estado del plan en Mercado Pago.
5. Se actualiza el estado del plan en la base de datos.
6. Se actualiza el estado del plan en Mercado Pago.

cabe destacar que se debe tener el token de la empresa para crear los planes.
y la base de datos debe tener la tabla subscription_plans.
con las columnas:
	id 	name 	type 	frequency 	discount 	price_base 	price_offer 	url 	status 	created_at 	updated_at 	

    ademas quitar el back_url y reemplazarlo por la url de ngrok para desarrollo.
    si se desean agregar mas planes se debe agregar al array $plans.
*/
require __DIR__ . '/../config.php';

use MercadoPago\Client\PreApprovalPlan\PreApprovalPlanClient;

$plans = [
    [
        "name" => "1 Sucursal mensual",
        "type" => "unaSucursal",
        "frequency" => "mensual",
        "discount" => 0,
        "price_base" => 10, // original 400 cambiado para pruebas
        "price_offer" => null,
        "amount" => 10, // original 400 cambiado para pruebas
        "freq" => 1,
        "freq_type" => "months"
    ],
    [
        "name" => "1 Sucursal mensual -10%",
        "type" => "unaSucursal",
        "frequency" => "mensual",
        "discount" => 10,
        "price_base" => 400,
        "price_offer" => 360,
        "amount" => 360,
        "freq" => 1,
        "freq_type" => "months"
    ],
    [
        "name" => "1 Sucursal anual",
        "type" => "unaSucursal",
        "frequency" => "anual",
        "discount" => 0,
        "price_base" => 4800,
        "price_offer" => null,
        "amount" => 4800,
        "freq" => 12,
        "freq_type" => "months"
    ],
    [
        "name" => "1 Sucursal anual -20%",
        "type" => "unaSucursal",
        "frequency" => "anual",
        "discount" => 20,
        "price_base" => 4800,
        "price_offer" => 3840,
        "amount" => 3840,
        "freq" => 12,
        "freq_type" => "months"
    ],
    [
        "name" => "Multi Sucursal mensual",
        "type" => "multiSucursal",
        "frequency" => "mensual",
        "discount" => 0,
        "price_base" => 700,
        "price_offer" => null,
        "amount" => 700,
        "freq" => 1,
        "freq_type" => "months"
    ],
    [
        "name" => "Multi Sucursal mensual -10%",
        "type" => "multiSucursal",
        "frequency" => "mensual",
        "discount" => 10,
        "price_base" => 700,
        "price_offer" => 630,
        "amount" => 630,
        "freq" => 1,
        "freq_type" => "months"
    ],
    [
        "name" => "Multi Sucursal anual",
        "type" => "multiSucursal",
        "frequency" => "anual",
        "discount" => 0,
        "price_base" => 8400,
        "price_offer" => null,
        "amount" => 8400,
        "freq" => 12,
        "freq_type" => "months"
    ],
    [
        "name" => "Multi Sucursal anual -20%",
        "type" => "multiSucursal",
        "frequency" => "anual",
        "discount" => 20,
        "price_base" => 8400,
        "price_offer" => 6720,
        "amount" => 6720,
        "freq" => 12,
        "freq_type" => "months"
    ]
];

$client = new PreApprovalPlanClient();

foreach ($plans as $p) {
    $request = [
        "reason" => $p['name'],
        "back_url" => BASE_URL . "/mercadoPagoEvents/success.php",
        "auto_recurring" => [
            "frequency" => $p['freq'],
            "frequency_type" => $p['freq_type'],
            "transaction_amount" => $p['amount'],
            "currency_id" => "MXN",
            "start_date" => date("c", strtotime("+1 minute")),
            "end_date" => date("c", strtotime("+1 year"))
        ]
        
    ];

    try {
        $plan = $client->create($request);

        $checkoutUrl = "https://www.mercadopago.com.mx/subscriptions/checkout?preapproval_plan_id=" . $plan->id;

        // Guardar en la tabla subscription_plans
        $stmt = $pdo->prepare("
            INSERT INTO subscription_plans 
            (name, type, frequency, discount, price_base, price_offer, url, status, created_at, updated_at) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())
        ");

        $stmt->execute([
            $p['name'],
            $p['type'],
            $p['frequency'],
            $p['discount'],
            $p['price_base'],
            $p['price_offer'],
            $checkoutUrl,
            1 // 1 = active, 0 = inactive
        ]);

        echo "Plan creado: {$p['name']} → URL: $checkoutUrl<br>";

    } catch (Exception $e) {
    echo "Error creando plan '{$p['name']}': " . $e->getMessage() . "<br>";

    if (method_exists($e, 'getApiResponse')) {
        echo "<pre>";
        print_r($e->getApiResponse()); // Esto muestra el detalle real
        echo "</pre>";
    }
}

}
