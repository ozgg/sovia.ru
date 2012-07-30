<?php
/**
 * SAPE.ru - Интеллектуальная система купли-продажи ссылок
 *
 * PHP-клиент
 *
 * Вебмастеры! Не нужно ничего менять в этом файле!
 * Все настройки - через параметры при вызове кода.
 * Читайте: http://help.sape.ru/
 *
 * По всем вопросам обращайтесь на support@sape.ru
 *
 * class SAPE_base 				- базовый класс
 * class SAPE_client 			- класс для вывода обычных ссылок
 * class SAPE_client_context 	- класс для вывода контекстных сссылок
 * class SAPE_articles 			- класс для вывода статей
 *
 * @version 1.1.6 от 27.01.2012
 */

/**
 * Класс для работы со статьями articles.sape.ru показывает анонсы и статьи
 */
class Sape_Articles extends Sape_Base
{

    var $_request_mode;

    var $_server_list             = array('dispenser.articles.sape.ru');

    var $_data                    = array();

    var $_article_id;

    var $_save_file_name;

    var $_announcements_delimiter = '';

    var $_images_path;

    var $_template_error = false;

    var $_noindex_code = '<!--sape_noindex-->';

    var $_headers_enabled = false;

    var $_mask_code;

    var $_real_host;
    
    var $_user_agent = 'SAPE_Articles_Client PHP';

    function SAPE_articles($options = null){
        parent::SAPE_base($options);
        if (is_array($options) && isset($options['headers_enabled'])) {
            $this->_headers_enabled = $options['headers_enabled'];
        }
        // Кодировка
        if (isset($options['charset']) && strlen($options['charset'])) {
            $this->_charset = $options['charset'];
        } else {
            $this->_charset = '';
        }
        $this->_get_index();
        if (!empty($this->_data['index']['announcements_delimiter'])) {
            $this->_announcements_delimiter = $this->_data['index']['announcements_delimiter'];
        }
        if (!empty($this->_data['index']['charset'])
            and !(isset($options['charset']) && strlen($options['charset']))) {
            $this->_charset = $this->_data['index']['charset'];
        }
        if (is_array($options)) {
            if (isset($options['host'])) {
                $host = $options['host'];
            }
        } elseif (strlen($options)) {
            $host = $options;
            $options = array();
        }
        if (isset($host) && strlen($host)) {
             $this->_real_host = $host;
        } else {
             $this->_real_host = $_SERVER['HTTP_HOST'];
        }
        if (!isset($this->_data['index']['announcements'][$this->_request_uri])) {
            $this->_correct_uri();
        }
    }

    function _correct_uri() {
        if(substr($this->_request_uri, -1) == '/') {
            $new_uri = substr($this->_request_uri, 0, -1);
        } else {
            $new_uri = $this->_request_uri . '/';
        }
        if (isset($this->_data['index']['announcements'][$new_uri])) {
            $this->_request_uri = $new_uri;
        }
    }

    /**
     * Возвращает анонсы для вывода
     * @param int $n      Сколько анонсов вывести, либо не задано - вывести все
     * @param int $offset C какого анонса начинаем вывод(нумерация с 0), либо не задано - с нулевого
     * @return string
     */
    function return_announcements($n = null, $offset = 0){
        $output = '';
        if ($this->_force_show_code || $this->_is_our_bot) {
            if (isset($this->_data['index']['checkCode'])) {
                $output .= $this->_data['index']['checkCode'];
            }
        }

        if (isset($this->_data['index']['announcements'][$this->_request_uri])) {

            $total_page_links = count($this->_data['index']['announcements'][$this->_request_uri]);

            if (!is_numeric($n) || $n > $total_page_links) {
                $n = $total_page_links;
            }

            $links = array();

            for ($i = 1; $i <= $n; $i++) {
                if ($offset > 0 && $i <= $offset) {
                    array_shift($this->_data['index']['announcements'][$this->_request_uri]);
                } else {
                    $links[] = array_shift($this->_data['index']['announcements'][$this->_request_uri]);
                }
            }

            $html = join($this->_announcements_delimiter, $links);

            if ($this->_is_our_bot) {
                $html = '<sape_noindex>' . $html . '</sape_noindex>';
            }

            $output .= $html;

        }

        return $output;
    }

