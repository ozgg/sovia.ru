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
     * Init from array
     *
     * @param array $data
     */
    public function initFromArray(array $data)
    {
        parent::initFromArray($data);
        if (isset($data['resources'])) {
            $this->setResources($data['resources']);
        }
    }

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

        $resource   = '';
        $elementId  = null;
        $resourceId = null;

        if (!empty($matches[2][0])) {
            $elementId  = $matches[1][0];
            $parameters = ['element_id' => $elementId];
            if (!empty($matches[3][0])) {
                $resourceId = $matches[3][0];

                $parameters['resource_id'] = $resourceId;
            }

            $resource = $matches[2][0];
        } elseif (!empty($matches[1][0])) {
            $elementId  = $matches[1][0];
            $parameters = [
                'element_id' => $elementId,
            ];
        } else {
            $parameters = [];
        }

        $this->mapActionName($elementId, $resource, $resourceId);
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
     * Map action name based on ids and resource name
     *
     * @param int    $elementId
     * @param string $resource apply action on resource
     * @param int    $resourceId
     */
    protected function mapActionName($elementId, $resource, $resourceId)
    {
        if (!empty($elementId)) {
            $actionName = 'Element';
            if (strlen($resource)) {
                $actionName .= ucfirst($resource);
                if (!empty($resourceId)) {
                    $actionName .= 'Resource';
                } else {
                    $actionName .= 'Resources';
                }
            }
        } else {
            $actionName = 'Collection';
        }

        $this->setActionName($actionName);
    }
}
