<?php
/**
 * Склонение чисел
 *
 * Класс используется для склонения единиц измерения, чтобы можно было выводить
 * не «21 штук», а «21 штука», например.
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @version 1.0
 */
class Ext_Helper_Declension
{
	/**
	 * Просклонять
	 *
	 * На входе принимает число и массив с описаниями того, в какой форме должны
	 * быть единицы в разных диапазонах чисел:
	 *  1 элемент — для ([^1]|^)1$
	 *  2 элемент — для ([^1]|^)[2-4]$
	 *  0 элемент — для остального
	 * Каждый элемент — это строка для sprintf
	 *
	 * @param int $number число
	 * @param array $names описание склонений
	 * @return string строка числом и правильной формой
	 */
	public static function decline($number, array $names = array())
	{
		/**
		 * На случай отрицательного числа фиксируем знак
		 */
		$minus = false;
		if (is_int($number)) {
			$minus = ($number < 0);
		} elseif (is_string($number)) {
			$minus = ($number[0] == '-');
		}

		/**
		 * Нужно будет оперировать только с цифрами, поэтому их и оставляем.
		 */
		$number = preg_replace('/\D/', '', $number);

		/**
		 * Массив со склонениями по умолчанию на случай отсутствия данных в
		 * переданном массиве $names
		 */
		$items = array(
			(isset($names[0]) ? $names[0] : '%d единиц'),
			(isset($names[1]) ? $names[1] : '%d единица'),
			(isset($names[2]) ? $names[2] : '%d единицы'),
		);

		/**
		 * Определяем, какую форму нужно использовать
		 */
		if (preg_match('/([^1]|^)1$/', $number)) {
			$index = 1;
		} elseif (preg_match('/([^1]|^)[2-4]$/', $number)) {
			$index = 2;
		} else {
			$index = 0;
		}

		/**
		 * Возвращаем на место знак, если он был, и добавляем %d в начало
		 * строки с форматом, если её там не было.
		 */
		$format = $minus ? '-' : '';
		if (strpos($items[$index], '%d') === false) {
			$format .= '%d ';
		}
		$format .= $items[$index];

		return sprintf($format, $number);
	}
}
