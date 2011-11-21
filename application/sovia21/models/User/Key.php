<?php
/**
 * Date: 30.08.11
 * Time: 19:49
 */

/**
 * Ключ пользователя
 */
class User_Key extends Ext_Db_Table_Abstract
{
    protected $_name = 'user_key';
    protected $_rowClass = 'User_Key_Row';
    /**
     * @var User_Key_Mapper
     */
    protected $_mapper;

    /**
     * Связи с другими таблицами
     * @var array
     */
    protected $_referenceMap = array(
        'User' => array(
            'columns'       => 'id',
            'refTableClass' => 'User',
            'refColumns'    => 'user_id',
        ),
    );

    /**
     * Регистрация нового пользователя
     */
    const KEY_REGISTER = 1;
    /**
     * Подтверждение e-mail
     */
    const KEY_APPROVE  = 2;
    /**
     * Сброс пароля
     */
    const KEY_RESET  = 3;
    
    /**
     * Получить преобразователь
     * @return User_Key_Mapper
     */
    public function getMapper()
    {
        if (is_null($this->_mapper)) {
            $this->_mapper = new User_Key_Mapper($this);
        }
        return $this->_mapper;
    }
}
