<?php
/**
 * Bootstrap file for unit tests
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */

define('APPLICATION_ENV', 'test');

require __DIR__ . '/../lib/Sovia/Loader.php';

spl_autoload_register('\\Sovia\\Loader::load');

$request = new \Sovia\Http\Request($_SERVER);
$request->setGet($_GET);
$request->setPost($_POST);
$request->setFiles($_FILES);
$request->setCookies($_COOKIE);
$request->setBody(file_get_contents('php://input'));

