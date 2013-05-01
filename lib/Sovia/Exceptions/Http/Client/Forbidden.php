<?php
/**
 * HTTP client error: Forbidden
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Exceptions\Http\Client
 */

namespace Sovia\Exceptions\Http\Client;

use Sovia\Exceptions\Http;
use Sovia\Http\Status;

/**
 * Forbidden
 */
class Forbidden extends Http
{
    /**
     * Get HTTP response status
     *
     * @return Status\Forbidden
     */
    final public function getStatus()
    {
        return new Status\Forbidden;
    }
}
