<?php
/**
 * Ошибка 405
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom\Http\Error
 */

namespace Atom\Http\Error;
 
use Atom\Http\Error;
use Atom\Http\Status\MethodNotAllowed as Status;

/**
 * Ошибка 405
 */
class MethodNotAllowed extends Error
{
    /**
     * Get HTTP response status
     *
     * @return Status
     */
    final public function getStatus()
    {
        return new Status;
    }
}
