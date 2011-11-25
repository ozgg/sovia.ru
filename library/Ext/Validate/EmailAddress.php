<?php
/**
 * Date: 25.11.11
 * Time: 23:55
 */
 
class Ext_Validate_EmailAddress extends Zend_Validate_EmailAddress
{
    /**
     * @var array
     */
    protected $_messageTemplates = array(
        self::INVALID            => 'Неправильный формат данных. Ожидается строка.',
        self::INVALID_FORMAT     => "'%value%' не похоже на адрес в виде local-part@hostname",
        self::INVALID_HOSTNAME   => "'%hostname%' — неправильное имя хоста для '%value%'",
        self::INVALID_MX_RECORD  => "'%hostname%' не имеет действительной MX-записи для адреса '%value%'",
        self::INVALID_SEGMENT    => "'%hostname%' находится в недоступном сегменте. Адрес '%value%' должен разрешаться из публичной сети",
        self::DOT_ATOM           => "'%localPart%' can not be matched against dot-atom format",
        self::QUOTED_STRING      => "'%localPart%' can not be matched against quoted-string format",
        self::INVALID_LOCAL_PART => "'%localPart%' не является правильной частью в '%value%'",
        self::LENGTH_EXCEEDED    => "'%value%' превышает допустимую длину",
    );
}
