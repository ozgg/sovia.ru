<?php
/**
 * HTTP-ответ
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom\Http
 */

namespace Atom\Http;

use Atom\Traits\Http\HasHeaders;

/**
 * HTTP-ответ
 */
class Response
{
    use HasHeaders;

    /**
     * @var Status
     */
    protected $status;

    /**
     * @var string
     */
    protected $contentType = 'text/plain;charset=UTF-8';

    /**
     * @var string
     */
    protected $body = '';

    /**
     * Конструктор
     *
     * На входе принимает тело ответа
     *
     * @param string $body
     */
    public function __construct($body = '')
    {
        $this->setBody($body);
    }

    /**
     * Отправить ответ
     */
    public function send()
    {
        if ($this->status instanceof Status) {
            header('HTTP/1.1 ' . $this->status);
        }

        header("Content-type: {$this->contentType}");

        foreach ($this->getHeaders() as $header => $value) {
            header("{$header}: {$value}");
        }

        if ($this->body != '') {
            echo $this->body;
        }
    }

    /**
     * @param string $body
     * @return Response
     */
    public function setBody($body)
    {
        $this->body = $body;

        return $this;
    }

    /**
     * @return string
     */
    public function getBody()
    {
        return $this->body;
    }

    /**
     * @param Status $status
     * @return Response
     */
    public function setStatus(Status $status)
    {
        $this->status = $status;

        return $this;
    }

    /**
     * @return Status
     */
    public function getStatus()
    {
        return $this->status;
    }

    /**
     * @param string $type
     * @return Response
     */
    public function setContentType($type)
    {
        $this->contentType = $type;

        return $this;
    }

    /**
     * @return string
     */
    public function getContentType()
    {
        return $this->contentType;
    }
}
