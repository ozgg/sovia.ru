<?php
/**
 * Class loader
 *
 * Used for auto-loading classes during runtime
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia
 */

namespace Sovia;

/**
 * Class Loader
 */
class Loader
{
    /**
     * Load class
     *
     * @param string $className
     */
    public static function load($className)
    {
        static $library = '';   // Path to library root

        if ($library == '') {
            $library = realpath(__DIR__ . '/../');
        }

        // Get parts of full class name with namespace
        $parts = explode('\\', $className);
        $path  = $library;

        // Class name has namespace in it?
        if (count($parts) > 1) {
            $file  = \array_pop($parts);
            $path .= implode(DIRECTORY_SEPARATOR, $parts);
        } else {
            $file = $className;
        }
        $file = $path . DIRECTORY_SEPARATOR . $file . '.php';
        if (file_exists($file) && is_file($file)) {
            require $file;
        }
    }
}
