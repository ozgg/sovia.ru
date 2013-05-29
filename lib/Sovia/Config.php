<?php
/**
 * Configuration handler
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia
 */

namespace Sovia;

/**
 * Configuration handler
 */
class Config 
{
    /**
     * Container
     *
     * @var array
     */
    protected $container = [];

    /**
     * Base directory with environment configuration files
     *
     * @var string
     */
    protected $baseDir;

    /**
     * Constructor
     *
     * @param string $baseDirectory
     */
    public function __construct($baseDirectory)
    {
        $this->baseDir = realpath($baseDirectory);
    }

    /**
     * Merge configuration arrays
     *
     * @param array $left
     * @param array $right
     * @return array
     */
    public static function merge(array $left, array $right)
    {
        foreach ($right as $key => $value) {
            if (array_key_exists($key, $left) && is_array($value)) {
                $left[$key] = self::merge($left[$key], $right[$key]);
            } else {
                $left[$key] = $value;
            }
        }

        return $left;
    }

    /**
     * Load environment configuration
     *
     * @param string $environment
     * @return array
     * @throws \Exception
     */
    public function load($environment)
    {
        $file = $this->baseDir . DIRECTORY_SEPARATOR . "{$environment}.php";
        if (file_exists($file) && is_file($file)) {
            $config = include $file;
        } else {
            $error = "Cannot load {$environment} config from {$file}";
            throw new \Exception($error);
        }

        $localFile = $this->baseDir . DIRECTORY_SEPARATOR . 'local.php';
        if (file_exists($localFile) && is_file($localFile)) {
            $local = include $localFile;
        } else {
            $local = [];
        }

        $this->container = static::merge($local, $config);
    }

    /**
     * Get top-level parameter
     *
     * @param string $parameter
     * @return mixed
     */
    public function get($parameter)
    {
        if (isset($this->container[$parameter])) {
            $value = $this->container[$parameter];
        } else {
            $value = null;
        }

        return $value;
    }

    /**
     * Set top-level parameter
     *
     * @param string $parameter
     * @param mixed $value
     */
    public function set($parameter, $value)
    {
        $this->container[$parameter] = $value;
    }
}
