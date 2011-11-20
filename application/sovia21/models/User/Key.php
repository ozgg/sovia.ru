<?php
/**
 * 
 */

/**
 *
 */
class Default_Model_UserKey extends Default_Model_Ancestor
{
	protected $_id;
	protected $_type;
	protected $_ownerId;
	protected $_eventKey;
	protected $_expiresAt;
	const TYPE_PASSWORD = 1;

	/**
	 * Get data mapper
	 *
	 * Lazy loads Default_Model_UserKeyMapper instance if no mapper registered.
	 * 
	 * @return Default_Model_UserKeyMapper
	 */
	public function getMapper()
	{
		if (null === $this->_mapper) {
			$this->setMapper(new Default_Model_UserKeyMapper());
		}
		return $this->_mapper;
	}
	
	public function getId()
	{
		return $this->_id;
	}

	public function setId($id)
	{
		$this->_id = intval($id);
		return $this;
	}

	public function getType()
	{
		return $this->_type;
	}

	public function setType($type)
	{
		$this->_type = $type;
		return $this;
	}

	public function getOwnerId()
	{
		return $this->_ownerId;
	}

	public function setOwnerId($ownerId)
	{
		$this->_ownerId = $ownerId;
		return $this;
	}

	public function getEventKey()
	{
		return $this->_eventKey;
	}

	public function setEventKey($eventKey)
	{
		$this->_eventKey = $eventKey;
		return $this;
	}

		public function getExpiresAt()
	{
		return $this->_expiresAt;
	}

	public function setExpiresAt($expiresAt)
	{
		$this->_expiresAt = $expiresAt;
		return $this;
	}
	
	public function create(Default_Model_UserItem $user, $type)
	{
		settype($type, 'int');
		$expiring = array(
			self::TYPE_PASSWORD => true,
		);
		$ownerId  = $user->getId();
		$addKey   = true;
		$expiry   = new Zend_Db_Expr('NOW() + INTERVAL 1 YEAR');
		$addError = false;
		if (isset($expiring[$type])) {
			$addKey = $this->getMapper()->isExpired($ownerId, $type);
			$expiry = new Zend_Db_Expr('NOW() + INTERVAL 1 DAY');
			if (!$addKey) {
				$addError = 'Предыдущий ключ ещё не истёк.';
			}
		}
		if ($addKey) {
			$key = md5("{$ownerId}-{$type}-" . microtime());
			$this->setType($type)
				 ->setOwnerId($ownerId)
				 ->setEventKey($key)
				 ->setExpiresAt($expiry);
			$this->save();
			unset($key);
		} else {
			$error = 'Ключ пользователя не может быть добавлен.';
			if (!empty($addError)) {
				$error .= "<br />{$addError}";
				unset($addError);
			}
			throw new Exception($error);
		}
		unset($addKey, $expiry, $ownerId, $expiring);
		return $this;
	}
	
	public function isExpired()
	{
		$expiresAt = preg_replace('/\D/', '', $this->getExpiresAt());
		$isExpired = ($expiresAt < date('YmdHis'));
		unset($expiresAt);
		return $isExpired;
	}
}
?>