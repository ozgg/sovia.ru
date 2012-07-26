<?php
/**
 * Date: 14.01.12
 * Time: 13:52
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */

class Posting_Row extends Ext_Db_Table_Row
{
    const VIS_PUBLIC     = 0;
    const VIS_REGISTERED = 1;
    const VIS_PRIVATE    = 255;

    const TYPE_DREAM   = 1;
    const TYPE_ARTICLE = 2;
    const TYPE_SYMBOL  = 3;
    const TYPE_ENTITY  = 4;
    const TYPE_POST    = 5;

    public function canBeSeenBy(User_Interface $user)
    {
        $isInternal = $this->getIsInternal();
        if ($isInternal == self::VIS_PUBLIC) {
            $can = true;
        } elseif ($isInternal == self::VIS_REGISTERED) {
            $can  = ($user->getId() > 0);
            $can &= ($this->getMinimalRank() <= $user->getRank());
        } else {
            $can = ($user->getId() == $this->getOwner()->getId());
        }

        return $can;
    }

    public function isArticle()
    {
        return ($this->get('type') == self::TYPE_ARTICLE);
    }

    /**
     * Дата написания записи в формате d.m.Y
     *
     * @return string
     */
    public function getDate()
    {
        $time = strtotime($this->get('created_at'));

        return date('d.m.Y', $time);
    }

    /**
     * @return Posting_Type_Row
     */
    public function getType()
    {
        return $this->findParentRow('Posting_Community')->findParentRow('Posting_Type');
    }

    public function getTitle()
    {
        return $this->get('title');
    }

    public function getAlias()
    {
        $alias = $this->get('alias');
        if (empty($alias)) {
            $alias = 'entry';
        }

        return $alias;
    }

    public function getPreview()
    {
        return $this->get('body');
    }

    public function getBody()
    {
        return $this->get('body_raw');
    }

    /**
     * @return User_Row
     */
    public function getOwner()
    {
        return $this->findParentRow('User');
    }

    /**
     * @return User_Avatar_Row
     */
    public function getAvatar()
    {
        return $this->findParentRow('User_Avatar');
    }

    public function getAvatarId()
    {
        $avatar = $this->getAvatar();
        if (!is_null($avatar)) {
            $avatarId = $avatar->getId();
        } else {
            $avatarId = 0;
        }

        return $avatarId;
    }

    public function getTags()
    {
        return array();
    }

    public function getDescription()
    {
        return $this->get('description');
    }

    public function getIsInternal()
    {
        return $this->get('is_internal');
    }

    public function getMinimalRank()
    {
        return $this->get('minimal_rank');
    }

    /**
     * @return Posting_Community_Row
     */
    public function getCommunity()
    {
        return $this->findParentRow('Posting_Community');
    }

    public function getComments()
    {
        $table  = new Posting_Comment();
        /** @var $mapper Posting_Mapper */
        $mapper = $table->getMapper()->post($this->getId())->order('left_key');

        return $mapper->fetchAll();
    }

    public function getRouteName()
    {
        switch ($this->get('type')) {
            case self::TYPE_DREAM:
                $route = 'dreams_entry';
                break;
            case self::TYPE_POST:
                $route = 'forum_entry';
                break;
            case self::TYPE_ARTICLE:
                $route = 'articles_entry';
                break;
            case self::TYPE_ENTITY:
                $route = 'entities_entry';
                break;
            case self::TYPE_SYMBOL:
                $route = 'dreambook_entry';
                break;
            default:
                $route = null;
                break;
        }

        return $route;
    }

    public function setData(array $data)
    {
        $this->set('type', $data['type']);
        $this->set('community_id', $data['community_id']);
        $this->set('avatar_id', $data['avatar_id']);
        $this->set('is_internal', $data['is_internal']);
        $this->set('title', $data['title']);
        $this->set('alias', BodyParser::transliterateForUrl($data['title']));
        $this->set('body_raw', $data['body']);
        $this->set('description', $data['description']);

        return $this;
    }

    public function touch()
    {
        $this->set('created_at', new Zend_Db_Expr('now()'));
    }
}
