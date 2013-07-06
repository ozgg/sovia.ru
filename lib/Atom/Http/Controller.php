<?php
/**
 * 
 * 
 * Date: 06.07.13
 * Time: 21:15
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom\Http
 */

namespace Atom\Http;
 
use Atom\Traits;

class Controller
{
    use Traits\HasParameters,
        Traits\Environment,
        Traits\Dependency\Container;

    /**
     * @var Application
     */
    protected $application;

    public function __construct(Application $application)
    {
        $this->setApplication($application);
        $this->setDependencyContainer($application->getDependencyContainer());
    }

    public function init()
    {
    }

    public function execute($method, $action)
    {
        echo "{$method}:{$action}";
    }

    /**
     * @return \Atom\Http\Application
     */
    public function getApplication()
    {
        return $this->application;
    }

    /**
     * @param \Atom\Http\Application $application
     * @return Controller
     */
    public function setApplication(Application $application)
    {
        $this->application = $application;

        return $this;
    }

    /**
     * @return Request
     * @throws \RuntimeException
     */
    protected function getRequest()
    {
        $request = $this->extractDependency('request');
        if (!$request instanceof Request) {
            throw new \RuntimeException('Cannot extract request');
        }

        return $request;
    }
}
