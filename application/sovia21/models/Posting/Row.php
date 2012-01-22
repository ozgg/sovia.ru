<?php
/**
 * Date: 14.01.12
 * Time: 13:52
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */

class Posting_Row extends Ext_Db_Table_Row
{

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
}
