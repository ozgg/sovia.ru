<?php
/**
 * Test case for DI container
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Test\Unit\Library\Sovia
 */

namespace Test\Unit\Library\Sovia;

use Sovia\Container;
use Sovia\Test\TestCase;

/**
 * Test for DI container
 *
 * @covers \Sovia\Container
 */
class ContainerTest extends TestCase
{
    /**
     * Test extracting existing element
     *
     * @covers \Sovia\Container::extract
     */
    public function testExtractExisting()
    {
        $element   = new \stdClass;
        $container = new Container;

        $element->foo = 'bar';
        $container->inject('foo', $element);

        $extracted = $container->extract('foo');
        $this->assertEquals($element, $extracted);
    }

    /**
     * Test extracting non-existent element
     *
     * @covers \Sovia\Container::extract
     */
    public function testExtractEmpty()
    {
        $container = new Container;
        $element   = $container->extract('foo');

        $this->assertNull($element);
    }

    /**
     * Test checking existence of elements in container
     *
     * @covers \Sovia\Container::check
     */
    public function testCheck()
    {
        $element   = ['foo' => 'bar'];
        $container = new Container;
        $container->inject('foo', $element);

        $this->assertTrue($container->check('foo'));
        $this->assertFalse($container->check('bar'));
    }
}
