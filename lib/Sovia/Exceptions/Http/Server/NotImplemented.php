<?php
/**
 * HTTP server error: not implemented
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Exceptions\Http\Server
 */

namespace Sovia\Exceptions\Http\Server;

use Sovia\Exceptions\Http;

/**
 * Not implemented
 */
class NotImplemented extends Http
{
    /**
     * Header
     *
     * This will be sent in response to client
     *
     * @var string
     */
    protected $header = '501 Not Implemented';
}
