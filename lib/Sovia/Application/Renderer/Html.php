<?php
/**
 * 
 * 
 * Date: 29.05.13
 * Time: 22:46
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */

namespace Sovia\Application\Renderer;
 
use Sovia\Application\Renderer;
use Sovia\Exceptions\Http as Error;

class Html extends Renderer
{
    /**
     * Render view
     *
     * @param array $parameters
     * @throws \ErrorException
     * @return void
     */
    public function render(array $parameters)
    {
        header("Content-Type: text/html;charset={$this->charset}");
        $result = '';

        $this->parameters = $parameters;
        if (!is_null($this->layoutFile)) {
            $layout = $this->directory . '/' . $this->layoutFile . '.phtml';
            if (file_exists($layout) && is_file($layout)) {
                ob_start();
                include $layout;
                $result .= ob_get_clean();
            } else {
                throw new \ErrorException("Cannot load layout {$layout}");
            }
        } elseif (!is_null($this->viewFile)) {
            $view = $this->directory . '/' . $this->viewFile . '.phtml';
            if (file_exists($view) && is_file($view)) {
                ob_start();
                include $view;
                $result .= ob_get_clean();
            } else {
                throw new \ErrorException("Cannot load view from {$view}");
            }
        } else {
            throw new \ErrorException('Cannot find layout/view to render');
        }

        echo $result;
    }

    protected function renderContent()
    {
        $view = $this->directory . '/' . $this->viewFile . '.phtml';
        if (file_exists($view) && is_file($view)) {
            include $view;
        } else {
            throw new \ErrorException("Cannot load view from {$view}");
        }
    }

    protected function renderError(Error $error)
    {
        print_r($error);
    }

    protected function partial($view)
    {
        if (!is_null($this->directory)) {
            $file = $this->directory . "/scripts/{$view}.phtml";
            if (file_exists($file) && is_file($file)) {
                include $file;
            } else {
                throw new \ErrorException("Cannot load view from {$file}");
            }
        } else {
            throw new \ErrorException('Views directory is not set');
        }
    }
}
