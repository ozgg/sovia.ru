<?php

/**
 * Bootstrap для приложения
 */
class Bootstrap extends Zend_Application_Bootstrap_Bootstrap
{
    /**
     * @var User_Interface
     */
    protected $_user;

    protected function _initDb()
    {
        $rs = $this->getPluginResource('db');
        $db = $rs->init();

        $request= new Zend_Controller_Request_Http();
        $ip = $request->getServer('REMOTE_ADDR');

        Ext_Db_Table_Row::setRemoteAddr($ip);

        return $db;
    }

    /**
     * Маршрутизация
     *
     * @return Zend_Controller_Router_Rewrite
     */
    protected function _initRouter()
    {
        $front  = Zend_Controller_Front::getInstance();
        /** @var $router Zend_Controller_Router_Rewrite */
        $router = $front->getRouter();
        $router->addDefaultRoutes();
        $routes = require APPLICATION_PATH . '/configs/routes.php';
        foreach ($routes as $name => $route) {
            $router->addRoute($name, $route);
        }

        return $router;
    }

    /**
     * Текущий пользователь
     *
     * @return User_Interface
     */
    protected function _initUser()
    {
        if (empty($this->_user)) {
            $this->bootstrap('db');
            $storage = new Zend_Session_Namespace('auth_user');
            /** @var $user User_Interface */
            $user = $storage->user;
            if (empty($user)) {
                $user = new User_Guest();
            } else {
                $table = new User();
                $table->see($user->getId());
            }

            $this->_user = $user;
        }

        return $this->_user;
    }

    /**
     * Фронт-контроллер
     *
     * @return Zend_Controller_Front
     */
    protected function _initFrontController()
    {
        $rs = $this->getPluginResource('frontController');
        $front = $rs->init();

        return $front;
    }

    /**
     * Шаблонизатор
     *
     * @return Zend_View
     */
    protected function _initView()
    {
        $view = new Zend_View();
        $view->doctype(Zend_View_Helper_Doctype::XHTML5);
        $view->headMeta()->prependHttpEquiv('Content-Type', 'text/html; charset=utf-8');
        $type = Zend_View_Helper_Placeholder_Container_Abstract::PREPEND;
        $view->headTitle()->setSeparator(' / ');
        $view->headTitle('Совия', $type);
        $view->headLink()->appendStylesheet('/css/main.css');
        $view->headScript()->prependFile('/js/jquery.js');
        Zend_Paginator::setDefaultScrollingStyle('Sliding');
        Zend_View_Helper_PaginationControl::setDefaultViewPartial('pager.phtml');

        return $view;
    }

    /**
     * Формы
     * 
     * @return Zend_Loader_Autoloader_Resource
     */
    protected function _initFormloader()
    {
        $resourceLoader = new Zend_Loader_Autoloader_Resource(array(
            'basePath' => APPLICATION_PATH,
            'namespace' => '',
        ));
        $resourceLoader->addResourceType('form', 'forms/', 'Form');
        
        return $resourceLoader;
    }
}
