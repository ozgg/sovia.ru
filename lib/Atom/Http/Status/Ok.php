<?php
/**
 * HTTP status: 200 OK
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom\Http\Status
 */

namespace Atom\Http\Status;
 
use Atom\Http\Status;

/**
 * HTTP Ok
 */
class Ok extends Status
{
    /**
     * @var int
     */
    protected $code = 200;

    /**
     * @var string
     */
    protected $message = 'OK';
}
