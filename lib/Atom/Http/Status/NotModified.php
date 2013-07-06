<?php
/**
 * HTTP status: 304 Not Modified
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom\Http\Status
 */

namespace Atom\Http\Status;
 
use Atom\Http\Status;

/**
 * HTTP Not Modified
 */
class NotModified extends Status
{
    /**
     * @var int
     */
    protected $code = 304;

    /**
     * @var string
     */
    protected $message = 'Not Modified';
}
