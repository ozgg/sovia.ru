<?php
/**
 * Trait for DI container
 * 
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Sovia\Traits
 */

namespace Sovia\Traits;

use Sovia\Container;

/**
 * Trait for dependency container
 */
trait DependencyContainer
{
    /**
     * Container
     *
     * @var Container
     */
    protected $dependencyContainer;

    /**
     * Get container
     *
     * @return \Sovia\Container
     */
    public function getDependencyContainer()
    {
        return $this->dependencyContainer;
    }

    /**
     * Set container
     *
     * @param \Sovia\Container $dependencyContainer
     * @return DependencyContainer
     */
    public function setDependencyContainer(Container $dependencyContainer)
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
     * @throws \Exception
     */
    protected function checkContainerState()
    {
        if (!$this->dependencyContainer instanceof Container) {
            throw new \Exception('Container is not set');
        }
    }
}
