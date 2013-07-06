<?php
/**
 * HTTP status: 308 Permanent Redirect
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom\Http\Status
 */

namespace Atom\Http\Status;
 
use Atom\Http\Status;

/**
 * HTTP Permanent Redirect
 *
 */
class PermanentRedirect extends Status
{
    /**
     * @var int
     */
    protected $code = 308;

    /**
     * @var string
     */
    protected $message = 'Permanent Redirect';
}
