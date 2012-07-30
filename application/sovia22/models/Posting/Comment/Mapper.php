<?php
/**
 *
 *
 * Date: 16.07.12
 * Time: 0:21
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */
class Posting_Comment_Mapper extends Ext_Db_Table_Select
{
    /**
     * @param Posting_Row $post
     * @return Posting_Comment_Mapper
     */
    public function post(Posting_Row $post)
    {
        $this->where('posting_id = ?', $post->getId());

        return $this;
    }
}
