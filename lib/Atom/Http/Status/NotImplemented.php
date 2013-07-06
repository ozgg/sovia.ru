<?php
/**
 * HTTP status: 501 Not Implemented
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom\Http\Status
 */

namespace Atom\Http\Status;
 
use Atom\Http\Status;

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
