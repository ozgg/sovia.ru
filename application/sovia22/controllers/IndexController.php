<?php

class IndexController extends Ext_Controller_Action
{
    public function indexAction()
    {
        $table  = new Posting();
        $mapper = $table->getMapper();
        $mapper->recent()->isInternal(0)->limit(3);
        $this->view->assign('posts', $mapper->fetchAll());
    }

    public function aboutAction()
    {
        $this->_headTitle('О проекте');
        $description = 'Информация о проекте «Совия», история и идеология';
        $this->setDescription($description);
    }

    public function funAction()
    {
        $this->_headTitle('Для забавы');
    }
}