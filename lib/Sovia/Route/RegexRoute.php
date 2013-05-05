<?php
/**
 * 
 * 
 * Date: 29.04.13
 * Time: 22:23
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */

namespace Sovia\Route;
 
use Sovia\Route;

class RegexRoute extends Route
{
    /**
     * Assemble URI
     *
     * @throws \Exception
     * @return string
     */
    public function assemble()
    {
        if ($this->reverse == '') {
            throw new \Exception('Reverse pattern is not specified');
        }

        if (func_num_args() == 1) {
            $parameters = (array) func_get_arg(0);
        } else {
            $parameters = func_get_args();
        }

        if (substr_count($this->reverse, '%') != count($parameters)) {
            throw new \Exception('Invalid number of parameters to assemble');
        }

        return vsprintf($this->reverse, $parameters);
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
     * @return void
     */
    public function request($method, $uri)
    {
        // TODO: Implement request() method.
    }
}
