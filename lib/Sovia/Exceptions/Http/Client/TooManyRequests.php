<?php
/**
 * HTTP client error: too many requests
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Exceptions\Http\Client
 */

namespace Sovia\Exceptions\Http\Client;

use Sovia\Exceptions\Http;
use Sovia\Http\Status;

/**
 * Too many requests
 */
class TooManyRequests extends Http
{
    /**
     * Get HTTP response status
     *
     * @return Status\TooManyRequests
     */
    final public function getStatus()
    {
        return new Status\TooManyRequests;
    }
}
