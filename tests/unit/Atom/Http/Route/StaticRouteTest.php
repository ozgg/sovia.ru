<?php
/**
 * Test case for static route
 * 
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Test\Unit\Atom\Http\Route
 */

namespace Test\Unit\Atom\Http\Route;

use Atom\Test\TestCase;
use Atom\Http\Route\StaticRoute;

/**
 * Test of static route
 *
 * @covers \Atom\Http\Route\StaticRoute
 */
class StaticRouteTest extends TestCase
{
    /**
     * Tests assembling of route
     *
     * Static route always assembles into its URI.
     *
     * @covers \Atom\Http\Route\StaticRoute::assemble
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
     * @covers \Atom\Http\Route\StaticRoute::request
     */
    public function testRequestSuccess()
    {
        $route = new StaticRoute;
        $route->setMethods([StaticRoute::METHOD_GET, StaticRoute::METHOD_POST]);
        $route->request(StaticRoute::METHOD_GET, '');
    }

    /**
     * Test failed request to route
     *
     * @expectedException \Atom\Http\Error\MethodNotAllowed
     * @covers \Atom\Http\Route\StaticRoute::request
     */
    public function testRequestFailure()
    {
        $route = new StaticRoute;
        $route->setMethods([StaticRoute::METHOD_GET]);
        $route->request(StaticRoute::METHOD_POST, '');
    }

    /**
     * Test getting regEx pattern
     *
     * @covers \Atom\Http\Route\StaticRoute::getMatch
     */
    public function testGetMatch()
    {
        $route = new StaticRoute;
        $route->setUri('/foo/bar');
        $this->assertEquals('/foo/bar', $route->getMatch());
    }
}
