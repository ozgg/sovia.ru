<?php
define('APPLICATION_PATH', realpath(dirname(__FILE__) . '/../application/3xtr/'));
set_include_path(APPLICATION_PATH . PATH_SEPARATOR . APPLICATION_PATH . '/../../library' . PATH_SEPARATOR . get_include_path());

require_once "Zend/Loader/Autoloader.php";
$autoloader = Zend_Loader_Autoloader::getInstance();

try {
	require '../application/3xtr/bootstrap.php';
} catch (Exception $exception) {
	echo '<html><body><center>'
	   . 'An exception occured while bootstrapping the application.';
	if (defined('APPLICATION_ENVIRONMENT')
		&& APPLICATION_ENVIRONMENT != 'production'
	) {
		echo '<br /><br />' . $exception->getMessage() . '<br />'
		   . '<div align="left">Stack Trace:' 
		   . '<pre>' . $exception->getTraceAsString() . '</pre></div>';
	}
	echo '</center></body></html>';
	exit(1);
}

Zend_Controller_Front::getInstance()->dispatch();
?>