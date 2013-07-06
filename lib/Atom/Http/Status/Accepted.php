<?php
/**
 * HTTP status: 202 Accepted
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom\Http\Status
 */

namespace Atom\Http\Status;

use Atom\Http\Status;

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
