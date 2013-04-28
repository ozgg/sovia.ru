<?php
/**
 * HTTP server error: internal server error
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Exceptions\Http\Server
 */

namespace Sovia\Exceptions\Http\Server;
 
use Sovia\Exceptions\Http;

/**
 * Internal server error
 */
class InternalServerError extends Http
{
    /**
     * Header
     *
     * This will be sent in response to client
     *
     * @var string
     */
    protected $header = '500 Internal Server Error';
}
