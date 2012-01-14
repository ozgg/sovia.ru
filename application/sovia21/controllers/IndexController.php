<?php

class IndexController extends Ext_Controller_Action
{
    public function indexAction()
    {
    }

    public function aboutAction()
    {
        $this->view->headTitle('О проекте');
        $description = 'Информация о проекте «Совия», история и идеология';
        $this->view->headMeta()->appendName('description', $description);
    }
}