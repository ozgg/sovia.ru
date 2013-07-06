<?php
/**
 * Конфигурация
 *
 * Отвечает за хранение конфигурации как приложения в целом, так и отдельных
 * компонентов.
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom
 */

namespace Atom;
 
use Atom\Traits\HasParameters;

/**
 * Конфигурация
 */
class Configuration
{
    use HasParameters;

    /**
     * Среда
     *
     * @var string
     */
    private $environment;

    /**
     * Базовая директория
     *
     * Путь к файлам с конфигурацией.
     *
     * @var string
     */
    private $baseDirectory;

    /**
     * @param string $baseDirectory
     */
    public function __construct($baseDirectory)
    {
        $this->setBaseDirectory($baseDirectory);
    }

    /**
     * Слить массивы с конфигурацией
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
     * Получить среду
     *
     * @return string
     */
    public function getEnvironment()
    {
        return $this->environment;
    }

    /**
     * Задать среду
     *
     * @param string $environment
     * @return Configuration
     */
    public function setEnvironment($environment)
    {
        $this->environment = str_replace('../', '', $environment);
        $this->initialize();

        return $this;
    }

    /**
     * Получить базовую директорию
     *
     * @return string
     */
    public function getBaseDirectory()
    {
        return $this->baseDirectory;
    }

    /**
     * Задать базовую директорию
     *
     * @param string $baseDirectory
     * @return Configuration
     */
    public function setBaseDirectory($baseDirectory)
    {
        $this->baseDirectory = realpath($baseDirectory);

        return $this;
    }

    /**
     * Проинициализировать конфигурацию
     *
     * Загружает файл с параметрами, соответствующий указанной среде
     *
     * @throws \ErrorException
     */
    private function initialize()
    {
        $file = $this->getBaseDirectory()
            . DIRECTORY_SEPARATOR
            . $this->getEnvironment() . '.php';

        if (file_exists($file) && is_file($file)) {
            $this->setParameters(include($file));
        } else {
            throw new \ErrorException("Cannot load config file {$file}");
        }
    }
}
