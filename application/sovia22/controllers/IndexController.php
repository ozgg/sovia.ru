<?php

class IndexController extends Ext_Controller_Action
{
    public function indexAction()
    {
    }

    public function aboutAction()
    {
        $this->_headTitle('О проекте');
        $description = 'Информация о проекте «Совия», история и идеология';
        $this->setDescription($description);
    }
}