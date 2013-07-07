<?php
/**
 * 
 * 
 * Date: 07.07.13
 * Time: 15:48
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom\Renderer\Helper
 */

namespace Atom\Renderer\Helper;
 
use Atom\Http\Router;
use Atom\Renderer\Helper;

class Link extends Helper
{
    public function render(array $input)
    {
        if (isset($input['route'])) {
            $routeName = $input['route'];
            try {
                $route   = $this->getRoute($routeName);

                if (isset($input['text'])) {
                    $text = $input['text'];
                } else {
                    $text = $routeName;
                }

                unset($input['route'], $input['text']);

                $uri    = $route->assemble($input);
                $format = '<a href="%s">%s</a>';
                $result = sprintf($format, $uri, $this->escape($text));
            } catch (\RuntimeException $e) {
                $result = $e->getMessage();
            }
        } else {
            $result = 'Route name is not set';
        }

        return $result;
    }

    /**
     * @param $name
     * @return \Atom\Http\Route
     * @throws \RuntimeException
     */
    protected function getRoute($name)
    {
        $router = $this->extractDependency('router');
        if ($router instanceof Router) {
            $route = $router->getRoute($name);
        } else {
            throw new \RuntimeException('Cannot extract router');
        }

        return $route;
    }
}
