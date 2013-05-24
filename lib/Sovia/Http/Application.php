<?php
/**
 * HTTP application
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Http
 */

namespace Sovia\Http;

use Sovia\Traits\DependencyContainer;

/**
 * HTTP application
 */
class Application
{
    use DependencyContainer;

    /**
     * Application directory
     *
     * @var string
     */
    protected $directory;

    /**
     * Constructor
     *
     * Sets application directory and bootstraps it
     *
     * @param string $directory
     */
    public function __construct($directory)
    {
        $this->setDirectory($directory);
        $this->bootstrap();
    }

    public function bootstrap()
    {
        $request = new Request($_SERVER);
        $request->setGet($_GET);
        $request->setPost($_POST);
        $request->setFiles($_FILES);
        $request->setCookies($_COOKIE);
        $request->setBody(file_get_contents('php://input'));
    }

    public function run()
    {

    }

    /**
     * Get application directory
     *
     * @return string
     */
    public function getDirectory()
    {
        return $this->directory;
    }

    /**
     * Set application directory
     *
     * @param string $directory
     * @return $this
     * @throws \Exception
     */
    public function setDirectory($directory)
    {
        if (!is_dir($directory)) {
            throw new \Exception("Directory {$directory} does not exist");
        }
        $this->directory = $directory;

        return $this;
    }

    /**
     * Import config from file
     *
     * @param string $name
     * @return array
     * @throws \Exception
     */
    public function importConfig($name)
    {
        if (strpos($name, '..') !== false) {
            throw new \Exception("Bad name for config to include: {$name}");
        }
        $path = realpath($this->directory . DIRECTORY_SEPARATOR . 'config');
        $file = $path . DIRECTORY_SEPARATOR . $name . '.php';
        if (file_exists($file) && is_file($file)) {
            $config = include $file;
        } else {
            throw new \Exception("Cannot read config from file {$file}");
        }

        return (array) $config;
    }
}
