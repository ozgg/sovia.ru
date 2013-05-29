<?php
/**
 *
 *
 * Date: 27.05.13
 * Time: 23:36
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */

namespace Sovia\Application;

use Sovia\Http\Application;
use Sovia\Exceptions\Http\Client\NotFound;
use Sovia\Traits;

abstract class Controller
{
    use Traits\DependencyContainer, Traits\Environment;

    /**
     * @var Application
     */
    protected $application;

    /**
     * @var string
     */
    protected $viewsPath;

    /**
     * Render format
     *
     * @var string
     */
    protected $renderFormat = Renderer::FORMAT_HTML;

    /**
     * Name of layout to use
     *
     * @var string
     */
    protected $layoutName = 'layout';

    /**
     * Name of view to render
     *
     * @var string
     */
    protected $viewName;

    /**
     * Parameters set from view
     *
     * @var array
     */
    protected $parameters = [];

    public function __construct(Application $application)
    {
        $this->application = $application;
        $this->setDependencyContainer($application->getDependencyContainer());

        $route = $this->getRoute();

        $this->viewsPath = $application->getDirectory() . '/views';
        $this->viewName  = strtolower(
            "{$route->getControllerName()}/{$route->getActionName()}"
        );
    }

    public function init()
    {
    }

    public function execute($method, $name)
    {
        $name .= 'Action';

        $callback   = [];
        $actionName = strtolower($method) . ucfirst($name);
        if (method_exists($this, $actionName)) {
            $callback = [$this, $actionName];
        } elseif (method_exists($this, $name)) {
            $callback = [$this, $name];
        }

        if (!empty($callback)) {
            call_user_func($callback);
            $this->render();
        } else {
            throw new NotFound("Cannot {$method} {$name} action");
        }
    }

    public function render()
    {
        $renderer = Renderer::factory($this->renderFormat);
        $renderer->setDirectory($this->getViewsPath());
        $renderer->setLayoutFile('layouts/' . $this->layoutName);
        $renderer->setViewFile('scripts/' . $this->viewName);
        $renderer->render($this->parameters);
    }

    /**
     * Get name of layout to use
     *
     * @return string
     */
    public function getLayoutName()
    {
        return $this->layoutName;
    }

    /**
     * Set name of layout to use
     *
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
    public function getViewsPath()
    {
        return $this->viewsPath;
    }

    /**
     * @param string $viewsPath
     * @return Controller
     */
    public function setViewsPath($viewsPath)
    {
        $this->viewsPath = $viewsPath;

        return $this;
    }

    /**
     * Get used route
     *
     * @return \Sovia\Route
     */
    protected function getRoute()
    {
        $this->requireDependencies('route');

        return $this->extractDependency('route');
    }

    /**
     * Get request
     *
     * @return \Sovia\Http\Request
     */
    protected function getRequest()
    {
        $this->requireDependencies('request');

        return $this->extractDependency('request');
    }
}
