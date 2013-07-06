<?php
/**
 * Router
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom\Http
 */

namespace Atom\Http;

use Atom\Http\Error\NotFound;

/**
 * Router
 */
class Router
{
    /**
     * Available routes
     *
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
     * @param array $routes
     */
    public function import(array $routes)
    {
        foreach ($routes as $name => $data) {
            $type  = isset($data['type']) ? $data['type'] : Route::TYPE_STATIC;
            $route = Route::factory($type);
            $route->setName($name);
            $route->initFromArray($data);

            $this->addRoute($route);
        }
    }

    /**
     * Match URI to routes and get according route
     *
     * @param string $uri
     * @return Route
     * @throws \Atom\Http\Error\NotFound
     */
    public function matchRequest($uri)
    {
        $match = null;
        $path  = '/' . trim(strtolower(parse_url($uri, PHP_URL_PATH)), '/');
        foreach ($this->routes as $route) {
            if ($route->isStatic()) {
                $found = $path == strtolower($route->getMatch());
            } else {
                $found = (preg_match("#{$route->getMatch()}#i", $path) > 0);
            }
            if ($found) {
                $match = $route;
                break;
            }
        }

        if (!$match instanceof Route) {
            throw new NotFound("Cannot match URI {$uri} against any route");
        }

        return $match;
    }
}
