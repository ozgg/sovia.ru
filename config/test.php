<?php
/**
 * Test environment
 * 
 * Date: 24.05.13
 * Time: 22:28
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */

$parent = include __DIR__ . DIRECTORY_SEPARATOR . 'development.php';
$config = [
    'database' => [
        'name' => 'sovia_test',
    ],
];

return \Brujo\Configuration::merge($parent, $config);