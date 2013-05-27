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

use Sovia\Exceptions\Http\Client\NotFound;

abstract class Controller
{
    protected $viewName;

    /**
     * @var string
     */
    protected $viewsPath;

    /**
     * Name of layout to use
     *
     * @var string
     */
    protected $layoutName = 'layout';

    public function init()
    {
    }

    public function runAction($method, $name)
    {
        $name      .= 'Action';
        $callback   = [];
        $actionName = strtolower($method) . ucfirst($name);
        if (method_exists($this, $actionName)) {
            $callback = [$this, $actionName];
        } elseif (method_exists($this, $name)) {
            $callback = [$this, $name];
        }

        if (!empty($callback)) {
            call_user_func($callback);
        } else {
            throw new NotFound("Cannot {$method} {$name} action");
        }
    }

    public function render()
    {
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
}
