<?php
/**
 * Date: 14.01.12
 * Time: 13:47
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */

/**
 * Метка записи
 */
class Posting_Tag extends Ext_Db_Table_Abstract
{
    /**
     * Название таблицы
     *
     * @var string
     */
    protected $_name = 'posting_tag';

    /**
     * Преобразователь для конкретизации выборки
     *
     * @var Posting_Tag_Mapper
     */
    protected $_mapper;

    /**
     * Класс для представления записи
     *
     * @var string
     */
    protected $_rowClass = 'Posting_Tag_Row';

    /**
     * Получить преобразователь
     *
     * @return Posting_Tag_Mapper
     */
    public function getMapper()
    {
        if (is_null($this->_mapper)) {
            $this->_mapper = new Posting_Tag_Mapper($this);
        }

        return $this->_mapper;
    }
}
