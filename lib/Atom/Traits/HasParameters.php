<?php
/**
 * Примесь: у объекта есть параметры
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom\Traits
 */

namespace Atom\Traits;

/**
 * У объекта есть параметры
 */
trait HasParameters
{
    use GetElement;

    /**
     * Параметры
     *
     * @var array
     */
    protected $parameters = [];

    /**
     * Получить параметры
     *
     * @return array
     */
    public function getParameters()
    {
        return $this->parameters;
    }

    /**
     * Задать параметры
     *
     * @param array $parameters
     * @return $this
     */
    public function setParameters(array $parameters)
    {
        $this->parameters = $parameters;

        return $this;
    }

    /**
     * Получить параметр верхнего уровня с приведением к типу
     *
     * @param string $name
     * @param mixed  $default
     * @return mixed|null
     */
    public function getParameter($name, $default = null)
    {
        if (strpos($name, '.') !== false) {
            $parts   = explode('.', $name);
            $storage = $this->parameters;
            $value   = $default;
            $part    = null;
            while (!empty($parts)) {
                $part = array_shift($parts);
                if (array_key_exists($part, $storage)) {
                    if (is_array($storage[$part])) {
                        $storage = $storage[$part];
                    } else {
                        break;
                    }
                } else {
                    $part = null;
                    break;
                }
            }
            if (!is_null($part) && empty($parts)) {
                $value = $this->getElement($storage, $part);
            }
        } else {
            $value = $this->getElement($this->parameters, $name, $default);
        }

        return $value;
    }

    /**
     * Задать параметр верхнего уровня
     *
     * @param string $name
     * @param mixed  $value
     * @throws \ErrorException
     * @return $this
     */
    public function setParameter($name, $value)
    {
        if (strpos($name, '.') !== false) {
            $parts   = explode('.', $name);
            $storage = &$this->parameters;
            $part    = null;
            while (!empty($parts)) {
                $part = array_shift($parts);
                if (!array_key_exists($part, $storage)) {
                    $storage[$part] = [];
                }
                if (is_array($storage[$part])) {
                    $storage = &$storage[$part];
                } else {
                    throw new \ErrorException("Cannot set part {$part}");
                }
            }
            if (!is_null($part)) {
                $storage = $value;
            }
        } else {
            $this->parameters[$name] = $value;
        }

        return $this;
    }
}
