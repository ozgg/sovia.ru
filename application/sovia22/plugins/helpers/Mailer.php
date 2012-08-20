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

    public function comment(
        Posting_Row $entry,
        Posting_Comment_Row $comment,
        Posting_Comment_Row $parent = null
    )
    {
        $sendComment = false;
        $sendReply   = false;
        $options     = array(
            BodyParser::OPTION_ESCAPE => true,
            BodyParser::OPTION_NO_CUT => true,
        );
        $body = BodyParser::parseEntry($comment->getBody(), $options);

        $entryOwner   = $entry->getOwner();
        $commentOwner = $comment->getOwner();
        $sendComment  = ($commentOwner->getId() != $entryOwner->getId());
        if (!is_null($parent)) {
            $parentOwner = $parent->getOwner();
            $sendReply   = ($parentOwner->getId() != $comment->getId());
            if ($parentOwner->getId() == $entryOwner->getId()) {
                $sendComment = false;
            }
            $sendReply &= (bool) $parentOwner->getAllowMail();
        }
        $sendComment &= (bool) $entryOwner->getAllowMail();

        $view = $this->_getView();
        $view->assign('entry', $entry);
        $view->assign('body', strip_tags($body['body']));
        $view->assign('commentator', $commentOwner);
        if ($sendComment) {
            $subject  = 'sovia.ru: Ответ на вашу запись';
            $template = 'mail/comment.phtml';
            $this->sendMail($entryOwner, $subject, $view->render($template));
        }
        if ($sendReply) {
            $subject  = 'sovia.ru: Ответ на ваш комментарий';
            $template = 'mail/reply.phtml';
            $this->sendMail($entryOwner, $subject, $view->render($template));
        }
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
            $file = sys_get_temp_dir() . '/sovia-' . date('Y-m-d H:i:s') . '.log';
            file_put_contents($file, $subject . PHP_EOL . $body, FILE_APPEND);
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
