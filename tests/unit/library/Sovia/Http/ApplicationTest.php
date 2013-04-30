<?php
/**
 * 
 * 
 * Date: 01.05.13
 * Time: 0:11
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Test\Unit\Library\Sovia\Http
 */

namespace Test\Unit\Library\Sovia\Http;

use Sovia\Http\Application;
use Sovia\Test\TestCase;

/**
 * Tests of HTTP application
 *
 * @covers \Sovia\Http\Application
 */
class ApplicationTest extends TestCase
{
    /**
     * Test setting existing directory
     *
     * @covers \Sovia\Http\Application::setDirectory
     */
    public function testSetExistingDirectory()
    {
        $application = $this->getApplicationInstance();
        $application->setDirectory(__DIR__);

        $this->assertEquals(__DIR__, $application->getDirectory());
    }

    /**
     * Test setting non-existent directory
     *
     * @expectedException \Exception
     * @covers \Sovia\Http\Application::setDirectory
     */
    public function testSetInvalidDirectory()
    {
        $application = $this->getApplicationInstance();
        $application->setDirectory(DIRECTORY_SEPARATOR . md5(microtime()));
    }

    /**
     * Get application instance without calling its constructor
     *
     * @return Application
     */
    protected function getApplicationInstance()
    {
        $reflection = new \ReflectionClass('\\Sovia\\Http\\Application');

        return $reflection->newInstanceWithoutConstructor();
    }
}
