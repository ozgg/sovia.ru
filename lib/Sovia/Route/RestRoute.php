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

use Sovia\Exceptions\Http\Client\MethodNotAllowed;
use Sovia\Route;

class RestRoute extends Route
{
    /**
     * @var array
     */
    protected $resources = [];

    public function __construct()
    {
        $this->methods = [
            static::METHOD_GET,
            static::METHOD_POST,
            static::METHOD_PUT,
            static::METHOD_PATCH,
            static::METHOD_DELETE,
        ];
    }

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
        $pattern = $this->uri;
        if (empty($this->resources)) {
            $pattern .= '(?:/(\d+))?';
        } else {
            $pattern .= '(?:/(\d+)(?:/('
                . implode('|', $this->resources)
                . ')(?:/(\d+))?)?)?';
        }

        return $pattern;
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

        preg_match_all("#{$this->getMatch()}#", $uri, $matches);

        $resource = '';

        if (!empty($matches[2][0])) {
            $parameters = ['element_id' => $matches[1][0]];
            if (!empty($matches[3][0])) {
                $parameters['resource_id'] = $matches[3][0];
            }

            $resource = $matches[2][0];
        } elseif (!empty($matches[1][0])) {
            $parameters = [
                'element_id' => $matches[1][0],
            ];
        } else {
            $parameters = [];
        }

        $this->mapActionName($method, $resource);
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

    /**
     * Map action name based on method
     *
     * @param string $method HTTP method
     * @param string $resource apply action on resource
     */
    protected function mapActionName($method, $resource = '')
    {
        $map = [
            static::METHOD_GET    => 'get',
            static::METHOD_POST   => 'create',
            static::METHOD_PATCH  => 'update',
            static::METHOD_PUT    => 'set',
            static::METHOD_DELETE => 'destroy',
        ];

        if (isset($map[$method])) {
            $actionName = $map[$method];
        } else {
            $actionName = strtolower($method);
        }

        $actionName .= 'Element';

        if (strlen($resource)) {
            $actionName .= ucfirst($resource);
        }

        $this->setActionName($actionName);
    }
}
