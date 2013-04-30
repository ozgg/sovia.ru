<?php
/**
 * Test case for dependency container trait
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Test\Unit\Library\Sovia\Traits
 */

namespace Test\Unit\Library\Sovia\Traits;

use Sovia\Container;
use Sovia\Test\TestCase;
use Sovia\Traits\DependencyContainer;

/**
 * Test of trait DependencyContainer
 *
 * @coversDefaultClass \Sovia\Traits\DependencyContainer
 */
class DependencyContainerTest extends TestCase
{
    /**
     * @var DependencyContainer
     */
    protected $trait;

    /**
     * @var \ReflectionClass
     */
    protected $reflection;

    /**
     * Set up before test
     *
     * Prepares object with the trait
     */
    public function setUp()
    {
        $traitName   = '\\Sovia\\Traits\\DependencyContainer';
        $this->trait = $this->getObjectForTrait($traitName);

        $this->reflection = new \ReflectionClass($this->trait);
    }

    /**
     * Tests checkContainerState when container is set
     *
     * @covers \Sovia\Traits\DependencyContainer::checkContainerState
     */
    public function testCheckContainerStateSet()
    {
        $this->trait->setDependencyContainer(new Container);
        $method = $this->reflection->getMethod('checkContainerState');
        $method->setAccessible(true);
        $method->invoke($this->trait);
    }

    /**
     * Tests checkContainerState when container is not set
     *
     * @covers \Sovia\Traits\DependencyContainer::checkContainerState
     * @expectedException \Exception
     */
    public function testCheckContainerStateUnset()
    {
        $method = $this->reflection->getMethod('checkContainerState');
        $method->setAccessible(true);
        $method->invoke($this->trait);
    }

    /**
     * Test extracting dependencies
     *
     * Extracts existing and non-existing dependencies
     * @covers \Sovia\Traits\DependencyContainer::injectDependency
     * @covers \Sovia\Traits\DependencyContainer::extractDependency
     */
    public function testExtractDependency()
    {
        $this->trait->setDependencyContainer(new Container);
        $element = new \stdClass;

        $element->foo = 'bar';

        $inject = $this->reflection->getMethod('injectDependency');
        $inject->setAccessible(true);
        $inject->invoke($this->trait, 'foo', $element);

        $extract   = $this->reflection->getMethod('extractDependency');
        $extract->setAccessible(true);
        $extracted = $extract->invoke($this->trait, 'foo');

        $this->assertEquals($element, $extracted);
        $this->assertNull($extract->invoke($this->trait, 'bar'));
    }
}
