<?php
/**
 * Загруженный по HTTP файл
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom\Http
 */

namespace Atom\Http;

/**
 * Загруженный файл
 */
class UploadedFile 
{
    /**
     * Original name
     *
     * @var string
     */
    protected $name;

    /**
     * MIME type
     *
     * @var string
     */
    protected $type;

    /**
     * Temporary file name
     *
     * @var string
     */
    protected $tmpName;

    /**
     * Error code
     *
     * @var int
     */
    protected $error = \UPLOAD_ERR_OK;

    /**
     * Constructor
     *
     * Expects data in format of $_FILES['filename'] array
     *
     * @param array $data
     * @throws \Exception
     */
    public function __construct(array $data)
    {
        if (!isset($data['name'], $data['type'], $data['tmp_name'])) {
            throw new \Exception('Invalid data format');
        }

        $this->setName($data['name']);
        $this->setTmpName($data['tmp_name']);
        $this->setType($data['type']);

        if (isset($data['error'])) {
            $this->setError($data['error']);
        }
    }

    /**
     * Is this a really uploaded file
     *
     * @return bool
     */
    public function isUploadedFile()
    {
        return is_uploaded_file($this->getTmpName());
    }

    /**
     * File is image by MIME type
     *
     * @return bool
     */
    public function isImage()
    {
        return strpos($this->type, 'image/') === 0;
    }

    /**
     * Move file to destination
     *
     * @param string $destination
     */
    public function move($destination)
    {
        move_uploaded_file($this->tmpName, $destination);
    }

    /**
     * Has any errors during upload
     *
     * @return bool
     */
    public function hasError()
    {
        return $this->error != UPLOAD_ERR_OK;
    }

    /**
     * Set error code
     *
     * @param int $error
     * @return UploadedFile
     */
    public function setError($error)
    {
        $this->error = $error;

        return $this;
    }

    /**
     * Get error code
     *
     * @return int
     */
    public function getError()
    {
        return $this->error;
    }

    /**
     * Set original name
     *
     * @param string $name
     * @return UploadedFile
     */
    public function setName($name)
    {
        $this->name = $name;

        return $this;
    }

    /**
     * Get original name
     *
     * @return string
     */
    public function getName()
    {
        return $this->name;
    }

    /**
     * Set temporary name
     *
     * @param string $tmpName
     * @return UploadedFile
     */
    public function setTmpName($tmpName)
    {
        $this->tmpName = $tmpName;

        return $this;
    }

    /**
     * Get temporary name
     *
     * @return string
     */
    public function getTmpName()
    {
        return $this->tmpName;
    }

    /**
     * Set MIME type
     *
     * @param string $type
     * @return UploadedFile
     */
    public function setType($type)
    {
        $this->type = $type;

        return $this;
    }

    /**
     * Get MIME type
     *
     * @return string
     */
    public function getType()
    {
        return $this->type;
    }
}
