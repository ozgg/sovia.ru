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

    const TAG_DREAM   = 'dream';
    const TAG_SYMBOL  = 'symbol';
    const TAG_ARTICLE = 'article';
    const TAG_POST    = 'post';
    const TAG_ENTRY   = 'entry';
    const TAG_ENTITY  = 'entity';

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
        $lines   = 0;

        foreach (explode("\n", $body) as $string) {
            $string = rtrim($string);
            if ($escape && !mb_strlen($string)) {
                continue;
            }
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
                if (!$escape || ($lines < 2)) {
                    $out['preview'] .= "{$buffer}\n";
                }
                if ($escape && ($lines == 3)) {
                    $out['preview'] .= '<cut text="Дальше">';
                }
                $lines++;
            }
        }

        return $out;
    }

    public static function replaceCuts($body, $baseUrl)
    {
        $pattern  = self::PATTERN_CUT_OPEN;
        $callback = function($matches) use ($baseUrl) {
            static $counter = 0;
            $text   = isset($matches[1]) ? $matches[1] : 'Читать дальше';
            $format = '<p class="cut">( <a href="%s#cut%d" rel="bookmark">%s</a> )</p>';

            return sprintf($format, $baseUrl, $counter++, $text);
        };
        $out = preg_replace_callback($pattern, $callback, $body);

        return $out;
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

    public static function getLink($tag, $attributes)
    {
        $helper  = new Zend_View_Helper_Url();
        $options = array();
        preg_match_all('/([a-z]+)="([^"]*)"/', $attributes, $matches);
        if (!empty($matches[1])) {
            foreach ($matches[1] as $index => $attribute) {
                $options[$attribute] = $matches[2][$index];
            }
        }
        $name   = '-';
        $table  = new Posting;
        $mapper = $table->getMapper();
        $mapper->type($tag);
        if ($tag == self::TAG_SYMBOL) {
            if (isset($options['name'])) {
                $mapper->title($options['name']);
                $name = $options['name'];
                /** @var $entry Posting_Row */
                $entry = $mapper->fetchRow();
            }
        } else {
            if (isset($options['id'])) {
                $mapper->id($options['id']);
                /** @var $entry Posting_Row */
                $entry = $mapper->fetchRow();
                if (!empty($entry)) {
                    if (isset($options['title'])) {
                        $name = $options['title'];
                    } else {
                        $name = $entry->getTitle();
                    }
                }
            }
        }
        if (!empty($entry) && !$entry->isPrivate()) {
            $href = $helper->url(
                $entry->getRouteParameters(), $entry->getRouteName()
            );
            $name = htmlspecialchars($name, ENT_QUOTES, 'utf-8');
            $link = '<a href="' . $href . '">' . $name . '</a>';
        } else {
            $link = "{$tag}:{$attributes}";
        }

        return $link;
    }

    protected static function _processTags($string, array $options)
    {
        $search  = array(
            self::TAG_ARTICLE, self::TAG_DREAM, self::TAG_ENTITY,
            self::TAG_ENTRY, self::TAG_POST, self::TAG_SYMBOL,
        );
        $pattern = '/<(' . implode('|', $search) . ')([^>]*)>/';
        $string  = preg_replace($pattern, '[$1$2]', $string);

        $out = $string;
        if (!empty($options[self::OPTION_ESCAPE])) {
            $out = htmlspecialchars($out, ENT_NOQUOTES, 'utf-8');
        }

        $pattern  = '/\[(' . implode('|', $search) . ')([^]]*)\]/';
        $callback = function($matches) {
            return BodyParser::getLink($matches[1], $matches[2]);
        };

        return preg_replace_callback($pattern, $callback, $out);
    }
}
