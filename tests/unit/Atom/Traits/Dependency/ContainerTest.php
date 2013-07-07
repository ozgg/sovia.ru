<?php
/**
 * Test case for dependency container trait
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Test\Unit\Atom\Traits
 */

namespace Test\Unit\Atom\Traits\Dependency;

use Atom\Test\TestCase;
use Atom\Traits\Dependency\Container;

/**
 * Test of trait DependencyContainer
 *
 * @coversDefaultClass \Atom\Traits\Dependency\Container
 */
class ContainerTest extends TestCase
{
    /**
     * @var Container
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
        $traitName   = '\\Atom\\Traits\\Dependency\\Container';
        $this->trait = $this->getObjectForTrait($traitName);

        $this->reflection = new \ReflectionClass($this->trait);
    }

    /**
     * Tests checkContainerState when container is set
     *
     * @covers \Atom\Traits\Dependency\Container::checkContainerState
     */
    public function testCheckContainerStateSet()
    {
        $this->trait->setDependencyContainer(new \Atom\Container);
        $method = $this->reflection->getMethod('checkContainerState');
        $method->setAccessible(true);
        $method->invoke($this->trait);
    }

    /**
     * Tests checkContainerState when container is not set
     *
     * @covers \Atom\Traits\Dependency\Container::checkContainerState
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
     * @covers \Atom\Traits\Dependency\Container::injectDependency
     * @covers \Atom\Traits\Dependency\Container::extractDependency
     */
    public function testExtractDependency()
    {
        $this->trait->setDependencyContainer(new \Atom\Container);
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
