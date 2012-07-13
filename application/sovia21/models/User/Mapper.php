<?php
/**
 * Date: 28.08.11
 * Time: 1:22
 */

/**
 * Преобразователь для пользователей
 *
 * Используется для конкретизации выборки из таблицы
 * 
 * @extends Zend_Db_Table_Select
 */
class User_Mapper extends Ext_Db_Table_Select
{
    /**
     * @param $email
     * @return User_Mapper
     */
    public function email($email)
    {
        $this->where('email = ?', $email);

        return $this;
    }

    /**
     * @param $login
     * @return User_Mapper
     */
    public function login($login)
    {
        $this->where('login = ?', $login);

        return $this;
    }
}
