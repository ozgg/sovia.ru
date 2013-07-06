<?php
/**
 * HTTP status: 409 Conflict
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom\Http\Status
 */

namespace Atom\Http\Status;
 
use Atom\Http\Status;

/**
 * HTTP Conflict
 */
class Conflict extends Status
{
    /**
     * @var int
     */
    protected $code = 409;

    /**
     * @var string
     */
    protected $message = 'Conflict';
}
