<?php
/**
 * HTTP status: 404 Not Found
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Http\Status
 */

namespace Sovia\Http\Status;
 
use Sovia\Http\Status;

/**
 * HTTP Not Found
 */
class NotFound extends Status
{
    /**
     * @var int
     */
    protected $code = 404;

    /**
     * @var string
     */
    protected $message = 'Not Found';
}
