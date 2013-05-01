<?php
/**
 * HTTP status: 301 Moved Permanently
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Http\Status
 */

namespace Sovia\Http\Status;
 
use Sovia\Http\Status;

/**
 * HTTP Moved Permanently
 *
 */
class MovedPermanently extends Status
{
    /**
     * @var int
     */
    protected $code = 301;

    /**
     * @var string
     */
    protected $message = 'Moved Permanently';
}
