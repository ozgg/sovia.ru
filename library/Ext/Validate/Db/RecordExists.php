<?php
/**
 * Date: 25.11.11
 * Time: 23:34
 */
 
class Ext_Validate_Db_RecordExists extends Zend_Validate_Db_RecordExists
{
    /**
     * @var array Message templates
     */
    protected $_messageTemplates = array(
        self::ERROR_NO_RECORD_FOUND => "Записи '%value%' не найдено",
    );
}
