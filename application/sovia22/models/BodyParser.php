<?php
/**
 * Date: 30.08.11
 * Time: 2:31
 */
 
class BodyParser
{
    const OPTION_ESCAPE = 'escape';
    const OPTION_NO_CUT = 'no-cut';

    const PATTERN_RAW_OPEN  = '/^<raw>\s*$/i';
    const PATTERN_RAW_CLOSE = '/^<\/raw>\s*$/i';
    const PATTERN_CUT_OPEN  = '/<cut(?:\s+text="([^"]*)")?>/i';
    const PATTERN_CUT_CLOSE = '/^<\/cut>\s*$/i';

    /**
     * Начальный разбор текста записи на предпросмотр и основной текст.
     * 
     * @static
     * @param string $body
     * @param array $options
     * @return array
     */
    public static function parseEntry($body, array $options = array())
    {
        $out = array(
            'preview' => '',
            'body'    => '',
        );
        $cut     = false;
        $raw     = false;
        $escape  = !empty($options[self::OPTION_ESCAPE]);
        $useCut  = empty($options[self::OPTION_NO_CUT]);
        $counter = 0;

        foreach (explode("\n", $body) as $string) {
            $string = rtrim($string);
            if (!$escape && preg_match(self::PATTERN_RAW_OPEN, $string)) {
                $raw = true;
                continue;
            } elseif ($useCut && preg_match(self::PATTERN_CUT_OPEN, $string)) {
                $cut = true;
                $out['body'] .= '<div id="cut' . $counter++ . '">&nbsp;</div>';
                $out['preview'] .= "{$string}\n";
                continue;
            } elseif (preg_match(self::PATTERN_RAW_CLOSE, $string)) {
                $raw = false;
                continue;
            } elseif (preg_match(self::PATTERN_CUT_CLOSE, $string)) {
                $cut = false;
                continue;
            }
            if ($raw) {
                $buffer = $string;
            } else {
                $buffer = '<p>' . self::_processTags($string, $options) . '</p>';
            }
            $out['body'] .= "{$buffer}\n";
            if (!$cut) {
                $out['preview'] .= "{$buffer}\n";
            }
        }

        return $out;
    }

    public static function replaceCuts($body, $baseUrl)
    {
        $pattern  = self::PATTERN_CUT_OPEN;
        $callback = function($matches) use ($baseUrl)
        {
            static $counter = 0;
            $text   = isset($matches[1]) ? $matches[1] : 'Читать дальше';
            $format = '<p class="cut">( <a href="%s#cut%d" rel="bookmark">%s</a> )</p>';

            return sprintf($format, $baseUrl, $counter++, $text);
        };
        $out = preg_replace_callback($pattern, $callback, $body);

        return $out;
    }

    protected static function _processTags($string, array $options)
    {
        $out = $string;
        if (!empty($options[self::OPTION_ESCAPE])) {
            $out = htmlspecialchars($out, ENT_QUOTES, 'utf-8');
        }
        return $out;
    }

    protected static function _processCut($matches)
    {
        static $counter = 0;
        echo $counter++;
        print_r($matches);
    }

    public static function transliterateForUrl($text)
    {
        $text = mb_strtolower($text);
        $from = array(
            'а', 'б', 'в', 'г', 'д', 'е', 'ё', 'ж', 'з', 'и', 'й', 'к', 'л',
            'м', 'н', 'о', 'п', 'р', 'с', 'т', 'у', 'ф', 'х', 'ц', 'ч', 'ш',
            'щ', 'ъ', 'ы', 'ь', 'э', 'ю', 'я',
        );
        $into = array(
            'a', 'b', 'v', 'g', 'd', 'e', 'yo', 'zh', 'z', 'i', 'j', 'k', 'l',
            'm', 'n', 'o', 'p', 'r', 's', 't', 'u', 'f', 'kh', 'c', 'ch', 'sh',
            'shh', '-', 'y', '', 'e', 'yu', 'ya',
        );
        $text = str_replace($from, $into, $text);
        $text = preg_replace('/[^-a-z0-9.]/', '-', $text);
        return trim($text, '-.');
    }
}
