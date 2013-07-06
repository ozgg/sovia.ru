<?php
/**
 * HTTP response status
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom\Http
 */

namespace Atom\Http;

/**
 * Abstract HTTP response status
 */
abstract class Status
{
    /**
     * HTTP status code
     *
     * @var int
     */
    protected $code;

    /**
     * Message
     *
     * @var string
     */
    protected $message;

    /**
     * Constructor
     *
     * @param string $message override default message
     */
    public function __construct($message = '')
    {
        if ($message != '') {
            $this->setMessage($message);
        }
    }

    /**
     * Get string to send as header (without protocol version)
     *
     * @return string
     */
    public function __toString()
    {
        return "{$this->code} {$this->message}";
    }

    /**
     * Get code
     *
     * @return int
     */
    public function getCode()
    {
        return $this->code;
    }

    /**
     * Get message
     *
     * @return string
     */
    public function getMessage()
    {
        return $this->message;
    }

    /**
     * Set message
     *
     * @param string $message
     * @return Status
     */
    public function setMessage($message)
    {
        $this->message = $message;

        return $this;
    }
}
