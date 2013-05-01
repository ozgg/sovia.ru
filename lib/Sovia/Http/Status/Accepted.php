<?php
/**
 * HTTP status: 202 Accepted
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Http\Status
 */

namespace Sovia\Http\Status;

use Sovia\Http\Status;

/**
 * HTTP Accepted
 */
class Accepted extends Status
{
    /**
     * @var int
     */
    protected $code = 202;

    /**
     * @var string
     */
    protected $message = 'Accepted';
}
