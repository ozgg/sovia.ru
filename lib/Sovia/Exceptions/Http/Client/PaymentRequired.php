<?php
/**
 * HTTP client error: payment required
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Exceptions\Http\Client
 */

namespace Sovia\Exceptions\Http\Client;
 
use Sovia\Exceptions\Http;
use Sovia\Http\Status;

/**
 * Payment required
 */
class PaymentRequired extends Http
{
    /**
     * Get HTTP response status
     *
     * @return Status\PaymentRequired
     */
    final public function getStatus()
    {
        return new Status\PaymentRequired;
    }
}
