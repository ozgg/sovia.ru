<?php
/**
 * Date: 13.01.12
 * Time: 23:02
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */

class CabinetController extends Ext_Controller_Action
{
    protected function checkUser()
    {
        if ($this->_user->getId() < 1) {
            $this->_redirect($this->_url(array(), 'user_login', true));
        }
    }

    public function indexAction()
    {
        $this->checkUser();
        $this->_headTitle('Личный кабинет');
    }

    public function avatarsAction()
    {
        $this->checkUser();
        $view = $this->view;
        $table = new User;
        /** @var $user User_Row */
        $user = $table->selectBy('id', $this->_user->getId())->fetchRowIfExists();
        $view->assign('user', $user);
        $this->_headTitle('Управление картинками пользователя');

        /** @var $request Zend_Controller_Request_Http */
        $request = $this->getRequest();
        $errors  = array();
        $results = array();
        $avatarTable = new User_Avatar;
        $avatarMapper = $avatarTable->getMapper();
        $avatarMapper->owner($user);
        $list = $avatarMapper->fetchAll();

        if ($request->isPost()) {
            $post = $request->getPost('avatar');
            if (!empty($post)) {
                foreach ($post as $avatarId => $data) {
                    /** @var $avatar User_Avatar_Row */
                    $avatar = $avatarTable->selectBy('id', $avatarId)->fetchRow();
                    if (!empty($avatar) && ($avatar->getOwnerId() == $user->getId())) {
                        if (isset($data['del'])) {
                            try {
                                $name = $avatar->getName();
                                $avatar->delete();
                                $results[] = "Картинка {$name} удалена.";
                            } catch (Exception $e) {
                                $errors[] = $e->getMessage();
                            }
                        } else {
                            if (isset($data['name']) && ($data['name'] != $avatar->getName())) {
                                $avatar->setName($data['name']);
                                try {
                                    $avatar->save();
                                    $results[] = "Информация о картинке {$avatar->getName()} обновлена";
                                } catch (Exception $e) {
                                    $errors[] = $e->getMessage();
                                }
                            }
                        }
                    }
                }
            }
            $post = $request->getPost('avatar_default');
            if (!empty($post)) {
                /** @var $avatar User_Avatar_Row */
                $avatar = $avatarTable->selectBy('id', $post)->fetchRow();
                if (!empty($avatar)) {
                    if ($avatar->getOwnerId() == $user->getId()) {
                        if ($user->getAvatarId() != $post) {
                            $user->setAvatarId($post);
                            try {
                                $user->save();
                                $result  = "Новая картинка по умолчанию &mdash; ";
                                $result .= $avatar->getName();
                                $results[] = $result;
                            } catch (Exception $e) {
                                $errors[] = $e->getMessage();
                            }
                        }
                    }
                } else {
                    $errors[] = "Выбранная по умолчанию картинка не найдена.";
                }
            }

            $count = count($list);
            if ($count < $user->getMaxAvatars()) {
                try {
                    $filePath = $this->_setUploadedAvatar('avatar_add');
                    if (!empty($filePath)) {
                        $results[] = 'Новая картинка добавлена';
                    }
                } catch (Exception $e) {
                    $errors[] = $e->getMessage();
                }
            }
        }
        $this->view->assign('errors', $errors);
        $this->view->assign('list', $list);
        $this->_setFlashMessage($results);
        if (!empty($results)) {
            $this->_redirect($this->_url(array(), 'cabinet_avatars', true));
        }
    }

    public function dreamsAction()
    {
        $this->checkUser();
        $this->_headTitle("Ваши сны, страница {$this->_page}");
        $table = new Posting();
        $mapper = $table->getMapper();
        $mapper->dream()->user($this->_user)->recent();
        $paginator = $mapper->paginate($this->_page, 10);
        $entries   = $paginator->getCurrentItems();

        $this->view->assign('paginator', $paginator);
        $this->view->assign('entries',   $entries);
        $this->view->assign('page',      $this->_page);
    }

    public function profileAction()
    {
        $this->checkUser();
        $view = $this->view;
        $table = new User;
        /** @var $user User_Row */
        $user = $table->selectBy('id', $this->_user->getId())->fetchRowIfExists();
        $view->assign('user', $user);

        $this->_headTitle('Редактировать профиль');
        $errors  = array();
        /** @var $request Zend_Controller_Request_Http */
        $request = $this->getRequest();
        if ($request->isPost()) {
            $post = $request->getPost();
            if (!empty($post['old_password'])) {
                try {
                    $this->_changeRegData($user, $post);
                } catch (Exception $e) {
                    $errors[] = $e->getMessage();
                }
            }
            if (empty($errors)) {
                $user->setAllowMail(!empty($post['allow_mail']));
                try {
                    $user->save();
                    $this->_setFlashMessage('Информация обновлена успешно');
                    $this->_redirect($this->_url(array(), 'cabinet_profile', true));
                } catch (Exception $e) {
                    $errors[] = $e->getMessage();
                }
            }
        }
        $view->assign('errors', $errors);
    }

    public function symbolsAction()
    {

    }

   	protected function _changeRegData(User_Row $user, array $post)
   	{
   		$error = '';
   		$pass  = $post['old_password'];
   		if ($user->checkCurrentPassword($pass)) {
   			$password = '';
   			if (!empty($post['new_password'])) {
   				$password = $post['new_password'];
   			}
   			if ($password != '') {
   				if (mb_strlen($password) >= 3) {
   					if (!empty($post['new_password_confirm'])) {
   						$confirm = $post['new_password_confirm'];
   						if ($password == $confirm) {
   							$user->setPassword($password);
   						} else {
   							$error = 'Пароль не совпадает с подтверждением';
   						}
   						unset($confirm);
   					} else {
   						$error = 'Пароль не совпадает с подтверждением';
   					}
   				} else {
   					$error = 'Пароль слишком короткий';
   				}
   			}
   			if (isset($post['new_email'])) {
   				$user->setEmail($post['new_email']);
   			}
   		} else {
   			$error = 'Старый пароль указан неверно.';
   		}

   		if (!empty($error)) {
   			throw new Exception($error);
   		}
   	}

    protected function _setUploadedAvatar($name)
    {
        $filePath = null;
        $process  = true;
        $upload = new Zend_File_Transfer_Adapter_Http();
        $upload->setDestination(APPLICATION_PATH . '/upload/');
        $upload->receive();
        $info = $upload->getFileInfo($name);
        switch ($info[$name]['error']) {
            case UPLOAD_ERR_NO_FILE:
                $process = false;
                break;
            case UPLOAD_ERR_FORM_SIZE:
                throw new Exception('Файл слишком большой');
                break;
            case UPLOAD_ERR_OK:
                break;
            default:
                throw new Exception("Ошибка загрузки: {$info[$name]['error']}");
        }

        if ($process) {
            $filePath = $upload->getFileName($name);
            if (!empty($filePath)) {
                $data = array(
                    'owner_id' => $this->_user->getId(),
                    'name'     => date('Y-m-d H:i'),
                );
                $table = new User_Avatar();

                /** @var $avatar User_Avatar_Row */
                $avatar = $table->createRow($data);
                $avatar->setFile($filePath);
                $avatar->save();
            }
        }

        return $filePath;
    }
}
