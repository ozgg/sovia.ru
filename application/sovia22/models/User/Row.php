<?php
/**
 * Date: 28.08.11
 * Time: 14:45
 */

/**
 * Пользователь сайта
 */
class User_Row extends Ext_Db_Table_Row implements User_Interface
{
    /**
     * Обновить время последнего входа
     *
     * @return User_Row
     */
    public function login()
    {
        $this->setLastSeen(new Zend_Db_Expr('now()'));

        return $this;
    }

    /**
     * Задать новый пароль
     *
     * @param string $password
     * @return User_Row
     */
    public function setPassword($password)
    {
        $salt = $this->_makeSalt();
        $this->set('salt', $salt);
        $this->set('password', md5($salt . $password));

        return $this;
    }

    /**
     * Сгенерировать соль
     * 
     * @return string
     */
    protected function _makeSalt()
    {
        $salt = '';
        $length   = rand(5, 15);
        $alphabet = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
        $symbols  = '1234567890-=~!@#$%^&*()_+|[]{};:,.<>?/';
        $alphaLength = strlen($alphabet) - 1;
        $symbolsLength = strlen($symbols) - 1;
        for ($i = 0; $i < $length; $i++) {
            if (rand(0, 1)) {
                $salt .= $alphabet[rand(0, $alphaLength)];
            } else {
                $salt .= $symbols[rand(0, $symbolsLength)];
            }
        }

        return $salt;
    }

    /**
     * Задать ip-адрес
     *
     * @return User_Row
     */
    public function setIp()
    {
        $this->set('remote_addr', ip2long(self::$_ip));

        return $this;
    }

    /**
     * Получить ip-адрес
     * 
     * @return string
     */
    public function getRemoteAddr()
    {
        return long2ip($this->get('remote_addr'));
    }

    /**
     * Создать ключ
     *
     * @param int $typeId тип ключа (@see User_Key)
     * @return User_Key_Row
     */
    public function createKey($typeId)
    {
        $data = array(
            'user_id' => $this->getId(),
            'type_id' => $typeId,
        );
        $keyTable = new User_Key();
        /** @var $key User_Key_Row */
        $key = $keyTable->createRow($data);
        $key->generate();
        $key->save();

        return $key;
    }

    public function setEmail($email)
    {
        $this->set('email', $email);

        return $this;
    }

    public function getEmail()
    {
        return $this->get('email');
    }

    public function getLogin()
    {
        return $this->get('login');
    }

    public function setLogin($login)
    {
        $this->set('login', $login);

        return $this;
    }

    public function getRank()
    {
        return intval($this->get('rank'));
    }

    public function setParentId($parentId)
    {
        $this->set('parent_id', $parentId);

        return $this;
    }

    public function getCreatedAt()
    {
        return $this->get('created_at');
    }

    public function getLastSeen()
    {
        return $this->get('last_seen');
    }

    public function getHasPosts()
    {
        return $this->get('has_posts');
    }

    public function getHasComments()
    {
        return $this->get('has_comments');
    }

    public function getIsActive()
    {
        return ($this->get('is_active') > 0);
    }

    /**
     * Добавить запись в блог
     *
     * @param array $data
     * @param array $tags
     * @return Posting_Row
     */
    public function createPosting(array $data, array $tags = array())
    {
        $table = new Posting();
        $entryData = array(
            'owner_id'  => $this->getId(),
        );
        /** @var $entry Posting_Row */
        $entry = $table->createRow($entryData);
        $entry->setData($data)->save();
        $entry->setTags($tags);

        return $entry;
    }

    public function setAllowMail($allowMail)
    {
        settype($allowMail, 'int');
        if ($allowMail != 0) {
            $allowMail = 1;
        }
        $this->set('allow_mail', $allowMail);

        return $this;
    }

    public function getAllowMail()
    {
        return (bool) $this->get('allow_mail');
    }

    public function getDefaultAvatar()
    {
//        $profile = $this->getProfile();
//        $avatar  = $profile->getDefaultAvatar();
//        unset($profile);
//        return $avatar;
    }

    public function setLastSeen($lastSeen)
    {
        $this->set('last_seen', $lastSeen);

        return $this;
    }

    public function checkCurrentPassword($password)
    {
        $salt = $this->get('salt');
        $hash = md5($salt . $password);

        return ($hash == $this->get('password'));
    }

    public function getAvatarId()
    {
        return $this->get('avatar_id');
    }

    public function setAvatarId($avatarId)
    {
        $this->set('avatar_id', $avatarId);
    }

    public function getMaxAvatars()
    {
        return $this->get('max_avatars');
    }

    public function getAvatars()
    {
        $table = new User_Avatar();
        $mapper = $table->getMapper();
        $mapper->owner($this);

        return $mapper->fetchAll();
    }


    public function getRoles($raw = false)
    {
        $roles    = array();
        $hasRoles = $this->getMapper()->getRoles($this->getId());
        if ($raw) {
            $roles = $hasRoles;
        } else {
            foreach ($hasRoles as $roleName => $isPresent) {
                if ($isPresent) {
                    $roles[] = $roleName;
                }
            }
            unset($roleName, $isPresent);
        }
        unset($hasRoles);
        return $roles;
    }

    public function addRole($name)
    {
        return $this->getMapper()->addRole($this->getId(), $name);
    }

    public function revokeRole($name)
    {
        if ($this->getId() == 1) {
            throw new Exception('У этого пользователя нельзя убирать роли');
        }
        return $this->getMapper()->revokeRole($this->getId(), $name);
    }
}
