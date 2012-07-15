<?php

class ErrorController extends Ext_Controller_Action
{

    public function errorAction()
    {
        $this->_headTitle('Ошибка');
        $errors = $this->_getParam('error_handler');
        
        if (!$errors || !$errors instanceof ArrayObject) {
            $this->view->assign('message', 'Вы пришли на страницу ошибки');
            return;
        }
        switch ($errors->type) {
            case Zend_Controller_Plugin_ErrorHandler::EXCEPTION_NO_ROUTE:
            case Zend_Controller_Plugin_ErrorHandler::EXCEPTION_NO_CONTROLLER:
            case Zend_Controller_Plugin_ErrorHandler::EXCEPTION_NO_ACTION:
                // 404 error -- controller or action not found
                $this->getResponse()->setHttpResponseCode(404);
                $priority = Zend_Log::NOTICE;
                $this->view->assign('message', 'Страница не найдена');
                break;
            default:
                // application error
                $this->getResponse()->setHttpResponseCode(500);
                $priority = Zend_Log::CRIT;
                $this->view->assign('message', 'Ошибка сервера');
                break;
        }
        
        // Log exception, if logger available
        /** @var $log Zend_Log */
        if ($log = $this->getLog()) {
            /** @noinspection PhpUndefinedFieldInspection */
            $log->log($this->view->message, $priority, $errors->exception);
            $log->log('Request Parameters', $priority, $errors->request->getParams());
        }
        
        // conditionally display exceptions
        if ($this->getInvokeArg('displayExceptions') == true) {
            $this->view->assign('exception', $errors->exception);
        }
        
        $this->view->assign('request', $errors->request);
    }

    public function getLog()
    {
        /** @var $bootstrap Bootstrap */
        $bootstrap = $this->getInvokeArg('bootstrap');
        if (!$bootstrap->hasResource('Log')) {
            return false;
        }
        $log = $bootstrap->getResource('Log');
        return $log;
    }

    public function deniedAction()
    {
        $this->_headTitle('Доступ запрещён');
        header('HTTP/1.1 403 Forbidden');
    }
}