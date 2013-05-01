<?php
/**
 * HTTP status: 201 Created
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Http\Status
 */

namespace Sovia\Http\Status;
 
use Sovia\Http\Status;

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
