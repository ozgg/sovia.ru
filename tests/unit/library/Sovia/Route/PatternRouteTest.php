<?php
/**
 * Test case for pattern-based route
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Test\Unit\Library\Sovia\Route
 */

namespace Test\Unit\Library\Sovia\Route;
 
use Sovia\Route\PatternRoute;
use Sovia\Test\TestCase;

/**
 * Tests for PatternRoute
 *
 * @covers \Sovia\Route\PatternRoute
 */
class PatternRouteTest extends TestCase
{
    /**
     * Data provider for testAssembleFailure
     *
     * @return array
     */
    public function assembleFailureProvider()
    {
        return [
            ['/foo/:foo', [['bar' => 'baz']]],
            ['/foo/:foo/bar/:bar', [['bar' => 'baz']]],
            ['/foo/:foo/bar/:bar', ['foo']],
        ];
    }

    /**
     * Data provider for testAssembleSuccess
     *
     * @return array
     */
    public function assembleSuccessProvider()
    {
        return [
            [[1, 2]],
            [[[1, 2]]],
            [[['a' => 1, 'b' => 2]]],
        ];
    }

    /**
     * Data provider for testRequestSuccess
     * 
     * @return array
     */
    public function requestSuccessProvider()
    {
        return [
            ['/foo/:foo', '/foo/1', ['foo' => 1]],
            ['/foo/:foo/:bar', '/foo/1/2', ['foo' => 1, 'bar' => 2]],
        ];
    }

    /**
     * Test assembling URI with correct parameters
     *
     * Method accepts arbitrary arguments or array (regular and associative)
     *
     * @param array $arguments
     *
     * @covers \Sovia\Route\PatternRoute::assemble
     * @dataProvider assembleSuccessProvider
     */
    public function testAssembleSuccess(array $arguments)
    {
        $uri    = '/foo/:a/bar/:b';
        $expect = '/foo/1/bar/2';
        $route  = new PatternRoute;
        $route->setUri($uri);

        $result = call_user_func_array([$route, 'assemble'], $arguments);
        $this->assertEquals($expect, $result);
    }

    /**
     * Test assembling URI throws exception on invalid parameters
     *
     * @param string $uri        URI to use in route pattern
     * @param array  $arguments  Arguments to pass to assemble()
     *
     * @expectedException \Exception
     * @dataProvider assembleFailureProvider
     * @covers \Sovia\Route\PatternRoute::assemble
     */
    public function testAssembleFailure($uri, array $arguments)
    {
        $route = new PatternRoute;
        $route->setUri($uri);
        call_user_func_array([$route, 'assemble'], $arguments);
    }

    /**
     * Test requesting URI with parameters
     *
     * @param string $pattern  URI pattern for route
     * @param string $uri      URI to request
     * @param array  $expect   expected route parameters taken from URI
     *
     * @covers \Sovia\Route\PatternRoute::request
     * @dataProvider requestSuccessProvider
     */
    public function testRequestSuccess($pattern, $uri, array $expect)
    {
        $route = new PatternRoute;
        $route->setUri($pattern);
        $route->setMethods([PatternRoute::METHOD_GET]);
        $route->request(PatternRoute::METHOD_GET, $uri);

        $this->assertEquals($expect, $route->getParameters());
    }

    /**
     * Test requesting with not allowed method
     *
     * @expectedException \Sovia\Exceptions\Http\Client\MethodNotAllowed
     * @covers \Sovia\Route\PatternRoute::request
     */
    public function testRequestFailure()
    {
        $route = new PatternRoute;
        $route->setMethods([PatternRoute::METHOD_GET]);
        $route->request(PatternRoute::METHOD_POST, '');
    }
}
