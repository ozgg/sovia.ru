<?php
/**
 * "Test" configuration for tests
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */

$parent = include __DIR__ . DIRECTORY_SEPARATOR . 'development.php';
$config = [
    'a' => 1,
    'b' => [
        'f' => 'g',
    ],
    'h' => 'i',
];

return \Brujo\Configuration::merge($parent, $config);