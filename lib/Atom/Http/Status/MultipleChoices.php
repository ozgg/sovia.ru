<?php
/**
 * HTTP status: 300 Multiple Choices
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom\Http\Status
 */

namespace Atom\Http\Status;
 
use Atom\Http\Status;

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
