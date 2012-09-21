<?php
/**
 * Контроллер сущностей снов
 *
 * Date: 25.07.12
 * Time: 0:19
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */
class EntitiesController extends PostingController
{
    const POSTING_TYPE      = Posting_Row::TYPE_ENTITY;
    const DEFAULT_COMMUNITY = 4;
    const POST_ADDED        = 'Сущность добавлена';
    const POST_UPDATED      = 'Сущность изменена';
    const ALWAYS_PUBLIC     = true;

    const TITLE_ADD = 'Описать сущность';
    const ROUTE_ADD = 'entities_new';

    public function indexAction()
    {
        $this->_headTitle('Сущности в снах');
        $this->_headTitle("Страница {$this->_page}");
        $table = new Posting();
        $mapper = $table->getMapper();
        $mapper->entity()
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
        $description = "Страница {$this->_page} с описанием сущностей.";
        $description .= ' ' . implode(', ', $titles);
        $this->view->assign('paginator', $paginator);
        $this->view->assign('entries',   $entries);
        $this->view->assign('page',      $this->_page);
        $this->setDescription($description);
        if ($this->_getParam('canonical', false)) {
            $href = $this->_url(array(), 'entities', true);
            $this->_headLink(array('rel' => 'canonical', 'href' => $href));
        }
        $this->view->assign('isActive', $this->_user->getIsActive());
    }

    public function entryAction()
    {
        $this->_headTitle('Сущности снов');
        $id    = intval($this->_getParam('id', 0));
        $alias = $this->_getParam('alias');
        $title = $this->_getParam('title');
        if (($id > 0) || !is_null($title)) {
            $view = $this->view;
            $table  = new Posting();
            $mapper = $table->getMapper();
            $mapper->entity();
            if (!is_null($title)) {
                $mapper->title($title);
            } else {
                $mapper->id($id);
            }
            /** @var $entry Posting_Row */
            $entry = $mapper->fetchRowIfExists('Такой записи нет');
            if (!$entry->canBeSeenBy($this->_user)) {
                $this->_forward('denied', 'error');
            }
            $realAlias = $entry->getAlias();
            if ($this->_getParam('canonical', false) || ($realAlias != $alias)) {
                $parameters = array('id' => $entry->getId(), 'alias' => $entry->getAlias());
                $href = $this->_url($parameters, $entry->getRouteName(), true);
                $this->_headLink(array('rel' => 'canonical', 'href' => $href));
            }
            $adjacent = $table->findAdjacent($entry, $this->_user);
            $view->assign('adjacent', $adjacent);
            $view->assign('entry', $entry);
            $view->assign('canEdit', $entry->canBeEditedBy($this->_user));
            $this->_headTitle($entry->getTitle());
            $this->setDescription($entry->getDescription());
        } else {
            $this->_redirect($this->_url(array(), 'entities', true));
        }
        $this->view->assign('canComment', $this->_user->getIsActive());
        $this->view->assign('avatars',    $this->_user->getAvatars());
        $this->view->assign('avatarId',   $this->_user->getAvatarId());
    }

    public function newAction()
    {
        if (!$this->_user->getIsActive()) {
            $this->_forward('denied', 'error');
        }
        parent::newAction();
    }

    protected function getForm()
    {
        $form = new Form_Posting_Entity();
        $form->setUser($this->_user);

        return $form;
    }

    /**
     * @param $id
     * @return Posting_Row
     */
    protected function getEntry($id)
    {
        $table = new Posting();
        $mapper = $table->getMapper();

        return $mapper->entity()->id($id)->fetchRowIfExists();
    }
}
