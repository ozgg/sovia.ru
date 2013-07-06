<?php
/**
 * HTTP status: 406 Not Acceptable
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom\Http\Status
 */

namespace Atom\Http\Status;
 
use Atom\Http\Status;

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
