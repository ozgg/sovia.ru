<?php
/**
 * 
 */

/**
 *
 */
class Default_Model_UserAvatarMapper
{
	/**
	 * @var Zend_Db_Table_Abstract
	 */
	protected $_dbTable;

	/**
	 * Specify Zend_Db_Table instance to use for data operations
	 * 
	 * @param  Zend_Db_Table_Abstract $dbTable 
	 * @return Default_Model_UserAvatarMapper
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
	 * Lazy loads Default_Model_DbTable_UserAvatar if no instance registered
	 * 
	 * @return Zend_Db_Table_Abstract
	 */
	public function getDbTable()
	{
		if (null === $this->_dbTable) {
			$this->setDbTable('Default_Model_DbTable_UserAvatar');
		}
		return $this->_dbTable;
	}

	/**
	 * Save a user item
	 * 
	 * @param  Default_Model_UserAvatar $item 
	 * @return void
	 */
	public function save(Default_Model_UserAvatar $item)
	{
		$data = array(
			'id' => $item->getId(),
			'owner_id' => $item->getOwnerId(),
			'name' => $item->getName(),
			'extension' => $item->getExtension(),
		);
		if (is_null($id = $item->getId())) {
			unset($data['id']);
			$id = $this->getDbTable()->insert($data);
			$item->setId($id);
		} else {
			unset($data['id'], $data['owner_id']);
			$this->getDbTable()->update($data, array('id = ?' => $id));
		}
	}

	/**
	 * Find a user item by id
	 * 
	 * @param  int $id 
	 * @param  Default_Model_UserAvatar $item 
	 * @return void
	 */
	public function find($id, Default_Model_UserAvatar $item)
	{
		$result = $this->getDbTable()->find($id);
		if (0 == count($result)) {
			return;
		}
		$row = $result->current();
		$item->setId($row->id)
			 ->setOwnerId($row->owner_id)
			 ->setName($row->name)
			 ->setExtension($row->extension);
	}

	public function findByField($field, $value, Default_Model_UserAvatar $item)
	{
		$result = $this->getDbTable()->findByField($field, $value);
		if (0 == count($result)) {
			return;
		}
		$row = $result->current();
		$item->setId($row->id)
			 ->setOwnerId($row->owner_id)
			 ->setName($row->name)
			 ->setExtension($row->extension);
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
			$item = new Default_Model_UserAvatar();
			$item->setId($row->id)
				 ->setOwnerId($row->owner_id)
				 ->setName($row->name)
				 ->setExtension($row->extension)
				 ->setMapper($this);
			$items[] = $item;
		}
		return $items;
	}
	
	public function getList($page, $epp, array $options)
	{
		$list = $this->getDbTable()->getList($page, $epp, $options);
		$out  = array('count' => 0, 'list' => array());
		$out['count'] = $list['count'];
		if (!empty($list['list'])) {
			foreach ($list['list'] as $row) {
				$item = new Default_Model_UserAvatar();
				$item->setId($row->id)
					 ->setOwnerId($row->owner_id)
					 ->setName($row->name)
					 ->setExtension($row->extension)
					 ->setMapper($this);
				$out['list'][] = $item;
				unset($item);
			}
			unset($row);
		}
		return $out;
	}
	
	public function delete($id)
	{
		return $this->getDbTable()->delete($id);
	}
	
	public function getCountOf($userId)
	{
		return $this->getDbTable()->getCountOf($userId);
	}
}
?>