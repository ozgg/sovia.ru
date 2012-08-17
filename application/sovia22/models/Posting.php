<?php
/**
 * Date: 14.01.12
 * Time: 13:47
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */

/**
 * Запись
 */
class Posting extends Ext_Db_Table_Abstract
{
    /**
     * Название таблицы
     *
     * @var string
     */
    protected $_name = 'posting_item';

    /**
     * Преобразователь для конкретизации выборки
     *
     * @var Posting_Mapper
     */
    protected $_mapper;

    /**
     * Класс для представления записи
     *
     * @var string
     */
    protected $_rowClass = 'Posting_Row';

    /**
     * Связи с другими таблицами
     *
     * @var array
     */
    protected $_referenceMap = array(
        'Owner' => array(
            'columns'       => 'owner_id',
            'refTableClass' => 'User',
            'refColumns'    => 'id',
        ),
        'Community' => array(
            'columns'       => 'community_id',
            'refTableClass' => 'Posting_Community',
            'refColumns'    => 'id',
        ),
        'Avatar' => array(
            'columns'       => 'avatar_id',
            'refTableClass' => 'User_Avatar',
            'refColumns'    => 'id',
        ),
    );

    /**
     * Получить преобразователь
     *
     * @return Posting_Mapper
     */
    public function getMapper()
    {
        if (is_null($this->_mapper)) {
            $this->_mapper = new Posting_Mapper($this);
        }

        return $this->_mapper;
    }

    public function getLetters($type)
    {
        settype($type, 'int');
        $letters = array();
        $query   = "select distinct substring(`title` from 1 for 1) as ltr ";
        $query  .= "from {$this->_name} where type = {$type} ";
        $query  .= "and `title` is not null ";
        $query  .= "order by ltr asc";
        foreach ($this->getAdapter()->fetchAll($query) as $row) {
            if ($row['ltr'] != '') {
                $letters[] = $row['ltr'];
            }
            unset($row);
        }
        unset($query);

        return $letters;
    }

    public function findSymbolsByLetter($letter)
    {
        $letter = $this->getAdapter()->quote($letter);
        $where  = array(
            'type = ' . Posting_Row::TYPE_SYMBOL,
            "title like concat(substring({$letter} from 1 for 1), '%')",
        );
        $query = 'select id, title, substring(title from 1 for 1) as letter'
               . " from {$this->_name}"
               . ' where ' . implode(' and ', $where)
               . ' order by title asc';

        return $this->getAdapter()->fetchAll($query);
    }

    public function findPostIdsForTag($tag)
    {
        $query = "select p.id from {$this->_name} p "
            . 'join posting_has_tag pht on (pht.posting_id = p.id) '
            . 'join posting_tag pt on (pht.tag_id = pt.id) '
            . 'where pt.name = ' . $this->getAdapter()->quote($tag);

        $ids = array();
        foreach ($this->getAdapter()->fetchAll($query) as $row) {
            $ids[] = $row['id'];
        }

        return $ids;
    }

    public function findAdjacent(Posting_Row $entry, User_Interface $user)
    {
        if ($user->getIsActive()) {
            $isInternal = Posting_Row::VIS_REGISTERED;
        } else {
            $isInternal = Posting_Row::VIS_PUBLIC;
        }
        $rank   = $user->getRank();
        $result = array();
        $mapper = $this->getMapper();
        $mapper->reset();
        $mapper->prevFor($entry)
               ->isInternal($isInternal)
               ->minimalRank($rank);
        $result['prev'] = $mapper->fetchRow();
        $mapper->reset();
        $mapper->nextFor($entry)
               ->isInternal($isInternal)
               ->minimalRank($rank);
        $result['next'] = $mapper->fetchRow();

        return $result;
    }
}
