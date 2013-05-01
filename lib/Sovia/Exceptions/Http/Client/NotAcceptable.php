<?php
/**
 * HTTP client error: Not acceptable
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Exceptions\Http\Client
 */

namespace Sovia\Exceptions\Http\Client;

use Sovia\Exceptions\Http;
use Sovia\Http\Status;

/**
 * Not acceptable
 */
class NotAcceptable extends Http
{
    /**
     * Get HTTP response status
     *
     * @return Status\NotAcceptable
     */
    final public function getStatus()
    {
        return new Status\NotAcceptable;
    }
}
