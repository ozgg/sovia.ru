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
     * Type of route
     *
     * @var string
     */
    protected $type;

    /**
     * Name of route
     *
     * @var string
     */
    protected $name;

    /**
     * Matching request URI
     *
     * @var string
     */
    protected $uri;

    /**
     * Pattern for reverse building
     *
     * Route builds URI from given parameters by pattern.
     *
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
     * @param string $uri
     * @return void
     */
    abstract public function request($method, $uri);

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
     * Set name of action in controller
     *
     * @param string $actionName
     * @return Route
     */
    public function setActionName($actionName)
    {
        $this->actionName = $actionName;

        return $this;
    }

    /**
     * Get action name
     *
     * @return string
     */
    public function getActionName()
    {
        return $this->actionName;
    }

    /**
     * Set controller name
     *
     * @param string $controllerName
     * @return Route
     */
    public function setControllerName($controllerName)
    {
        $this->controllerName = $controllerName;

        return $this;
    }

    /**
     * Get controller name
     *
     * @return string
     */
    public function getControllerName()
    {
        return $this->controllerName;
    }

    /**
     * Set allowed HTTP methods
     *
     * @param array $methods
     * @return Route
     */
    public function setMethods($methods)
    {
        $this->methods = $methods;

        return $this;
    }

    /**
     * Get allowed HTTP methods
     *
     * @return array
     */
    public function getMethods()
    {
        return $this->methods;
    }

    /**
     * Set route name
     *
     * @param string $name
     * @return Route
     */
    public function setName($name)
    {
        $this->name = $name;

        return $this;
    }

    /**
     * Get route name
     *
     * @return string
     */
    public function getName()
    {
        return $this->name;
    }

    /**
     * Set parameters
     *
     * @param array $parameters
     * @return Route
     */
    public function setParameters(array $parameters)
    {
        $this->parameters = $parameters;

        return $this;
    }

    /**
     * Get parameters
     *
     * @return array
     */
    public function getParameters()
    {
        return $this->parameters;
    }

    /**
     * Set reverse pattern
     *
     * @param string $reverse
     * @return Route
     */
    public function setReverse($reverse)
    {
        $this->reverse = $reverse;

        return $this;
    }

    /**
     * Get reverse pattern
     *
     * @return string
     */
    public function getReverse()
    {
        return $this->reverse;
    }

    /**
     * Set matching request URI
     *
     * @param string $uri
     * @return Route
     */
    public function setUri($uri)
    {
        $this->uri = $uri;

        return $this;
    }

    /**
     * Get matching request URI
     *
     * @return string
     */
    public function getUri()
    {
        return $this->uri;
    }

    /**
     * Get route type
     *
     * @return string
     */
    public function getType()
    {
        return $this->type;
    }

    /**
     * Set route type
     *
     * @param string $type
     * @return Route
     */
    public function setType($type)
    {
        $this->type = $type;

        return $this;
    }
}
