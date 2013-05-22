<?php
/**
 * REST route
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Route
 */

namespace Sovia\Route;

use Sovia\Exceptions\Http\Client\MethodNotAllowed;
use Sovia\Route;

/**
 * REST route
 */
class RestRoute extends Route
{
    /**
     * Available element resources
     *
     * @var array
     */
    protected $resources = [];

    /**
     * Assemble URI
     *
     * @throws \Exception
     * @return string
     */
    public function assemble()
    {
        if (func_num_args() > 1) {
            throw new \Exception('Too many arguments. Pass array|int or none');
        }
        $uri = $this->uri;
        if (func_num_args() != 0) {
            $argument = func_get_arg(0);
            if (!is_array($argument)) {
                $uri .= '/' . intval($argument);
            } else {
                if (empty($argument['id'])) {
                    throw new \Exception('Missing id index');
                }
                $uri .= '/' . intval($argument['id']);
                unset($argument['id']);
                if (!empty($argument)) {
                    if (count($argument) > 1) {
                        throw new \Exception('Excessive number of resources');
                    }
                    $resource = key($argument);
                    if (!in_array($resource, $this->resources)) {
                        throw new \Exception("Invalid resource: {$resource}");
                    }
                    $uri .= '/' . $resource;
                    if (!is_null($argument[$resource])) {
                        $uri .= '/' . intval($argument[$resource]);
                    }
                }
            }
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
     * Get available resources
     *
     * @return array
     */
    public function getResources()
    {
        return $this->resources;
    }

    /**
     * Set available resources
     *
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
