<?php
/**
 * Date: 25.11.11
 * Time: 23:34
 */
 
class Ext_Validate_Db_NoRecordExists extends Zend_Validate_Db_NoRecordExists
{
    /**
     * @var array Message templates
     */
    protected $_messageTemplates = array(
        self::ERROR_RECORD_FOUND    => "Запись '%value%' уже есть",
    );
}
