<?php
/**
 * HTTP status: 300 Multiple Choices
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Http\Status
 */

namespace Sovia\Http\Status;
 
use Sovia\Http\Status;

/**
 * HTTP Multiple Choices
 */
class MultipleChoices extends Status
{
    /**
     * @var int
     */
    protected $code = 300;

    /**
     * @var string
     */
    protected $message = 'Multiple Choices';
}
