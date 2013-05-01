<?php
/**
 * HTTP status: 503 Service Unavailable
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Http\Status
 */

namespace Sovia\Http\Status;
 
use Sovia\Http\Status;

/**
 * HTTP Service Unavailable
 */
class ServiceUnavailable extends Status
{
    /**
     * @var int
     */
    protected $code = 503;

    /**
     * @var string
     */
    protected $message = 'Service Unavailable';
}
