<?php

class IndexController extends Ext_Controller_Action
{
    public function indexAction()
    {
        $table  = new Posting();
        $mapper = $table->getMapper();
        $mapper->recent()->isInternal(0)->limit(3);
        $this->view->assign('entries', $mapper->fetchAll());
        $rss = $this->_url(array(), 'feed', true);
        /** @noinspection PhpUndefinedMethodInspection */
        $this->view->headLink()->appendAlternate($rss, 'rss', 'Совия');
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

    public function featuresAction()
    {
        $this->_headTitle('О проекте');
        $this->_headTitle('Возможности');
    }

    public function changesAction()
    {
        $this->_headTitle('О проекте');
        $this->_headTitle('История изменений');
    }
}