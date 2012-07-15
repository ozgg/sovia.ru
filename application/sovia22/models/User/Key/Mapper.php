<?php
/**
 * Date: 30.08.11
 * Time: 19:50
 */
 
class User_Key_Mapper extends Ext_Db_Table_Select
{
    public function typeId($typeId)
    {
        $this->where('type_id = ?', $typeId);
        return $this;
    }

    public function active()
    {
        $this->where('updated_at is null');
        return $this;
    }

    public function body($body)
    {
        $this->where('body = ?', $body);
        return $this;
    }

    public function user(User_Row $user)
    {
        $this->where('user_id = ?', $user->getId());
        return $this;
    }
}
