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
        $bootstrap   = $this->getInvokeArg('bootstrap');
        $this->_user = $bootstrap->getResource('user');
        $page = intval($this->_getParam('page', 1));
        if ($page < 1) {
            $page = 1;
        }
        $this->_page = $page;
        $this->view->assign('flashMessage', $this->_getFlashMessage());
    }

    /**
     * Установить сообщение в сессию
     *
     * @param string|array $message
     * @return void
     * @todo передавать массив в представление
     */
    protected function _setFlashMessage($message)
    {
        if (!empty($message)) {
            if (is_array($message)) {
                $message = implode('<br />', $message);
            }
            $storage = new Zend_Session_Namespace('internal');
            /** @noinspection PhpUndefinedFieldInspection */
            $storage->message = $message;
        }
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
        /** @noinspection PhpUndefinedFieldInspection */
        $message = $storage->message;
        if ($clear) {
            /** @noinspection PhpUndefinedFieldInspection */
            $storage->message = null;
        }

        return $message;
    }

    /**
     * @return Zend_Layout
     */
    protected function _getLayout()
    {
        /** @var $helper Zend_Layout_Controller_Action_Helper_Layout */
        $helper = $this->getHelper('layout');

        return $helper->direct();
    }

    /**
     * @param string|null $title
     * @param string|null $setType
     * @return Zend_View_Helper_HeadTitle
     */
    protected function _headTitle($title = null, $setType = null)
    {
        /**
         * @var $view Zend_View
         * @var $helper Zend_View_Helper_HeadTitle
         */
        $view   = $this->view;
        $helper = $view->getHelper('headTitle');

        return $helper->headTitle($title, $setType);
    }

    /**
     * @param string|null $content
     * @param string|null $keyValue
     * @param string $keyType
     * @param array $modifiers
     * @param string $placement
     * @return Zend_View_Helper_HeadMeta
     */
    protected function _headMeta(
        $content = null, $keyValue = null, $keyType = 'name',
        $modifiers = array(),
        $placement = Zend_View_Helper_Placeholder_Container_Abstract::APPEND
    )
    {
        /**
         * @var $view Zend_View
         * @var $helper Zend_View_Helper_HeadMeta
         */
        $view   = $this->view;
        $helper = $view->getHelper('headMeta');

        return $helper->headMeta(
            $content, $keyValue, $keyType, $modifiers, $placement
        );
    }

    /**
     * @param array $urlOptions
     * @param string|null $name
     * @param bool $reset
     * @param bool $encode
     * @return string
     */
    protected function _url(
        array $urlOptions = array(), $name = null,
        $reset = false, $encode = true
    )
    {
        /**
         * @var $view Zend_View
         * @var $helper Zend_View_Helper_Url
         */
        $view   = $this->view;
        $helper = $view->getHelper('url');

        return $helper->url($urlOptions, $name, $reset, $encode);
    }

    /**
     * @param array $attributes
     * @param string $placement
     * @return Zend_View_Helper_HeadLink
     */
    protected function _headLink(
        array $attributes = null,
        $placement = Zend_View_Helper_Placeholder_Container_Abstract::APPEND
    )
    {
        /**
         * @var $view Zend_View
         * @var $helper Zend_View_Helper_HeadLink
         */
        $view   = $this->view;
        $helper = $view->getHelper('headLink');

        return $helper->headLink($attributes, $placement);
    }

    /**
     * @param $description
     * @return Zend_View_Helper_HeadMeta
     */
    protected function setDescription($description)
    {
        /** @noinspection PhpUndefinedMethodInspection */
        return $this->_headMeta()->appendName('description', $description);
    }
}