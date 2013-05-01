<?php
/**
 * HTTP client error: Method not allowed
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Exceptions\Http\Client
 */

namespace Sovia\Exceptions\Http\Client;

use Sovia\Exceptions\Http;
use Sovia\Http\Status;

/**
 * Method not allowed
 */
class MethodNotAllowed extends Http
{
    /**
     * Get HTTP response status
     *
     * @return Status\MethodNotAllowed
     */
    final public function getStatus()
    {
        return new Status\MethodNotAllowed;
    }
}
