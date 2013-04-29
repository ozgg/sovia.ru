<?php
/**
 * Abstract route
 *
 * Date: 29.04.13
 * Time: 21:09
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */

namespace Sovia;

abstract class Route
{
    /**
     * Static route
     */
    const TYPE_STATIC  = 'static';

    /**
     * Pattern route
     */
    const TYPE_PATTERN = 'pattern';

    /**
     * Regular expression route
     */
    const TYPE_REGEX   = 'regex';

    /**
     * REST route
     */
    const TYPE_REST    = 'rest';

    /**
     * HTTP get
     */
    const METHOD_GET    = 'GET';

    /**
     * HTTP post
     */
    const METHOD_POST   = 'POST';

    /**
     * HTTP put
     */
    const METHOD_PUT    = 'PUT';

    /**
     * HTTP delete
     */
    const METHOD_DELETE = 'DELETE';

    /**
     * HTTP patch
     */
    const METHOD_PATCH  = 'PATCH';

    /**
     * @var string
     */
    protected $type;

    /**
     * @var string
     */
    protected $name;

    /**
     * @var string
     */
    protected $uri;

    /**
     * @var string
     */
    protected $reverse;

    /**
     * Allowed HTTP methods
     *
     * @var array
     */
    protected $methods = [];

    /**
     * Controller name to execute
     *
     * @var string
     */
    protected $controllerName;

    /**
     * Action name to execute
     *
     * @var string
     */
    protected $actionName;

    /**
     * Parameters to pass to controller
     *
     * @var array
     */
    protected $parameters = [];

    /**
     * Assemble URI
     *
     * @return string
     */
    abstract public function assemble();

    /**
     * Request by HTTP method $method
     *
     * @param string $method
     * @return void
     */
    abstract public function request($method);

    /**
     * Route factory
     *
     * @param string $type
     * @return Route\PatternRoute|Route\RegexRoute|Route\RestRoute|Route\StaticRoute
     * @throws \Exception
     */
    public static function factory($type)
    {
        switch ($type) {
            case static::TYPE_STATIC:
                $route = new Route\StaticRoute;
                break;
            case static::TYPE_PATTERN:
                $route = new Route\PatternRoute;
                break;
            case static::TYPE_REGEX:
                $route = new Route\RegexRoute;
                break;
            case static::TYPE_REST:
                $route = new Route\RestRoute;
                break;
            default:
                throw new \Exception("Invalid route type: {$type}");
        }

        $route->setType($type);

        return $route;
    }

    /**
     * @param string $actionName
     * @return Route
     */
    public function setActionName($actionName)
    {
        $this->actionName = $actionName;

        return $this;
    }

    /**
     * @return string
     */
    public function getActionName()
    {
        return $this->actionName;
    }

    /**
     * @param string $controllerName
     * @return Route
     */
    public function setControllerName($controllerName)
    {
        $this->controllerName = $controllerName;

        return $this;
    }

    /**
     * @return string
     */
    public function getControllerName()
    {
        return $this->controllerName;
    }

    /**
     * @param array $methods
     * @return Route
     */
    public function setMethods($methods)
    {
        $this->methods = $methods;

        return $this;
    }

    /**
     * @return array
     */
    public function getMethods()
    {
        return $this->methods;
    }

    /**
     * @param string $name
     * @return Route
     */
    public function setName($name)
    {
        $this->name = $name;

        return $this;
    }

    /**
     * @return string
     */
    public function getName()
    {
        return $this->name;
    }

    /**
     * @param array $parameters
     * @return Route
     */
    public function setParameters($parameters)
    {
        $this->parameters = $parameters;

        return $this;
    }

    /**
     * @return array
     */
    public function getParameters()
    {
        return $this->parameters;
    }

    /**
     * @param string $reverse
     * @return Route
     */
    public function setReverse($reverse)
    {
        $this->reverse = $reverse;

        return $this;
    }

    /**
     * @return string
     */
    public function getReverse()
    {
        return $this->reverse;
    }

    /**
     * @param string $uri
     * @return Route
     */
    public function setUri($uri)
    {
        $this->uri = $uri;

        return $this;
    }

    /**
     * @return string
     */
    public function getUri()
    {
        return $this->uri;
    }

    /**
     * @return string
     */
    public function getType()
    {
        return $this->type;
    }

    /**
     * @param string $type
     * @return Route
     */
    public function setType($type)
    {
        $this->type = $type;

        return $this;
    }
}
