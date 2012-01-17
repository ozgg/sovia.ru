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

        $this->view->list = $mapper->fetchAll();
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
}
