<?php
/**
 *
 *
 * Date: 29.05.13
 * Time: 22:36
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */

namespace Sovia\Application;

abstract class Renderer
{
    const FORMAT_HTML = 'html';
    const FORMAT_JSON = 'json';
    const FORMAT_TEXT = 'text';

    /**
     * Directory with layouts and views
     *
     * @var string
     */
    protected $directory;

    /**
     * Default view to use
     *
     * @var string
     */
    protected $defaultView;

    /**
     * @var string
     */
    protected $charset = 'UTF-8';

    /**
     * @var array
     */
    protected $parameters;

    /**
     * Render view
     *
     * @param string $layout
     * @param array  $parameters
     * @return void
     */
    abstract public function render($layout, array $parameters);

    /**
     * Factory
     *
     * @param string $format
     * @throws \ErrorException
     * @return Renderer\Html|Renderer\Json|Renderer\Text
     */
    public static function factory($format)
    {
        switch ($format) {
            case static::FORMAT_TEXT:
                $renderer = new Renderer\Text;
                break;
            case static::FORMAT_HTML:
                $renderer = new Renderer\Html;
                break;
            case static::FORMAT_JSON:
                $renderer = new Renderer\Json;
                break;
            default:
                throw new \ErrorException("Invalid render format: {$format}");
        }

        return $renderer;
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
     * @return Renderer
     */
    public function setDirectory($directory)
    {
        $this->directory = $directory;

        return $this;
    }

    /**
     * @return string
     */
    public function getCharset()
    {
        return $this->charset;
    }

    /**
     * @param string $charset
     * @return Renderer
     */
    public function setCharset($charset)
    {
        $this->charset = $charset;

        return $this;
    }

    /**
     * @return string
     */
    public function getDefaultView()
    {
        return $this->defaultView;
    }

    /**
     * @param string $defaultView
     * @return Renderer
     */
    public function setDefaultView($defaultView)
    {
        $this->defaultView = $defaultView;

        return $this;
    }

    /**
     * Get parameter
     *
     * @param string $parameter
     * @param mixed  $default
     * @return mixed|null
     */
    protected function get($parameter, $default = null)
    {
        if (isset($this->parameters[$parameter])) {
            $value = $this->parameters[$parameter];
        } else {
            $value = $default;
        }

        return $value;
    }
}
