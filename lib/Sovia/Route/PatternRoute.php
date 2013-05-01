<?php
/**
 * 
 * 
 * Date: 29.04.13
 * Time: 22:22
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Route
 */

namespace Sovia\Route;
 
use Sovia\Route;

/**
 * Pattern-based route
 */
class PatternRoute extends Route
{
    /**
     * Assemble URI
     *
     * @throws \Exception
     * @return string
     */
    public function assemble()
    {
        preg_match_all('/:([^\/]+)/', $this->uri, $matches);
        if (isset($matches[1])) {
            $map = $matches[1];
        } else {
            $map = [];
        }

        if (func_num_args() == 1) {
            $arguments = (array) func_get_arg(0);
        } else {
            $arguments = func_get_args();
        }

        if (count($map) != count($arguments)) {
            throw new \Exception('Invalid number of parameters to assemble');
        }

        $uri = $this->uri;
        foreach ($arguments as $parameter => $value) {
            if (is_numeric($parameter)) {
                $search = ':' . $map[$parameter];
            } else {
                if (!in_array($parameter, $map)) {
                    throw new \Exception("Invalid URI parameter: {$parameter}");
                }
                $search = ":{$parameter}";
            }
            $uri = str_replace($search, $value, $uri);
        }

        return $uri;
    }

    /**
     * Request by HTTP method $method
     *
     * @param string $method
     * @param string $uri
     * @return void
     */
    public function request($method, $uri)
    {
        // TODO: Implement request() method.
    }
}
