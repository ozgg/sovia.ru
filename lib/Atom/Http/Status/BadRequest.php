<?php
/**
 * HTTP status: 400 Bad request
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom\Http\Status
 */

namespace Atom\Http\Status;
 
use Atom\Http\Status;

/**
 * HTTP Bad Request
 */
class BadRequest extends Status
{
    /**
     * @var int
     */
    protected $code = 400;

    /**
     * @var string
     */
    protected $message = 'Bad Request';
}
