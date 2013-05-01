<?php
/**
 * HTTP client error: Bad Request
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Exceptions\Http\Client
 */

namespace Sovia\Exceptions\Http\Client;

use Sovia\Exceptions\Http;
use Sovia\Http\Status;

/**
 * Bad request
 */
class BadRequest extends Http
{
    /**
     * Get HTTP response status
     *
     * @return Status\BadRequest
     */
    final public function getStatus()
    {
        return new Status\BadRequest;
    }
}
