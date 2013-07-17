<?php
/**
 * Application routes
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */

use Brujo\Http\Route;

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
