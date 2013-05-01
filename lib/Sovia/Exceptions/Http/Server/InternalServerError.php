<?php
/**
 * HTTP server error: internal server error
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Exceptions\Http\Server
 */

namespace Sovia\Exceptions\Http\Server;
 
use Sovia\Exceptions\Http;
use Sovia\Http\Status;

/**
 * Internal server error
 */
class InternalServerError extends Http
{
    /**
     * Get HTTP response status
     *
     * @return Status\InternalServerError
     */
    final public function getStatus()
    {
        return new Status\InternalServerError;
    }
}
