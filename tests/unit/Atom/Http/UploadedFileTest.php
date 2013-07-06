<?php
/**
 * Test cases for uploaded file
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Test\Unit\Atom\Http
 */

namespace Test\Unit\Atom\Http;
 
use Atom\Http\UploadedFile;
use Atom\Test\TestCase;

/**
 * Tests uploaded file
 *
 * @covers \Atom\Http\UploadedFile
 */
class UploadedFileTest extends TestCase
{
    /**
     * Test if uploaded file recognizes image MIME type
     *
     * @covers \Atom\Http\UploadedFile::isImage
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
     * @covers \Atom\Http\UploadedFile::hasError
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
