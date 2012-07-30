<?php
/**
 *
 *
 * Date: 31.07.12
 * Time: 1:34
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */
class StatisticsController extends Ext_Controller_Action
{
    public function indexAction()
    {
        $this->_headTitle('Статистика');
    }

    public function symbolsAction()
    {
        $this->_headTitle('Статистика');
        $this->_headTitle('Символы снов');
        $this->_headTitle('Страница ' . $this->_page);
        $words  = array('снов', 'сон', 'сна');
        $table  = new Posting_Tag();
        $mapper = $table->getMapper();
        $mapper->dreams()->byWeight();
        $paginator = $mapper->paginate($this->_page, 50);
        $entries   = $paginator->getCurrentItems();
        $description = "Страница {$this->_page} со статистикой по символам снов.";

        $this->view->assign('paginator', $paginator);
        $this->view->assign('entries',   $entries);
        $this->view->assign('page',      $this->_page);
        $this->view->assign('words',     $words);

        $this->setDescription($description);
    }
}
