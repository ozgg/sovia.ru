<?php
/**
 *
 *
 * Date: 16.07.12
 * Time: 20:09
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */
class DreamsController extends Ext_Controller_Action
{
    public function indexAction()
    {

    }

    public function randomAction()
    {
        $table = new Posting();
        $mapper = $table->getMapper();
        $mapper->dream()->isInternal(Posting_Row::VIS_PUBLIC)->random();
        $this->view->assign('entry', $mapper->fetchRow());
        $this->_headTitle('Сны');
        $this->_headTitle('Случайный сон');
        $this->setDescription('Случайный сон, выбранный из базы.');
    }
}
