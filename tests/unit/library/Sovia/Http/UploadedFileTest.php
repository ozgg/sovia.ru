<?php
/**
 * Test cases for uploaded file
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Test\Unit\Library\Sovia\Http
 */

namespace Test\Unit\Library\Sovia\Http;
 
use Sovia\Http\UploadedFile;
use Sovia\Test\TestCase;

/**
 * Tests uploaded file
 *
 * @covers \Sovia\Http\UploadedFile
 */
class UploadedFileTest extends TestCase
{
    /**
     * Test if uploaded file recognizes image MIME type
     *
     * @covers \Sovia\Http\UploadedFile::isImage
     */
    public function testIsImage()
    {
        $data = [
            'name'     => 'foo.jpeg',
            'type'     => 'image/jpeg',
            'tmp_name' => '/tmp/uploaded.dat',
        ];
        $file = new UploadedFile($data);

        $this->assertTrue($file->isImage());
    }

    /**
     * Test hasError method
     *
     * @param array $data
     * @param bool $hasError
     * @dataProvider hasErrorProvider
     * @covers \Sovia\Http\UploadedFile::hasError
     */
    public function testHasError(array $data, $hasError)
    {
        $file = new UploadedFile($data);

        $this->assertEquals($hasError, $file->hasError());
    }

    /**
     * Data provider for testHasError
     *
     * @return array
     */
    public function hasErrorProvider()
    {
        return [
            [
                [
                    'name'     => 'foo.jpeg',
                    'type'     => 'image/jpg',
                    'tmp_name' => '/tmp/incomplete.dat',
                    'error'    => \UPLOAD_ERR_PARTIAL,
                ],
                true,
            ],
            [
                [
                    'name'     => 'foo.txt',
                    'type'     => 'text/plain',
                    'tmp_name' => '/tmp/good.dat',
                    'error'    => \UPLOAD_ERR_OK,
                ],
                false,
            ],
        ];
    }
}
