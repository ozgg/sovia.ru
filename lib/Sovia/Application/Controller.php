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

use Sovia\Exceptions;
use Sovia\Exceptions\Http\Client\NotFound;
use Sovia\Http;
use Sovia\Traits;

abstract class Controller
{
    use Traits\Dependency\LoadingContainer,
        Traits\Environment,
        Traits\ResponseStatus;

    /**
     * @var Http\Application
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

    public function __construct(Http\Application $application)
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

    public function execute($method, $action)
    {
        $action .= 'Action';

        $callback = [];
        $actionName = strtolower($method) . ucfirst($action);
        if (method_exists($this, $actionName)) {
            $callback = [$this, $actionName];
        } elseif (method_exists($this, $action)) {
            $callback = [$this, $action];
        }

        if (!empty($callback)) {
            call_user_func($callback);
            if (!$this->status instanceof Http\Status) {
                $this->setStatus(new Http\Status\Ok);
            }
            try {
                $this->render();
            } catch (Exceptions\Http $error) {
                $this->renderError($error);
            }
        } else {
            $error = new NotFound("Cannot {$method} {$action} action");
            $this->renderError($error);
        }
    }

    public function render()
    {
        $renderer = Renderer::factory($this->renderFormat);
        $renderer->setDirectory($this->getViewsPath());
        $renderer->setDefaultView($this->viewName);
        $renderer->render($this->layoutName, $this->parameters);
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
     * Set internal parameter
     *
     * @param string $parameter
     * @param mixed  $value
     */
    protected function setParameter($parameter, $value)
    {
        $this->parameters[$parameter] = $value;
    }

    /**
     * Get parameter
     *
     * @param string $parameter
     * @param mixed  $default
     * @return mixed
     */
    protected function getParameter($parameter, $default = null)
    {
        if (isset($this->parameters[$parameter])) {
            $value = $this->parameters[$parameter];
        } else {
            $route = $this->getRoute()->getParameters();
            if (isset($route[$parameter])) {
                $value = $route[$parameter];
            } else {
                $value = $this->getRequest()->getParameter(
                    $parameter, $default
                );
            }
        }

        return $value;
    }

    protected function renderError(Exceptions\Http $exception)
    {
        $status = $exception->getStatus();

        header("HTTP/1.1 {$status->getCode()} {$status->getMessage()}");

        ob_end_clean();

        $this->setParameter('exception', $exception);
        $this->setParameter('is_development', $this->isDevelopment());

        $renderer = Renderer::factory(Renderer::FORMAT_HTML);
        $renderer->render('error', $this->parameters);

        // throw $exception;
    }
}
