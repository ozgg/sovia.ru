<?php
/**
 * Date: 14.01.12
 * Time: 13:58
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */

class Posting_Community_Row extends Ext_Db_Table_Row
{
    public function getId()
   	{
   		return $this->get('id');
   	}

   	public function getLevel()
   	{
   		return $this->get('level');
   	}

   	public function getOwnerId()
   	{
   		return $this->get('owner_id');
   	}

   	public function getParentId()
   	{
   		return $this->get('parent_id');
   	}

    public function getLeftKey()
    {
        return $this->get('left_key');
    }

    public function getRightKey()
    {
        return $this->get('right_key');
    }

   	public function getCreatedAt()
   	{
   		return $this->get('created_at');
   	}

   	public function getIsInternal()
   	{
   		return $this->get('is_internal');
   	}

   	public function setIsInternal($isInternal)
   	{
   		$this->set('is_internal', intval($isInternal));

   		return $this;
   	}

   	public function getMinimalRank()
   	{
   		return $this->_minimalRank;
   	}

   	public function setMinimalRank($minimalRank)
   	{
   		$this->_minimalRank = intval($minimalRank);
   		return $this;
   	}

   	public function getTypeId()
   	{
   		return $this->get('type_id');
   	}

   	public function setTypeId($typeId)
   	{
   		$this->_typeId = intval($typeId);
   		return $this;
   	}

   	public function getIsFinal()
   	{
   		return $this->get('is_final');
   	}

   	public function setIsFinal($isFinal)
   	{
   		$this->_isFinal = intval($isFinal);
   		return $this;
   	}

   	public function getHasPosts()
   	{
   		return $this->get('has_posts');
   	}

   	public function setHasPosts($hasPosts)
   	{
   		$this->_hasPosts = intval($hasPosts);
   		return $this;
   	}

   	public function getTitle()
   	{
   		return $this->get('title');
   	}

   	public function setTitle($title)
   	{
   		$this->set('title', $title);

   		return $this;
   	}

   	public function getAlias()
   	{
   		return $this->_alias;
   	}

   	public function setAlias($alias)
   	{
   		$this->_alias = $alias;
   		return $this;
   	}

   	public function getPostingType()
   	{
   		static $cache = array();
   		$id = $this->getTypeId();
   		if (!isset($cache[$id])) {
   			$model = new Default_Model_PostingType();
   			$cache[$id] = $model->find($id);
   			unset($model);
   		}
   		return $cache[$id];
   	}

   	public function getLink()
   	{
   		$link = '/forum/contents/of/';
   		if (!empty($this->_alias)) {
   			$link .= rawurlencode($this->_alias);
   		} else {
   			$link .= $this->getId();
   		}
   		return $link;
   	}

   	public function getOwner()
   	{
   		static $cache = array();
   		$ownerId = $this->getOwnerId();
   		if (!isset($cache[$ownerId])) {
   			$model = new Default_Model_UserItem();
   			$cache[$ownerId] = $model->find($ownerId);
   			unset($model);
   		}
   		return $cache[$ownerId];
   	}

   	public function getPath(Default_Model_PostingCommunity $community)
   	{
   		return $this->getMapper()->getPath($community);
   	}
}
