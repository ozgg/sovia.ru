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

    public function canBeEditedBy(User_Interface $user)
    {
        return ($this->getOwner()->getId() == $user->getId());
    }

    public function isArticle()
    {
        return ($this->get('type') == self::TYPE_ARTICLE);
    }

    public function isSymbol()
    {
        return ($this->get('type') == self::TYPE_SYMBOL);
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
     * @return string
     */
    public function getCreatedAt()
    {
        return $this->get('created_at');
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
        $tags = $this->findManyToManyRowset('Posting_Tag', 'Posting_HasTag');

        return $tags;
    }

    public function getTagsAsText()
    {
        $buffer = array();
        foreach ($this->getTags() as $tag) {
            /** @var $tag Posting_Tag_Row */
            $buffer[] = $tag->getName();
        }

        return implode(', ', $buffer);
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

    public function getCommunityId()
    {
        $community = $this->getCommunity();
        if (!is_null($community)) {
            $id = $community->getId();
        } else {
            $id = null;
        }

        return $id;
    }

    public function getComments()
    {
        $table  = new Posting_Comment();
        /** @var $mapper Posting_Mapper */
        $mapper = $table->getMapper()->post($this)->order('left_key');

        return $mapper->fetchAll();
    }

    /**
     * @return int
     */
    public function getHasComments()
    {
        return intval($this->get('has_comments'));
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

    public function getRouteParameters()
    {
        $parameters = array();
        switch ($this->get('type')) {
            case self::TYPE_DREAM:
            case self::TYPE_POST:
            case self::TYPE_ARTICLE:
            case self::TYPE_ENTITY:
                $parameters = array(
                    'id'    => $this->getId(),
                    'alias' => $this->getAlias(),
                );
                break;
            case self::TYPE_SYMBOL:
                $parameters = array(
                    'letter' => $this->getLetter(),
                    'symbol' => $this->getTitle(),
                );
        }

        return $parameters;
    }

    public function getTagRoute()
    {
        switch ($this->get('type')) {
            case self::TYPE_DREAM:
                $route = 'dreams_tagged';
                break;
            default:
                $route = null;
                break;
        }

        return $route;
    }

    public function getParserOptions()
    {
        $useCut = $this->get('type') == $this->isArticle();
        $escape = !($this->isArticle() || $this->isSymbol());

        return array(
            BodyParser::OPTION_ESCAPE => $escape,
            BodyParser::OPTION_NO_CUT => !$useCut,
        );
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

    public function setTags(array $tags)
    {
        $oldTags = array();
        foreach ($this->getTags() as $tagRow) {
            /** @var $tagRow Posting_Tag_Row */
            $oldTags[$tagRow->getName()] = $tagRow->getId();
        }

        $newTags = array_unique($tags);
        foreach ($newTags as $tag) {
            $tag = trim($tag);
            if (mb_strlen($tag) < 1) {
                continue;
            }
            if (isset($oldTags[$tag])) {
                unset($oldTags[$tag]);
            } else {
                $this->addTagName($tag);
            }
        }

        foreach ($oldTags as $tagId) {
            $this->removeTag($tagId);
        }

        return $this;
    }

    public function touch()
    {
        $this->set('created_at', new Zend_Db_Expr('now()'));
    }

    public function getLetter()
    {
        return mb_substr($this->getTitle(), 0, 1);
    }

    public function addTagName($tagName)
    {
        $tagTable = new Posting_Tag();

        $tag = $tagTable->getTagForPost($this, $tagName);
        if (is_null($tag)) {
            $data = array(
                'type_id' => $this->getType()->getId(),
                'name'    => $tagName,
            );
            $tag = $tagTable->createRow($data);
            $tag->save();
        }

        $intersection = new Posting_HasTag();

        $data = array(
            'posting_id' => $this->getId(),
            'tag_id'     => $tag->getId(),
        );

        $row = $intersection->createRow($data);
        $row->save();
    }

    public function isPublic()
    {
        return ($this->get('is_internal') == self::VIS_PUBLIC);
    }

    public function isPrivate()
    {
        return ($this->get('is_internal') == self::VIS_PRIVATE);
    }

    public function getEntryType()
    {
        return intval($this->get('type'));
    }

    protected function removeTag($tagId)
    {
        $intersection = new Posting_HasTag();

        $where = "posting_id = {$this->getId()} and tag_id = {$tagId}";

        $intersection->delete($where);
    }
}
