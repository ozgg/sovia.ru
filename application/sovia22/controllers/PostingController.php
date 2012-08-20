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
//        $commentId = $table->getAdapter()->lastInsertId();
//        try {
//            /** @var $mailer Helper_Mailer */
//            $mailer  = $this->_helper->getHelper('Mailer');
//            /** @var $comment Posting_Comment_Row */
//            $comment = $table->selectBy('id', $commentId)->fetchRow();
//            $mailer->comment($entry, $comment, $parent);
//        } catch (Exception $e) {
//            $file = sys_get_temp_dir() . '/sovia-' . date('Y-m-d') . '.log';
//            $text = date('Y-m-d H:i:s') . ' ' . $e->getMessage();
//            file_put_contents($file, $text . PHP_EOL, FILE_APPEND);
//        }
        $this->_setFlashMessage('Комментарий добавлен');
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

//        $this->view->assign('feed', $feed->export('rss'));
    }
}
