<?php
/**
 * Entry point for application
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */

require __DIR__ . '/../../../bootstrap.php';

$application = new \Sovia\Http\Application(realpath(__DIR__ . '/../'));

$routes = $application->importConfig('routes');
$router = new \Sovia\Router();
$router->import($routes);

$application->getDependencyContainer()->inject('router', $router);