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
            $this->_redirect($this->view->url(array(), 'user_login', true));
        }
    }

    public function indexAction()
    {
        $this->checkUser();
        $this->view->headTitle('Личный кабинет');
    }

    public function avatarsAction()
    {
        $this->checkUser();
        $view = $this->view;
        $table = new User;
        /** @var $user User_Row */
        $user = $table->selectBy('id', $this->_user->getId())->fetchRowIfExists();
        $view->user = $user;
        $this->view->headTitle('Управление картинками пользователя');

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
                    $avatar = $avatarTable->selectBy('id', $avatarId)->fetchRowIfExists();
                    if ($avatar->getOwnerId() == $user->getId()) {
                        if (isset($data['del'])) {
                            try {
                                $name = strip_tags($avatar->getName());
                                $avatar->delete();
                                $results[] = "Картинка {$name} удалена.";
                            } catch (Exception $e) {
                                $errors[] = $e->getMessage();
                            }
                        } else {
                            if (isset($data['name'])) {
                                $avatar->setName($data['name']);
                                try {
                                    $avatar->save();
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
                $avatar = $avatarTable->selectBy('id', $post)->fetchRowIfExists();
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
        $this->view->errors = $errors;
        $this->view->list   = $list;
        $this->_setFlashMessage($results);
    }

    public function dreamsAction()
    {

    }

    public function profileAction()
    {
        $this->checkUser();
        $view = $this->view;
        $table = new User;
        /** @var $user User_Row */
        $user = $table->selectBy('id', $this->_user->getId())->fetchRowIfExists();
        $view->user = $user;

        $view->headTitle('Редактировать профиль');
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
                    $this->_redirect($view->url(array(), 'cabinet_profile', true));
                } catch (Exception $e) {
                    $errors[] = $e->getMessage();
                }
            }
        }
        $view->errors = $errors;
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
   		$upload = new Zend_File_Transfer_Adapter_Http();
//   		$upload->setDestination(APPLICATION_PATH . '/upload/');
   		$upload->receive();
   		$filePath = $upload->getFileName($name);
   		if (!empty($filePath)) {
   			$data = array(
   				'owner_id' => $this->_userId,
   				'name'     => date('Y-m-d H:i'),
   			);
   			$model = new Default_Model_UserAvatar($data);
   			$mimetype = $upload->getMimeType('avatar_add');
   			if (strpos($mimetype, 'image/') === 0) {
   				$model->setFile($filePath);
   			} else {
   				throw new Exception('Недопустимый тип файла.');
   			}
   		}
   		return $filePath;
   	}

   	protected function _getEntries(Default_Model_PostingItem $model, $epp = 10, $tag = null)
   	{
   		$list  = array('count' => 0, 'list' => array());
   		$pager = null;
   		$options = array(
   			'tag'      => $tag,
   			'owner_id' => $this->_userId,
   			'is_internal' => 255,
   		);
   		$list  = $model->getList($this->_page, $epp, $options);
   		$pages = new Zend_Paginator_Adapter_Null($list['count']);
   		$pager = new Zend_Paginator($pages);
   		$pager->setCurrentPageNumber($this->_page)
   			  ->setItemCountPerPage($epp);
   		unset($pages);
   		$this->view->pager = $pager;
   		$this->view->list  = $list;
   		$this->view->page  = $this->_page;
   		$this->view->tag   = $tag;
   	}

   	protected function _getTags($epp = 50, $typeId = null)
   	{
   		$options = array(
   			'type'     => $typeId,
   			'owner_id' => $this->_userId,
   		);
   		$model = new Default_Model_PostingTag();
   		$list   = $model->getList($this->_page, $epp, $options);
   		$pages  = new Zend_Paginator_Adapter_Null($list['count']);
   		$pager  = new Zend_Paginator($pages);
   		$pager->setCurrentPageNumber($this->_page)
   			  ->setItemCountPerPage($epp);
   		$this->view->total = ceil($list['count'] / $epp);
   		$this->view->pager = $pager;
   		$this->view->list  = $list;
   		$this->view->page  = $this->_page;
   		$this->view->forms = array('%d снов', '%d сон', '%d сна');
   		unset($pages, $model, $epp, $typeId);
   	}
}
