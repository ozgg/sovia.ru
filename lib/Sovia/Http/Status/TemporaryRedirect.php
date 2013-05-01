<?php
/**
 * HTTP status: 307 Temporary Redirect
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Http\Status
 */

namespace Sovia\Http\Status;
 
use Sovia\Http\Status;

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
