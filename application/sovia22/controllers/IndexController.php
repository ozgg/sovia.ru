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

    public function sitemapAction()
    {
        header('Content-Type: application/xml;charset=UTF-8');
        $this->_getLayout()->disableLayout();
        $list   = array();
        $host   = "http://{$_SERVER['HTTP_HOST']}";
        $router = Zend_Controller_Front::getInstance()->getRouter();
        $static = array(
            'home', 'tos', 'privacy', 'user_register', 'about',
            'user_login', 'user_forgot', 'user_reset', 'forum', 'dreams',
            'dreams_random', 'dreams_archive', 'fun', 'fun_rave', 'entities',
            'dreambook', 'statistics', 'statistics_symbols', 'articles',
            'about_changes', 'about_features',
        );
        foreach ($static as $name) {
            $url = $router->assemble(array(), $name, true);
            $list[] = array('loc' => "{$host}{$url}");
        }
        $table = new Posting();
        $mapper = $table->getMapper();
        $mapper->isInternal(0)->order('id desc');
        foreach ($mapper->fetchAll() as $post) {
            /** @var $post Posting_Row */
            $url = $router->assemble(
                $post->getRouteParameters(), $post->getRouteName(), true
            );
            $list[] = array('loc' => "{$host}{$url}");
        }
        $this->view->assign('list', $list);
    }
}