<?php
/**
 * Date: 14.01.12
 * Time: 13:47
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */

/**
 * Тип записи
 */
class Posting_Type extends Ext_Db_Table_Abstract
{
    /**
     * Название таблицы
     *
     * @var string
     */
    protected $_name = 'posting_type';

    /**
     * Преобразователь для конкретизации выборки
     *
     * @var Posting_Type_Mapper
     */
    protected $_mapper;

    /**
     * Класс для представления записи
     *
     * @var string
     */
    protected $_rowClass = 'Posting_Type_Row';

    /**
     * Получить преобразователь
     *
     * @return Posting_Type_Mapper
     */
    public function getMapper()
    {
        if (is_null($this->_mapper)) {
            $this->_mapper = new Posting_Type_Mapper($this);
        }

        return $this->_mapper;
    }
}
