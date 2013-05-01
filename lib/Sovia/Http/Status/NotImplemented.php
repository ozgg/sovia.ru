<?php
/**
 * HTTP status: 501 Not Implemented
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Http\Status
 */

namespace Sovia\Http\Status;
 
use Sovia\Http\Status;

/**
 * HTTP Not Implemented
 */
class NotImplemented extends Status
{
    /**
     * @var int
     */
    protected $code = 501;

    /**
     * @var string
     */
    protected $message = 'Not Implemented';
}
