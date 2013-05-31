<?php
/**
 * 
 * 
 * Date: 31.05.13
 * Time: 17:31
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */

namespace Sovia\Traits\Dependency;
 
use Sovia\Http;
use Sovia\Route;

trait LoadingContainer
{
    use Container;

    /**
     * Get request
     *
     * @return Http\Request
     */
    protected function getRequest()
    {
        $request = $this->extractDependency('request');

        if (!$request instanceof Http\Request) {
            $request = new Http\Request($_SERVER);
            $request->setGet($_GET);
            $request->setPost($_POST);
            $request->setFiles($_FILES);
            $request->setCookies($_COOKIE);
            $request->setBody(file_get_contents('php://input'));

            $this->injectDependency('request', $request);
        }

        return $request;
    }

    /**
     * Get session
     *
     * @return Http\Session
     */
    protected function getSession()
    {
        $session = $this->extractDependency('session');

        if (!$session instanceof Http\Session) {
            $session = new Http\Session;

            $this->injectDependency('session', $session);
        }

        return $session;
    }

    /**
     * Get used route
     *
     * @return Route
     * @throws \ErrorException
     */
    protected function getRoute()
    {
        $route = $this->extractDependency('route');

        if (!$route instanceof Route) {
            throw new \ErrorException('Route is not injected');
        }

        return $route;
    }
}
