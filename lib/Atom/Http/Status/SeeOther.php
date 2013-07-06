<?php
/**
 * HTTP status: 303 See Other
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom\Http\Status
 */

namespace Atom\Http\Status;
 
use Atom\Http\Status;

/**
 * HTTP See Other
 */
class SeeOther extends Status
{
    /**
     * @var int
     */
    protected $code = 303;

    /**
     * @var string
     */
    protected $message = 'See Other';
}
