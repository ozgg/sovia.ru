<?php
/**
 * 
 * 
 * Date: 25.06.13
 * Time: 16:23
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom\Test
 */

namespace Atom\Test;
 
class TestCase extends \PHPUnit_Framework_TestCase
{
    protected $rootPath = '../../../tests';

    /**
     * Get sample for test from file
     *
     * @param string $name
     * @throws \Exception
     * @return mixed
     */
    protected function getSample($name)
    {
        $sample = null;
        $path   = __DIR__ . DIRECTORY_SEPARATOR . $this->rootPath
            . DIRECTORY_SEPARATOR . 'samples';
        $file   = realpath($path) . DIRECTORY_SEPARATOR . $name . '.php';
        if (file_exists($file) && is_file($file)) {
            $sample = include $file;
        } else {
            throw new \Exception("Cannot load sample {$name} from {$file}");
        }

        return $sample;
    }
}
