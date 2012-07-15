<?php
/**
 * Комментарий к записи
 *
 * Date: 16.07.12
 * Time: 0:22
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */
class Posting_Comment extends Ext_Db_Table_Abstract
{
    /**
     * Название таблицы
     *
     * @var string
     */
    protected $_name = 'posting_comment';

    /**
     * Преобразователь для конкретизации выборки
     *
     * @var Posting_Comment_Mapper
     */
    protected $_mapper;

    /**
     * Класс для представления записи
     *
     * @var string
     */
    protected $_rowClass = 'Posting_Comment_Row';

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
        'Posting' => array(
            'columns'       => 'posting_id',
            'refTableClass' => 'Posting_Item',
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
     * @return Posting_Comment_Mapper
     */
    public function getMapper()
    {
        if (is_null($this->_mapper)) {
            $this->_mapper = new Posting_Comment_Mapper($this);
        }

        return $this->_mapper;
    }
}
