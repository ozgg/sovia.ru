<?php
/**
 * 
 */

/**
 *
 */
class Default_Model_UserRoleMapper
{
	/**
	 * @var Zend_Db_Table_Abstract
	 */
	protected $_dbTable;

	/**
	 * Specify Zend_Db_Table instance to use for data operations
	 * 
	 * @param  Zend_Db_Table_Abstract $dbTable 
	 * @return Default_Model_UserRoleMapper
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
	 * Lazy loads Default_Model_DbTable_UserRole if no instance registered
	 * 
	 * @return Zend_Db_Table_Abstract
	 */
	public function getDbTable()
	{
		if (null === $this->_dbTable) {
			$this->setDbTable('Default_Model_DbTable_UserRole');
		}
		return $this->_dbTable;
	}

	/**
	 * Save a user role
	 * 
	 * @param  Default_Model_UserRole $item 
	 * @return void
	 */
	public function save(Default_Model_UserRole $item)
	{
		$data = array(
			'id' => $item->getId(),
			'name' => $item->getName(),
		);
		if (null === ($id = $item->getId())) {
			unset($data['id']);
			$this->getDbTable()->insert($data);
		} else {
			$this->getDbTable()->update($data, array('id = ?' => $id));
		}
	}

	/**
	 * Find a user Role by id
	 * 
	 * @param  int $id 
	 * @param  Default_Model_UserRole $item 
	 * @return void
	 */
	public function find($id, Default_Model_UserRole $item)
	{
		$result = $this->getDbTable()->find($id);
		if (0 == count($result)) {
			return;
		}
		$row = $result->current();
		$item->setId($row->id)
			 ->setName($row->name);
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
			$item = new Default_Model_UserRole();
			$item->setId($row->id)
				 ->setName($row->name)
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
				$item = new Default_Model_UserRole();
				$item->setId($row->id)
					 ->setName($row->name)
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