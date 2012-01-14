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
            'columns'       => 'id',
            'refTableClass' => 'User',
            'refColumns'    => 'owner_id',
        ),
        'Community' => array(
            'columns'       => 'id',
            'refTableClass' => 'Posting_Community',
            'refColumns'    => 'community_id',
        ),
        'Avatar' => array(
            'columns'       => 'id',
            'refTableClass' => 'User_Avatar',
            'refColumns'    => 'avatar_id',
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
}
