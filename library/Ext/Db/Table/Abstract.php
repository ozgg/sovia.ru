<?php
/**
 * Date: 28.08.11
 * Time: 14:50
 */
 
class Ext_Db_Table_Abstract extends Zend_Db_Table_Abstract
{
    /**
     * @var Ext_Db_Table_Row
     */
    protected $_rowClass = 'Ext_Db_Table_Row';

    /**
     * @var Ext_Db_Table_RowSet
     */
    protected $_rowsetClass = 'Ext_Db_Table_Rowset';

    /**
     * @param $field
     * @param $value
     * @return Ext_Db_Table_Select
     */
    public function selectBy($field, $value)
    {
        $select = $this->select();
        $fieldName = $this->getAdapter()->quoteIdentifier($field);
        if (is_null($value)) {
            $select->where("{$fieldName} is null");
        } else {
            $select->where("{$fieldName} in (?)", $value);
        }
        return $select;
    }

    /**
     * @param bool $withFromPart
     * @return Ext_Db_Table_Select
     */
    public function select($withFromPart = self::SELECT_WITHOUT_FROM_PART)
    {
        $select = new Ext_Db_Table_Select($this);
        if ($withFromPart == self::SELECT_WITH_FROM_PART) {
            $name = $this->info(self::NAME);
            $cols = Zend_Db_Table_Select::SQL_WILDCARD;
            $schema = $this->info(self::SCHEMA);
            $select->from($name, $cols, $schema);
        }
        return $select;
    }

    /**
     * @throws Zend_Controller_Router_Exception
     * @param Zend_Db_Table_Select $select
     * @param string $message
     * @return Ext_Db_Table_Row
     */
    public function fetchRowIfExists(Zend_Db_Table_Select $select, $message = '')
    {
        $row = $this->fetchRow($select);
        if (empty($row)) {
            throw new Zend_Controller_Router_Exception($message, 404);
        }

        return $row;
    }

    /**
     * @param Zend_Db_Table_Select $select
     * @param int $page
     * @param int $limit
     * @return Zend_Paginator
     */
    public function paginate(Zend_Db_Table_Select $select, $page = 1, $limit = 10)
    {
        $paginator = Zend_Paginator::factory($select);
        $paginator->setItemCountPerPage($limit);
        $paginator->setCurrentPageNumber($page);
//        $paginator->setPageRange(7);

        return $paginator;
    }
}
