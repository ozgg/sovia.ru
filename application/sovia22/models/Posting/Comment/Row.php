<?php
/**
 *
 *
 * Date: 16.07.12
 * Time: 0:21
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */
class Posting_Comment_Row extends Ext_Db_Table_Row
{
    /**
     * @return User_Row
     */
    public function getOwner()
    {
        return $this->findParentRow('User');
    }

    /**
     * @return string
     */
    public function getCreatedAt()
    {
        return $this->get('created_at');
    }

    /**
     * @return int
     */
    public function getLevel()
    {
        return $this->get('level');
    }

    /**
     * @return User_Avatar_Row
     */
    public function getAvatar()
    {
        return $this->findParentRow('User_Avatar');
    }

    /**
     * @return string
     */
    public function getBody()
    {
        return $this->get('body');
    }
}
