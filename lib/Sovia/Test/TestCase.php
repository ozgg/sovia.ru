<?php
/**
 * Test case
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Test
 */

namespace Sovia\Test;

/**
 * Test case
 */
class TestCase extends \PHPUnit_Framework_TestCase
{
    protected $rootPath = '../../../tests';

    /**
     * Get sample for test from file
     *
     * @param string $name
     * @return mixed|null
     */
    protected function getSample($name)
    {
        $sample    = null;
        $directory = realpath(__DIR__ . DIRECTORY_SEPARATOR . $this->rootPath);
        $file      = $directory . DIRECTORY_SEPARATOR . $name . '.php';
        if (file_exists($file) && is_file($file)) {
            $sample = include $file;
        }

        return $sample;
    }
}
