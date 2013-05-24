<?php
/**
 * Sample routes for test cases
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */

use Sovia\Route;

return [
    Route::TYPE_STATIC  => [
        '/'      => [
            'name'       => 'home',
            'controller' => 'index',
            'action'     => 'index',
            'methods'    => [Route::METHOD_GET],
        ],
        '/about' => [
            'name'       => 'about',
            'controller' => 'index',
            'action'     => 'about',
            'methods'    => [Route::METHOD_GET],
        ],
    ],
    Route::TYPE_PATTERN => [
        '/articles/:id' => [
            'name'       => 'article',
            'controller' => 'articles',
            'action'     => 'article',
            'methods'    => [Route::METHOD_GET, Route::METHOD_PUT],
        ],
    ],
    Route::TYPE_REGEX   => [
        '/u(?P<user_id>\d+)' => [
            'name'       => 'user',
            'controller' => 'users',
            'action'     => 'user',
            'methods'    => [Route::METHOD_GET],
        ]
    ],
    Route::TYPE_REST    => [
        '/dreams' => [
            'name'       => 'dreams',
            'controller' => 'dreams',
        ],
        '/users'  => [
            'name'       => 'users',
            'controller' => 'users',
            'resources'  => ['dreams', 'comments'],
        ],
    ],
];
