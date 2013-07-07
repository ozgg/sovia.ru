<?php
/**
 * 
 * 
 * Date: 07.07.13
 * Time: 12:32
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom\Renderer
 */

namespace Atom\Renderer;
 
use Atom\Renderer;

class Html extends Renderer
{
    /**
     * @return string
     */
    public function render()
    {
        return print_r($this->getParameters(), true);
    }

    /**
     * @return string
     */
    public function getContentType()
    {
        return 'text/html;charset=UTF-8';
    }
}
