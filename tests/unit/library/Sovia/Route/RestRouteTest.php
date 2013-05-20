<?php
/**
 *
 *
 * Date: 01.05.13
 * Time: 12:44
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Test\Unit\Library\Sovia\Route
 */

namespace Test\Unit\Library\Sovia\Route;

use Sovia\Route\RegexRoute;
use Sovia\Route\RestRoute;
use Sovia\Test\TestCase;

/**
 * Class RestRouteTest
 *
 * @covers \Sovia\Route\RestRoute
 */
class RestRouteTest extends TestCase
{
    /**
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
        $method = RegexRoute::METHOD_GET;
        return [
            ['/foo', [], '/foo', $method, []],
            ['/foo', [], '/foo/4', $method, ['element_id' => 4]],
            ['/a', ['b', 'c'], '/a/1/c', $method, ['element_id' => 1]],
            ['/a', ['b', 'c'], '/a/1/b/2', $method, ['element_id' => 1, 'resource_id' => 2]],
        ];
    }

    public function mapActionNameProvider()
    {
        return [
            ['', [], '', '', '']
        ];
    }

    /**
     * @param string $uri
     * @param array  $resources
     * @param array  $parameters
     * @param string $expect
     * @dataProvider assembleSuccessProvider
     * @covers       \Sovia\Route\RestRoute::assemble
     */
    public function testAssembleSuccess($uri, $resources, $parameters, $expect)
    {
        $this->markTestIncomplete();
    }

    /**
     * @param string $uri
     * @param array  $resources
     * @param array  $parameters
     * @dataProvider assembleFailureProvider
     * @covers       \Sovia\Route\RestRoute::assemble
     */
    public function testAssembleFailure($uri, $resources, $parameters)
    {
        $this->markTestIncomplete();
    }

    /**
     * @param string $pattern
     * @param array  $resources
     * @param string $uri
     * @param string $method
     * @param array  $expect
     * @dataProvider requestSuccessProvider
     * @covers       \Sovia\Route\RestRoute::request
     */
    public function testRequestSuccess($pattern, $resources, $uri, $method, $expect)
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

    public function testGetMatch()
    {
        $this->markTestIncomplete();
    }

    /**
     * @param $pattern
     * @param $resources
     * @param $uri
     * @param $method
     * @param $expect
     * @dataProvider mapActionNameProvider
     * @covers \Sovia\Route\RestRoute::mapActionName
     */
    public function testMapActionName($pattern, $resources, $uri, $method, $expect)
    {
        $this->markTestIncomplete();
    }
}
