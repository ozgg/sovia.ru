<?php
/**
 * Entry point for application
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */

require __DIR__ . '/../../../bootstrap.php';

$application = new \Atom\Http\Application(realpath(__DIR__ . '/../'));
$application->run();
