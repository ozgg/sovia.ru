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
    'tos' => [
        'uri'        => '/tos',
        'controller' => 'index',
        'action'     => 'tos',
    ],
    'archive' => [
        'uri'        => '/dreams/archive',
        'controller' => 'dreams',
        'action'     => 'archive',
    ],
    'random_dream' => [
        'uri'        => '/dreams/random',
        'controller' => 'dreams',
        'action'     => 'random',
    ],
    'articles'     => [
        'uri'       => '/articles',
        'controller' => 'articles',
        'action'     => 'index',
    ],
    'dreams'     => [
        'uri'    => '/dreams',
        'controller' => 'dreams',
        'action'     => 'index',
    ],
    'dreambook' => [
        'uri'    => '/dreambook',
        'controller' => 'dreambook',
        'action'     => 'index',
    ],
    'forum' => [
        'uri' => '/forum',
        'controller' => 'forum',
        'action' => 'index',
    ],
];
