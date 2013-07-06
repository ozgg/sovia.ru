<?php
/**
 * HTTP status: 500 Internal Server Error
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom\Http\Status
 */

namespace Atom\Http\Status;
 
use Atom\Http\Status;

/**
 * HTTP Internal Server Error
 */
class InternalServerError extends Status
{
    /**
     * @var int
     */
    protected $code = 500;

    /**
     * @var string
     */
    protected $message = 'Internal Server Error';
}
