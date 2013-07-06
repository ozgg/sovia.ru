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

    /**
     * @var Status
     */
    protected $status;

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
        $action .= 'Action';

        $callback   = [];
        $actionName = strtolower($method) . ucfirst($action);
        if (method_exists($this, $actionName)) {
            $callback = [$this, $actionName];
        } elseif (method_exists($this, $action)) {
            $callback = [$this, $action];
        }

        if (!empty($callback)) {
            call_user_func($callback);
            if (!$this->status instanceof Status) {
                $this->setStatus(new Status\Ok);
            }
            try {
                $this->render();
            } catch (Error $error) {
                $this->renderError($error);
            }
        } else {
            $error = new Error\NotFound("Cannot {$method} {$action} action");
            $this->renderError($error);
        }
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
     * @return \Atom\Http\Status
     */
    public function getStatus()
    {
        return $this->status;
    }

    /**
     * @param \Atom\Http\Status $status
     * @return Controller
     */
    public function setStatus($status)
    {
        $this->status = $status;

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

    protected function render()
    {
        echo 'Rendering', PHP_EOL;
    }

    protected function renderError(Error $exception)
    {
        throw $exception;
    }

    /**
     * @return Route
     * @throws \RuntimeException
     */
    protected function getRoute()
    {
        $route = $this->extractDependency('route');
        if (!$route instanceof Route) {
            throw new \RuntimeException('Cannot extract route');
        }

        return $route;
    }
}
