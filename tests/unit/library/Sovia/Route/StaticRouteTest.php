<?php
/**
 * Test case for static route
 * 
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Test\Unit\Library\Sovia\Route
 */

namespace Test\Unit\Library\Sovia\Route;

use Sovia\Test\TestCase;
use Sovia\Route\StaticRoute;

/**
 * Test of static route
 *
 * @covers \Sovia\Route\StaticRoute
 */
class StaticRouteTest extends TestCase
{
    /**
     * Tests assembling of route
     *
     * Static route always assembles into its URI.
     *
     * @covers \Sovia\Route\StaticRoute::assemble
     */
    public function testAssemble()
    {
        $uri = '/foo/bar/la-la-la';

        $route = new StaticRoute;
        $route->setUri($uri);

        $this->assertEquals($uri, $route->assemble());
    }

    /**
     * Test successful request to route
     *
     * There must be no errors after method call
     *
     * @covers \Sovia\Route\StaticRoute::request
     */
    public function testRequestSuccess()
    {
        $route = new StaticRoute;
        $route->setMethods([StaticRoute::METHOD_GET, StaticRoute::METHOD_POST]);
        $route->request(StaticRoute::METHOD_GET);
    }

    /**
     * Test failed request to route
     *
     * @expectedException \Sovia\Exceptions\Http\Client\MethodNotAllowed
     * @covers \Sovia\Route\StaticRoute::request
     */
    public function testRequestFailure()
    {
        $route = new StaticRoute;
        $route->setMethods([StaticRoute::METHOD_GET]);
        $route->request(StaticRoute::METHOD_POST);
    }
}
