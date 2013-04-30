<?php
/**
 * Bootstrap file for application and unit tests
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */

require __DIR__ . '/lib/Sovia/Loader.php';

spl_autoload_register('\\Sovia\\Loader::load');
