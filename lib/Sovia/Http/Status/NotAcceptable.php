<?php
/**
 * HTTP status: 406 Not Acceptable
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Http\Status
 */

namespace Sovia\Http\Status;
 
use Sovia\Http\Status;

/**
 * HTTP Not Acceptable
 */
class NotAcceptable extends Status
{
    /**
     * @var int
     */
    protected $code = 406;

    /**
     * @var string
     */
    protected $message = 'Not Acceptable';
}
