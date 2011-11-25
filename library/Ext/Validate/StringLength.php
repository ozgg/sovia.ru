<?php
/**
 * Date: 25.11.11
 * Time: 23:26
 */
 
class Ext_Validate_StringLength extends Zend_Validate_StringLength
{
    /**
     * @var array
     */
    protected $_messageTemplates = array(
        self::INVALID   => 'Неправильный тип данных. Ожидается строка',
        self::TOO_SHORT => "Длина строки '%value%' меньше %min%",
        self::TOO_LONG  => "Длина строки '%value%' больше %max%",
    );

}
