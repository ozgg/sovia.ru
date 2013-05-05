<?php
/**
 * Static route
 *
 * Represents static route without any parameters in URI
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Route
 */

namespace Sovia\Route;

use Sovia\Exceptions\Http\Client\MethodNotAllowed;
use Sovia\Route;

/**
 * Static route
 */
class StaticRoute extends Route
{
    /**
     * Assemble URI
     *
     * @return string
     */
    public function assemble()
    {
        return $this->getUri();
    }

    /**
     * Get regEx pattern to match
     *
     * @return string
     */
    public function getMatch()
    {
        return $this->uri;
    }

    /**
     * Request by HTTP method $method
     *
     * @param string $method
     * @param string $uri
     * @throws \Sovia\Exceptions\Http\Client\MethodNotAllowed
     * @return void
     */
    public function request($method, $uri)
    {
        if (!in_array($method, $this->methods)) {
            throw new MethodNotAllowed;
        }
    }
}
