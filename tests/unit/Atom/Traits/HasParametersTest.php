<?php
/**
 * Тест примеси HasParameters
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Test\Unit\Atom\Traits
 */

namespace Test\Unit\Atom\Traits;

use Atom\Test\TestCase;
use Atom\Traits\HasParameters;

/**
 * Тест примеси HasParameters
 *
 * @covers \Atom\Traits\HasParameters
 */
class HasParametersTest extends TestCase
{
    /**
     * @var HasParameters
     */
    private $trait;

    /**
     * Перед тестированием создадим использующий примесь объект
     */
    protected function setUp()
    {
        $traitName   = '\\Atom\\Traits\\HasParameters';
        $this->trait = $this->getObjectForTrait($traitName);
    }

    /**
     * Набор данных для testGetExistingParameter()
     *
     * @return array
     */
    public function getExistingParameterProvider()
    {
        return [
            [['a' => 'b', 'c' => 'd'], 'a', 'b'],
            [['a' => ['b' => 'c'], 'd' => 'e'], 'a', ['b' => 'c']],
            [['a' => ['b' => 'c'], 'd' => 'e'], 'a.b', 'c'],
            [['a' => ['b' => ['c' => 1, 'e' => 2]], 'd' => 'e'], 'a.b.c', 1],
        ];
    }

    /**
     * Набор данных для testSetParameter()
     *
     * @return array
     */
    public function setParameterProvider()
    {
        return [
            ['a', ['b' => 'c'], ['a' => ['b' => 'c']]],
            ['a.b', 'c', ['a' => ['b' => 'c']]],
            ['a.b.c', ['d' => 0], ['a' => ['b' => ['c' => ['d' => 0]]]]],
        ];
    }

    /**
     * @param array  $initial
     * @param string $name
     * @param mixed  $expect
     *
     * @dataProvider getExistingParameterProvider
     * @covers       \Atom\Traits\HasParameters::getParameter
     */
    public function testGetExistingParameter(array $initial, $name, $expect)
    {
        $this->trait->setParameters($initial);
        $this->assertEquals($expect, $this->trait->getParameter($name));
    }

    /**
     * @param string $name
     * @param mixed  $value
     * @param array  $expect
     *
     * @dataProvider setParameterProvider
     * @covers       \Atom\Traits\HasParameters::setParameter
     */
    public function testSetParameter($name, $value, array $expect)
    {
        $this->trait->setParameters([]);
        $this->trait->setParameter($name, $value);
        $this->assertEquals($expect, $this->trait->getParameters());
    }
}
