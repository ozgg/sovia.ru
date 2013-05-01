<?php
/**
 * HTTP server error: not implemented
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Exceptions\Http\Server
 */

namespace Sovia\Exceptions\Http\Server;

use Sovia\Exceptions\Http;
use Sovia\Http\Status;

/**
 * Not implemented
 */
class NotImplemented extends Http
{
    /**
     * Get HTTP response status
     *
     * @return Status\NotImplemented
     */
    final public function getStatus()
    {
        return new Status\NotImplemented;
    }
}
