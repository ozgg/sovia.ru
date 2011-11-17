<?php
/**
 * Date: 28.08.11
 * Time: 15:01
 */
 
class Ext_Db_Table_Select extends Zend_Db_Table_Select
{
    public function fetchRow()
    {
        return $this->getTable()->fetchRow($this);
    }

    public function fetchAll()
    {
        return $this->getTable()->fetchAll($this);
    }

    public function fetchRowIfExists($message = 'Страница не найдена')
    {
        /** @var $table Ext_Db_Table_Abstract */
        $table = $this->getTable();
        return $table->fetchRowIfExists($this, $message);
    }

    public function paginate($page = 1, $limit = 10)
    {
        /** @var $table Ext_Db_Table_Abstract */
        $table = $this->getTable();
        return $table->paginate($this, $page, $limit);
    }
}
