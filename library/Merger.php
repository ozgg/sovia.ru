<?php
/**
* Created by JetBrains PhpStorm.
* User: ozgg
* Date: 11.06.11
* Time: 23:50
*/

/**
* Класс для слияния массивов конфигурации
*/
class Merger
{
    /**
     * Выполнить рекурсивное слияние массивов
     *
     * @static
     * @param array $left
     * @param array $right
     * @return array
     */
    public static function merge(array $left, array $right)
    {
        foreach ($right as $key => $value) {
            if (array_key_exists($key, $left) && is_array($value)) {
                $left[$key] = self::merge($left[$key], $right[$key]);
            } else {
                $left[$key] = $value;
            }
        }

        return $left;
    }
}