<?php
/**
 * Date: 25.11.11
 * Time: 23:21
 */
 
class Ext_Validate_NotEmpty extends Zend_Validate_NotEmpty
{
    /**
     * @var array
     */
    protected $_messageTemplates = array(
        self::IS_EMPTY => 'Это поле необходимо заполнить',
        self::INVALID  => 'Неправильный тип данных',
    );
}
