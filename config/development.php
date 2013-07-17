<?php
/**
 * Development configuration
 * 
 * Date: 24.05.13
 * Time: 20:43
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */

$parent = include __DIR__ . DIRECTORY_SEPARATOR . 'production.php';
$config = [
    'database' => [
        'name' => 'sovia_development',
        'user' => 'maxim',
    ],
];

return \Brujo\Configuration::merge($parent, $config);