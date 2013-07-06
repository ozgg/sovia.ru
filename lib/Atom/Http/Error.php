<?php
/**
 * Абстрактная ошибка при работе с HTTP
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom\Http
 */

namespace Atom\Http;
 
use Atom\Traits\HasHeaders;

/**
 * Абстрактная ошибка при работе с HTTP
 */
abstract class Error extends \ErrorException
{
    use HasHeaders;

    /**
     * Get HTTP response status
     *
     * @return Status
     */
    abstract public function getStatus();
}
