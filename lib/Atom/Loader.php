<?php
/**
 * Загрузчик классов
 *
 * Используется для автозагрузки классов
 * 
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom
 */

namespace Atom;

/**
 * Загрузчик классов
 */
class Loader
{
    /**
     * Загрузить класс
     *
     * @param string $className
     */
    public static function load($className)
    {
        static $library = '';   // Путь к корню библиотеки

        if ($library == '') {
            $library = realpath(__DIR__ . '/../');
        }

        // Получить части полного название класса с пространством имён
        $parts = explode('\\', $className);
        $path  = $library . DIRECTORY_SEPARATOR;

        // У названия класса есть пространство имён?
        if (count($parts) > 1) {
            $file  = \array_pop($parts);
            $path .= implode(DIRECTORY_SEPARATOR, $parts) . DIRECTORY_SEPARATOR;
        } else {
            $file = $className;
        }

        // Дополнить путь к файлу расширением
        $file = $path . $file . '.php';
        if (file_exists($file) && is_file($file)) {
            require $file;
        }
    }
}
