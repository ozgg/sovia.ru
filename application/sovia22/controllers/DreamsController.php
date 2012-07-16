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
        $this->_headTitle('Сны');
        $this->_headTitle("Страница {$this->_page}");
        $table = new Posting();
        $mapper = $table->getMapper();
        $mapper->dream()
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
        $description = "Страница {$this->_page} со снами.";
        $description .= ' ' . implode(', ', $titles);
        $this->view->assign('paginator', $paginator);
        $this->view->assign('entries',   $entries);
        $this->view->assign('page',      $this->_page);
        $this->setDescription($description);
        if ($this->_getParam('canonical', false)) {
            $href = $this->_url(array(), 'dreams', true);
            $this->_headLink(array('rel' => 'canonical', 'href' => $href));
        }
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

    public function entryAction()
    {
        $id    = intval($this->_getParam('id', 0));
        $alias = $this->_getParam('alias');
        if ($id > 0) {
            $view = $this->view;
            $table  = new Posting();
            $mapper = $table->getMapper();
            $mapper->dream()->id($id);
            /** @var $entry Posting_Row */
            $entry = $mapper->fetchRowIfExists('Такой записи нет');
            if (!$entry->canBeSeenBy($this->_user)) {
                $this->_forward('denied', 'error');
            }
            $realAlias = $entry->getAlias();
            if ($this->_getParam('canonical', false) || ($realAlias != $alias)) {
                $parameters = array('id' => $id, 'alias' => $entry->getAlias());
                $href = $this->_url($parameters, 'dreams_entry', true);
                $this->_headLink(array('rel' => 'canonical', 'href' => $href));
            }
            $view->assign('entry', $entry);
            $this->_headTitle($entry->getTitle());
            $this->setDescription($entry->getDescription());
        } else {
            $this->_redirect($this->_url(array(), 'forum', true));
        }
    }
}
