<?php
/**
 * Date: 16.01.12
 * Time: 22:09
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */

/**
 * Контроллер форума
 */
class ForumController extends Ext_Controller_Action
{
    public function indexAction()
    {
        $this->view->headTitle('Форум');
        $description = 'Форум, где можно обсуждать разные темы касательно снов и не только';
        $this->view->headMeta()->appendName('description', $description);

        $table = new Posting_Community();
        /** @var $parent Posting_Community_Row */
        $parent = $table->find(6)->current();
        $mapper = $table->getMapper();
        $mapper->tree()
               ->minimalRank($this->_user->getRank())
               ->isInternal($this->_user->getId() > 0)
               ->parent($parent);

        $this->view->assign('list', $mapper->fetchAll());
    }

    public function communityAction()
    {
        $id = $this->_getParam('id');
        $table  = new Posting_Community();
        if (is_numeric($id)) {
            $community = $table->selectBy('id', $id)->fetchRowIfExists();
        } else {
            $community = $table->selectBy('alias', $id)->fetchRowIfExists();
        }

        /** @var $community Posting_Community_Row */
        $allowed = ($community->getMinimalRank() <= $this->_user->getRank());
        if ($community->getIsInternal()) {
            $allowed &= ($this->_user->getId() > 0);
        }
        if (!$allowed) {
            $this->_forward('denied', 'Error');
        }

        $this->getPosts($community);

        $view = $this->view;
        $view->headTitle('Форум');
        if ($this->_getParam('canonical', false)) {
            $href = $view->url(array(), 'tos', true);
            $view->headLink(array('rel' => 'canonical', 'href' => $href));
        }

        $view->headTitle($community->getTitle());

        $mapper = $table->getMapper();
        $mapper->tree()
                ->parent($community)
                ->isInternal($this->_user->getId() > 0)
                ->minimalRank($this->_user->getRank());

        $view->list      = $mapper->fetchAll();
        $view->community = $community;
        $ancestors = $table->getPathTo($community)->toArray();
        if (count($ancestors) > 2) {
            array_pop($ancestors);
            array_shift($ancestors);
        } else {
            $ancestors = array();
        }

        $view->ancestors = $ancestors;
    }

    protected function getPosts(Posting_Community_Row $community)
    {
        $table = new Posting();
        $mapper = $table->getMapper();
        $mapper->community($community)
               ->isInternal($this->_user->getId() > 0)
               ->minimalRank($this->_user->getRank())
               ->recent();
        $paginator = $mapper->paginate($this->_page, 5);
        $entries = $paginator->getCurrentItems();
        $titles  = array();
        foreach ($entries as $entry) {
            $titles[] = "«{$entry->title}»";
        }
        $description = "Страница {$this->_page} форума «{$community->getTitle()}».";
        $description .= ' ' . implode(', ', $titles);
        $this->view->assign('paginator', $paginator);
        $this->view->assign('entries',   $entries);
        $this->view->assign('page',      $this->_page);
        $this->view->headTitle("Страница {$this->_page}");
        $this->view->headMeta()->appendName('description', $description);
    }
}
