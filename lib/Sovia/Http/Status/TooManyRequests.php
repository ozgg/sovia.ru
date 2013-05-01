<?php
/**
 * HTTP status: 429 Too Many Requests
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Http\Status
 */

namespace Sovia\Http\Status;
 
use Sovia\Http\Status;

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
