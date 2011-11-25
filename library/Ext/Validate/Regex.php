<?php
/**
 * Date: 25.11.11
 * Time: 23:40
 */
 
class Ext_Validate_Regex extends Zend_Validate_Regex
{
    /**
     * @var array
     */
    protected $_messageTemplates = array(
        self::INVALID   => 'Недопустимый тип данных',
        self::NOT_MATCH => "'%value%' не подходит под шаблон '%pattern%'",
        self::ERROROUS  => "Внутренняя ошибка при использовании шаблона '%pattern%'",
    );
}
