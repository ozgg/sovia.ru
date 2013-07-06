<?php
/**
 * Static route
 *
 * Represents static route without any parameters in URI
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom\Http\Route
 */

namespace Atom\Http\Route;

use Atom\Http\Route;

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
        return $this->getUri();
    }
}
