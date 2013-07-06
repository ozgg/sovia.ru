<?php
/**
 * HTTP status: 307 Temporary Redirect
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom\Http\Status
 */

namespace Atom\Http\Status;
 
use Atom\Http\Status;

/**
 * HTTP Temporary Redirect
 */
class TemporaryRedirect extends Status
{
    /**
     * @var int
     */
    protected $code = 307;

    /**
     * @var string
     */
    protected $message = 'Temporary Redirect';
}
