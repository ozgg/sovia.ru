<?php
/**
 * Test case for router
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Test\Unit\Library\Sovia
 */

namespace Test\Unit\Library\Sovia;

use Sovia;
use Sovia\Test\TestCase;

/**
 * Tests for Router
 *
 * @covers \Sovia\Router
 */
class RouterTest extends TestCase
{
    /**
     * Tested instance
     *
     * @var Sovia\Router
     */
    protected $router;

    /**
     * Set up
     *
     * Create tested instance of Router
     */
    public function setUp()
    {
        $this->router = new Sovia\Router;
    }

    /**
     * Test importing routes configuration
     *
     * @covers \Sovia\Router::import
     */
    public function testImport()
    {
        $config = $this->getSample('config/routes');

        $this->router->import($config);
        $this->assertGreaterThan(0, count($this->router->getRoutes()));
    }

    /**
     * Test successful matching request URI
     *
     * @covers \Sovia\Router::matchRequest
     */
    public function testMatchRequestSuccess()
    {
        $this->router->addRoute((new Sovia\Route\StaticRoute)->setUri('/foo'));
        $this->router->addRoute((new Sovia\Route\PatternRoute)->setUri('/bar'));

        $route = $this->router->matchRequest('/bar');

        $this->assertTrue($route instanceof Sovia\Route\PatternRoute);
    }

    /**
     * Test failing matching request URI
     *
     * @expectedException \Sovia\Exceptions\Http\Client\NotFound
     * @covers \Sovia\Router::matchRequest
     */
    public function testMatchRequestFailure()
    {
        $this->router->addRoute((new Sovia\Route\StaticRoute)->setUri('/foo'));
        $this->router->matchRequest('/bar');
    }
}
