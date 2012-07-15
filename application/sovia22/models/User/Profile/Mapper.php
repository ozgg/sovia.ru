<?php
/**
 * 
 */

/**
 *
 */
class Default_Model_UserProfileMapper
{
	/**
	 * @var Zend_Db_Table_Abstract
	 */
	protected $_dbTable;

	/**
	 * Specify Zend_Db_Table instance to use for data operations
	 * 
	 * @param  Zend_Db_Table_Abstract $dbTable 
	 * @return Default_Model_UserProfileMapper
	 */
	public function setDbTable($dbTable)
	{
		if (is_string($dbTable)) {
			$dbTable = new $dbTable();
		}
		if (!$dbTable instanceof Zend_Db_Table_Abstract) {
			throw new Exception('Invalid table data gateway provided');
		}
		$this->_dbTable = $dbTable;
		return $this;
	}

	/**
	 * Get registered Zend_Db_Table instance
	 *
	 * Lazy loads Default_Model_DbTable_UserProfile if no instance registered
	 * 
	 * @return Zend_Db_Table_Abstract
	 */
	public function getDbTable()
	{
		if (null === $this->_dbTable) {
			$this->setDbTable('Default_Model_DbTable_UserProfile');
		}
		return $this->_dbTable;
	}

	/**
	 * Save a user item
	 * 
	 * @param  Default_Model_UserProfile $item 
	 * @return void
	 */
	public function save(Default_Model_UserProfile $item)
	{
		$data = array(
			'owner_id' => $item->getOwnerId(),
			'avatar_id' => $item->getAvatarId(),
			'max_avatars' => $item->getMaxAvatars(),
		);
		$id = $data['owner_id'];
		unset($data['owner_id']);
		$this->getDbTable()->update($data, array('owner_id = ?' => $id));
		unset($id, $data);
	}

	/**
	 * Find a user item by id
	 * 
	 * @param  int $id 
	 * @param  Default_Model_UserProfile $item 
	 * @return void
	 */
	public function find($id, Default_Model_UserProfile $item)
	{
		$result = $this->getDbTable()->find($id);
		if (0 == count($result)) {
			return;
		}
		$row = $result->current();
		$item->setOwnerId($row->owner_id)
			 ->setAvatarId($row->avatar_id)
			 ->setMaxAvatars($row->max_avatars);
	}

	public function findByField($field, $value, Default_Model_UserProfile $item)
	{
		$result = $this->getDbTable()->findByField($field, $value);
		if (0 == count($result)) {
			return;
		}
		$row = $result->current();
		$item->setOwnerId($row->owner_id)
			 ->setAvatarId($row->avatar_id)
			 ->setMaxAvatars($row->max_avatars);
	}

	/**
	 * Fetch all Items
	 * 
	 * @return array
	 */
	public function fetchAll()
	{
		$resultSet = $this->getDbTable()->fetchAll();
		$items   = array();
		foreach ($resultSet as $row) {
			$item = new Default_Model_UserProfile();
			$item->setOwnerId($row->owner_id)
				 ->setAvatarId($row->avatar_id)
				 ->setMaxAvatars($row->max_avatars)
				 ->setMapper($this);
			$items[] = $item;
		}
		return $items;
	}
	
	public function getList($page, $epp)
	{
		$list = $this->getDbTable()->getList($page, $epp);
		$out  = array('count' => 0, 'list' => array());
		$out['count'] = $list['count'];
		if (!empty($list['list'])) {
			foreach ($list['list'] as $row) {
				$item = new Default_Model_UserProfile();
				$item->setOwnerId($row->owner_id)
					 ->setAvatarId($row->avatar_id)
					 ->setMaxAvatars($row->max_avatars)
					 ->setMapper($this);
				$out['list'][] = $item;
				unset($item);
			}
			unset($row);
		}
		return $out;
	}
}
?>