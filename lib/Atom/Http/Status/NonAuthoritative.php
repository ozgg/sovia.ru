<?php
/**
 * HTTP status: 203 Non-Authoritative Infomation
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom\Http\Status
 */

namespace Atom\Http\Status;
 
use Atom\Http\Status;

/**
 * HTTP Non-Authoritative Information
 */
class NonAuthoritative extends Status
{
    /**
     * @var int
     */
    protected $code = 203;

    /**
     * @var string
     */
    protected $message = 'Non-Authoritative Information';
}
