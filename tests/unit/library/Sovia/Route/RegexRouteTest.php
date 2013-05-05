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
    public function assembleProvider()
    {
        return [
            ['/foo/(\s+)', '/foo/%s', ['bar'], '/foo/bar'],
            ['/u(\d+)/a/(\s+)', '/u%u/a/%s', [123, 'yay'], '/u123/a/yay'],
            ['/u(\d+)/a/(\s+)', '/u%u/a/%s', [[123, 'yay']], '/u123/a/yay'],
        ];
    }

    /**
     * Test assembling route
     *
     * @param string $uri
     * @param string $reverse
     * @param array $parameters
     * @param string $expect
     * @dataProvider assembleProvider
     * @covers \Sovia\Route\RegexRoute::assemble
     */
    public function testAssemble($uri, $reverse, array $parameters, $expect)
    {
        $route = new RegexRoute;
        $route->setUri($uri);
        $route->setReverse($reverse);
        $result = call_user_func_array([$route, 'assemble'], $parameters);
        $this->assertEquals($expect, $result);
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
