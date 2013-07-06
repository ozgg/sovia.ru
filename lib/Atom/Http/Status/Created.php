<?php
/**
 * HTTP status: 201 Created
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom\Http\Status
 */

namespace Atom\Http\Status;
 
use Atom\Http\Status;

/**
 * HTTP Created
 */
class Created extends Status
{
    /**
     * @var int
     */
    protected $code = 201;

    /**
     * @var string
     */
    protected $message = 'Created';
}
