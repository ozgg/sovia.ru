<?php
/**
 * Date: 14.01.12
 * Time: 13:51
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */

class Posting_Mapper extends Ext_Db_Table_Select
{
    public function community(Posting_Community_Row $community)
    {
        $this->where('community_id = ?', $community->getId());

        return $this;
    }

    public function minimalRank($rank)
    {
        $this->where('minimal_rank >= ?', $rank);

        return $this;
    }

    public function isInternal($isInternal)
    {
        $this->where('is_internal <= ?', $isInternal);

        return $this;
    }

    public function user(User_Row $user)
    {
        $this->where('owner_id = ?', $user->getId());

        return $this;
    }

    public function recent()
    {
        $this->order('id desc');

        return $this;
    }
}
