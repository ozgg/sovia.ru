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
    }

    public function newAction()
    {
        if (!$this->_user->getIsActive()) {
            $this->_forward('denied', 'error');
        }
        $this->_headTitle('Описать сущность');
        $form = new Form_Posting_Entity();
        $form->setUser($this->_user);
        $form->setAction($this->_url(array(), 'entities_new', true));
        $this->view->assign('form', $form);
        /** @var $request Zend_Controller_Request_Http */
        $request = $this->getRequest();
        if ($request->isPost()) {
            $data = $request->getPost();
            if ($form->isValid($data)) {
                $this->_edit($data);
            }
        }
    }

    public function editAction()
    {
        if (!$this->_user->getIsActive()) {
            $this->_forward('denied', 'error');
        }
        $this->_headTitle('Редактирование');
        $id = $this->_getParam('id');
        $this->view->assign('message', $this->_getFlashMessage());

        $table = new Posting();
        $mapper = $table->getMapper();
        /** @var $entry Posting_Row */
        $entry = $mapper->entity()->id($id)->fetchRowIfExists();

        if (!$entry->canBeEditedBy($this->_user)) {
            $this->_forward('denied', 'error');
        }
        $form  = new Form_Posting_Entity();
        $form->setUser($this->_user);

        /** @var $request Zend_Controller_Request_Http */
        $request = $this->getRequest();
        if ($request->isPost()) {
            $data = $request->getPost();
            if ($form->isValid($data)) {
                $this->_edit($data, $entry);
            }
        } else {
            if (!empty($entry)) {
                $form->setEntry($entry);
            }
            $this->view->assign('form', $form);
        }
    }
}
