<?php
/**
 * HTTP status: 200 OK
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Http\Status
 */

namespace Sovia\Http\Status;
 
use Sovia\Http\Status;

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
