<?php
/**
 * 
 * 
 * Date: 29.04.13
 * Time: 2:27
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */

namespace Sovia\Http;
 
class Request 
{
    /**
     * @var array
     */
    protected $get     = [];

    /**
     * @var array
     */
    protected $post    = [];

    /**
     * @var string
     */
    protected $body    = '';

    /**
     * @var array
     */
    protected $files   = [];

    /**
     * @var array
     */
    protected $cookies = [];

    /**
     * @var array
     */
    protected $server  = [];

    /**
     * @var string
     */
    protected $uri     = '';

    /**
     * @var string
     */
    protected $host    = '';

    /**
     * @var string
     */
    protected $method  = '';

    public function __construct(array $server)
    {
        $this->setServer($server);
        if (isset($this->server['REQUEST_URI'])) {
            $this->setUri($this->server['REQUEST_URI']);
        }
        if (isset($this->server['HTTP_HOST'])) {
            $this->setHost($this->server['HTTP_HOST']);
        }
        if (isset($this->server['REQUEST_METHOD'])) {
            $this->setMethod($this->server['REQUEST_METHOD']);
        }
    }

    /**
     * @param string $body
     * @return Request
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
     * @param array $cookies
     * @return Request
     */
    public function setCookies(array $cookies)
    {
        $this->cookies = $cookies;

        return $this;
    }

    /**
     * @return array
     */
    public function getCookies()
    {
        return $this->cookies;
    }

    /**
     * @param array $files
     * @return Request
     */
    public function setFiles(array $files)
    {
        $this->files = $files;

        return $this;
    }

    /**
     * @return array
     */
    public function getFiles()
    {
        return $this->files;
    }

    /**
     * @param array $get
     * @return Request
     */
    public function setGet(array $get)
    {
        $this->get = $get;

        return $this;
    }

    /**
     * @return array
     */
    public function getGet()
    {
        return $this->get;
    }

    /**
     * @param array $post
     * @return Request
     */
    public function setPost(array $post)
    {
        $this->post = $post;

        return $this;
    }

    /**
     * @return array
     */
    public function getPost()
    {
        return $this->post;
    }

    /**
     * @param array $server
     * @return Request
     */
    public function setServer(array $server)
    {
        $this->server = $server;

        return $this;
    }

    /**
     * @return array
     */
    public function getServer()
    {
        return $this->server;
    }

    /**
     * @param string $uri
     * @return Request
     */
    public function setUri($uri)
    {
        $this->uri = $uri;

        return $this;
    }

    /**
     * @return string
     */
    public function getUri()
    {
        return $this->uri;
    }

    /**
     * @return string
     */
    public function getHost()
    {
        return $this->host;
    }

    /**
     * @param string $host
     * @return Request
     */
    public function setHost($host)
    {
        $this->host = $host;

        return $this;
    }

    /**
     * @return string
     */
    public function getMethod()
    {
        return $this->method;
    }

    /**
     * @param string $method
     * @return Request
     */
    public function setMethod($method)
    {
        $this->method = $method;

        return $this;
    }

}
