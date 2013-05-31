<?php
/**
 * Plain text renderer
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Application\Renderer
 */

namespace Sovia\Application\Renderer;
 
use Sovia\Application\Renderer;

/**
 * Renderer in plain text
 */
class Text extends Renderer
{
    /**
     * Render contents
     *
     * @param string $layout
     * @param array  $parameters
     */
    public function render($layout, array $parameters)
    {
        header("Content-Type: text/plain;charset={$this->charset}");

        if (!is_null($this->directory)) {
            $file = $this->getDirectory() . "/layouts/{$layout}.txt";

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
