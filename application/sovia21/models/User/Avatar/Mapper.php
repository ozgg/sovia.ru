<?php
/**
 * 
 */

/**
 *
 */
class User_Avatar_Mapper extends Ext_Db_Table_Select
{
    public function owner(User_Row $user)
    {
        $this->where('owner_id = ?', $user->getId());

        return $this;
    }
}
?>