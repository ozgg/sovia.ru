<?php
/**
 * 
 * 
 * Date: 07.07.13
 * Time: 12:32
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom\Renderer
 */

namespace Atom\Renderer;
 
use Atom\Renderer;

class Html extends Renderer
{
    /**
     * @throws \RuntimeException
     * @return string
     */
    public function render()
    {
        $templatePath = $this->getBaseDirectory()
            . '/layouts/'
            . $this->getLayoutName()
            . '.html';

        if (!is_file($templatePath)) {
            throw new \RuntimeException("Cannot find template {$templatePath}");
        }

        return $this->parseTemplate($templatePath);
    }

    /**
     * @return string
     */
    public function getContentType()
    {
        return 'text/html;charset=UTF-8';
    }

    protected function parseTemplate($path)
    {
        $content  = file_get_contents($path);
        $pattern  = '/\{\{ ([^\}]+) \}\}/';

        return preg_replace_callback($pattern, [$this, 'parseBlock'], $content);
    }

    protected function parseBlock($block)
    {
        if (isset($block[1])) {
            $command = trim($block[1]);
            $pattern = '/([a-z]+):([a-z]+)(\s+.+)?/';
            preg_match($pattern, $command, $data);

            if (isset($data[1], $data[2])) {
                $arguments = isset($data[3]) ? trim($data[3]) : '';
                $result    = $this->callHelper($data[1], $data[2], $arguments);
            } else {
                $result = "Invalid helper call: {$command}";
            }
        } else {
            $result = 'Invalid block';
        }

        return $result;
    }

    protected function callHelper($helperName, $methodName, $arguments)
    {
        return "{$helperName}::{$methodName}({$arguments})";
    }
}
