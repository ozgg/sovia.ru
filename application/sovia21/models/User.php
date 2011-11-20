<?php
class User extends Ext_Db_Table_Abstract
{
    /**
     * Имя таблицы
     * @var string
     */
    protected $_name = 'user_item';

    /**
     * Преобразователь для конкретизации выборки
     * @var User_Mapper
     */
    protected $_mapper;

    /**
     * Класс для представления записи
     * @var string
     */
    protected $_rowClass = 'User_Row';

    /**
     * Связи с другими таблицами
     * @var array
     */
    protected $_referenceMap = array(
        'Parent' => array(
            'columns'       => 'id',
            'refTableClass' => 'User',
            'refColumns'    => 'parent_id',
        ),
    );

    /**
     * Получить преобразователь
     * @return User_Mapper
     */
    public function getMapper()
    {
        if (is_null($this->_mapper)) {
            $this->_mapper = new User_Mapper($this);
        }
        return $this->_mapper;
    }

    /**
     * «Увидеть» пользователя
     *
     * Изменить поле last_seen на текущий момент времени для пользователя.
     *
     * @param $id
     * @return void
     */
    public function see($id)
    {
        settype($id, 'int');
        $data = array('last_seen' => new Zend_Db_Expr('now()'));
        $where = array('id = ' . $id);
        $this->update($data, $where);
    }
}