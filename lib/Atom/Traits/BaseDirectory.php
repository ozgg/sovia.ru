<?php
/**
 * 
 * 
 * Date: 07.07.13
 * Time: 12:48
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom\Traits
 */

namespace Atom\Traits;

trait BaseDirectory 
{
    /**
     * @var string
     */
    protected $baseDirectory;

    /**
     * @return string
     */
    public function getBaseDirectory()
    {
        return $this->baseDirectory;
    }

    /**
     * @param string $baseDirectory
     * @throws \InvalidArgumentException
     * @return BaseDirectory
     */
    public function setBaseDirectory($baseDirectory)
    {
        if (!is_dir($baseDirectory)) {
            $error = "Directory {$baseDirectory} does not exist";
            throw new \InvalidArgumentException($error);
        }

        $this->baseDirectory = realpath($baseDirectory);

        return $this;
    }
}
