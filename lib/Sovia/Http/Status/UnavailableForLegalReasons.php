<?php
/**
 * HTTP status: 451 Unavailable For Legal Reasons
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Http\Status
 */

namespace Sovia\Http\Status;
 
use Sovia\Http\Status;

/**
 * HTTP Unavailable For Legal Reasons
 */
class UnavailableForLegalReasons extends Status
{
    /**
     * @var int
     */
    protected $code = 451;

    /**
     * @var string
     */
    protected $message = 'Unavailable For Legal Reasons';
}
