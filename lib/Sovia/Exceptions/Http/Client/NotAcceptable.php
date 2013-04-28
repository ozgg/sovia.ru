<?php
/**
 * HTTP client error: Not acceptable
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Exceptions\Http\Client
 */

namespace Sovia\Exceptions\Http\Client;

use Sovia\Exceptions\Http;

/**
 * Not acceptable
 */
class NotAcceptable extends Http
{
    /**
     * Header
     *
     * This will be sent in response to client
     *
     * @var string
     */
    protected $header = '406 Not Acceptable';
}
