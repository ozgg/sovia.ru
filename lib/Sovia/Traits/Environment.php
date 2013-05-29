<?php
/**
 * Environment trait
 *
 * If added, object works with environment
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Traits
 */

namespace Sovia\Traits;

/**
 * Environment trait
 */
trait Environment 
{
    /**
     * Current environment
     *
     * @var string
     */
    protected $environment;

    /**
     * Set current environment
     *
     * @param string $environment
     * @return $this
     */
    public function setEnvironment($environment)
    {
        $this->environment = (string) $environment;

        return $this;
    }

    /**
     * Get current environment
     *
     * @return string
     */
    public function getEnvironment()
    {
        return $this->environment;
    }

    /**
     * It is development
     *
     * @return bool
     */
    public function isDevelopment()
    {
        return $this->environment == 'development';
    }

    /**
     * It is production
     *
     * @return bool
     */
    public function isProduction()
    {
        return $this->environment == 'production';
    }

    /**
     * It is test
     *
     * @return bool
     */
    public function isTest()
    {
        return $this->environment == 'test';
    }
}
