<?php
class Zend_View_Helper_sape extends Zend_View_Helper_Abstract
{
	private static $_stack = array();
    /**
     * @var Sape_Client
     */
    private static $_object;
	
	public function sape($input = null)
	{
		if (empty(self::$_object)) {
			self::$_object = new Sape_Client(array('charset' => 'UTF-8', 'host' => 'sovia.ru'));
		}
		if (is_array($input)) {
			self::$_stack = array_reverse($input);
		} elseif ($input == 'all') {
			$links = self::$_object->return_links();
		} else {
			$links = self::$_object->return_links(intval(array_pop(self::$_stack)));
		}
		if (!empty($links)) {
			return $links;
		} else {
            return null;
        }
	}
}
