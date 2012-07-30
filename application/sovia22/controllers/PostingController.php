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
        $id = $this->_getParam('id');
        $table = new Posting();
        $mapper = $table->getMapper();
        /** @var $entry Posting_Row */
        $entry = $mapper->entity()->id($id)->fetchRowIfExists();
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
        $parameters = array(
            'id'    => $entry->getId(),
            'alias' => $entry->getAlias()
        );
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
    }
}
