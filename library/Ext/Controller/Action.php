<?php
/**
 * Date: 29.08.11
 * Time: 20:09
 */

/**
 * Контроллер действия
 */
abstract class Ext_Controller_Action extends Zend_Controller_Action
{
    /**
     * Текущий пользователь
     * @var User_Interface
     */
    protected $_user;

    /**
     * Текущая страница
     * @var int
     */
    protected $_page = 1;

    public function preDispatch()
    {
        /** @var $bootstrap Zend_Application_Bootstrap_Bootstrap */
        $bootstrap = $this->getInvokeArg('bootstrap');
        $this->_user = $bootstrap->getResource('user');
        $page = intval($this->_getParam('page', 1));
        if ($page < 1) {
            $page = 1;
        }
        $this->_page = $page;
        $this->view->flashMessage = $this->_getFlashMessage();
    }

    /**
     * Установить сообщение в сессию
     *
     * @param string $message
     * @return void
     */
    protected function _setFlashMessage($message)
    {
        $storage = new Zend_Session_Namespace('internal');
        $storage->message = $message;
    }

    /**
     * Получить сообщение из сессии
     *
     * @param bool $clear сбросить после прочтения
     * @return string|null
     */
    protected function _getFlashMessage($clear = true)
    {
        $storage = new Zend_Session_Namespace('internal');
        $message = $storage->message;
        if ($clear) {
            $storage->message = null;
        }

        return $message;
    }
}
