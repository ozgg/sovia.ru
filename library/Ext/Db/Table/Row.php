<?php
/**
 * Date: 28.08.11
 * Time: 15:12
 */
 
class Ext_Db_Table_Row extends Zend_Db_Table_Row_Abstract
{
    protected static $_ip;

    public function getId()
    {
        return $this->get('id');
    }

    public static function setRemoteAddr($ip)
    {
        $octet = '(25[0-5]|2[0-4]\d|1\d{2}|\d{1,2})';
        $cutPattern = "/^{$octet}\.{$octet}\.{$octet}\.{$octet}.*/";
        self::$_ip = preg_replace($cutPattern, '$1.$2.$3.$4', $ip);
    }

    protected function set($column, $value)
    {
        $this->$column = $value;
    }

    protected function get($column)
    {
        return $this->$column;
    }
}
