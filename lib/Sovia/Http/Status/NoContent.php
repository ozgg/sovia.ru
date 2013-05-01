<?php
/**
 * HTTP status: 204 No Content
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Http\Status
 */

namespace Sovia\Http\Status;
 
use Sovia\Http\Status;

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
