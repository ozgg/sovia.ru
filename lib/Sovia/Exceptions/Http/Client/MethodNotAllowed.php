<?php
/**
 * HTTP client error: Method not allowed
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Exceptions\Http\Client
 */

namespace Sovia\Exceptions\Http\Client;

use Sovia\Exceptions\Http;

/**
 * Method not allowed
 */
class MethodNotAllowed extends Http
{
    /**
     * Header
     *
     * This will be sent in response to client
     *
     * @var string
     */
    protected $header = '405 Method Not Allowed';
}
