<?php
/**
 * JSON renderer
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Application\Renderer
 */

namespace Sovia\Application\Renderer;
 
use Sovia\Application\Renderer;

/**
 * Renderer in JSON format
 */
class Json extends Renderer
{
    /**
     * Render view
     *
     * @param string $layout
     * @param array  $parameters
     * @return void
     */
    public function render($layout, array $parameters)
    {
        header("Content-Type: application/json;charset={$this->charset}");
        echo json_encode($parameters, JSON_UNESCAPED_UNICODE);
    }
}
