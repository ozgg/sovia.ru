<?php
/**
 * Test case for regex route
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Test\Unit\Library\Sovia\Route
 */

namespace Test\Unit\Library\Sovia\Route;
 
use Sovia\Route\RegexRoute;
use Sovia\Test\TestCase;

/**
 * Test of regex route
 *
 * @covers \Sovia\Route\RegexRoute
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
     * Test assembling route
     *
     * @param string $uri
     * @param string $reverse
     * @param array $params
     * @param string $expect
     * @dataProvider assembleSuccessProvider
     * @covers \Sovia\Route\RegexRoute::assemble
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
     * @param array $parameters
     * @expectedException \Exception
     * @dataProvider assembleFailureProvider
     * @covers \Sovia\Route\RegexRoute::assemble
     */
    public function testAssembleFailure($uri, $reverse, array $parameters)
    {
        $route = new RegexRoute;
        $route->setUri($uri);
        $route->setReverse($reverse);
        $route->assemble($parameters);
    }

    public function testRequestSuccess()
    {
        $this->markTestIncomplete();
    }

    public function testRequestFailure()
    {
        $this->markTestIncomplete();
    }

    /**
     * Test getting regEx match pattern
     *
     * @covers \Sovia\Route\RegexRoute::getMatch
     */
    public function testGetMatch()
    {
        $uri   = '/foo/u(\d+)/bar/(\s+)';
        $route = new RegexRoute;
        $route->setUri($uri);
        $this->assertEquals($uri, $route->getMatch());
    }
}
