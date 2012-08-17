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

    public function ids(array $ids)
    {
        $this->where('id in (' . implode(', ', $ids) . ')');

        return $this;
    }

    public function title($title)
    {
        $this->where('title = ?', $title);

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
        $this->where('minimal_rank <= ?', $rank);

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
     * @param $entry
     * @return Posting_Mapper
     */
    public function prevFor(Posting_Row $entry)
    {
        $this->where('id < ?', $entry->getId());
        $this->where('type = ?', $entry->getEntryType());
        $this->order('id desc');

        return $this;
    }

    /**
     * Следующая запись относительно заданной
     *
     * @param $entry
     * @return Posting_Mapper
     */
    public function nextFor(Posting_Row $entry)
    {
        $this->where('id > ?', $entry->getId());
        $this->where('type = ?', $entry->getEntryType());
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

    public function letters()
    {
        $this->group('substring(`alias` from 1 for 1)');
        $this->order('1 asc');

        return $this;
    }

    public function tagged($tag)
    {
        $this->setIntegrityCheck(true);
        $this->join(array('pht' => 'posting_has_tag'), 'pht.posting_id = posting_item.id');
        $this->join(array('pt' => 'posting_tag'), 'pt.id = pht.tag_id');
        $this->where('pt.name = ?', $tag);

        return $this;
    }

    /**
     * @param $typeName
     * @return Posting_Mapper
     */
    public function type($typeName)
    {
        switch ($typeName) {
            case BodyParser::TAG_ARTICLE:
            case BodyParser::TAG_ENTRY:
                $this->article();
                break;
            case BodyParser::TAG_DREAM:
                $this->dream();
                break;
            case BodyParser::TAG_ENTITY:
                $this->entity();
                break;
            case BodyParser::TAG_POST:
                $this->post();
                break;
            case BodyParser::TAG_SYMBOL:
                $this->symbol();
                break;
        }

        return $this;
    }
}
