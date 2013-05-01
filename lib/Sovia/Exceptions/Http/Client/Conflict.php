<?php
/**
 * HTTP client error: Conflict
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Exceptions\Http\Client
 */

namespace Sovia\Exceptions\Http\Client;

use Sovia\Exceptions\Http;
use Sovia\Http\Status;

/**
 * Conflict
 */
class Conflict extends Http
{
    /**
     * Get HTTP response status
     *
     * @return Status\Conflict
     */
    final public function getStatus()
    {
        return new Status\Conflict;
    }
}
