<?php
/**
 * Date: 14.01.12
 * Time: 13:51
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */

class Posting_Mapper extends Ext_Db_Table_Select
{
    public function id($id)
    {
        $this->where('id = ?', $id);

        return $this;
    }

    public function dream()
    {
        $this->where('type = ?', Posting_Row::TYPE_DREAM);

        return $this;
    }

    public function article()
    {
        $this->where('type = ?', Posting_Row::TYPE_ARTICLE);

        return $this;
    }

    public function symbol()
    {
        $this->where('type = ?', Posting_Row::TYPE_SYMBOL);

        return $this;
    }

    public function entity()
    {
        $this->where('type = ?', Posting_Row::TYPE_ENTITY);

        return $this;
    }

    public function post()
    {
        $this->where('type = ?', Posting_Row::TYPE_POST);

        return $this;
    }

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

    public function random()
    {
        $this->order('rand()');
        $this->limit(1);

        return $this;
    }
    /**
     * Предыдущая запись относительно заданной
     *
     * @param $id
     * @return Posting_Mapper
     */
    public function prevFor($id)
    {
        $this->where('id < ?', $id);
        $this->order('id desc');

        return $this;
    }

    /**
     * Следующая запись относительно заданной
     *
     * @param $id
     * @return Posting_Mapper
     */
    public function nextFor($id)
    {
        $this->where('id > ?', $id);
        $this->order('id asc');

        return $this;
    }

    /**
     * Выборка записей из архива по году и месяцу
     * @param int $year
     * @param int $month
     * @return Posting_Mapper
     */
    public function archive($year, $month)
    {
        $this->where('year(created_at) = ?', $year);
        $this->where('month(created_at) = ?', $month);

        return $this;
    }

    public function years()
    {
        $this->from($this->_table, 'year(created_at) as y')
            ->group('y')
            ->order('y');

        return $this;
    }

    public function months($year)
    {
        $this->from($this->_table, 'month(created_at) as m, count(*) as cnt')
            ->where('year(created_at) = ?', $year)
            ->group('m')
            ->order('m');

        return $this;
    }
}
