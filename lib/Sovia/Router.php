<?php
/**
 * Router
 * 
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia
 */

namespace Sovia;

/**
 * Router
 */
class Router 
{
    /**
     * @var Route[]
     */
    protected $routes = [];

    /**
     * Add route
     *
     * @param Route $route
     */
    public function addRoute(Route $route)
    {
        $this->routes[$route->getName()] = $route;
    }

    /**
     * Get route by name
     *
     * @param $name
     * @return Route
     * @throws \Exception
     */
    public function getRoute($name)
    {
        if (isset($this->routes[$name])) {
            $route = $this->routes[$name];
        } else {
            throw new \Exception("Cannot find route {$name}");
        }

        return $route;
    }

    /**
     * Get all routes
     *
     * @return Route[]
     */
    public function getRoutes()
    {
        return $this->routes;
    }

    /**
     * Import routes from array
     *
     * @param array $config
     */
    public function import(array $config)
    {
        foreach ($config as $type => $routes) {
            foreach ($routes as $uri => $data) {
                $route = Route::factory($type);
                $route->setUri($uri);
                $route->initFromArray($data);

                $this->addRoute($route);
            }
        }
    }
}
