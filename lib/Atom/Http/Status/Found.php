<?php
/**
 * HTTP status: 302 Found
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom\Http\Status
 */

namespace Atom\Http\Status;
 
use Atom\Http\Status;

/**
 * HTTP Found
 */
class Found extends Status
{
    /**
     * @var int
     */
    protected $code = 302;

    /**
     * @var string
     */
    protected $message = 'Found';
}
