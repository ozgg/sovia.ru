<?php
/**
 * HTTP client error: Gone
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Exceptions\Http\Client
 */

namespace Sovia\Exceptions\Http\Client;

use Sovia\Exceptions\Http;

/**
 * Gone
 */
class Gone extends Http
{
    /**
     * Header
     *
     * This will be sent in response to client
     *
     * @var string
     */
    protected $header = '410 Gone';
}
