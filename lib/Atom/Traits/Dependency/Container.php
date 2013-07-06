<?php
/**
 * 
 * 
 * Date: 27.06.13
 * Time: 15:01
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom\Traits\Dependency
 */

namespace Atom\Traits\Dependency;

trait Container 
{
    /**
     * Container
     *
     * @var \Atom\Container
     */
    protected $dependencyContainer;

    /**
     * Get container
     *
     * @return \Atom\Container
     */
    public function getDependencyContainer()
    {
        return $this->dependencyContainer;
    }

    /**
     * Set container
     *
     * @param \Atom\Container $dependencyContainer
     * @return Container
     */
    public function setDependencyContainer(\Atom\Container $dependencyContainer)
    {
        $this->dependencyContainer = $dependencyContainer;

        return $this;
    }

    /**
     * Inject dependency into container
     *
     * @param string $name
     * @param mixed $element
     */
    protected function injectDependency($name, $element)
    {
        $this->checkContainerState();
        $this->dependencyContainer->inject($name, $element);
    }

    /**
     * Extract dependency from container
     *
     * @param string $name
     * @return mixed|null
     */
    protected function extractDependency($name)
    {
        $this->checkContainerState();

        return $this->dependencyContainer->extract($name);
    }

    /**
     * Check if container is set
     *
     * @throws \ErrorException
     */
    protected function checkContainerState()
    {
        if (!$this->dependencyContainer instanceof \Atom\Container) {
            throw new \ErrorException('Container is not set');
        }
    }

    /**
     * Require dependencies to be injected
     *
     * @throws \ErrorException
     */
    protected function requireDependencies()
    {
        $this->checkContainerState();

        $injected    = $this->dependencyContainer->getKeys();
        $notInjected = [];
        foreach (func_get_args() as $argument) {
            if (is_array($argument)) {
                call_user_func_array(__METHOD__, $argument);
            } else {
                if (!in_array($argument, $injected)) {
                    $notInjected[] = $argument;
                }
            }
        }

        if (!empty($notInjected)) {
            $error = 'Required dependencies are not injected: '
                . implode(', ', $notInjected);
            throw new \ErrorException($error);
        }
    }
}
