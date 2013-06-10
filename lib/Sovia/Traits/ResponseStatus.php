<?php
/**
 * Trait for adding HTTP response status
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Traits
 */

namespace Sovia\Traits;

use Sovia\Http\Status;

/**
 * HTTP response status
 */
trait ResponseStatus
{
    /**
     * HTTP status to respond with
     *
     * @var Status
     */
    protected $status;

    /**
     * Get HTTP response status
     *
     * @return \Sovia\Http\Status
     */
    public function getStatus()
    {
        return $this->status;
    }

    /**
     * Set HTTP response status
     *
     * @param \Sovia\Http\Status $status
     * @return $this
     */
    public function setStatus(Status $status)
    {
        $this->status = $status;

        return $this;
    }
}
