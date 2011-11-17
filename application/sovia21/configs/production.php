<?php
$local = dirname(__FILE__) . '/local.php';
if (file_exists($local)) {
    $super = include $local;
} else {
    $super = array();
}

$config = array(
    'phpSettings' => array(
        'display_startup_errors' => 0,
        'display_errors' => 0,
    ),
    'includePaths' => array(
        'library' => APPLICATION_PATH . '/../library',
    ),
    'bootstrap' => array(
        'path' => APPLICATION_PATH . '/Bootstrap.php',
        'class' => 'Bootstrap',
    ),
    'appnamespace' => 'Application',
    'resources' => array(
        'frontController' => array(
            'controllerDirectory' => APPLICATION_PATH . '/controllers',
            'params' => array(
                'displayExceptions' => 0,
            ),
        ),
        'layout' => array(
            'layoutPath' => APPLICATION_PATH . '/layouts/scripts',
        ),
        'db' => array(
            'adapter'  => 'MYSQLI',
            'params' => array(
                'host'     => '127.0.0.1',
                'username' => '',
                'password' => '',
                'dbname'   => '',
            ),
        ),
    ),
);

return Merger::merge($config, $super);