<?php
/**
 * HTTP status: 405 Method Not Allowed
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom\Http\Status
 */

namespace Atom\Http\Status;
 
use Atom\Http\Status;

/**
 * HTTP Method Not Allowed
 */
class MethodNotAllowed extends Status
{
    /**
     * @var int
     */
    protected $code = 405;

    /**
     * @var string
     */
    protected $message = 'Method Not Allowed';
}
