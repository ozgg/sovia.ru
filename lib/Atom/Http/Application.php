<?php
/**
 * 
 * 
 * Date: 27.06.13
 * Time: 15:31
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom\Http
 */

namespace Atom\Http;
 
use Atom\Container;
use Atom\Traits;

class Application
{
    use Traits\Environment, Traits\Dependency\Container;

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
        $this->initRequest();
        $this->guessEnvironment();
    }

    public function run()
    {
        header('Content-Type: text/plain;charset=UTF-8');
        echo 'Atom!';
    }

    /**
     * @return string
     */
    public function getDirectory()
    {
        return $this->directory;
    }

    /**
     * @param string $directory
     * @return Application
     */
    public function setDirectory($directory)
    {
        $this->directory = $directory;

        return $this;
    }

    /**
     * @return string
     */
    public function getName()
    {
        return $this->name;
    }

    /**
     * @param string $name
     * @return Application
     */
    public function setName($name)
    {
        $this->name = $name;

        return $this;
    }

    /**
     * @return Request
     * @throws \RuntimeException
     */
    public function getRequest()
    {
        $request = $this->extractDependency('request');
        if (!$request instanceof Request) {
            $this->initRequest();
            $request = $this->extractDependency('request');
        }
        if (!$request instanceof Request) {
            throw new \RuntimeException('Cannot extract request');
        }

        return $request;
    }

    protected function initRequest()
    {
        $request = new Request($_SERVER);
        $request->setPost($_POST);
        $request->setGet($_GET);
        $request->setBody(file_get_contents('php://input'));

        $this->injectDependency('request', $request);
    }

    protected function guessEnvironment()
    {
        $request = $this->getRequest();
        $host    = $request->getHost();
        if (strpos($host, '.local') !== false) {
            $environment = 'development';
        } elseif (strpos($host, 'test.') !== false) {
            $environment = 'test';
        } else {
            $environment = 'production';
        }

        $this->setEnvironment($environment);
    }
}
