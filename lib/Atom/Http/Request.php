<?php
/**
 * HTTP-запрос
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom\Http
 */

namespace Atom\Http;

use Atom\Traits\GetElement;

/**
 * HTTP-запрос
 */
class Request
{
    use GetElement;

    /**
     * Query string parameters
     *
     * Normally it's contents of $_GET
     *
     * @var array
     */
    protected $get = [];

    /**
     * Post parameters
     *
     * Normally it's contents of $_POST
     *
     * @var array
     */
    protected $post = [];

    /**
     * Request body
     *
     * Normally it's taken from php://input
     *
     * @var string
     */
    protected $body = '';

    /**
     * Uploaded files
     *
     * Normally it's contents of $_FILES
     *
     * @var array
     */
    protected $files = [];

    /**
     * Client cookies
     *
     * Normally it's contents of $_COOKIE
     *
     * @var array
     */
    protected $cookies = [];

    /**
     * Server parameters
     *
     * Normally it's contents of $_SERVER
     *
     * @var array
     */
    protected $server = [];

    /**
     * Requested URI
     *
     * Normally it's taken from $server
     *
     * @var string
     */
    protected $uri = '';

    /**
     * HTTP host
     *
     * Normally it's taken from $server
     *
     * @var string
     */
    protected $host = '';

    /**
     * HTTP request method
     *
     * Normally it's taken from $server
     *
     * @var string
     */
    protected $method = '';

    /**
     * Constructor
     *
     * @param array $server
     */
    public function __construct(array $server)
    {
        $this->setServer($server);
    }

    /**
     * Get parameter from query or post data
     *
     * @param string $name
     * @param mixed  $default
     * @return mixed
     */
    public function getParameter($name, $default = null)
    {
        if (isset($this->get[$name])) {
            $value = $this->getElement($this->get, $name, $default);
        } elseif (isset($this->post[$name])) {
            $value = $this->getElement($this->post, $name, $default);
        } else {
            $value = $default;
        }

        return $value;
    }

    /**
     * Set request body
     *
     * @param string $body
     * @return Request
     */
    public function setBody($body)
    {
        $this->body = $body;

        return $this;
    }

    /**
     * Get request body
     *
     * @return string
     */
    public function getBody()
    {
        return $this->body;
    }

    /**
     * Set client cookies
     *
     * @param array $cookies
     * @return Request
     */
    public function setCookies(array $cookies)
    {
        $this->cookies = $cookies;

        return $this;
    }

    /**
     * Get raw client cookies data
     *
     * @return array
     */
    public function getCookies()
    {
        return $this->cookies;
    }

    /**
     * Get client cookie
     *
     * @param string $name
     * @param mixed  $default
     * @return mixed
     */
    public function getCookie($name, $default = null)
    {
        return $this->getElement($this->cookies, $name, $default);
    }

    /**
     * Set uploaded files
     *
     * @param array $files
     * @return Request
     */
    public function setFiles(array $files)
    {
        $this->files = $files;

        return $this;
    }

    /**
     * Get raw uploaded files data
     *
     * @return array
     */
    public function getFiles()
    {
        return $this->files;
    }

    /**
     * Get uploaded file
     *
     * @param string $name
     * @return null|UploadedFile
     */
    public function getFile($name)
    {
        if (isset($this->files[$name])) {
            $file = new UploadedFile($this->files[$name]);
        } else {
            $file = null;
        }

        return $file;
    }

    /**
     * Set query string parameters
     *
     * @param array $get
     * @return Request
     */
    public function setGet(array $get)
    {
        $this->get = $get;

        return $this;
    }

    /**
     * Get query string parameter(s)
     *
     * @param string $parameter
     * @param mixed  $default
     * @return mixed
     */
    public function getGet($parameter = '', $default = null)
    {
        if ($parameter != '') {
            $value = $this->getElement($this->get, $parameter, $default);
        } else {
            $value = $this->get;
        }

        return $value;
    }

    /**
     * Set post query data
     *
     * @param array $post
     * @return Request
     */
    public function setPost(array $post)
    {
        $this->post = $post;

        return $this;
    }

    /**
     * Get post parameter(s)
     *
     * @param string $parameter
     * @param mixed  $default
     * @return mixed
     */
    public function getPost($parameter = '', $default = null)
    {
        if ($parameter != '') {
            $value = $this->getElement($this->post, $parameter, $default);
        } else {
            $value = $this->post;
        }

        return $value;
    }

    /**
     * Set server parameters
     *
     * @param array $server
     * @return Request
     */
    public function setServer(array $server)
    {
        $this->server = $server;
        $this->setUri($this->getServer('REQUEST_URI'));
        $this->setHost($this->getServer('HTTP_HOST'));
        $this->setMethod($this->getServer('REQUEST_METHOD'));

        return $this;
    }

    /**
     * Get server parameter(s)
     *
     * @param string $parameter
     * @param string $default
     * @return string|array
     */
    public function getServer($parameter = '', $default = '')
    {
        if ($parameter != '') {
            $value = $this->getElement($this->server, $parameter, $default);
        } else {
            $value = $this->server;
        }

        return $value;
    }

    /**
     * Get request header
     *
     * @param $header
     * @return string|null
     */
    public function getHeader($header)
    {
        $parameter = 'HTTP_' . str_replace('-', '_', strtoupper($header));

        return $this->getElement($this->server, $parameter, null);
    }

    /**
     * Set request URI
     *
     * @param string $uri
     * @return Request
     */
    public function setUri($uri)
    {
        $this->uri = $uri;

        return $this;
    }

    /**
     * Get request URI
     *
     * @return string
     */
    public function getUri()
    {
        return $this->uri;
    }

    /**
     * Get HTTP host
     *
     * @return string
     */
    public function getHost()
    {
        return $this->host;
    }

    /**
     * Set HTTP host
     *
     * @param string $host
     * @return Request
     */
    public function setHost($host)
    {
        $this->host = $host;

        return $this;
    }

    /**
     * Ret request method
     *
     * @return string
     */
    public function getMethod()
    {
        return $this->method;
    }

    /**
     * Set request method
     *
     * @param string $method
     * @return Request
     */
    public function setMethod($method)
    {
        $this->method = $method;

        return $this;
    }
}
