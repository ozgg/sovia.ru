<?php
/**
 * HTTP application
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Http
 */

namespace Sovia\Http;

use Sovia\Application\Controller;
use Sovia\Container;
use Sovia\Exceptions\Http;
use Sovia\Traits;

/**
 * HTTP application
 */
class Application
{
    use Traits\Dependency\LoadingContainer, Traits\Environment;

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
        $this->setDependencyContainer(new Container);
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
        $request = $this->getRequest();

        if (substr($request->getHost(), -5) == 'local') {
            $environment = 'development';
        } else {
            $environment = 'production';
        }

        $this->setEnvironment($environment);
    }

    /**
     * Load controller
     *
     * @param string $name
     * @param string $method
     * @param string $action
     * @throws \Exception
     * @return Controller
     */
    protected function executeController($name, $method, $action)
    {
        $parts = [
            $this->directory,
            'controllers',
            "{$name}Controller"
        ];
        $file  = implode(DIRECTORY_SEPARATOR, $parts) . '.php';
        if (file_exists($file) && is_file($file)) {
            include $file;
            $parts[0]  = $this->getName();
            $className = implode('\\', $parts);
            if (!class_exists($className)) {
                throw new \Exception("Cannot find controller {$className}");
            }
            $controller = new $className($this);
            if (!$controller instanceof Controller) {
                throw new \Exception("Invalid controller: {$className}");
            }
        } else {
            throw new \Exception("Cannot load controller from {$file}");
        }

        $controller->setEnvironment($this->getEnvironment());
        $controller->init();
        $controller->execute($method, $action);
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
        header('HTTP/1.1 500 Internal Server Error');
        header('Content-Type: text/plain');
        if ($this->isDevelopment() || $this->isTest()) {
            echo $e->getMessage(), PHP_EOL;
            echo $e->getTraceAsString(), PHP_EOL;
        } else {
            echo 'Internal server error', PHP_EOL;
        }
    }
}
