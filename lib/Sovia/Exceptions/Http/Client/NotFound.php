<?php
/**
 * HTTP client error: not found
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Exceptions\Http\Client
 */

namespace Sovia\Exceptions\Http\Client;
 
use Sovia\Exceptions\Http;
use Sovia\Http\Status;

/**
 * Not Found
 */
class NotFound extends Http
{
    /**
     * Get HTTP response status
     *
     * @return Status\NotFound
     */
    final public function getStatus()
    {
        return new Status\NotFound;
    }
}
