<?php
class Ext_Helper_Date
{
	public static function makeString($date, $time = false)
	{
		static $months = array(
			1 => 'января', 'февраля', 'марта',
			'апреля', 'мая', 'июня',
			'июля', 'августа', 'сентября',
			'октября', 'ноября', 'декабра'
		);
		static $days = array(
			'воскресенье', 'понедельник', 'вторник', 'среда', 'четверг',
			'пятница', 'суббота', 'воскресенье'
		);
		$ts   = strtotime($date);
		$mon  = $months[date('n', $ts)];
		$day  = $days[date('w', $ts)];
		$out  = date('d', $ts) . " {$mon} " . date('Y', $ts);
		if ($time) {
			$out .= date(', H:i', $ts);
		}
		$out .= " ({$day})";
		unset($ts, $day, $mon);

		return $out;
	}
}
