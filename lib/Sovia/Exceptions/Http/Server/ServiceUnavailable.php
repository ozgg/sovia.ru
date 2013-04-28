<?php
/**
 * HTTP server error: service unavailable
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Exceptions\Http\Server
 */

namespace Sovia\Exceptions\Http\Server;

use Sovia\Exceptions\Http;

/**
 * Service unavailable
 */
class ServiceUnavailable extends Http
{
    /**
     * Header
     *
     * This will be sent in response to client
     *
     * @var string
     */
    protected $header = '503 Service Unavailable';
}
