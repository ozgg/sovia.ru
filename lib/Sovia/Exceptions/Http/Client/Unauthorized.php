<?php
/**
 * HTTP client error: unauthorized
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Exceptions\Http\Client
 */

namespace Sovia\Exceptions\Http\Client;

use Sovia\Exceptions\Http;
use Sovia\Http\Status;

/**
 * Unauthorized
 */
class Unauthorized extends Http
{
    /**
     * Get HTTP response status
     *
     * @return Status\Unauthorized
     */
    final public function getStatus()
    {
        return new Status\Unauthorized;
    }
}
