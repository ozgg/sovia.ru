<?php
/**
 * HTTP Exception
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Exceptions
 */

namespace Sovia\Exceptions;

/**
 * Abstract HTTP exception
 */
abstract class Http extends \Exception
{
    /**
     * Header
     *
     * This will be sent in response to client
     *
     * @var string
     */
    protected $header = '500 Internal Server Error';

    /**
     * Get header
     *
     * @return string
     */
    protected function getHeader()
    {
        return $this->header;
    }
}
