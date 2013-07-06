<?php
/**
 * Ошибка 404
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom\Http\Error
 */

namespace Atom\Http\Error;

use Atom\Http\Error;
use Atom\Http\Status\NotFound as Status;

/**
 * Ошибка 404
 */
class NotFound extends Error
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
