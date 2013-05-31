<?php
/**
 * HTTP application
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Http
 */

namespace Sovia\Http;

use Sovia\Application\Controller;
use Sovia\Config;
use Sovia\Container;
use Sovia\Router;
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
        $this->guessEnvironment();
        $this->initRouter();
        $this->injectDependency('session', new Session);
        $this->initConfig();
    }

    /**
     * Run application
     *
     * Loads controller and runs it
     */
    public function run()
    {
        $this->requireDependencies('request', 'router');
        try {
            /**
             * @var Request $request
             * @var Router  $router
             */
            $request = $this->extractDependency('request');
            $router  = $this->extractDependency('router');

            $route = $router->matchRequest($request->getUri());
            $this->injectDependency('route', $route);

            $parts = [
                $this->directory,
                'controllers',
                $route->getControllerName() . 'Controller'
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
            $controller->execute(
                $request->getMethod(), $route->getActionName()
            );
        } catch (\Exception $e) {
            $this->fallback($e);
        }
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
     * Initialize router
     */
    protected function initRouter()
    {
        $routes = $this->importConfig('routes');
        $router = new Router;
        $router->import($routes);

        $this->injectDependency('router', $router);
    }

    /**
     * Initialize environment configuration
     */
    protected function initConfig()
    {
        $baseDir = $this->getDirectory() . '/../../config';
        $config  = new Config($baseDir);
        $config->load($this->getEnvironment());
        $this->injectDependency('config', $config);
    }

    protected function fallback(\Exception $e)
    {
        header('Content-Type: text/plain');
        echo $e->getMessage(), PHP_EOL;
        echo $e->getTraceAsString(), PHP_EOL;
    }
}
