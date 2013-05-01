<?php
/**
 * 
 * 
 * Date: 01.05.13
 * Time: 3:01
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */

namespace Sovia\Http;
 
class Response 
{
    /**
     * @var Status
     */
    protected $status;

    /**
     * @var array
     */
    protected $headers = [];

    /**
     * @var string
     */
    protected $type    = 'text/plain';

    /**
     * @var string
     */
    protected $body    = '';

    public function __construct($body = '')
    {
        $this->setBody($body);
    }

    public function send()
    {
        if ($this->status instanceof Status) {
            header('HTTP/1.1 ' . $this->status);
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
     * @param array $headers
     * @return Response
     */
    public function setHeaders(array $headers)
    {
        $this->headers = $headers;

        return $this;
    }

    /**
     * @return array
     */
    public function getHeaders()
    {
        return $this->headers;
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
    public function setType($type)
    {
        $this->type = $type;

        return $this;
    }

    /**
     * @return string
     */
    public function getType()
    {
        return $this->type;
    }
}
