<?php
/**
 * Created by JetBrains PhpStorm.
 *
 * Date: 04.08.12
 * Time: 19:51
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */
class DreambookController extends PostingController
{
    const POSTING_TYPE      = Posting_Row::TYPE_SYMBOL;
    const DEFAULT_COMMUNITY = 3;
    const POST_ADDED        = 'Символ добавлен';
    const POST_UPDATED      = 'Символ изменён';
    const ALWAYS_PUBLIC     = true;

    const TITLE_ADD = 'Описать символ';
    const ROUTE_ADD = 'dreambook_new';

    public function indexAction()
    {
        $this->_headTitle('Сонник');
        $this->view->assign('canAdd', $this->_user->getRank() > 1);
        $letter = 'А';
        $table = new Posting;
        $this->view->assign('words', $table->findSymbolsByLetter($letter));
        if ($this->_getParam('canonical', false)) {
            $href = $this->_url(array(), 'dreambook', true);
            $this->_headLink(array('rel' => 'canonical', 'href' => $href));
        }
    }

    public function letterAction()
    {
        $letter = mb_substr($this->_getParam('letter', ''), 0, 1);
        $table  = new Posting();
        $this->_headTitle('Сонник');
        $this->_headTitle($letter);
        if ($this->_getParam('canonical', false)) {
            $parameters = array('letter' => $letter);

            $href = $this->_url($parameters, 'dreambook_letter', true);
            $this->_headLink(array('rel' => 'canonical', 'href' => $href));
        }

        $this->view->assign('letter', $letter);
        $this->view->assign('words', $table->findSymbolsByLetter($letter));
    }

    public function entryAction()
    {
        $this->_headTitle('Сонник');
        $letter = $this->_getParam('letter');
        $title  = $this->_getParam('symbol');
        if (!is_null($title)) {
            $view = $this->view;
            $table  = new Posting();
            $mapper = $table->getMapper();
            $mapper->symbol()->title($title);
            /** @var $entry Posting_Row */
            $entry = $mapper->fetchRowIfExists('Такой записи нет');

            $sameLetter = ($letter == $entry->getLetter());
            if ($this->_getParam('canonical', false) || !$sameLetter) {
                $parameters = array(
                    'letter' => $entry->getLetter(),
                    'symbol' => $title,
                );

                $href = $this->_url($parameters, 'dreambook_entry', true);
                $this->_headLink(array('rel' => 'canonical', 'href' => $href));
            }
            $adjacent = $table->findAdjacent($entry, $this->_user);
            $view->assign('adjacent', $adjacent);
            $view->assign('entry', $entry);
            $view->assign('canEdit', $entry->canBeEditedBy($this->_user));
            $this->_headTitle($entry->getTitle());
            $this->setDescription($entry->getDescription());
        } else {
            $this->_redirect($this->_url(array(), 'dreambook', true));
        }
        $this->view->assign('canComment', $this->_user->getIsActive());
        $this->view->assign('avatars',    $this->_user->getAvatars());
    }

    public function newAction()
    {
        if (!$this->_user->getIsActive() || $this->_user->getRank() < 2) {
            $this->_forward('denied', 'error');
        }
        parent::newAction();
    }

    public function lettersAction()
    {
        $table = new Posting;
        $letters = $table->getLetters(Posting_Row::TYPE_SYMBOL);

        $this->view->assign('letters', $letters);
    }

    protected function getForm()
    {
        $form = new Form_Posting_Symbol();
        $form->setUser($this->_user);

        return $form;
    }
}
