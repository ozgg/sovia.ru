<?php
/**
 * Date: 14.01.12
 * Time: 13:58
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */

class Posting_Community_Row extends Ext_Db_Table_Row
{
    const VIS_PUBLIC     = 0;
    const VIS_REGISTERED = 1;

    public function canBeSeenBy(User_Interface $user)
    {
        $isInternal = $this->getIsInternal();
        if ($isInternal == self::VIS_PUBLIC) {
            $can = true;
        } else {
            $can  = ($user->getId() > 0);
            $can &= ($this->getMinimalRank() <= $user->getRank());
        }

        return $can;
    }


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
   		return $this->get('minimal_rank');
   	}

   	public function setMinimalRank($minimalRank)
   	{
   		$this->set('minimal_rank', intval($minimalRank));

   		return $this;
   	}

   	public function getIsFinal()
   	{
   		return $this->get('is_final');
   	}

   	public function setIsFinal($isFinal)
   	{
   		$this->set('is_final', intval($isFinal));

   		return $this;
   	}

   	public function getHasPosts()
   	{
   		return $this->get('has_posts');
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
   		return $this->get('alias');
   	}

    public function getLink()
    {
        if (strlen($this->get('alias')) > 0) {
            $link = rawurlencode($this->get('alias'));
        } else {
            $link = $this->getId();
        }

        return $link;
    }

    /**
     * @return User_Row
     */
    public function getOwner()
    {
        return $this->findParentRow('User');
    }
}
