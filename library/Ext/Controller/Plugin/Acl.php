<?php

class Ext_Controller_Plugin_Acl extends Zend_Controller_Plugin_Abstract
{
    /**
     * @var Ext_Acl
     */
    protected $_acl;

    /**
     * @var string
     */
    protected $_roleName;

    /**
     * @var array
     */
    protected $_deniedAction;

    /**
     * @var boolean
     */
    protected $_throwExceptions = null;

    /**
     * @var boolean
     */
    protected $_denyUnknown = false;

    /**
     * Sets the ACL object
     *
     * @param Zend_Acl $aclData
     * @return void
     */
    public function setAcl(Zend_Acl $aclData)
    {
        $this->_acl = $aclData;
    }

    /**
     * Returns the ACL object
     *
     * @return Ext_Acl
     */
    public function getAcl()
    {
        return $this->_acl;
    }

    /**
     * Sets the ACL role to use
     *
     * @param string $roleName
     * @return void
     */
    public function setRoleName($roleName)
    {
        $this->_roleName = $roleName;
    }

    /**
     * Returns the ACL role used
     *
     * @return string
     */
    public function getRoleName()
    {
        return $this->_roleName;
    }

    /**
     * Sets the denied action
     *
     * @param string $action
     * @param string $controller
     * @param string $module
     * @return void
     */
    public function setDeniedAction($action, $controller = null, $module = null)
    {
        if (!is_array($this->_deniedAction)) {
            $default = array(
                'module' => null,
                'controller' => null,
                'action' => null,
            );
            $this->_deniedAction = $default;
        }

        if (!is_null($module)) {
            $this->_deniedAction['module'] = $module;
        }

        if (!is_null($controller)) {
            $this->_deniedAction['controller'] = $controller;
        }

        $this->_deniedAction['action'] = $action;
    }

    /**
     * Returns the denied action
     *
     * @return array
     */
    public function getDeniedAction()
    {
        return $this->_deniedAction;
    }

    /**
     * Set throw exceptions flag
     *
     * @param boolean $flag
     * @return boolean|Ext_Controller_Plugin_Acl Used as a setter,
     * returns object; as a getter, returns boolean
     */
    public function throwExceptions($flag = null)
    {
        if (!is_null($flag)) {
            $this->_throwExceptions = (bool) $flag;
            return $this;
        }

        return $this->_throwExceptions;
    }

    /**
     * Set deny unknown flag
     *
     * @param boolean $flag
     * @return boolean|Ext_Controller_Plugin_Acl Used as a setter,
     * returns object; as a getter, returns boolean
     */
    public function denyUnknown($flag = null)
    {
        if (!is_null($flag)) {
            $this->_denyUnknown = (bool) $flag;
            return $this;
        }

        return $this->_denyUnknown;
    }

    /**
     * Predispatch
     * Checks if the current user identified by roleName has rights to
     * the requested url (module/controller/action)
     * If not, it will call denyAccess to be redirected to errorPage
     *
     * @param Zend_Controller_Request_Abstract $request
     * @return void
     */
    public function routeShutdown(Zend_Controller_Request_Abstract $request)
    {
        $this->prepare();
        $dispatcher = Zend_Controller_Front::getInstance()->getDispatcher();
        /** Check if the given model/controller/action can be dispatched */
        if (!$dispatcher->isDispatchable($request)) {
            if ($this->denyUnknown()) {
                $this->denyAccess();
            }
        } else {
            $resourceName = $this->getResourceName(
                $request->getModuleName(), $request->getControllerName()
            );

            /** Check if the module/controller/action exists in the acl */
            if (!$this->getAcl()->has($resourceName)) {
                $this->denyAccess(
                    'Resource (' . $resourceName . ') was not found in the Acl'
                );
            } else {
                /** Check if the module/controller/action can be accessed by
                 * the current user
                 */
                if (!$this->getAcl()
                        ->isAllowed(
                            $this->_roleName,
                            $resourceName,
                            $request->getActionName()
                        )
                    ) {
                    /** Redirect to access denied page */
                    $this->denyAccess(
                        'You are not authorized for access this page. ('
                        . $resourceName . ' - '
                        . $request->getActionName() . ')'
                    );
                }
            }
        }
    }

    /**
     * prepare
     *
     * @return void
     */
    public function prepare()
    {
        $front = Zend_Controller_Front::getInstance();

        /** @var $bootstrap Zend_Application_Bootstrap_Bootstrap */
        $bootstrap = $front->getParam('bootstrap');
        $bootstrap->bootstrap('acl');
        $bootstrap->bootstrap('user');
        $this->setAcl($bootstrap->getResource('acl'));

        $this->_roleName = $bootstrap->getResource('user')->getRoleKey();

        /** @var $handler Zend_Controller_Plugin_ErrorHandler */
        $handler = $front->getPlugin('Zend_Controller_Plugin_ErrorHandler');
        $module     = $handler->getErrorHandlerModule();
        $controller = $handler->getErrorHandlerController();
        $action     = $handler->getErrorHandlerAction();

        if (!is_null($module) && ($module != 'default')) {
            if (!$this->getAcl()->has($module)) {
                $resource = $module . ':' . $controller;
                $this->_acl->addResource(new Zend_Acl_Resource($module));
                $this->_acl->addResource(
                    new Zend_Acl_Resource($resource, $module)
                );
                $this->_acl->allow($this->_roleName, $resource, $action);
            }
        } else {
            if (!$this->getAcl()->has($controller)) {
                $this->_acl->addResource(
                    new Zend_Acl_Resource($controller)
                );
            }
            $this->_acl->allow($this->_roleName, $controller, $action);
        }

        $this->setDeniedAction('denied', $controller, $module);
    }

    /**
     * Deny Access Function
     * Redirects to deniedAction, this can be called from an action
     * using the action helper
     *
     * @param string|NULL $message
     * @return void
     */
    public function denyAccess($message = 'Access denied')
    {
        $request = $this->getRequest();
        if (!$this->_throwExceptions) {
            $deniedAction = $this->getDeniedAction();

            $request->setModuleName($deniedAction['module']);
            $request->setControllerName($deniedAction['controller']);
            $request->setActionName($deniedAction['action']);
            $request->setParam('message', $message);
        } else {
            $front   = Zend_Controller_Front::getInstance();
            /** @var $handler Zend_Controller_Plugin_ErrorHandler */
            $handler = $front->getPlugin('Zend_Controller_Plugin_ErrorHandler');

            $request->setModuleName($handler->getErrorHandlerModule());
            $request->setControllerName($handler->getErrorHandlerController());
            $request->setActionName($handler->getErrorHandlerAction());
            throw new Exception($message);
        }
    }

    public function getRouteResourceName()
    {
        return $this->getResourceName(
            $this->_request->getParam('module'),
            $this->_request->getParam('controller')
        );
    }

    public function getResourceName($moduleName = null, $controllerName = null)
    {
        $resourceName = '';

        if (($moduleName != 'default') && ($moduleName != '')) {
            $resourceName .= $moduleName . ':';
        }

        return $resourceName . $controllerName;
    }
}
