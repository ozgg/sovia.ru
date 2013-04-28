<?php
/**
 * HTTP client error: payment required
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Exceptions\Http\Client
 */

namespace Sovia\Exceptions\Http\Client;
 
use Sovia\Exceptions\Http;

/**
 * Payment required
 */
class PaymentRequired extends Http
{
    /**
     * Header
     *
     * This will be sent in response to client
     *
     * @var string
     */
    protected $header = '402 Payment Required';
}
