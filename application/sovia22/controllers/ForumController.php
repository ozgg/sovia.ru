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
        $this->_headTitle('Форум');
        $description = 'Форум, где можно обсуждать разные темы касательно снов и не только';
        $this->setDescription($description);

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
        $id    = $this->_getParam('id');
        $table = new Posting_Community();
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

        $view = $this->view;
        $this->_headTitle('Форум');
        if ($this->_getParam('canonical', false)) {
            $href = $this->_url(array('id' => $id), 'forum_community', true);
            $this->_headLink(array('rel' => 'canonical', 'href' => $href));
        }

        $this->_headTitle($community->getTitle());
        $this->getPosts($community);

        $mapper = $table->getMapper();
        $mapper->tree()
                ->parent($community)
                ->isInternal($this->_user->getId() > 0)
                ->minimalRank($this->_user->getRank());

        $view->assign('list', $mapper->fetchAll());
        $view->assign('community', $community);
        $ancestors = $table->getPathTo($community)->toArray();
        if (count($ancestors) > 2) {
            array_pop($ancestors);
            array_shift($ancestors);
        } else {
            $ancestors = array();
        }

        $view->assign('ancestors', $ancestors);
        $view->assign('canAdd', $this->_user->getIsActive());
    }

    public function entryAction()
    {
        $id    = intval($this->_getParam('id', 0));
        $alias = $this->_getParam('alias');
        if ($id > 0) {
            $view = $this->view;
            $table  = new Posting();
            $mapper = $table->getMapper();
            $mapper->post()->id($id);
            /** @var $entry Posting_Row */
            $entry = $mapper->fetchRowIfExists('Такой записи нет');
            if (!$entry->canBeSeenBy($this->_user)) {
                $this->_forward('denied', 'error');
            }
            $realAlias = $entry->getAlias();
            if ($this->_getParam('canonical', false) || ($realAlias != $alias)) {
                $parameters = array('id' => $id, 'alias' => $entry->getAlias());
                $href = $this->_url($parameters, 'forum_entry', true);
                $this->_headLink(array('rel' => 'canonical', 'href' => $href));
            }
            $view->assign('entry',   $entry);
            $view->assign('canEdit', $entry->canBeEditedBy($this->_user));
            $community = $entry->getCommunity();
            if (!empty($community)) {
                $view->assign('community', $entry->getCommunity());
                $communityTable = new Posting_Community();
                $ancestors = $communityTable->getPathTo($community)->toArray();
                if (count($ancestors) > 2) {
                    array_pop($ancestors);
                    array_shift($ancestors);
                } else {
                    $ancestors = array();
                }

                $view->assign('ancestors', $ancestors);
            }
            $this->_headTitle($entry->getTitle());
            $this->setDescription($entry->getDescription());
        } else {
            $this->_redirect($this->_url(array(), 'forum', true));
        }
        $this->view->assign('canComment', $this->_user->getIsActive());
        $this->view->assign('avatars',    $this->_user->getAvatars());
    }

    public function newAction()
    {
        if (!$this->_user->getIsActive()) {
            $this->_forward('denied', 'error');
        }
        $id        = $this->_getParam('id');
        $table     = new Posting_Community();
        $community = $table->selectBy('id', $id)->fetchRowIfExists();

        /** @var $community Posting_Community_Row */
        $allowed = ($community->getMinimalRank() <= $this->_user->getRank());
        if ($community->getIsInternal()) {
            $allowed &= ($this->_user->getId() > 0);
        }
        if (!$allowed) {
            $this->_forward('denied', 'Error');
        }
        $this->_headTitle('Форум');
        $this->_headTitle('Добавить запись');
        $form = new Form_Posting_Entry();
        $form->setUser($this->_user);
        $form->setAction($this->_url());
        $this->view->assign('form', $form);
        $this->view->assign('community', $community);
        /** @var $request Zend_Controller_Request_Http */
        $request = $this->getRequest();
        if ($request->isPost()) {
            $data = $request->getPost();
            $data['community_id'] = $community->getId();
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
        $entry = $mapper->post()->id($id)->fetchRowIfExists();

        if (!$entry->canBeEditedBy($this->_user)) {
            $this->_forward('denied', 'error');
        }
        $form  = new Form_Posting_Entry();
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

    /**
     * Редактирование записи и создание новой
     *
     * @param array $data данные формы
     * @param Posting_Row|null $entry
     * @return void
     */
    protected function _edit(array $data, Posting_Row $entry = null)
    {
        $owner = (is_null($entry) ? $this->_user : $entry->getOwner());
        if (isset($data['avatar_id'])) {
            $table = new User_Avatar();
            /** @var $avatar User_Avatar_Row */
            $avatar = $table->selectBy('id', $data['avatar_id'])->fetchRow();
            if (!is_null($avatar)) {
                if (!$avatar->belongsTo($owner)) {
                    $data['avatar_id'] = null;
                }
            } else {
                $data['avatar_id'] = null;
            }
        }
        $data['type']        = Posting_Row::TYPE_POST;
        $data['description'] = '';

        if (is_null($entry)) {
            /** @var $user User_Row */
            $user  = $this->_user;
            $entry = $user->createPosting($data);
            $this->_setFlashMessage('Запись добавлена');
        } else {
            /** @var $community Posting_Community_Row */
            $community = $entry->getCommunity();

            $data['community_id'] = $community->getId();
            $entry->setData($data);
            $entry->touch();
            $entry->save();
            $this->_setFlashMessage('Запись изменена');
        }

        $parameters = array(
            'id'    => $entry->getId(),
            'alias' => $entry->getAlias()
        );
        $this->_redirect($this->_url($parameters, $entry->getRouteName(), true));
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
        $this->_headTitle("Страница {$this->_page}");
        $this->setDescription($description);
    }
}
