<?php
/**
 * Тест конфигурации
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Test\Unit\Atom
 */

namespace Test\Unit\Atom;

use Atom\Configuration;
use Atom\Test\TestCase;

/**
 * Тест конфигурации
 *
 * @covers \Atom\Configuration
 */
class ConfigurationTest extends TestCase
{
    /**
     * @var Configuration
     */
    private $configuration;

    /**
     * Перед началом каждого теста нужно создать объект тестирования
     */
    protected function setUp()
    {
        $path = __DIR__ . '/../../samples/configuration';

        $this->configuration = new Configuration($path);
    }

    /**
     * Данные для теста успешной установки среды
     */
    public function environmentProvider()
    {
        return [
            ['production', ['a' => 0, 'b' => ['c' => 'd']]],
            ['development', ['a' => 0, 'b' => ['c' => 'e']]],
            ['test', ['a' => 1, 'b' => ['c' => 'e', 'f' => 'g'], 'h' => 'i']],
        ];
    }

    /**
     * Проверить успешный случай установки среды
     *
     * @dataProvider environmentProvider
     * @covers       \Atom\Configuration::setEnvironment
     */
    public function testSetEnvironmentSuccess($environment, array $expect)
    {
        $this->configuration->setEnvironment($environment);
        $this->assertEquals($expect, $this->configuration->getParameters());
    }

    /**
     * Проверить случай установки несуществующей среды
     *
     * @expectedException \ErrorException
     * @covers \Atom\Configuration::setEnvironment
     */
    public function testSetEnvironmentFail()
    {
        $this->configuration->setEnvironment('invalid');
    }
}
