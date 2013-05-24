<?php
/**
 * Session handler
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Http
 */

namespace Sovia\Http;

/**
 * Session handler
 */
class Session 
{
    /**
     * Constructor
     *
     * Start session if it's not started yet.
     */
    public function __construct()
    {
        if (!isset($_SESSION)) {
            session_start();
        }
    }

    /**
     * Get parameter from session
     *
     * @param string $parameter
     * @return mixed
     */
    public function get($parameter)
    {
        return isset($_SESSION[$parameter]) ? $_SESSION[$parameter] : null;
    }

    /**
     * Set session parameter
     *
     * @param string $parameter
     * @param mixed $value
     */
    public function set($parameter, $value)
    {
        $_SESSION[$parameter] = $value;
    }

    /**
     * Get session id
     *
     * @return string
     */
    public function getId()
    {
        return session_id();
    }
}
