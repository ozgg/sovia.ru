<?php
class User_Guest implements User_Interface
{
    public function getId()
    {
        return 0;
    }

    public function getRank()
    {
        return 0;
    }

    public function getIsActive()
    {
        return false;
    }

    public function getAvatars()
    {
        return array();
    }

    public function getAvatarId()
    {
        return null;
    }

    protected function _hasRoles($roles)
    {
        return false;
    }
}
