<?php
/**
 * HTTP status: 205 Reset Content
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom\Http\Status
 */

namespace Atom\Http\Status;
 
use Atom\Http\Status;

/**
 * HTTP Reset Content
 */
class ResetContent extends Status
{
    /**
     * @var int
     */
    protected $code = 205;

    /**
     * @var string
     */
    protected $message = 'Reset Content';
}
