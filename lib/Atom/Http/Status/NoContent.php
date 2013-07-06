<?php
/**
 * HTTP status: 204 No Content
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom\Http\Status
 */

namespace Atom\Http\Status;
 
use Atom\Http\Status;

/**
 * HTTP No Content
 */
class NoContent extends Status
{
    /**
     * @var int
     */
    protected $code = 204;

    /**
     * @var string
     */
    protected $message = 'No Content';
}
