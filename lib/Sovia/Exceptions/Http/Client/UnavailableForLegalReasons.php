<?php
/**
 * HTTP client error: unavailable for legal reasons
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Exceptions\Http\Client
 */

namespace Sovia\Exceptions\Http\Client;
 
use Sovia\Exceptions\Http;

/**
 * Unavailable for legal reasons
 */
class UnavailableForLegalReasons extends Http
{
    /**
     * Header
     *
     * This will be sent in response to client
     *
     * @var string
     */
    protected $header = '451 Unavailable For Legal Reasons';
}
