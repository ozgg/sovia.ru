<?php
/**
 * 
 */

/**
 *
 */
class Default_Model_UserKeyMapper
{
	/**
	 * @var Zend_Db_Table_Abstract
	 */
	protected $_dbTable;

	/**
	 * Specify Zend_Db_Table instance to use for data operations
	 * 
	 * @param  Zend_Db_Table_Abstract $dbTable 
	 * @return Default_Model_UserKeyMapper
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
	 * Lazy loads Default_Model_DbTable_UserKey if no instance registered
	 * 
	 * @return Zend_Db_Table_Abstract
	 */
	public function getDbTable()
	{
		if (null === $this->_dbTable) {
			$this->setDbTable('Default_Model_DbTable_UserKey');
		}
		return $this->_dbTable;
	}

	/**
	 * Save a user key
	 * 
	 * @param  Default_Model_UserKey $item 
	 * @return void
	 */
	public function save(Default_Model_UserKey $item)
	{
		$data = array(
			'id' => $item->getId(),
			'type' => $item->getType(),
			'owner_id' => $item->getOwnerId(),
			'event_key' => $item->getEventKey(),
			'expires_at' => $item->getExpiresAt(),
		);
		if (null === ($id = $item->getId())) {
			unset($data['id']);
			$this->getDbTable()->insert($data);
		} else {
			$this->getDbTable()->update($data, array('id = ?' => $id));
		}
	}

	/**
	 * Find a user Key by id
	 * 
	 * @param  int $id 
	 * @param  Default_Model_UserKey $item 
	 * @return void
	 */
	public function find($id, Default_Model_UserKey $item)
	{
		$result = $this->getDbTable()->find($id);
		if (0 == count($result)) {
			return;
		}
		$row = $result->current();
		$item->setId($row->id)
			 ->setType($row->type)
			 ->setOwnerId($row->owner_id)
			 ->setEventKey($row->event_key)
			 ->setExpiresAt($row->expires_at);
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
			$item = new Default_Model_UserKey();
			$item->setId($row->id)
				 ->setType($row->type)
				 ->setOwnerId($row->owner_id)
				 ->setEventKey($row->event_key)
				 ->setExpiresAt($row->expires_at)
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
				$item = new Default_Model_UserKey();
				$item->setId($row->id)
					 ->setType($row->type)
					 ->setOwnerId($row->owner_id)
					 ->setEventKey($row->event_key)
					 ->setExpiresAt($row->expires_at)
					 ->setMapper($this);
				$out['list'][] = $item;
				unset($item);
			}
			unset($row);
		}
		return $out;
	}
	
	/**
	 * Истёк ли ключ
	 *
	 * Проверяет, истёк ли ключ заданного типа для заданного пользователя.
	 */
	public function isExpired($ownerId, $type)
	{
		return $this->getDbTable()->isExpired($ownerId, $type);
	}

	public function findByField($field, $value, Default_Model_UserKey $item)
	{
		$result = $this->getDbTable()->findByField($field, $value);
		if (0 == count($result)) {
			return;
		}
		$row = $result->current();
		$item->setId($row->id)
			 ->setType($row->type)
			 ->setOwnerId($row->owner_id)
			 ->setEventKey($row->event_key)
			 ->setExpiresAt($row->expires_at);
	}
	
	public function delete($id)
	{
		return $this->getDbTable()->delete($id);
	}
}
?>