    function _get_index(){
        $this->_set_request_mode('index');
        $this->_save_file_name = 'articles.db';
        $this->load_data();
    }

    /**
     * Возвращает полный HTML код страницы статьи
     * @return string
     */
    function process_request(){

        if (!empty($this->_data['index']) and isset($this->_data['index']['articles'][$this->_request_uri])) {
			return $this->_return_article();
        } elseif (!empty($this->_data['index']) and isset($this->_data['index']['images'][$this->_request_uri])) {
            return $this->_return_image();
          } else {
                if ($this->_is_our_bot) {
                    return $this->_return_html($this->_data['index']['checkCode'] . $this->_noindex_code);
                } else {
                    return $this->_return_not_found();
                }
          }
    }

    function _return_article(){
        $this->_set_request_mode('article');
        //Загружаем статью
        $article_meta = $this->_data['index']['articles'][$this->_request_uri];
        $this->_save_file_name = $article_meta['id'] . '.article.db';
        $this->_article_id = $article_meta['id'];
        $this->load_data();

        //Обновим если устарела
        if (!isset($this->_data['article']['date_updated']) OR $this->_data['article']['date_updated']  < $article_meta['date_updated']) {
            unlink($this->_get_db_file());
            $this->load_data();
        }

        //Получим шаблон
        $template = $this->_get_template($this->_data['index']['templates'][$article_meta['template_id']]['url'], $article_meta['template_id']);

        //Выведем статью
        $article_html = $this->_fetch_article($template);

        if ($this->_is_our_bot) {
            $article_html .= $this->_noindex_code;
        }

        return $this->_return_html($article_html);

    }

    function _prepare_path_to_images(){
        $this->_images_path = dirname(__FILE__) . '/images/';
        if (!is_dir($this->_images_path)) {
            // Пытаемся создать папку.
            if (@mkdir($this->_images_path)) {
                @chmod($this->_images_path, 0777);    // Права доступа
            } else {
                return $this->raise_error('Нет папки ' . $this->_images_path . '. Создать не удалось. Выставите права 777 на папку.');
              }
        }
        if ($this->_multi_site) {
            $this->_images_path .= $this->_host. '.';
        }        
    }

    function _return_image(){
        $this->_set_request_mode('image');
        $this->_prepare_path_to_images();

        //Проверим загружена ли картинка
        $image_meta = $this->_data['index']['images'][$this->_request_uri];
        $image_path = $this->_images_path . $image_meta['id']. '.' . $image_meta['ext'];

        if (!is_file($image_path) or filemtime($image_path) > $image_meta['date_updated']) {
            // Чтобы не повесить площадку клиента и чтобы не было одновременных запросов
            @touch($image_path, $image_meta['date_updated']);

            $path = $image_meta['dispenser_path'];

            foreach ($this->_server_list as $i => $server){
                if ($data = $this->fetch_remote_file($server, $path)) {
                    if (substr($data, 0, 12) == 'FATAL ERROR:') {
                        $this->raise_error($data);
                    } else {
                        // [псевдо]проверка целостности:
                        if (strlen($data) > 0) {
                            $this->_write($image_path, $data);
                            break;
                        }
                    }
                }
            }
        }

        unset($data);
        if (!is_file($image_path)) {
            return $this->_return_not_found();
        }
        $image_file_meta = @getimagesize($image_path);
        $content_type = isset($image_file_meta['mime'])?$image_file_meta['mime']:'image';
        if ($this->_headers_enabled) {
            header('Content-Type: ' . $content_type);
        }
        return $this->_read($image_path);
    }

