<?php
/**
 * Test case for pattern-based route
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Test\Unit\Atom\Http\Route
 */

namespace Test\Unit\Atom\Http\Route;
 
use Atom\Http\Route\PatternRoute;
use Atom\Test\TestCase;

/**
 * Tests for PatternRoute
 *
 * @covers \Atom\Http\Route\PatternRoute
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
     * Data provider for testGetMatch
     *
     * @return array
     */
    public function getMatchProvider()
    {
        return [
            [['/foo/:foo'], ['/foo/[^/]+']],
            [['/foo/:foo/:bar'], ['/foo/[^/]+/[^/]+']],
            [['/foo/:foo/:bar/baz'], ['/foo/[^/]+/[^/]+/baz']],
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
     * @covers \Atom\Http\Route\PatternRoute::assemble
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
     * @covers \Atom\Http\Route\PatternRoute::assemble
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
     * @covers \Atom\Http\Route\PatternRoute::request
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
     * @expectedException \Atom\Http\Error\MethodNotAllowed
     * @covers \Atom\Http\Route\PatternRoute::request
     */
    public function testRequestFailure()
    {
        $route = new PatternRoute;
        $route->setMethods([PatternRoute::METHOD_GET]);
        $route->request(PatternRoute::METHOD_POST, '');
    }

    /**
     * Test getting regEx match
     *
     * @param string $uri
     * @param string $pattern
     * @covers \Atom\Http\Route\PatternRoute::getMatch
     * @dataProvider getMatchProvider
     */
    public function testGetMatch($uri, $pattern)
    {
        $route = new PatternRoute;
        $route->setUri($uri);
        $this->assertEquals($pattern, $route->getMatch());
    }
}
