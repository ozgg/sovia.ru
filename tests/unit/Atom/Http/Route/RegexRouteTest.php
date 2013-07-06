<?php
/**
 * Test case for regex route
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Test\Unit\Atom\Http\Route
 */

namespace Test\Unit\Atom\Http\Route;

use Atom\Http\Route\RegexRoute;
use Atom\Test\TestCase;

/**
 * Test of regex route
 *
 * @covers \Atom\Http\Route\RegexRoute
 */
class RegexRouteTest extends TestCase
{
    /**
     * Data provider for testAssembleSuccess
     *
     * @return array
     */
    public function assembleSuccessProvider()
    {
        return [
            ['/foo/(\s+)', '/foo/%s', ['bar'], '/foo/bar'],
            ['/u(\d+)/a/(\s+)', '/u%u/a/%s', [123, 'yay'], '/u123/a/yay'],
            ['/u(\d+)/a/(\s+)', '/u%u/a/%s', [[123, 'yay']], '/u123/a/yay'],
        ];
    }

    /**
     * Data provider for testAssembleFailure
     *
     * @return array
     */
    public function assembleFailureProvider()
    {
        return [
            ['/u(\d+)', '', [1]],
            ['/u(\d+)/foo/(\s+)', '/u%u/foo/%s', [10]],
            ['/u(\d+)/foo/(\s+)', '', [1, 'yay']],
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
            ['/u(\d+)/foo\d+', '/u123/foo456', [0 => 123]],
            ['/u/(?P<u>\d+)/foo/(\d+)', '/u/12/foo/34', ['u' => 12, 1 => 34]],
            [
                '/(?P<a>\d+)/(?P<b>\d+)/(\d+)', '/1/2/3',
                ['a' => 1, 'b' => 2, 2 => 3]
            ],
            [
                '/(?P<a>\d+)/(\d+)/(?P<b>\d+)', '/1/2/3',
                ['a' => 1, 1 => 2, 'b' => 3]
            ],
        ];
    }

    /**
     * Test assembling route
     *
     * @param string $uri
     * @param string $reverse
     * @param array  $params
     * @param string $expect
     * @dataProvider assembleSuccessProvider
     * @covers       \Atom\Http\Route\RegexRoute::assemble
     */
    public function testAssembleSuccess($uri, $reverse, array $params, $expect)
    {
        $route = new RegexRoute;
        $route->setUri($uri);
        $route->setReverse($reverse);
        $result = call_user_func_array([$route, 'assemble'], $params);
        $this->assertEquals($expect, $result);
    }

    /**
     * Test assembling without reverse pattern
     *
     * @param string $uri
     * @param string $reverse
     * @param array  $parameters
     * @expectedException \Exception
     * @dataProvider assembleFailureProvider
     * @covers       \Atom\Http\Route\RegexRoute::assemble
     */
    public function testAssembleFailure($uri, $reverse, array $parameters)
    {
        $route = new RegexRoute;
        $route->setUri($uri);
        $route->setReverse($reverse);
        $route->assemble($parameters);
    }

    /**
     * Test successful route request
     *
     * @param string $pattern
     * @param string $uri
     * @param array  $expect
     * @dataProvider requestSuccessProvider
     * @covers       \Atom\Http\Route\RegexRoute::request
     */
    public function testRequestSuccess($pattern, $uri, array $expect)
    {
        $route = new RegexRoute;
        $route->setUri($pattern);
        $route->setMethods([RegexRoute::METHOD_GET]);
        $route->request(RegexRoute::METHOD_GET, $uri);

        $this->assertEquals($expect, $route->getParameters());
    }

    /**
     * Test getting exception requesting not allowed method
     *
     * @expectedException \Atom\Http\Error\MethodNotAllowed
     * @covers \Atom\Http\Route\RegexRoute::request
     */
    public function testRequestFailure()
    {
        $route = new RegexRoute;
        $route->setMethods([RegexRoute::METHOD_GET, RegexRoute::METHOD_PUT]);
        $route->request(RegexRoute::METHOD_POST, '/');
    }

    /**
     * Test getting regEx match pattern
     *
     * @covers \Atom\Http\Route\RegexRoute::getMatch
     */
    public function testGetMatch()
    {
        $uri = '/foo/u(\d+)/bar/(\s+)';
        $route = new RegexRoute;
        $route->setUri($uri);
        $this->assertEquals($uri, $route->getMatch());
    }
}
