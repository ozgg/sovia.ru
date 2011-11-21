<?php
/**
 * Date: 20.11.11
 * Time: 1:31
 */
 
class UserController extends Ext_Controller_Action
{
    /**
     * @var Zend_Auth_Adapter_DbTable
     */
    protected $_authAdapter;
    /**
     * @var Zend_Auth
     */
    protected $_auth;

    /**
     * Инициализация
     *
     * @return void
     */
    public function init()
    {
        $this->_auth = Zend_Auth::getInstance();
    }

    public function agreementAction()
    {
        $view  = $this->view;
        $title = 'Пользовательское соглашение';
        if ($this->_getParam('canonical', false)) {
            $href = $view->url(array(), 'tos', true);
            $view->headLink(array('rel' => 'canonical', 'href' => $href));
        }
        $view->headTitle($title);
        $view->crumbs = array($title);
    }

    public function privacyAction()
    {
        $view  = $this->view;
        $title = 'Соглашение о конфиденциальности';
        if ($this->_getParam('canonical', false)) {
            $href = $view->url(array(), 'privacy', true);
            $view->headLink(array('rel' => 'canonical', 'href' => $href));
        }
        $view->headTitle($title);
        $view->crumbs = array($title);
    }

    public function authinfoAction()
    {
        $this->view->user = $this->_user;
    }

    /**
     * Регистрация на сайте
     * @return void
     */
    public function registerAction()
    {
        $this->view->headTitle('Регистрация');
        $description = 'Регистрация на ресурсе';
        $this->view->headMeta()->appendName('description', $description);

        /** @var $request Zend_Controller_Request_Http */
        $request = $this->getRequest();
        $form    = new Form_User_Register();
        if ($request->isPost()) {
            $data = $request->getPost();
            if ($form->isValid($data)) {
                $keyTable  = new User_Key();
                $userTable = new User();
                $mapper = $keyTable->getMapper();
                $mapper->body($data['key'])->active()->typeId(User_Key::KEY_REGISTER);
                /** @var $key User_Key_Row */
                $key = $mapper->fetchRow();
                unset($data['key']);
                /** @var $user User_Row */
                $user = $userTable->createRow();
                $user->login = $data['login'];
                $user->setPassword($data['password']);
                $user->email = $data['email'];
                if (!empty($key)) {
                    $user->parent_id = $key->user_id;
                }
                $user->setIp();
                $user->save();
                $key->expire();
                $key->save();
                $this->_auth->getStorage()->write($user->getId());
                $storage = new Zend_Session_Namespace('auth_user');
                $storage->user = $user;
                $this->_redirect($this->view->url(array(), 'home', true));
            }
        }
        $this->view->form = $form;
    }


    /**
     * Вход
     */
    public function loginAction()
    {
        if ($this->_user->getId() > 0) {
            $this->_redirect($this->view->url(array(), 'home', true));
        }
        $this->view->headTitle('Вход');
        $this->view->headMeta()->appendName('description', 'Вход на сайт');
        $error = '';

        /** @var $request Zend_Controller_Request_Http */
        $request = $this->getRequest();
        if ($request->isPost()) {
            $login    = $request->getPost('login');
            $password = $request->getPost('password');
            $isValid  = $this->_checkCredentials($login, $password);
            if ($isValid) {
                $user = $this->_auth();
                $storage = new Zend_Session_Namespace('auth_user');
                $storage->user = $user;
                $this->_redirect('/');
            } else {
                $this->getResponse()->setHttpResponseCode(401);
                $error = 'Неправильный логин или пароль';
            }
        }
        $this->view->error = $error;

        $this->view->headTitle('Вход на сайт');
        $authData = $this->_auth->read();
        if (!empty($authData['user'])) {
            $this->_redirect('/user/');
        }
        $errors     = array();
        $result     = '';
        $showForm   = true;
        $login      = '';
        $rememberMe = '';
        $request    = $this->getRequest();
        if ($request->isPost()) {
            $login    = $request->getPost('login');
            $password = $request->getPost('password');
            $remember = $request->getPost('remember');
            if ($login != '') {
                $model  = new Default_Model_UserItem();
                $userId = $model->checkPair($login, $password);
                if (!empty($userId)) {
                    $result  .= 'Вы успешно вошли.';
                    $showForm = false;
                    $user     = $model->find($userId);
                    $roles    = $user->getRoles();
                    $authData = array(
                        'user' => $user,
                        'roles' => $roles,
                    );
                    $this->_auth->write($authData);
                    $authData = $this->_auth->read();
                    $this->view->user = $authData['user'];
                    unset($authData);
                    if (!empty($remember)) {
                        $remoteAddr = $_SERVER['REMOTE_ADDR'];
                        $sessionKey = $model->setSession($userId, $remoteAddr);
                        $cookieData = "{$userId}\t{$sessionKey}";
                        unset($remoteAddr, $sessionKey);
                        $expires    = time() + 2419200;
                        setcookie('person', $cookieData, $expires, '/');
                        unset($cookieData, $expires);
                        $rememberMe = 'checked="checked" ';
                    }
                } else {
                    $errors[] = 'В доступе отказано';
                }
                unset($userId, $model);
            }
            unset($password, $remember);
        }
        $this->view->showForm = $showForm;
        $this->view->errors   = $errors;
        $this->view->result   = $result;
        $this->view->login    = $login;
        $this->view->remember = $rememberMe;
    }

