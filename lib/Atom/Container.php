<?php
/**
 * 
 * 
 * Date: 27.06.13
 * Time: 14:58
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom
 */

namespace Atom;
 
class Container 
{
    /**
     * Storage of injected elements
     *
     * @var array
     */
    protected $storage = [];

    /**
     * Inject element
     *
     * @param string $name
     * @param mixed $element
     */
    public function inject($name, $element)
    {
        $this->storage[$name] = $element;
    }

    /**
     * Extract element from storage
     *
     * @param string $name
     * @return mixed|null
     */
    public function extract($name)
    {
        if (isset($this->storage[$name])) {
            $element = $this->storage[$name];
        } else {
            $element = null;
        }

        return $element;
    }

    /**
     * Remove element from storage
     *
     * @param string $name
     */
    public function remove($name)
    {
        if (isset($this->storage[$name])) {
            unset($this->storage[$name]);
        }
    }

    /**
     * Check if element exists in storage
     *
     * @param string $name
     * @return bool
     */
    public function check($name)
    {
        return isset($this->storage[$name]);
    }

    /**
     * Get available keys
     *
     * @return array
     */
    public function getKeys()
    {
        return array_keys($this->storage);
    }
}
