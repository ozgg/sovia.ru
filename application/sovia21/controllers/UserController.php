<?php
/**
 * Date: 20.11.11
 * Time: 1:31
 */

/**
 * Контроллер пользователей
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

    /**
     * Пользовательское соглашение
     */
    public function agreementAction()
    {
        $view  = $this->view;
        $title = 'Пользовательское соглашение';
        if ($this->_getParam('canonical', false)) {
            $href = $view->url(array(), 'tos', true);
            $view->headLink(array('rel' => 'canonical', 'href' => $href));
        }
        $view->headTitle($title);
    }

    /**
     * Соглашение о конфиденциальности
     */
    public function privacyAction()
    {
        $view  = $this->view;
        $title = 'Соглашение о конфиденциальности';
        if ($this->_getParam('canonical', false)) {
            $href = $view->url(array(), 'privacy', true);
            $view->headLink(array('rel' => 'canonical', 'href' => $href));
        }
        $view->headTitle($title);
    }

    /**
     * Блок с информацией о пользователе
     */
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
            $done = false || !empty($data['agree']);
            if ($form->isValid($data) && empty($data['agree'])) {
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
                $user->setAllowMail(!empty($data['mail_get']));
                $user->setIp();
                if (!empty($key)) {
                    $user->parent_id = $key->user_id;
                    $key->expire();
                    $key->save();
                }
                $user->save();
                $this->_auth->getStorage()->write($user->getId());
                $storage = new Zend_Session_Namespace('auth_user');
                $storage->user = $user;
                $done = true;
            }
            if ($done) {
                $this->_setFlashMessage('Регистрация прошла успешно.');
                $this->_redirect($this->view->url(array(), 'home', true));
            }
        }
        $this->view->form = $form;
    }

    /**
     * Авторизация
     *
     * @return void
     */
    public function loginAction()
    {
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
                $this->_redirect($this->view->url(array(), 'home', true));
            } else {
                $this->getResponse()->setHttpResponseCode(401);
                $error = 'Неправильный логин или пароль';
            }
        }
        $this->view->error = $error;
    }

    /**
     * Сброс пароля
     *
     * @return void
     */
    public function resetAction()
    {
        $this->view->headTitle('Сброс пароля');
        $description = 'Форма восстановления пароля';
        $this->view->headMeta()->appendName('description', $description);
        $isReset = false;
        $message = '';
        $email   = '';
        $body    = '';
        /** @var $request Zend_Controller_Request_Http */
        $request = $this->getRequest();
        if ($request->isPost()) {
            $email = $request->getPost('email', '');
            $body  = $request->getPost('key',   '');
            $password = $request->getPost('password', '');
            if (strlen($email) < 6) {
                $message = 'Неправильный e-mail';
            } elseif (strlen($body) < 1) {
                $message = 'Неправильный ключ';
            } elseif (strlen($password) < 5) {
                $message = 'Слишком короткий пароль';
            } else {
                $userTable = new User();
                $userMapper = $userTable->getMapper();
                $userMapper->email($email);
                /** @var $user User_Row */
                $user = $userMapper->fetchRow();
                if (!is_null($user)) {
                    $keyTable = new User_Key();
                    $keyMapper = $keyTable->getMapper();
                    $keyMapper->active()
                              ->user($user)
                              ->body($body)
                              ->typeId(User_Key::KEY_RESET);
                    /** @var $key User_Key_Row */
                    $key = $keyMapper->fetchRow();
                    if (!is_null($key)) {
                        $user->setPassword($password);
                        $user->save();
                        $isReset = true;
                        $key->expire();
                        $key->save();
                    } else {
                        $message = 'Недействительный ключ';
                    }
                } else {
                    $message = 'Такого адреса нет';
                }
            }
        }

        $this->view->isReset = $isReset;
        $this->view->message = $message;
        $this->view->email   = $email;
        $this->view->key     = $body;
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
     * Выход с сайта (закрытие сессии)
     *
     * @return void
     */
    public function logoutAction()
    {
        $this->_auth->clearIdentity();
        $storage = new Zend_Session_Namespace('auth_user');
        $storage->user = null;
        $this->_redirect($this->view->url(array(), 'home', true));
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
     * Получение ключа сброса пароля
     *
     * @return void
     */
    public function forgotAction()
    {
        $this->view->headTitle('Выслать ключ восстановления пароля');
        $description = 'Форма отправки ключа восстановления пароля';
        $this->view->headMeta()->appendName('description', $description);
        $isSent  = false;
        $message = '';
        /** @var $request Zend_Controller_Request_Http */
        $request = $this->getRequest();
        if ($request->isPost() && $request->has('email')) {
            $email = $request->getPost('email');
            $userTable = new User();
            $userMapper = $userTable->getMapper();
            $userMapper->email($email);
            /** @var $user User_Row */
            $user = $userMapper->fetchRow();
            if (!empty($user)) {
                $keyTable  = new User_Key();
                $keyMapper = $keyTable->getMapper();
                $keyMapper->user($user)->active()->typeId(User_Key::KEY_RESET);
                $key = $keyMapper->fetchRow();
                if (is_null($key)) {
                    $key = $user->createKey(User_Key::KEY_RESET);
                    /** @var $mailer Helper_Mailer */
                    $mailer = $this->_helper->getHelper('Mailer');
                    $isSent = $mailer->recover($user, $key);
                } else {
                    $message = 'Ключ уже создан и ещё не использован';
                }
            } else {
                $message = 'Такого адреса нет';
            }
        }

        $this->view->isSent  = $isSent;
        $this->view->message = $message;
    }

    /**
     * Воспользоваться ключом восстановления
     * @param $ownerId
     * @param $eventKey
     * @return null
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
        $this->_authAdapter->setTableName('user_item')
                    ->setIdentityColumn($column)
                    ->setCredentialColumn('password')
                    ->setCredentialTreatment('md5(concat(salt, ?))')
                    ->setIdentity($login)
                    ->setCredential($password);
        $select = $this->_authAdapter->getDbSelect();
        $select->where('is_active = 1');
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