	/**
	 * Редактирование пользователя
	 */
	public function editAction()
	{
		if (!$this->_hasRoles('administrator')) {
			$this->_redirect('/user/');
		}
		$epp     = 30;
		$model   = new Default_Model_UserItem();
		$request = $this->getRequest();
		$userId  = intval($request->getParam('user_id', 0));
		$item    = $model->find($userId);
		$errors  = array();
		$result  = '';
		if (!empty($item) && ($item->getId() > 0)) {
			$this->view->item = $item;
			if ($request->isPost()) {
				$post = $request->getPost();
				if (!empty($post['password'])) {
					$item->setNewPassword($post['password']);
				}
				if (isset($post['mail'])) {
					$item->setMail($post['mail']);
				}
				if (isset($post['karma'])) {
					$item->setRank($post['rank']);
				}
				$item->setAllowMail(!empty($post['allow_mail']));
				try {
					$item->save();
					$result = 'Информация обновлена успешно';
				} catch (Exception $e) {
					$errors[] = $e->getMessage();
				}
			}
			$this->view->roles = $item->getRoles(true);
		}
		$list  = $model->getList($this->_page, $epp);
		$count = $list['count'];
		$pager = new Zend_Paginator(new Zend_Paginator_Adapter_Null($count));
		$pager->setCurrentPageNumber($this->_page)
			  ->setItemCountPerPage($epp);
		$this->view->pager  = $pager;
		$this->view->list   = $list;
		$this->view->page   = $this->_page;
		$this->view->userId = $userId;
		$this->view->errors = $errors;
		$this->view->result = $result;
	}

	/**
	 * Выход
	 */
	public function logoutAction()
	{
		$this->view->headTitle('Выход');
		$auth = $this->_auth->read();
		if (!empty($auth['user'])) {
			$this->_auth->write(array('user' => null, 'roles' => array()));
			setcookie('person', false, 0, '/');
			$this->view->result = 'Вы вышли.';
		} else {
			$this->_redirect('/');
		}
	}

	/**
	 * Профиль пользователя
	 */
	public function profileAction()
	{
		$title   = 'Профиль пользователя';
		$request = $this->getRequest();
		$login   = $request->getParam('of', '');
		$search  = '';
		$list    = array();
		$model   = new Default_Model_UserItem();
		if ($login != '') {
			$item  = $model->findByField('login', $login);
			if ($item->getId() > 0) {
				$title .= " {$item->getLogin()}";
				$this->view->item = $item;
			}
		} else {
			$title = 'Поиск пользователей';
		}
		unset($login);
		if ($request->isPost()) {
			$login = trim($request->getPost('search_login', ''));
			if ($login != '') {
				$search = mb_substr($login, 0, 16);
				$list   = $model->search($search);
			}
			unset($login);
		}
		unset($request, $model);
		$this->view->search = $search;
		$this->view->list   = $list;
		$this->view->headTitle($title);
	}

	/**
	 * Активность пользователей
	 */
	public function activityAction()
	{
		$this->view->headTitle('Активность пользователей');
		$model = new Default_Model_UserItem();
		$this->view->list = $model->getActivity();
		unset($model);
	}

