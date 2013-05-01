<?php
/**
 * HTTP status: 410 Gone
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Http\Status
 */

namespace Sovia\Http\Status;
 
use Sovia\Http\Status;

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
