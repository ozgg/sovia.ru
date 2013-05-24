<?php
/**
 * HTTP application
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Http
 */

namespace Sovia\Http;

use Sovia\Config;
use Sovia\Container;
use Sovia\Router;
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
     * Current environment
     *
     * @var string
     */
    protected $environment;

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
        $this->setDependencyContainer(new Container);
        $this->bootstrap();
    }

    /**
     * Bootstrap application
     */
    public function bootstrap()
    {
        $this->initRequest();
        $this->initRouter();
        $this->injectDependency('session', new Session);
        $this->initConfig();
    }

    public function run()
    {
        header('Content-Type: text/plain');
        echo 'Oh, hi!', PHP_EOL;
        echo $this->getEnvironment(), PHP_EOL;
        print_r($this->getDependencyContainer()->getKeys());
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
     * Set current environment
     *
     * @param string $environment
     * @return Application
     */
    public function setEnvironment($environment)
    {
        $this->environment = (string) $environment;

        return $this;
    }

    /**
     * Get current environment
     *
     * @return string
     */
    public function getEnvironment()
    {
        return $this->environment;
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
     * Initialize request and guess environment
     */
    protected function initRequest()
    {
        $request = new Request($_SERVER);
        $request->setGet($_GET);
        $request->setPost($_POST);
        $request->setFiles($_FILES);
        $request->setCookies($_COOKIE);
        $request->setBody(file_get_contents('php://input'));

        $this->injectDependency('request', $request);

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
}
