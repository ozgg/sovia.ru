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
        $body    = "<p>Здравствуйте, {$user->getLogin()}.</p>";
        $body   .= '<p>Для сброса вашего пароля проследуйте по ссылке '
                 . '<a href="' . $route . '">' . $route . '</a> '
                 . 'и введите ключ <b>' . $key->getBody() . '</b></p>'
                 . '<p>Если вы не запрашивали восстановление пароля, '
                 . 'просто проигнорируйте это письмо.</p>' . self::SIGN;

        return $this->sendMail($user, $subject, $body);
    }
	
	public function send(User_Row $user, array $params = array())
	{
		if (isset($params['type'])) {
			switch ($params['type']) {
				case self::TYPE_RECOVER:
					$this->recoverPassword($user, $params);
					break;
				case self::TYPE_COMMENT:
					$this->sendCommentNotify($user, $params);
					break;
			}
		}
		return $this;
	}
	
	/**
	 * Восстановление пароля.
	 *
	 * Формирует текст письма и отправляет его пользователю, если все данные
	 * верны.
	 */
	public function recoverPassword(User_Row $user, array $params)
	{
		$error = '';
		if (isset($params['key'])) {
			$key = $params['key'];
			if (is_a($key, 'Default_Model_UserKey')) {
				$mailData = array(
					'toAddress' => $user->getMail(),
					'toName'    => $user->getLogin(),
					'subject'   => 'sovia.ru: Восстановление пароля',
				);
				$userId  = $user->getId();
				$keyText = $key->getEventKey();
				$url  = self::HOST . "/user/recover/key/{$userId}-{$keyText}";
				$link = sprintf('<a href="%1$s">%1$s</a>', $url);
				$expiresAt = $key->getExpiresAt();
				$body  = '';
				$body .= "<p>Здравствуйте, {$user->getLogin()}.</p>";
				$body .= "<p>Для вашего логина был запрос на восстановление
							пароля. Для восстановления пароля пройдите по
							ссылке {$link}</p>";
				$body .= "<p>Ссылка действительна до {$expiresAt}.</p>";
				$body .= '<p>Если вы не запрашивали восстановление пароля,
							просто проигнорирйте это письмо.</p>';
				$body .= self::SIGN;
				$mailData['body'] = $body;
				unset($expiresAt, $url, $link, $userId, $keyText, $body);
				$this->sendMail($mailData);
			} else {
				$error = 'Ошибка ключа восстановления пароля. Неверный класс.';
			}
			unset($key);
		}
		if (!empty($error)) {
			throw new Exception($error);
		}
		return $this;
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
	 * Проверить адрес электронный почты на соответствие шаблону
	 *
	 * Осуществляет простую проверку входящей строки на похожесть на адрес
	 * электронной почты. В случае несоответсвтия выбрасывает исключение.
	 */
	public function validateAddress($address)
	{
		return $this;
	}
	
	/**
	 * Проверить наличие параметров в массиве.
	 *
	 * Ищет в массиве $input индексы, являющиеся элементами массива $required.
	 * Если хотя бы один параметр не найден, выбрасывает исключение с названием
	 * параметра. Останавливается на первом же ненайденном индексе.
	 */
	public function checkParameters(array $input, array $required)
	{
		foreach ($required as $parameter) {
			if (!isset($input[$parameter])) {
				throw new Exception("Параметр {$parameter} не задан.");
			}
		}
		unset($parameter);
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
}
?>