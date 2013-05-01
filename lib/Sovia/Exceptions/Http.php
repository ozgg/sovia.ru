<?php
/**
 * HTTP Exception
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Exceptions
 */

namespace Sovia\Exceptions;

use Sovia\Http\Status;

/**
 * Abstract HTTP exception
 */
abstract class Http extends \Exception
{
    /**
     * Get HTTP response status
     *
     * @return Status
     */
    abstract public function getStatus();
}
