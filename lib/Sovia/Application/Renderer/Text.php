<?php
/**
 * 
 * 
 * Date: 29.05.13
 * Time: 22:38
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */

namespace Sovia\Application\Renderer;
 
use Sovia\Application\Renderer;

class Text extends Renderer
{
    /**
     * Render contents
     *
     * @param array $parameters
     */
    public function render(array $parameters)
    {
        header("Content-Type: text/plain;charset={$this->charset}");

        if (!is_null($this->viewFile)) {
            $file = $this->getViewFile() . '.txt';

            if (file_exists($file) && is_file($file)) {
                include $file;
            }

        }

        if (!empty($parameters)) {
            echo 'Parameters', PHP_EOL;
            print_r($parameters);
        }
    }
}
