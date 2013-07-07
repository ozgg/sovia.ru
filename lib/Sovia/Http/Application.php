<?php
/**
 * HTTP application
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Http
 */

namespace Sovia\Http;

use Sovia\Exceptions\Http;
use Sovia\Traits;

/**
 * HTTP application
 */
class Application
{

    /**
     * Application directory
     *
     * @var string
     */
    protected $directory;

    /**
     * Application name
     *
     * @var string
     */
    protected $name;

    /**
     * Constructor
     *
     * Sets application directory and bootstraps it
     *
     * @param string $directory
     */
    public function __construct($directory)
    {
        $name = ucfirst(strtolower(basename($directory)));

        $this->setDirectory($directory);
        $this->setName($name);
        $this->bootstrap();
    }

    /**
     * Bootstrap application
     */
    public function bootstrap()
    {
    }

    /**
     * Run application
     *
     * Loads controller and runs it
     */
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
     * Get application name
     *
     * @return string
     */
    public function getName()
    {
        return $this->name;
    }

    /**
     * Set application name
     *
     * @param string $name
     * @return Application
     */
    public function setName($name)
    {
        $this->name = $name;

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

    /**
     * Guess environment
     */
    protected function guessEnvironment()
    {
    }

    protected function executeController($name, $method, $action)
    {
    }

    protected function renderError(Http $error)
    {
    }

    /**
     * Fallback if exception is caught
     *
     * @param \Exception $e
     */
    protected function fallback(\Exception $e)
    {
    }
}
