<?php
/**
 * HTTP client error: unavailable for legal reasons
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Exceptions\Http\Client
 */

namespace Sovia\Exceptions\Http\Client;
 
use Sovia\Exceptions\Http;
use Sovia\Http\Status;

/**
 * Unavailable for legal reasons
 */
class UnavailableForLegalReasons extends Http
{
    /**
     * Get HTTP response status
     *
     * @return Status\UnavailableForLegalReasons
     */
    final public function getStatus()
    {
        return new Status\UnavailableForLegalReasons;
    }
}
