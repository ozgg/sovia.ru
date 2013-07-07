<?php
/**
 *
 *
 * Date: 07.07.13
 * Time: 12:25
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom
 */

namespace Atom;

use Atom\Traits;

abstract class Renderer
{
    use Traits\HasParameters,
        Traits\BaseDirectory,
        Traits\Dependency\Container;

    /**
     * Render as JSON
     */
    const FORMAT_JSON = 'json';

    /**
     * Render as HTML
     */
    const FORMAT_HTML = 'html';

    /**
     * @var string
     */
    protected $layoutName;

    /**
     * @var string
     */
    protected $viewName;

    /**
     * @return string
     */
    abstract public function render();

    /**
     * @return string
     */
    abstract public function getContentType();

    public static function factory($format, Container $container)
    {
        switch ($format) {
            case static::FORMAT_JSON:
                $renderer = new Renderer\Json;
                break;
            case static::FORMAT_HTML:
                $renderer = new Renderer\Html;
                break;
            default:
                $error = "Invalid renderer format: {$format}";
                throw new \InvalidArgumentException($error);
        }

        $renderer->setDependencyContainer($container);

        return $renderer;
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
     * @return Renderer
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
     * @return Renderer
     */
    public function setViewName($viewName)
    {
        $this->viewName = $viewName;

        return $this;
    }
}
