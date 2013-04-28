<?php
/**
 * 
 * 
 * Date: 29.04.13
 * Time: 2:40
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Test\Unit\Library\Sovia\Http
 */

namespace Test\Unit\Library\Sovia\Http;
 
use Sovia\Http\Request;
use Sovia\Test\TestCase;

/**
 * Class RequestTest
 *
 * @covers \Sovia\Http\Request
 */
class RequestTest extends TestCase
{
    /**
     * @covers \Sovia\Http\Request::__construct
     */
    public function testConstructor()
    {
        $server = [
            'REQUEST_METHOD' => 'GET',
            'HTTP_HOST'      => 'example.com',
            'REQUEST_URI'    => '/test/request/',
        ];

        $request = new Request($server);

        $this->assertEquals($server['REQUEST_METHOD'], $request->getMethod());
        $this->assertEquals($server['HTTP_HOST'], $request->getHost());
        $this->assertEquals($server['REQUEST_URI'], $request->getUri());
    }

    public function testGetHeader()
    {
        $this->markTestIncomplete();
    }

    public function testGetParameter()
    {
        $this->markTestIncomplete();
    }

    public function testGetFile()
    {
        $this->markTestIncomplete();
    }
}
