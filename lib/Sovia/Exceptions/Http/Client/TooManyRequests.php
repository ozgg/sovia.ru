<?php
/**
 * HTTP client error: too many requests
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Exceptions\Http\Client
 */

namespace Sovia\Exceptions\Http\Client;

use Sovia\Exceptions\Http;

/**
 * Too many requests
 */
class TooManyRequests extends Http
{
    /**
     * Header
     *
     * This will be sent in response to client
     *
     * @var string
     */
    protected $header = '429 Too Many Requests';
}
