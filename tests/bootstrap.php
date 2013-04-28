<?php
/**
 * Bootstrap file for unit tests
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */

define('APPLICATION_ENV', 'test');

require __DIR__ . '/../lib/Sovia/Loader.php';

spl_autoload_register('\\Sovia\\Loader::load');
