<?php
/**
 * 
 * 
 * Date: 29.05.13
 * Time: 22:45
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */

namespace Sovia\Application\Renderer;
 
use Sovia\Application\Renderer;

class Json extends Renderer
{
    /**
     * Render view
     *
     * @param array $parameters
     * @return void
     */
    public function render(array $parameters)
    {
        header("Content-Type: application/json;charset={$this->charset}");
        echo json_encode($parameters, JSON_UNESCAPED_UNICODE);
    }
}
