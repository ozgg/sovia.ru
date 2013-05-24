<?php
/**
 * Test case for abstract route
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Test\Unit\Library\Sovia
 */

namespace Test\Unit\Library\Sovia;
 
use Sovia\Route;
use Sovia\Test\TestCase;

/**
 * Test of abstract route
 *
 * @covers \Sovia\Route
 */
class RouteTest extends TestCase
{
    /**
     * Data provider for testFactorySuccess
     *
     * @return array
     */
    public function factorySuccessProvider()
    {
        return [
            [Route::TYPE_STATIC,  '\\Sovia\\Route\\StaticRoute'],
            [Route::TYPE_REGEX,   '\\Sovia\\Route\\RegexRoute'],
            [Route::TYPE_REST,    '\\Sovia\\Route\\RestRoute'],
            [Route::TYPE_PATTERN, '\\Sovia\\Route\\PatternRoute'],
        ];
    }

    /**
     * Test factory with successful result
     *
     * @param string $type       route type
     * @param string $className  expected class name
     * @dataProvider factorySuccessProvider
     * @covers \Sovia\Route::factory
     */
    public function testFactorySuccess($type, $className)
    {
        $route = Route::factory($type);

        $this->assertTrue($route instanceof $className);
    }

    /**
     * Test factory failure with unknown route type
     *
     * @expectedException \Exception
     * @covers \Sovia\Route::factory
     */
    public function testFactoryFailure()
    {
        Route::factory('non-existent');
    }

    /**
     * Test initializing from array
     *
     * @covers \Sovia\Route::initFromArray
     */
    public function testInitFromArray()
    {
        /** @var Route $route */
        $route = $this->getMockForAbstractClass('\\Sovia\\Route');
        $data  = [
            'name'       => 'testRoute',
            'methods'    => [Route::METHOD_GET, Route::METHOD_PUT],
            'reverse'    => '/yummy',
            'controller' => 'test',
            'action'     => 'tested',
        ];

        $route->initFromArray($data);

        $this->assertEquals($data['name'], $route->getName());
        $this->assertEquals($data['methods'], $route->getMethods());
        $this->assertEquals($data['reverse'], $route->getReverse());
        $this->assertEquals($data['controller'], $route->getControllerName());
        $this->assertEquals($data['action'], $route->getActionName());
    }
}
