<?php
/**
 * 
 * 
 * Date: 07.07.13
 * Time: 12:25
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom
 */

namespace Atom;
 
use Atom\Traits\HasParameters;

abstract class Renderer
{
    use HasParameters;

    /**
     * Render as JSON
     */
    const TYPE_JSON = 'json';

    /**
     * Render as HTML
     */
    const TYPE_HTML = 'html';

    protected $layoutName;

    protected $baseDirectory;

    /**
     * @return string
     */
    abstract public function render();

    public static function factory($type)
    {
        switch ($type) {
            case static::TYPE_JSON:
                $renderer = new Renderer\Json;
                break;
            case static::TYPE_HTML:
                $renderer = new Renderer\Html;
                break;
            default:
                $error = "Invalid renderer type {$type}";
                throw new \InvalidArgumentException($error);
        }

        return $renderer;
    }
}
