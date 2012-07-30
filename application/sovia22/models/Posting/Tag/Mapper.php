<?php
/**
 * Date: 14.01.12
 * Time: 14:00
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */

class Posting_Tag_Mapper extends Ext_Db_Table_Select
{
    public function dreams()
    {
        $this->where('type_id = ?', Posting_Row::TYPE_DREAM);

        return $this;
    }

    public function byWeight()
    {
        $this->order('weight desc');

        return $this;
    }
}
