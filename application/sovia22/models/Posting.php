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
        $query   = "SELECT DISTINCT SUBSTRING(`title` FROM 1 FOR 1) AS ltr ";
        $query  .= "FROM {$this->_name} WHERE type = {$type} ";
        $query  .= "AND `title` IS NOT NULL ";
        $query  .= "ORDER BY ltr ASC";
        foreach ($this->getAdapter()->fetchAll($query) as $row) {
            if ($row['ltr'] != '') {
                $letters[] = $row['ltr'];
            }
            unset($row);
        }
        unset($query);

        return $letters;
    }
}
