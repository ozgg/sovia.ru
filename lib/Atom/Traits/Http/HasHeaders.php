<?php
/**
 * Примесь для работы с HTTP-заголовками
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom\Traits\Http
 */

namespace Atom\Traits\Http;

use Atom\Traits\GetElement;

/**
 * Объект работает с заголовками
 */
trait HasHeaders 
{
    use GetElement;

    /**
     * HTTP-заголовки
     *
     * @var array
     */
    protected $headers = [];

    /**
     * Задать заголовки
     *
     * @param array $headers
     * @return $this
     */
    public function setHeaders(array $headers)
    {
        $this->headers = $headers;

        return $this;
    }

    /**
     * Задать заголовок
     *
     * @param string $name
     * @param string $value
     */
    public function setHeader($name, $value)
    {
        $this->headers[$name] = trim($value);
    }

    /**
     * Получить заголовки
     *
     * @return array
     */
    public function getHeaders()
    {
        return $this->headers;
    }

    /**
     * Получить заголовок
     *
     * @param string $name
     * @return string|null
     */
    public function getHeader($name)
    {
        return $this->getElement($this->headers, $name, '');
    }

    /**
     * Добавить заголовки
     *
     * @param array $headers
     */
    public function addHeaders(array $headers)
    {
        foreach ($headers as $name => $value) {
            $this->setHeader($name, $value);
        }
    }
}
