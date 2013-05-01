<?php
/**
 * HTTP client error: Gone
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Exceptions\Http\Client
 */

namespace Sovia\Exceptions\Http\Client;

use Sovia\Exceptions\Http;
use Sovia\Http\Status;

/**
 * Gone
 */
class Gone extends Http
{
    /**
     * Get HTTP response status
     *
     * @return Status\Gone
     */
    final public function getStatus()
    {
        return new Status\Gone;
    }
}
