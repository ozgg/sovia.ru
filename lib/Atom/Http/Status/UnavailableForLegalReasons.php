<?php
/**
 * HTTP status: 451 Unavailable For Legal Reasons
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom\Http\Status
 */

namespace Atom\Http\Status;
 
use Atom\Http\Status;

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