    function _fetch_article($template){
        if (strlen($this->_charset)) {
            $template = str_replace('{meta_charset}',  $this->_charset, $template);
        }
        foreach ($this->_data['index']['template_fields'] as $field){
            if (isset($this->_data['article'][$field])) {
                $template = str_replace('{' . $field . '}',  $this->_data['article'][$field], $template);
            } else {
                $template = str_replace('{' . $field . '}',  '', $template);
            }
        }
        return ($template);
    }

    function _get_template($template_url, $templateId){
        //Загрузим индекс если есть
        $this->_save_file_name = 'tpl.articles.db';
        $index_file = $this->_get_db_file();

        if (file_exists($index_file)) {
            $this->_data['templates'] = unserialize($this->_read($index_file));
        }


        //Если шаблон не найден или устарел в индексе, обновим его
        if (!isset($this->_data['templates'][$template_url])
            or (time() - $this->_data['templates'][$template_url]['date_updated']) > $this->_data['index']['templates'][$templateId]['lifetime']) {
            $this->_refresh_template($template_url, $index_file);
        }
        //Если шаблон не обнаружен - ошибка
        if (!isset($this->_data['templates'][$template_url])) {
            if ($this->_template_error){
                return $this->raise_error($this->_template_error);
            }
            return $this->raise_error('Не найден шаблон для статьи');
        }

        return $this->_data['templates'][$template_url]['body'];
    }

    function _refresh_template($template_url, $index_file){
        $parseUrl = parse_url($template_url);

        $download_url = '';
        if ($parseUrl['path']) {
            $download_url .= $parseUrl['path'];
        }
        if (isset($parseUrl['query'])) {
            $download_url .= '?' . $parseUrl['query'];
        }

        $template_body = $this->fetch_remote_file($this->_real_host, $download_url, true);

        //проверим его на корректность
        if (!$this->_is_valid_template($template_body)){
            return false;
        }

        $template_body = $this->_cut_template_links($template_body);

        //Запишем его вместе с другими в кэш
        $this->_data['templates'][$template_url] = array( 'body' => $template_body, 'date_updated' => time());
        //И сохраним кэш
        $this->_write($index_file, serialize($this->_data['templates']));
    }

    function _fill_mask ($data) {
        global $unnecessary;
        $len = strlen($data[0]);
        $mask = str_repeat($this->_mask_code, $len);
        $unnecessary[$this->_mask_code][] = array(
            'mask' => $mask,
            'code' => $data[0],
            'len'  => $len
        );

        return $mask;
    }

    function _cut_unnecessary(&$contents, $code, $mask) {
        global $unnecessary;
        $this->_mask_code = $code;
        $_unnecessary[$this->_mask_code] = array();
        $contents = preg_replace_callback($mask, array($this, '_fill_mask'), $contents);
    }

    function _restore_unnecessary(&$contents, $code) {
        global $unnecessary;
        $offset = 0;
        if (!empty($unnecessary[$code])) {
            foreach ($unnecessary[$code] as $meta) {
                $offset = strpos($contents, $meta['mask'], $offset);
                $contents = substr($contents, 0, $offset)
                    . $meta['code'] . substr($contents, $offset + $meta['len']);
            }
        }
    }

