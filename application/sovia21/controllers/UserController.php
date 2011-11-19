<?php
/**
 * Date: 20.11.11
 * Time: 1:31
 */
 
class UserController extends Ext_Controller_Action
{
    public function agreementAction()
    {
        $title = 'Пользовательское соглашение';
        $this->view->headTitle($title);
        $this->view->canonical = $this->_getParam('canonical', false);
        $this->view->crumbs = array($title);
    }

    public function privacyAction()
    {
        $title = 'Соглашение о конфиденциальности';
        $this->view->headTitle($title);
        $this->view->canonical = $this->_getParam('canonical', false);
        $this->view->crumbs = array($title);
    }
}
