<?php
/**
 * Bootstrap file for application
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */

if (!empty($_SERVER['HOST'])) {
    if (strpos($_SERVER['HOST'], '.local') !== false) {
        $env = 'dev';
    } else {
        $env = 'prod';
    }
} else {
    $env = 'cli';
}
define('APPLICATION_ENV', $env);

require __DIR__ . '/../../lib/Sovia/Loader.php';

spl_autoload_register('\\Sovia\\Loader::load');
