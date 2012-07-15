<?php
/**
 * Date: 14.01.12
 * Time: 13:58
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */

class Posting_Community_Mapper extends Ext_Db_Table_Select
{
    public function tree()
    {
        $this->order('left_key');

        return $this;
    }

    public function minimalRank($rank)
    {
        $this->where('minimal_rank <= ?', $rank);

        return $this;
    }

    public function isInternal($isInternal)
    {
        $this->where('is_internal <= ?', $isInternal);

        return $this;
    }

    public function parent(Posting_Community_Row $parent)
    {
        $this->where('left_key >= ?', $parent->getLeftKey())
             ->where('right_key <= ?', $parent->getRightKey())
             ->where('level = ?', $parent->getLevel() + 1);

        return $this;
    }
}
