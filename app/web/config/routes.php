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
    Route::TYPE_STATIC => [
        '/' => [
            'name'       => 'home',
            'controller' => 'index',
            'action'     => 'index',
        ],
    ],
];