<?php
/**
 *
 *
 * Date: 06.08.12
 * Time: 1:34
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */
class ArticlesController extends Ext_Controller_Action
{
    public function indexAction()
    {
        $this->_headTitle('Блог и статьи');
        $this->_headTitle("Страница {$this->_page}");
        $table  = new Posting();
        $mapper = $table->getMapper();
        $mapper->article()
               ->isInternal($this->_user->getId() > 0)
               ->minimalRank($this->_user->getRank())
               ->recent();
        $paginator = $mapper->paginate($this->_page, 10);
        $entries   = $paginator->getCurrentItems();
        $titles    = array();
        /** @var $entry Posting_Row */
        foreach ($entries as $entry) {
            $titles[] = "«{$entry->getTitle()}»";
        }
        $description = "Страница {$this->_page} со статьями.";
        $description .= ' ' . implode(', ', $titles);
        $this->view->assign('paginator', $paginator);
        $this->view->assign('entries',   $entries);
        $this->view->assign('page',      $this->_page);
        $this->setDescription($description);
        if ($this->_getParam('canonical', false)) {
            $href = $this->_url(array(), 'articles', true);
            $this->_headLink(array('rel' => 'canonical', 'href' => $href));
        }
    }
}
