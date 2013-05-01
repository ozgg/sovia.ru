<?php
/**
 * 
 * 
 * Date: 01.05.13
 * Time: 12:43
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */

namespace Test\Unit\Library\Sovia\Route;
 
use Sovia\Route\PatternRoute;
use Sovia\Test\TestCase;

/**
 * Class PatternRouteTest
 *
 * @package Test\Unit\Library\Sovia\Route
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

    public function testRequestSuccess()
    {
        $this->markTestIncomplete();
    }

    public function testRequestFailure()
    {
        $this->markTestIncomplete();
    }
}
