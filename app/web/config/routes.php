<?php
/**
 * Application routes
 *
 * Date: 24.05.13
 * Time: 12:09
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */

use Sovia\Route;

return [
    'home'  => [
        'type'       => Route::TYPE_STATIC,
        'uri'        => '/',
        'controller' => 'index',
        'action'     => 'index',
    ],
    'about' => [
        'uri'        => '/about',
        'controller' => 'about',
        'action'     => 'index',
    ],
];