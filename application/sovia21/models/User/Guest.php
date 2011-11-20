<?php
class User_Guest implements User_Interface
{
    public function getId()
    {
        return 0;
    }

    protected function _hasRoles($roles)
    {
        return false;
    }
}
