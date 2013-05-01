<?php
/**
 * HTTP status: 409 Conflict
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Http\Status
 */

namespace Sovia\Http\Status;
 
use Sovia\Http\Status;

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
