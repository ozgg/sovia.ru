<?php
/**
 * Примесь для получения элементов массива с приведением типа
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom\Traits
 */

namespace Atom\Traits;

/**
 * Получение элементов массива с приведением типа
 */
trait GetElement 
{
    /**
     * Получить значение из произвольного хранилища с приведением типа
     *
     * @param array  $storage
     * @param string $name
     * @param mixed  $default
     * @return mixed|null
     */
    public function getElement(array $storage, $name, $default = null)
    {
        if (isset($storage[$name])) {
            $value = $storage[$name];
            if (is_int($default)) {
                settype($value, 'int');
            } elseif (is_float($default)) {
                settype($value, 'float');
            } elseif (is_string($default)) {
                settype($value, 'string');
            } elseif (is_bool($default)) {
                settype($value, 'bool');
            } elseif (is_array($default)) {
                settype($value, 'array');
            }
        } else {
            $value = $default;
        }

        return $value;
    }
}
