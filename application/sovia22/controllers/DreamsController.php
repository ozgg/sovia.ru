<?php
/**
 *
 *
 * Date: 16.07.12
 * Time: 20:09
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */
class DreamsController extends PostingController
{
    const POSTING_TYPE      = Posting_Row::TYPE_DREAM;
    const DEFAULT_COMMUNITY = 1;
    const USE_TAGS          = true;
    const POST_ADDED        = 'Сон добавлен';
    const POST_UPDATED      = 'Сон изменён';

    const TITLE_ADD = 'Описать сон';
    const ROUTE_ADD = 'dreams_new';

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
        foreach ($entries as $entry) {
            /** @var $entry Posting_Row */
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
        $this->view->assign('canAdd', $this->_user->getIsActive());
    }

    public function authorAction()
    {
        $login = $this->_getParam('login');
        if (is_null($login)) {
            $this->_redirect($this->_url(array(), 'dreams', true));
        }
        $userTable = new User();
        /** @var $user User_Row */
        $user      = $userTable->selectBy('login', $login)->fetchRowIfExists();
        $this->_headTitle('Сны пользователя ' . $user->getLogin());
        $this->_headTitle("Страница {$this->_page}");
        $this->view->assign('login', $user->getLogin());
        $table = new Posting();
        $mapper = $table->getMapper();
        $mapper->dream()
               ->user($user)
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
        $description = "Страница {$this->_page} со снами.";
        $description .= ' ' . implode(', ', $titles);
        $this->view->assign('paginator', $paginator);
        $this->view->assign('entries',   $entries);
        $this->view->assign('page',      $this->_page);
        $this->setDescription($description);
        if ($this->_getParam('canonical', false)) {
            $href = $this->_url(array('login' => $login), 'dreams_author', true);
            $this->_headLink(array('rel' => 'canonical', 'href' => $href));
        }
        $this->view->assign('canAdd', $this->_user->getIsActive());
    }

    public function taggedAction()
    {
        $tag = $this->_getParam('tag');
        if (is_null($tag)) {
            $this->_redirect($this->_url(array(), 'dreams', true));
        }
        $this->_headTitle('Сны');
        $this->_headTitle("С меткой «{$tag}»");
        $this->_headTitle("Страница {$this->_page}");
        $description = "Страница {$this->_page} со снами.";

        $table  = new Posting();
        $ids    = $table->findPostIdsForTag($tag);
        if (!empty($ids)) {
            $mapper = $table->getMapper();
            $mapper->dream()
                ->ids($ids)
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

            $description .= ' ' . implode(', ', $titles);
            $this->view->assign('paginator', $paginator);
            $this->view->assign('entries',   $entries);
        }
        if ($this->_getParam('canonical', false)) {
            $href = $this->_url(array('tag' => $tag), 'dreams_tagged', true);
            $this->_headLink(array('rel' => 'canonical', 'href' => $href));
        }
        $this->view->assign('canAdd', $this->_user->getIsActive());
        $this->view->assign('tag',    $tag);
        $this->view->assign('page',   $this->_page);
        $this->setDescription($description);
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
        $this->view->assign('canComment', $this->_user->getIsActive());
        $this->view->assign('avatars',    $this->_user->getAvatars());
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
            $adjacent = $table->findAdjacent($entry, $this->_user);
            $view->assign('adjacent', $adjacent);
            $view->assign('entry', $entry);
            $view->assign('canEdit', $entry->canBeEditedBy($this->_user));
            $this->_headTitle('Сны');
            $this->_headTitle($entry->getTitle());
            $this->setDescription($entry->getDescription());
        } else {
            $this->_redirect($this->_url(array(), 'dreams', true));
        }
        $this->view->assign('canComment', $this->_user->getIsActive());
        $this->view->assign('avatars',    $this->_user->getAvatars());
    }

    public function archiveAction()
    {
        $this->_headTitle('Дневник снов');
        $this->_headTitle('Архив');
        $year  = intval($this->_getParam('year', 0));
        $month = intval($this->_getParam('month', 0));
        $table = new Posting();
        $mapper = $table->getMapper();
        $mapper->dream()
               ->isInternal($this->_user->getId() > 0)
               ->minimalRank($this->_user->getRank());
        $months = array(
            1 => 'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь',
            'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь',
        );
        if ($year > 1990) {
            $this->view->assign('year', $year);
            $this->_headTitle($year);
            if (($month > 0) && ($month < 13)) {
                $this->_headTitle($months[$month]);
                $this->view->assign('month', $months[$month]);
                $this->view->assign('posts', $mapper->archive($year, $month)->fetchAll());
            } else {
                $month = null;
                $this->view->assign('monthPosts', $mapper->months($year)->fetchAll());
            }
        }
        $mapper->reset();
        $years = $mapper->years()->fetchAll();
        $this->view->assign('years', $years);
        $this->view->assign('months', $months);
    }

    public function raveAction()
    {
        $this->_headTitle('Для забавы');
        $this->_headTitle('Бредовый генератор снов');
        $table = new Posting();
        $mapper = $table->getMapper();
        $mapper->dream()->isInternal(0)->random()->limit(rand(3, 5));
        $chunks = array();
        $title  = '';
        foreach ($mapper->fetchAll() as $dream) {
            /** @var $dream Posting_Row */
            $plot = explode("\n", $dream->getBody());
            if (empty($title)) {
                $title = $dream->getTitle();
            } elseif (rand(0, 1)) {
                $title = $dream->getTitle();
            }
            $chunks[] = $plot[rand(0, count($plot) - 1)];
            unset($plot);
        }
        unset($i, $dream, $communityId, $total);
        $body = implode("\n", $chunks);
        $this->view->assign('title', $title);
        $this->view->assign('body', $body);
    }

    public function sidebarAction()
    {
        $table = new Posting();
        $mapper = $table->getMapper();
        $mapper->dream()
               ->isInternal(Posting_Row::VIS_PUBLIC)
               ->random()
               ->limit(1);
        /** @var $dream Posting_Row */
        $dream = $mapper->fetchRow();
        if (!is_null($dream)) {
            $this->view->assign('title', $dream->getTitle());

            $options = array(BodyParser::OPTION_ESCAPE => true);
            $body    = BodyParser::parseEntry($dream->getBody(), $options);
            $href    = $this->_url(array(
                'id' => $dream->getId(),
                'alias' => $dream->getAlias()
            ), $dream->getRouteName(), true);
            $stripped = strip_tags($body['body']);
            $text = mb_substr($stripped, 0, 200);
            if (mb_strlen($text) < mb_strlen($stripped)) {
                $text .= '…';
            }

            $this->view->assign('href', $href);
            $this->view->assign('text', $text);
        }
    }

    public function statisticsAction()
    {
        $words  = array('снов', 'сон', 'сна');
        $table  = new Posting_Tag();
        $mapper = $table->getMapper();
        $mapper->dreams()->byWeight()->limit(10);

        $this->view->assign('tags', $mapper->fetchAll());
        $this->view->assign('words', $words);
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
        $form = new Form_Posting_Dream();
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

        return $mapper->dream()->id($id)->fetchRowIfExists();
    }
}
