<?php
$parent = include (dirname(__FILE__) . '/production.php');
$config = array(
    'phpSettings' => array(
        'display_startup_errors' => 1,
        'display_errors' => 1,
    ),
    'resources' => array(
        'frontController' => array(
            'params' => array(
                'displayExceptions' => 1,
            ),
        ),
        'db' => array(
            'params' => array(
                'dbname'   => 'sovia_dev',
                'username' => 'root',
                'password' => 'buttrix',
            ),
        ),
    ),
);

return Merger::merge($parent, $config);