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
    public function render($input)
    {
        $arguments = explode(',', $input);
        $routeName = array_shift($arguments);

        try {
            $route   = $this->getRoute($routeName);
            $pattern = '/"([^"]+)",?(.+)?/';

            preg_match($pattern, implode(',', $arguments), $info);
            if (isset($info[1])) {
                $text = $info[1];
            } else {
                $text = $routeName;
            }
            $parameters = isset($info[2]) ? json_decode($info[2], true) : [];

            $uri    = $route->assemble($parameters);
            $format = '<a href="%s">%s</a>';
            $result = sprintf($format, $uri, $this->escape($text));
        } catch (\RuntimeException $e) {
            $result = $e->getMessage();
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
