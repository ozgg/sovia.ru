<?php
/**
 * 
 */

/**
 *
 */
class User_Avatar extends Ext_Db_Table_Abstract
{
    /**
     * Имя таблицы
     *
     * @var string
     */
    protected $_name = 'user_avatar';

    /**
     * Преобразователь для конкретизации выборки
     *
     * @var User_Mapper
     */
    protected $_mapper;

    /**
     * Класс для представления записи
     *
     * @var string
     */
    protected $_rowClass = 'User_Avatar_Row';

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
    );

    const STORAGE = '/images/avatars/';
    const MAX_WIDTH  = 100;
    const MAX_HEIGHT = 100;
    const MAX_WEIGHT = 40960;

    /**
     * Получить преобразователь
     *
     * @return User_Avatar_Mapper
     */
    public function getMapper()
    {
        if (is_null($this->_mapper)) {
            $this->_mapper = new User_Avatar_Mapper($this);
        }
        return $this->_mapper;
    }
}
?>