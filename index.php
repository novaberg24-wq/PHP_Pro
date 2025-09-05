<?php


use Illuminate\Contracts\Http\Kernel;
use Illuminate\Http\Request;

if (!empty($_SERVER['REQUEST_URI'])) {
    if (strpos($_SERVER['REQUEST_URI'], '/install') !== false) {
        if (!file_exists(__DIR__ . '/.env')) {
            copy(__DIR__ . '/.env.example', __DIR__ . '/.env');
        }
    }
}

if (!version_compare(PHP_VERSION, '8.0.2', '>=')) {
    die("Current PHP version: " . PHP_VERSION . "<br>You must upgrade PHP version to 8.0.2 or later");
}

if (file_exists(__DIR__ . '/storage/bc.php')) {
    require __DIR__ . '/storage/bc.php';
}

define('LARAVEL_START', microtime(true));

if (file_exists($maintenance = __DIR__ . '/storage/framework/maintenance.php')) {
    require $maintenance;
}

require __DIR__ . '/vendor/autoload.php';

$app = require_once __DIR__ . '/bootstrap/app.php';

$kernel = $app->make(Kernel::class);

$response = $kernel->handle(
    $request = Request::capture()
)->send();

$kernel->terminate($request, $response);
