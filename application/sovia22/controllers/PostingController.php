<?php
/**
 *
 *
 * Date: 30.07.12
 * Time: 23:00
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */
class PostingController extends Ext_Controller_Action
{
    const POSTING_TYPE      = Posting_Row::TYPE_ARTICLE;
    const DEFAULT_COMMUNITY = 2;
    const USE_DESCRIPTION   = false;
    const USE_TAGS          = false;
    const POST_ADDED        = 'Запись добавлена';
    const POST_UPDATED      = 'Запись изменена';
    const ALWAYS_PUBLIC     = false;

    const TITLE_ADD = 'Добавить статью';
    const ROUTE_ADD = 'articles_new';

    public function commentsAction()
    {
        if (!$this->_user->getIsActive()) {
            $this->_forward('denied', 'error');
        }
        $id     = $this->_getParam('id');
        $table  = new Posting();
        $mapper = $table->getMapper();
        /** @var $entry Posting_Row */
        $entry = $mapper->id($id)->fetchRowIfExists();
        if (!$entry->canBeSeenBy($this->_user)) {
            $this->_forward('denied', 'error');
        }

        $form = new Form_Posting_Comment();
        /** @var $request Zend_Controller_Request_Http */
        $request = $this->getRequest();
        if ($request->isPost()) {
            $data = $request->getPost();
            $form->setUser($this->_user);
            if ($form->isValid($data)) {
                $this->_comment($data, $entry);
            }
        }
        if ($entry->isSymbol()) {
            $parameters = array(
                'letter' => $entry->getLetter(),
                'symbol' => $entry->getTitle()
            );
        } else {
            $parameters = array(
                'id'    => $entry->getId(),
                'alias' => $entry->getAlias()
            );
        }
        $this->_redirect($this->_url($parameters, $entry->getRouteName(), true));
    }

    public function editAction()
    {
        $this->_headTitle('Редактирование');
        $id = $this->_getParam('id');
        $this->view->assign('message', $this->_getFlashMessage());

        $table = new Posting();
        $mapper = $table->getMapper();
        /** @var $entry Posting_Row */
        $entry = $mapper->dream()->id($id)->fetchRowIfExists();

        if (!$entry->canBeEditedBy($this->_user)) {
            $this->_forward('denied', 'error');
        }
        $form = $this->getForm();

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
        }
        $this->view->assign('form', $form);
    }

    public function rssAction()
    {
        $this->getResponse()->setHeader('Content-Type', 'application/rss+xml', true);
        $this->_getLayout()->disableLayout();
        $host = $_SERVER['HTTP_HOST'];
        $feed = new Zend_Feed_Writer_Feed();
        $feed->setTitle('Совия');
        $feed->setDescription('Сайт о снах');
        $feed->setLink("http://{$host}/");
        $feed->setFeedLink("http://{$host}/rss/", 'rss');
        $feed->setDateModified(time());
        $table   = new Posting();
        $mapper  = $table->getMapper();
        $mapper->isInternal(Posting_Row::VIS_PUBLIC)->recent()->limit(10);
        $entries = $mapper->fetchAll();
        if ($entries->count() > 0) {
            foreach ($entries as $post) {
                /** @var $post Posting_Row */
                $options = $post->getRouteParameters();
                $route   = $post->getRouteName();
                $link    = $this->_url($options, $route, true);
                $entry   = $feed->createEntry();
                $body    = BodyParser::parseEntry(
                    $post->getBody(), $post->getParserOptions()
                );
                $entry->setTitle($post->getTitle());
                $entry->setLink("http://{$host}{$link}");
                $entry->setDateCreated(strtotime($post->getCreatedAt()));
                $entry->setContent(BodyParser::replaceCuts($body['preview'], $link));
                $feed->addEntry($entry);
            }
        }
        echo $feed->export('rss');
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
        $data['type']         = static::POSTING_TYPE;
        if (static::DEFAULT_COMMUNITY > 0) {
            $data['community_id'] = static::DEFAULT_COMMUNITY;
        } elseif (!empty($entry)) {
            $data['community_id'] = $entry->getCommunityId();
        }
        if (!static::USE_DESCRIPTION) {
            $data['description']  = '';
        }
        if (static::ALWAYS_PUBLIC) {
            $data['is_internal']  = Posting_Row::VIS_PUBLIC;
        }
        if (static::USE_TAGS) {
            $noCommas = (strpos($data['tags'], ',') === false);
            $noDots   = (strpos($data['tags'], '.') === false);
            if ($noCommas && $noDots) {
                $tags = explode(' ', $data['tags']);
            } else {
                $tags = explode(',', str_replace('.', ',', $data['tags']));
            }
        } else {
            $tags = array();
        }

        if (is_null($entry)) {
            /** @var $user User_Row */
            $user  = $this->_user;
            $entry = $user->createPosting($data, $tags);
            $this->_setFlashMessage(static::POST_ADDED);
        } else {
            $entry->setData($data);
            $entry->setTags($tags);
            $entry->touch();
            $entry->save();
            $this->_setFlashMessage(static::POST_UPDATED);
        }

        $parameters = $entry->getRouteParameters();
        $this->_redirect($this->_url($parameters, $entry->getRouteName(), true));
    }

    protected function _comment(array $data, Posting_Row $entry)
    {
        $table = new Posting_Comment();
        if (!empty($data['parent_id'])) {
            $parentId = intval($data['parent_id']);
            /** @var $parent Posting_Comment_Row */
            $parent   = $table->selectBy('id', $parentId)->fetchRowIfExists();
            if ($parent->getPosting()->getId() != $entry->getId()) {
                $this->_forward('denied', 'error');
            }
        } else {
            $parent   = null;
            $parentId = null;
        }
        $query  = 'call posting_comment_add(';
        $query .= "{$entry->getId()}, ";
        $userId = $this->_user->getId();
        if ($userId > 0) {
            $query .= $userId . ', ';
        } else {
            $query .= 'null, ';
        }
        if (!empty($parent)) {
            $query .= $parent->getId() . ', ';
        } else {
            $query .= 'null, ';
        }
        if (!empty($data['avatar_id'])) {
            $query .= $data['avatar_id'] . ', ';
        } else {
            $query .= 'null, ';
        }
        /** @var $request Zend_Controller_Request_Http */
        $request = $this->getRequest();
        $query  .= ip2long($request->getServer('REMOTE_ADDR')) . ', ';
        $query  .= $table->getDefaultAdapter()->quote($data['body']);
        $query  .= ')';
        $table->getDefaultAdapter()->query($query);
        try {
            /** @var $mailer Helper_Mailer */
            $mailer  = $this->_helper->getHelper('Mailer');
            $mailer->comment($entry, $this->_user, $data['body'], $parent);
        } catch (Exception $e) {
            $file = sys_get_temp_dir() . '/sovia-' . date('Y-m-d') . '.log';
            $text = date('Y-m-d H:i:s') . ' ' . $e->getMessage();
            file_put_contents($file, $text . PHP_EOL, FILE_APPEND);
        }
        $this->_setFlashMessage('Комментарий добавлен');
    }

    public function newAction()
    {
        $this->_headTitle(static::TITLE_ADD);
        $form = $this->getForm();
        $form->setAction($this->_url(array(), static::ROUTE_ADD, true));
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

    protected function getForm()
    {
        $form = new Form_Posting_Article();
        $form->setUser($this->_user);

        return $form;
    }
}
