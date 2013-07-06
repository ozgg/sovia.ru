<?php
/**
 * HTTP status: 503 Service Unavailable
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom\Http\Status
 */

namespace Atom\Http\Status;
 
use Atom\Http\Status;

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
