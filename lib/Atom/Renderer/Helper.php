<?php
/**
 * 
 * 
 * Date: 07.07.13
 * Time: 15:17
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom\Renderer
 */

namespace Atom\Renderer;
 
use Atom\Traits;

abstract class Helper
{
    use Traits\Dependency\Container, Traits\HasParameters;

    /**
     * @var Html
     */
    protected $renderer;

    /**
     * @return \Atom\Renderer\Html
     */
    public function getRenderer()
    {
        return $this->renderer;
    }

    /**
     * @param \Atom\Renderer\Html $renderer
     * @return Helper
     */
    public function setRenderer($renderer)
    {
        $this->renderer = $renderer;

        return $this;
    }

    public function escape($string)
    {
        return htmlspecialchars($string, ENT_QUOTES, 'UTF-8');
    }
}
