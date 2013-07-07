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

use Atom\Container;
use Atom\Renderer;
use Atom\Traits;

class Controller
{
    use Traits\HasParameters,
        Traits\Environment,
        Traits\Dependency\Container;

    /**
     * @var Status
     */
    protected $status;

    /**
     * @var string
     */
    protected $format = Renderer::FORMAT_HTML;

    /**
     * @var string
     */
    protected $layoutName = 'layout';

    /**
     * @var string
     */
    protected $viewName = 'index';

    public function __construct(Container $container)
    {
        $this->setDependencyContainer($container);
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
        } else {
            throw new Error\NotFound("Cannot {$method} {$action} action");
        }
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
     * @return mixed
     */
    public function getFormat()
    {
        return $this->format;
    }

    /**
     * @param mixed $format
     * @return Controller
     */
    public function setFormat($format)
    {
        $this->format = $format;

        return $this;
    }

    /**
     * @return string
     */
    public function getLayoutName()
    {
        return $this->layoutName;
    }

    /**
     * @param string $layoutName
     * @return Controller
     */
    public function setLayoutName($layoutName)
    {
        $this->layoutName = $layoutName;

        return $this;
    }

    /**
     * @return string
     */
    public function getViewName()
    {
        return $this->viewName;
    }

    /**
     * @param string $viewName
     * @return Controller
     */
    public function setViewName($viewName)
    {
        $this->viewName = $viewName;

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