    function _cut_template_links($template_body){
        $link_pattern    = '~(\<a [^\>]*?href[^\>]*?\=["\']{0,1}http[^\>]*?\>.*?\</a[^\>]*?\>|\<a [^\>]*?href[^\>]*?\=["\']{0,1}http[^\>]*?\>|\<area [^\>]*?href[^\>]*?\=["\']{0,1}http[^\>]*?\>)~si';
        $link_subpattern = '~\<a |\<area ~si';
        $rel_pattern     = '~[\s]{1}rel\=["\']{1}[^ "\'\>]*?["\']{1}| rel\=[^ "\'\>]*?[\s]{1}~si';
        $href_pattern    = '~[\s]{1}href\=["\']{0,1}(http[^ "\'\>]*)?["\']{0,1} {0,1}~si';

        $allowed_domains = $this->_data['index']['ext_links_allowed'];
        $allowed_domains[] = $this -> _host;
        $allowed_domains[] = 'www.' . $this -> _host;
        $this->_cut_unnecessary($template_body, 'C', '|<!--(.*?)-->|smi');
        $this->_cut_unnecessary($template_body, 'S', '|<script[^>]*>.*?</script>|si');
        $this->_cut_unnecessary($template_body, 'N', '|<noindex[^>]*>.*?</noindex>|si');

        $slices = preg_split($link_pattern, $template_body, -1,  PREG_SPLIT_DELIM_CAPTURE );
        //Обрамляем все видимые ссылки в noindex
        if(is_array($slices)) {
            foreach ($slices as $id => $link) {
                if ($id % 2 == 0) {
                    continue;
                }
                if (preg_match($href_pattern, $link, $urls)) {
                    $parsed_url = @parse_url($urls[1]);
                    $host = isset($parsed_url['host'])?$parsed_url['host']:false;
                    if (!in_array($host, $allowed_domains) || !$host){
                        //Обрамляем в тэги noindex
                        $slices[$id] = '<noindex>' . $slices[$id] . '</noindex>';
                    }
                }
            }
            $template_body = implode('', $slices);
        }
        //Вновь отображаем содержимое внутри noindex
        $this->_restore_unnecessary($template_body, 'N');

        //Прописываем всем ссылкам nofollow
        $slices = preg_split($link_pattern, $template_body, -1,  PREG_SPLIT_DELIM_CAPTURE );
        if(is_array($slices)) {
            foreach ($slices as $id => $link) {
                if ($id % 2 == 0) {
                    continue;
                }
                if (preg_match($href_pattern, $link, $urls)) {
                    $parsed_url = @parse_url($urls[1]);
                    $host = isset($parsed_url['host'])?$parsed_url['host']:false;
                    if (!in_array($host, $allowed_domains) || !$host) {
                        //вырезаем REL
                        $slices[$id] = preg_replace($rel_pattern, '', $link);
                        //Добавляем rel=nofollow
                        $slices[$id] = preg_replace($link_subpattern, '$0rel="nofollow" ', $slices[$id]);
                    }
                }
            }
            $template_body = implode('', $slices);
        }

        $this->_restore_unnecessary($template_body, 'S');
        $this->_restore_unnecessary($template_body, 'C');
        return $template_body;
    }

    function _is_valid_template($template_body){
        foreach ($this->_data['index']['template_required_fields'] as $field){
            if (strpos($template_body, '{' . $field . '}') === false){
                $this->_template_error = 'В шаблоне не хватает поля ' . $field . '.';
                return false;
            }
        }
        return true;
    }

    function _return_html($html){
        if ($this->_headers_enabled){
            header('HTTP/1.x 200 OK');
            if (!empty($this->_charset)){
                    header('Content-Type: text/html; charset=' . $this->_charset);
            }
        }
        return $html;
    }

    function _return_not_found(){
        header('HTTP/1.x 404 Not Found');
    }

    function _get_dispenser_path(){
        switch ($this->_request_mode){
            case 'index':
                return '/?user=' . _SAPE_USER . '&host=' .
                $this->_host . '&rtype=' . $this->_request_mode;
            break;
            case 'article':
                return '/?user=' . _SAPE_USER . '&host=' .
                $this->_host . '&rtype=' . $this->_request_mode . '&artid=' . $this->_article_id;
            break;
            case 'image':
                return $this->image_url;
            break;
        }
    }

    function _set_request_mode($mode){
        $this->_request_mode = $mode;
    }

    function _get_db_file(){
        if ($this->_multi_site){
            return dirname(__FILE__) . '/' . $this->_host . '.' . $this->_save_file_name;
        }
        else{
            return dirname(__FILE__) . '/' . $this->_save_file_name;
        }
    }

    function set_data($data){
       $this->_data[$this->_request_mode] = $data;
    }

}

?>