<?php
/**
 * 
 */

/**
 *
 */
class Default_Model_UserProfile extends Default_Model_Ancestor
{
	protected $_ownerId;
	protected $_avatarId;
	protected $_maxAvatars;

	/**
	 * Get data mapper
	 *
	 * Lazy loads Default_Model_UserProfileMapper instance if no mapper registered.
	 * 
	 * @return Default_Model_UserProfileMapper
	 */
	public function getMapper()
	{
		if (null === $this->_mapper) {
			$this->setMapper(new Default_Model_UserProfileMapper());
		}
		return $this->_mapper;
	}

	public function getOwnerId()
	{
		return $this->_ownerId;
	}

	public function setOwnerId($ownerId)
	{
		$this->_ownerId = intval($ownerId);
		return $this;
	}

	public function getAvatarId()
	{
		return $this->_avatarId;
	}

	public function setAvatarId($avatarId)
	{
		$this->_avatarId = intval($avatarId);
		return $this;
	}
	
	public function getMaxAvatars()
	{
		return $this->_maxAvatars;
	}

	public function setMaxAvatars($value)
	{
		$this->_maxAvatars = intval($value);
		return $this;
	}
	
	public function getDefaultAvatar()
	{
		$model = new Default_Model_UserAvatar();
		$avatar = $model->find($this->getAvatarId());
		unset($model);
		return $avatar;
	}
	
	public function getAvatars()
	{
		$model = new Default_Model_UserAvatar();
		$options = array('userId' => $this->getOwnerId());
		$avatars = $model->getList(1, $this->getMaxAvatars(), $options);
		unset($options, $model);
		return $avatars;
	}
}
?>