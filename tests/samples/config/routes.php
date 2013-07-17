<?php
/**
 * Sample routes for test cases
 *
 * @see RouterTest
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */

use Brujo\Http\Route;

return [
    'home' => [
        'uri'  => '/',
        'name'       => 'home',
        'controller' => 'index',
        'action'     => 'index',
        'methods'    => [Route::METHOD_GET],
    ],
    'about' => [
        'type' => Route::TYPE_STATIC,
        'uri'  => '/about',
        'controller' => 'index',
        'action'     => 'about',
        'methods'    => [Route::METHOD_GET],
    ],
    'article' => [
        'type' => Route::TYPE_PATTERN,
        'uri'  => '/articles/:id',
        'controller' => 'articles',
        'action'     => 'article',
        'methods'    => [Route::METHOD_GET, Route::METHOD_PUT],
    ],
    'user' => [
        'type' => Route::TYPE_REGEX,
        'uri'  => '/u(?P<user_id>\d+)',
        'controller' => 'users',
        'action'     => 'user',
        'methods'    => [Route::METHOD_GET],
    ],
    'dreams' => [
        'type' => Route::TYPE_REST,
        'uri'  => '/dreams',
        'controller' => 'dreams',
    ],
    'users' => [
        'type' => Route::TYPE_REST,
        'uri'  => '/users',
        'controller' => 'users',
        'resources'  => ['dreams', 'comments'],
    ],
];
