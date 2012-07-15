<?php
/**
 * 
 */

/**
 *
 */
class Default_Model_UserRole extends Default_Model_Ancestor
{
	protected $_id;
	protected $_name;

	/**
	 * Get data mapper
	 *
	 * Lazy loads Default_Model_UserRoleMapper instance if no mapper registered.
	 * 
	 * @return Default_Model_UserRoleMapper
	 */
	public function getMapper()
	{
		if (null === $this->_mapper) {
			$this->setMapper(new Default_Model_UserRoleMapper());
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

	public function getName()
	{
		return $this->_name;
	}

	public function setName($name)
	{
		$this->_name = $name;
		return $this;
	}
}
?>