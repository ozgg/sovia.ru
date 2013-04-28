<?php
/**
 * HTTP client error: not found
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Exceptions\Http\Client
 */

namespace Sovia\Exceptions\Http\Client;
 
use Sovia\Exceptions\Http;

/**
 * Not Found
 */
class NotFound extends Http
{
    /**
     * Header
     *
     * This will be sent in response to client
     *
     * @var string
     */
    protected $header = '404 Not Found';
}
