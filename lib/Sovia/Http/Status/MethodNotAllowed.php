<?php
/**
 * HTTP status: 405 Method Not Allowed
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Http\Status
 */

namespace Sovia\Http\Status;
 
use Sovia\Http\Status;

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
