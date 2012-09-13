<?php
/**
 *
 *
 * Date: 06.08.12
 * Time: 1:34
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */
class ArticlesController extends PostingController
{
    const USE_DESCRIPTION   = true;
    const POST_ADDED        = 'Статья добавлена';
    const POST_UPDATED      = 'Статья изменена';
    const ALWAYS_PUBLIC     = true;

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
        foreach ($entries as $entry) {
            /** @var $entry Posting_Row */
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
        $this->view->assign('canAdd', $this->_user->getRank() > 1);
    }

    public function entryAction()
    {
        $id    = intval($this->_getParam('id', 0));
        $alias = $this->_getParam('alias');
        if ($id > 0) {
            $view = $this->view;
            $table  = new Posting();
            $mapper = $table->getMapper();
            $mapper->article()->id($id);
            /** @var $entry Posting_Row */
            $entry = $mapper->fetchRowIfExists('Такой записи нет');
            if (!$entry->canBeSeenBy($this->_user)) {
                $this->_forward('denied', 'error');
            }
            $realAlias = $entry->getAlias();
            if ($this->_getParam('canonical', false) || ($realAlias != $alias)) {
                $parameters = array('id' => $id, 'alias' => $entry->getAlias());
                $href = $this->_url($parameters, 'articles_entry', true);
                $this->_headLink(array('rel' => 'canonical', 'href' => $href));
            }
            $adjacent = $table->findAdjacent($entry, $this->_user);
            $view->assign('adjacent', $adjacent);
            $view->assign('entry', $entry);
            $view->assign('canEdit', $entry->canBeEditedBy($this->_user));
            $this->_headTitle($entry->getTitle());
            $this->setDescription($entry->getDescription());
        } else {
            $this->_redirect($this->_url(array(), 'articles', true));
        }
        $this->view->assign('canComment', $this->_user->getIsActive());
        $this->view->assign('avatars',    $this->_user->getAvatars());
    }

    public function newAction()
    {
        if (!$this->_user->getIsActive() || $this->_user->getRank() < 1) {
            $this->_forward('denied', 'error');
        }
        parent::newAction();
    }

    public function calendarAction()
    {

    }

    public function tagsAction()
    {

    }

    /**
     * @param $id
     * @return Posting_Row
     */
    protected function getEntry($id)
    {
        $table = new Posting();
        $mapper = $table->getMapper();

        return $mapper->article()->id($id)->fetchRowIfExists();
    }
}
