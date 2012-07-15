<?php
/**
 * Date: 14.01.12
 * Time: 13:47
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */

/**
 * Сообщество
 */
class Posting_Community extends Ext_Db_Table_Abstract
{
    /**
     * Название таблицы
     *
     * @var string
     */
    protected $_name = 'posting_community';

    /**
     * Преобразователь для конкретизации выборки
     *
     * @var Posting_Community_Mapper
     */
    protected $_mapper;

    /**
     * Класс для представления записи
     *
     * @var string
     */
    protected $_rowClass = 'Posting_Community_Row';

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
        'Type' => array(
            'columns'       => 'type_id',
            'refTableClass' => 'Posting_Type',
            'refColumns'    => 'id',
        ),
    );

    /**
     * Получить преобразователь
     *
     * @return Posting_Community_Mapper
     */
    public function getMapper()
    {
        if (is_null($this->_mapper)) {
            $this->_mapper = new Posting_Community_Mapper($this);
        }

        return $this->_mapper;
    }

    public function getPathTo(Posting_Community_Row $community)
    {
        $select = $this->select();
        $select->from($this, '*')
               ->where('left_key <= ?', $community->getLeftKey())
               ->where('right_key >= ?', $community->getRightKey())
               ->order('left_key');

        return $this->fetchAll($select);
    }
}
