<?php
/**
 * HTTP status: 410 Gone
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom\Http\Status
 */

namespace Atom\Http\Status;
 
use Atom\Http\Status;

/**
 * HTTP Gone
 */
class Gone extends Status
{
    /**
     * @var int
     */
    protected $code = 410;

    /**
     * @var string
     */
    protected $message = 'Gone';
}
