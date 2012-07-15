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
        $this->_headTitle('Форум');
        if ($this->_getParam('canonical', false)) {
            $href = $this->_url(array(), 'tos', true);
            $this->_headLink(array('rel' => 'canonical', 'href' => $href));
        }

        $this->_headTitle($community->getTitle());

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
            if ($entry->getAlias() != $alias) {
                $parameters = array('id' => $id, 'alias' => $entry->getAlias());
                $this->_redirect($this->_url($parameters, 'forum_entry'));
            }
            $view->assign('entry', $entry);
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
