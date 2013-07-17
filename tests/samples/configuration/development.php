<?php
/**
 * "Development" configuration for tests
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */

$parent = include __DIR__ . DIRECTORY_SEPARATOR . 'production.php';
$config = [
    'b' => [
        'c' => 'e',
    ]
];

return \Brujo\Configuration::merge($parent, $config);
