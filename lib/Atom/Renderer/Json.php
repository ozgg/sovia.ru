<?php
/**
 * 
 * 
 * Date: 07.07.13
 * Time: 12:28
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom\Renderer
 */

namespace Atom\Renderer;
 
use Atom\Renderer;

class Json extends Renderer
{
    public function render()
    {
        return json_encode($this->getParameters(), JSON_UNESCAPED_UNICODE);
    }
}
