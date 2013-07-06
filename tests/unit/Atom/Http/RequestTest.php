<?php
/**
 * Test case for HTTP request
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Test\Unit\Atom\Http
 */

namespace Test\Unit\Atom\Http;

use Atom\Test\TestCase;
use Atom\Http\Request;
use Atom\Http\UploadedFile;

/**
 * Test of HTTP request
 *
 * @covers \Atom\Http\Request
 */
class RequestTest extends TestCase
{
    /**
     * Test if constructor initializes $server parameters
     *
     * @covers \Atom\Http\Request::__construct
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

    /**
     * Test getHeader() method
     *
     * @covers \Atom\Http\Request::getHeader
     */
    public function testGetHeader()
    {
        $value  = 'Beautiful header';
        $server = [
            'HTTP_CUSTOM_HEADER' => $value,
        ];

        $request = new Request($server);
        $this->assertEquals($value, $request->getHeader('Custom-header'));
    }

    /**
     * Test getParameter() method
     *
     * @covers \Atom\Http\Request::getParameter
     */
    public function testGetParameter()
    {
        $get  = [
            'foo' => 'get',
            'bar' => 'get',
        ];
        $post = [
            'foo' => 'post',
            'baz' => 'post',
        ];

        $request = new Request([]);
        $request->setGet($get);
        $request->setPost($post);

        $this->assertEquals('get', $request->getParameter('foo'));
        $this->assertEquals('post', $request->getParameter('baz'));
        $this->assertNull($request->getParameter('non_existent'));
    }

    /**
     * Test getFile method
     *
     * Method must return instance of UploadedFile
     *
     * @covers \Atom\Http\Request::getFile
     */
    public function testGetFile()
    {
        $files = [
            'foo' => [
                'name'     => 'foo.jpg',
                'type'     => 'image/jpeg',
                'tmp_name' => '/tmp/001.dat',
                'error'    => \UPLOAD_ERR_OK,
            ],
        ];

        $request = new Request([]);
        $request->setFiles($files);

        $file = $request->getFile('foo');
        $this->assertTrue($file instanceof UploadedFile);
    }
}
