<?php
/**
 * Test case for REST route class
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Test\Unit\Library\Sovia\Route
 */

namespace Test\Unit\Library\Sovia\Route;

use Sovia\Route\RestRoute;
use Sovia\Test\TestCase;

/**
 * Test of REST route
 *
 * @covers \Sovia\Route\RestRoute
 */
class RestRouteTest extends TestCase
{
    /**
     * Tested instance
     *
     * @var RestRoute
     */
    protected $route;

    public function setUp()
    {
        $this->route = new RestRoute;
    }

    public function assembleSuccessProvider()
    {
        return [
            ['', [], [], ''],
        ];
    }

    public function assembleFailureProvider()
    {
        return [
            ['', [], []],
        ];
    }

    /**
     * Data provider for testing successful requests
     *
     * @return array
     */
    public function requestSuccessProvider()
    {
        $method = RestRoute::METHOD_GET;

        return [
            ['/foo', [], '/foo', $method, []],
            ['/foo', [], '/foo/4', $method, ['element_id' => 4]],
            ['/a', ['b', 'c'], '/a/1/c', $method, ['element_id' => 1]],
            [
                '/a', ['b', 'c'], '/a/1/b/2', $method,
                ['element_id' => 1, 'resource_id' => 2]
            ],
        ];
    }

    /**
     * Data provider for mapping action name
     *
     * @see testMapActionName()
     *
     * @return array
     */
    public function mapActionNameProvider()
    {
        return [
            ['/users', [], '/users', RestRoute::METHOD_GET, 'getElement'],
            ['/users', [], '/users/1', RestRoute::METHOD_GET, 'getElement'],
            ['/users', [], '/users/1', RestRoute::METHOD_PUT, 'setElement'],
            ['/foo', [], '/foo/1', RestRoute::METHOD_PATCH, 'updateElement'],
            ['/foo', [], '/foo/1', RestRoute::METHOD_DELETE, 'destroyElement'],
            ['/foo', ['a'], '/foo', RestRoute::METHOD_DELETE, 'destroyElement'],
            ['/foo', ['f'], '/foo', RestRoute::METHOD_POST, 'createElement'],
            [
                '/a', ['bar', 'c'], '/a/1/bar', RestRoute::METHOD_GET,
                'getElementBar'
            ],
        ];
    }

    /**
     * Data provider for getting match pattern
     *
     * @see testGetMatch()
     *
     * @return array
     */
    public function getMatchProvider()
    {
        return [
            ['/users', [], '/users(?:/(\d+))?'],
            ['/foo', ['a', 'b'], '/foo(?:/(\d+)(?:/(a|b)(?:/(\d+))?)?)?'],
        ];
    }

    /**
     * Test successful assembling
     *
     * @param string $uri
     * @param array  $resources
     * @param array  $parameters
     * @param string $expect
     * @dataProvider assembleSuccessProvider
     * @covers       \Sovia\Route\RestRoute::assemble
     */
    public function testAssembleSuccess(
        $uri, array $resources, array $parameters, $expect
    )
    {
        $this->markTestIncomplete();
    }

    /**
     * Test failing assembling
     *
     * @param string $uri
     * @param array  $resources
     * @param array  $parameters
     * @dataProvider assembleFailureProvider
     * @covers       \Sovia\Route\RestRoute::assemble
     * @expectedException \Exception
     */
    public function testAssembleFailure(
        $uri, array $resources, array $parameters
    )
    {
        $this->markTestIncomplete();
    }

    /**
     * Test successful request
     *
     * @param string $pattern
     * @param array  $resources
     * @param string $uri
     * @param string $method
     * @param array  $expect
     * @dataProvider requestSuccessProvider
     * @covers       \Sovia\Route\RestRoute::request
     */
    public function testRequestSuccess(
        $pattern, array $resources, $uri, $method, array $expect
    )
    {
        $this->route->setUri($pattern);
        $this->route->setResources($resources);
        $this->route->request($method, $uri);

        $this->assertEquals($expect, $this->route->getParameters());
    }

    public function testRequestFailure()
    {
        $this->markTestIncomplete();
    }

    /**
     * Test getting match pattern
     *
     * @param string $uri
     * @param array  $resources
     * @param string $match
     * @dataProvider getMatchProvider
     * @covers       \Sovia\Route\RestRoute::getMatch
     */
    public function testGetMatch($uri, array $resources, $match)
    {
        $this->route->setUri($uri);
        $this->route->setResources($resources);
        $this->assertEquals($match, $this->route->getMatch());
    }

    /**
     * Test mapping action name
     *
     * @param string $pattern
     * @param array  $resources
     * @param string $uri
     * @param string $method
     * @param string $expect
     * @dataProvider mapActionNameProvider
     * @covers       \Sovia\Route\RestRoute::mapActionName
     */
    public function testMapActionName(
        $pattern, array $resources, $uri, $method, $expect
    )
    {
        $this->route->setUri($pattern);
        $this->route->setResources($resources);
        $this->route->request($method, $uri);

        $this->assertEquals($expect, $this->route->getActionName());
    }
}