	/**
	 * Восстановление пароля
	 *
	 */
	public function recoverAction()
	{
		$this->view->headTitle('Восстановление пароля');
		$showForm = true;
		$errors   = array();
		$result   = '';
		$request  = $this->getRequest();
		$model    = new Default_Model_UserItem();
		if ($request->isPost()) {
			$login = $request->getPost('recover_login', '');
			$email = $request->getPost('recover_email', '');
			$user  = $model->findByField('login', $login);
			if ($user->getId() > 0) {
				if ($user->getMail() == $email) {
					try {
						$this->_addRecoveryKey($user);
						$result = 'Запрос на восстановление пароля принят.
								Вам придёт письмо со ссылкой для
								восстановления.';
					} catch (Exception $e) {
						$errors[] = $e->getMessage();
					}
					$showForm = false;
				} else {
					$errors[] = 'E-mail не совпадает с адресом в профиле.';
				}
			} else {
				$errors[] = 'Не нашлось такого пользователя.';
			}
			unset($login, $email, $user);
		} else {
			$key   = $request->getParam('key', '');
			$parts = explode('-', $key);
			if (count($parts) == 2) {
				$ownerId  = $parts[0];
				$eventKey = $parts[1];
				try {
					$password = $this->_useRecoveryKey($ownerId, $eventKey);
					if (!empty($password)) {
						$result .= "Пароль успешно изменён на {$password}";
					} else {
						$errors[] = 'Не удалось создать новый пароль.';
					}
				} catch (Exception $e) {
					$errors[] = $e->getMessage();
				}
				unset($ownerId, $eventKey);
				$showForm = false;
			}
			unset($key, $parts);
		}
		unset($model, $request);
		$this->view->showForm = $showForm;
		$this->view->errors   = $errors;
		$this->view->result   = $result;
	}

	/**
	 * Добавить ключ восстановления пароля
	 */
	protected function _addRecoveryKey(Default_Model_UserItem $user)
	{
		$key = new Default_Model_UserKey();
		$key->create($user, Default_Model_UserKey::TYPE_PASSWORD);
		$mailer = $this->_helper->getHelper('Mailer');
		$data   = array(
			'type' => Helper_Mailer::TYPE_RECOVER,
			'key'  => $key,
		);
		$mailer->send($user, $data);
		unset($data, $key);
	}

	/**
	 * Воспользоваться ключом восстановления
	 */
	protected function _useRecoveryKey($ownerId, $eventKey)
	{
		settype($ownerId, 'int');
		$userKey  = new Default_Model_UserKey();
		$userItem = new Default_Model_UserItem();
		$password = null;
		$key = $userKey->findByField('event_key', $eventKey);
		if ($key->getId() > 0) {
			if ($ownerId == $key->getOwnerId()) {
				if (!$key->isExpired()) {
					$user = $userItem->find($ownerId);
					if ($user->getId() > 0) {
						$password = $user->resetPassword();
						$key->delete();
					}
					unset($user);
				} else {
					$key->delete();
					throw new Exception('Ключ больше недействителен.');
				}
			} else {
				throw new Exception('Неправильный ключ.');
			}
		} else {
			throw new Exception('Неизвестный ключ.');
		}
		unset($key, $userKey, $userItem);
		return $password;
	}

    /**
     * Аутентификация
     *
     * @param $login логин или e-mail
     * @param $password пароль
     * @return bool
     */
    protected function _checkCredentials($login, $password)
    {
        if (strpos($login, '@') !== false) {
            $column = 'email';
        } else {
            $column = 'login';
        }
        $dbAdapter = Zend_Db_Table_Abstract::getDefaultAdapter();
        $this->_authAdapter = new Zend_Auth_Adapter_DbTable($dbAdapter);
        $this->_authAdapter->setTableName('user')
                    ->setIdentityColumn($column)
                    ->setCredentialColumn('password')
                    ->setCredentialTreatment('md5(concat(salt, ?))')
                    ->setIdentity($login)
                    ->setCredential($password);
        $select = $this->_authAdapter->getDbSelect();
        $select->where('banned_till is null or banned_till < now()');
        $result = $this->_auth->authenticate($this->_authAdapter);
        return $result->isValid();
    }

    /**
     * Сохранение id пользователя в сессии
     *
     * @return User_Row
     */
    protected function _auth()
    {
        $storage = $this->_auth->getStorage();
        $userStd = $this->_authAdapter->getResultRowObject(null, 'password');

        $userTable = new User();
        /** @var $user User_Row */
        $user = $userTable->selectBy('id', $userStd->id)->fetchRowIfExists();
        $user->login();
        $user->save();
        $storage->write($user->getId());
        return $user;
    }
}