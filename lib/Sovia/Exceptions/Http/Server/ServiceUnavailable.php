<?php
/**
 * HTTP server error: service unavailable
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Exceptions\Http\Server
 */

namespace Sovia\Exceptions\Http\Server;

use Sovia\Exceptions\Http;
use Sovia\Http\Status;

/**
 * Service unavailable
 */
class ServiceUnavailable extends Http
{
    /**
     * Get HTTP response status
     *
     * @return Status\ServiceUnavailable
     */
    final public function getStatus()
    {
        return new Status\ServiceUnavailable;
    }
}
