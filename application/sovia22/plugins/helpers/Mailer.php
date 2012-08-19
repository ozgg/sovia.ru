<?php
class Helper_Mailer extends Zend_Controller_Action_Helper_Abstract
{
	const TYPE_RECOVER = 1;
	const TYPE_COMMENT = 2;
	const HOST = 'http://sovia.ru';
	const SIGN = "<p>-- <br />С уважением,<br />Команда sovia.ru</p>";

    /**
     * Сброс пароля
     *
     * @param User_Row $user
     * @param User_Key_Row $key
     * @return bool
     */
    public function recover(User_Row $user, User_Key_Row $key)
    {
        $subject = 'Sovia.ru: восстановление пароля';
        $route   = self::HOST . '/user/reset/';
        $view    = $this->_getView();
        $view->assign('user', $user);
        $view->assign('route', $route);
        $view->assign('key', $key);
        $body = $view->render('mail/recover.phtml');
        echo $body;

        return $this->sendMail($user, $subject, $body);
    }

    public function comment(Posting_Row $entry, Posting_Comment_Row $comment)
    {
        $sendComment = false;
        $sendReply   = false;
    }

	public function sendCommentNotify(Default_Model_UserItem $user, array $params)
	{
		$parentId = $params['parentId'];
		$comment  = $params['comment'];
		$entry    = $params['entry'];
		$reply    = Ext_Helper_Sovia_Parser::parse($comment->getBody(), true);
		$entryOwner   = $user;
		$commentOwner = $comment->getOwner();
		$parentOwner  = null;
		$sentToParent = false;
		if (!empty($parentId)) {
			$parent = new Default_Model_PostingComment();
			$parent->find($parentId);
			$parentOwner = $parent->getOwner();
			if (is_object($parentOwner)) {
				if ($parentOwner->getId() != $commentOwner->getId()) {
					if ($parentOwner->getAllowMail()) {
						$mailData = array(
							'toAddress' => $parentOwner->getMail(),
							'toName'    => $parentOwner->getLogin(),
							'subject'   => 'sovia.ru: Ответ на ваш комментарий',
						);
						$url  = self::HOST . $entry->getLink();
						$link = sprintf('<a href="%1$s">%1$s</a>', $url);
						$body  = '';
						$body .= "<p>Здравствуйте, {$user->getLogin()}.</p>";
						$body .= "<p>Вы оставляли комментарий к записи на сайте
									sovia.ru, на него был дан ответ от пользователя
									{$commentOwner->getLogin()}:</p>";
						$body .= "<blockquote>{$reply}</blockquote>";
						$body .= "<hr /><p>Для ответа или просмотра комментария на
									сайте вы можете перейти по ссылке {$link}</p>";
						$body .= self::SIGN;
						$mailData['body'] = $body;
						try {
							$this->sendMail($mailData);
							$sentToParent = true;
						} catch (Exception $e) {
							// do nothing
						}
					}
					
				}
			}
		}
		$parentOwnerId = 0;
		if (is_object($parentOwner)) {
			$parentOwnerId = $parentOwner->getId();
		}
		if ($commentOwner->getId() != $entryOwner->getId()) {
			$sendToEntryOwner = true;
			if ($entryOwner->getId() == $parentOwnerId) {
				$sendToEntryOwner = !$sentToParent;
			}
			if ($sendToEntryOwner && $entryOwner->getAllowMail()) {
				$mailData = array(
					'toAddress' => $entryOwner->getMail(),
					'toName'    => $entryOwner->getLogin(),
					'subject'   => 'sovia.ru: Ответ на вашу запись',
				);
				$url  = self::HOST . $entry->getLink();
				$link = sprintf('<a href="%1$s">%1$s</a>', $url);
				$body  = '';
				$body .= "<p>Здравствуйте, {$user->getLogin()}.</p>";
				$body .= "<p>Вы оставляли запись на сайте sovia.ru, на неё 
							был оставлен комментарий от пользователя
							{$commentOwner->getLogin()}:</p>";
				$body .= "<blockquote>{$reply}</blockquote>";
				$body .= "<hr /><p>Для ответа или просмотра комментария на
							сайте вы можете перейти по ссылке {$link}</p>";
				$body .= self::SIGN;
				$mailData['body'] = $body;
				try {
					$this->sendMail($mailData);
				} catch (Exception $e) {
					// do nothing
				}
			}
		}
		return $this;
	}

    /**
     * Отправить письмо
     *
     * @param \User_Row $user
     * @param string $subject
     * @param string $body
     * @return bool
     */
	public function sendMail(User_Row $user, $subject, $body)
	{
        try {
            $mail = new Zend_Mail('utf-8');
            $mail->setFrom('support@sovia.ru', 'Sovia.ru');
            $mail->setSubject($subject);
            $mail->addTo($user->getEmail(), $user->getLogin());
            $mail->setBodyHtml($body, 'UTF-8', Zend_Mime::ENCODING_BASE64);
            $mail->send();
            $isSent = true;
        } catch (Exception $e) {
            $isSent = false;
        }

        return $isSent;
	}

    protected function _getView()
    {
        $config = array('scriptPath' => APPLICATION_PATH . '/views/scripts');

        return new Zend_View($config);
    }
}
