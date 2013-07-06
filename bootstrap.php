<?php
/**
 * Bootstrap file for application and unit tests
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */

require __DIR__ . '/lib/Atom/Loader.php';

spl_autoload_register('\\Atom\\Loader::load');

date_default_timezone_set('Europe/Moscow');
mb_internal_encoding('UTF-8');