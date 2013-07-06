<?php
/**
 * HTTP status: 429 Too Many Requests
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom\Http\Status
 */

namespace Atom\Http\Status;
 
use Atom\Http\Status;

/**
 * HTTP Too Many Requests
 */
class TooManyRequests extends Status
{
    /**
     * @var int
     */
    protected $code = 429;

    /**
     * @var string
     */
    protected $message = 'Too Many Requests';
}
