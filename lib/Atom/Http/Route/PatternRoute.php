<?php
/**
 * Pattern-based route
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom\Http\Route
 */

namespace Atom\Http\Route;

use Atom\Http\Route;

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
        preg_match_all('#:([^/]+)#', $this->uri, $matches);
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
     * Get regEx pattern to match
     *
     * @return string
     */
    public function getMatch()
    {
        return preg_replace('#:[^/]+#', '[^/]+', $this->uri);
    }

    /**
     * Request by HTTP method $method
     *
     * @param string $method
     * @param string $uri
     */
    public function request($method, $uri)
    {
        parent::request($method, $uri);
        $pattern = preg_replace('#:([^/]+)#', '(?P<$1>[^/]+)', $this->uri);
        preg_match_all("#{$pattern}#", $uri, $matches);

        foreach ($matches as $parameter => $result) {
            if (!is_numeric($parameter) && isset($result[0])) {
                $this->parameters[$parameter] = $result[0];
            }
        }
    }
}
