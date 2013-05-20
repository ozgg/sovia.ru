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

class RestRoute extends Route
{
    /**
     * @var array
     */
    protected $resources = [];

    /**
     * Assemble URI
     *
     * @return string
     */
    public function assemble()
    {
        // TODO: Implement assemble() method.
    }

    /**
     * Get regEx pattern to match
     *
     * @return string
     */
    public function getMatch()
    {
        // TODO: Implement getMatch() method.
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
        $pattern = $this->uri;
        if (empty($this->resources)) {
            $pattern .= '(?:/(\d+))?';
        } else {
            $pattern .= '(?:/(\d+)(?:/(?:'
                . implode('|', $this->resources)
                . ')(?:/(\d+))?)?)?';
        }

        preg_match_all("#{$pattern}#", $uri, $matches);

        if (!empty($matches[2][0])) {
            $parameters = [
                'element_id'  => $matches[1][0],
                'resource_id' => $matches[2][0],
            ];
        } elseif (!empty($matches[1][0])) {
            $parameters = [
                'element_id' => $matches[1][0],
            ];
        } else {
            $parameters = [];
        }

        $this->setParameters($parameters);
    }

    /**
     * @return array
     */
    public function getResources()
    {
        return $this->resources;
    }

    /**
     * @param array $resources
     * @return RestRoute
     */
    public function setResources($resources)
    {
        $this->resources = $resources;

        return $this;
    }
}
