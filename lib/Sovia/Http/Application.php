<?php
/**
 * HTTP application
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Http
 */

namespace Sovia\Http;

/**
 * HTTP application
 */
class Application 
{
    /**
     * Application directory
     *
     * @var string
     */
    protected $directory;

    /**
     * Constructor
     *
     * Sets application directory and bootstraps it
     *
     * @param string $directory
     */
    public function __construct($directory)
    {
        $this->setDirectory($directory);
        $this->bootstrap();
    }

    public function bootstrap()
    {
        $request = new Request($_SERVER);
        $request->setGet($_GET);
        $request->setPost($_POST);
        $request->setFiles($_FILES);
        $request->setCookies($_COOKIE);
        $request->setBody(file_get_contents('php://input'));
    }

    public function run()
    {

    }

    /**
     * Get application directory
     *
     * @return string
     */
    public function getDirectory()
    {
        return $this->directory;
    }

    /**
     * Set application directory
     *
     * @param string $directory
     * @return $this
     * @throws \Exception
     */
    public function setDirectory($directory)
    {
        if (!is_dir($directory)) {
            throw new \Exception("Directory {$directory} does not exist");
        }
        $this->directory = $directory;

        return $this;
    }
}
