<?php
/**
 * Test case for router
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Test\Unit\Atom\Http
 */

namespace Test\Unit\Atom\Http;

use Atom\Http;
use Atom\Test\TestCase;

/**
 * Tests for Router
 *
 * @covers \Atom\Http\Router
 */
class RouterTest extends TestCase
{
    /**
     * Tested instance
     *
     * @var Http\Router
     */
    protected $router;

    /**
     * Set up
     *
     * Create tested instance of Router
     */
    public function setUp()
    {
        $this->router = new Http\Router;
    }

    /**
     * Test importing routes configuration
     *
     * @covers \Atom\Http\Router::import
     */
    public function testImport()
    {
        $config = $this->getSample('config/routes');

        $this->router->import($config);
        $this->assertEquals(count($config), count($this->router->getRoutes()));
    }

    /**
     * Test successful matching request URI
     *
     * @covers \Atom\Http\Router::matchRequest
     */
    public function testMatchRequestSuccess()
    {
        $this->router->addRoute((new Http\Route\StaticRoute)->setUri('/foo'));
        $this->router->addRoute((new Http\Route\PatternRoute)->setUri('/bar'));

        $route = $this->router->matchRequest('/bar');

        $this->assertTrue($route instanceof Http\Route\PatternRoute);
    }

    /**
     * Test failing matching request URI
     *
     * @expectedException \Atom\Http\Error\NotFound
     * @covers \Atom\Http\Router::matchRequest
     */
    public function testMatchRequestFailure()
    {
        $this->router->addRoute((new Http\Route\StaticRoute)->setUri('/foo'));
        $this->router->matchRequest('/bar');
    }
}
