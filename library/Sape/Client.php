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
 * Класс для работы с обычными ссылками
 */
class Sape_Client extends Sape_Base
{
    var $_links_delimiter = '';
    var $_links = array();
    var $_links_page = array();
    var $_user_agent = 'SAPE_Client PHP';

    function SAPE_client($options = null) {
        parent::SAPE_base($options);
        $this->load_data();
    }

	/**
	 * Обработка html для массива ссылок
	 *
	 * @param string $html
	 * @return string
	 */
	function _return_array_links_html($html, $options = null) {

		if(empty($options)) {
			$options = array();
		}

		// если запрошена определенная кодировка, и известна кодировка кеша, и они разные, конвертируем в заданную
		if (
				strlen($this->_charset) > 0
				&&
				strlen($this->_sape_charset) > 0
				&&
				$this->_sape_charset != $this->_charset
				&&
				function_exists('iconv')
		) {
			$new_html = @iconv($this->_sape_charset, $this->_charset, $html);
			if ($new_html) {
				$html = $new_html;
			}
		}

		if ($this->_is_our_bot) {

			$html = '<sape_noindex>' . $html . '</sape_noindex>';

			if(isset($options['is_block_links']) && true == $options['is_block_links']) {

				if(!isset($options['nof_links_requested'])) {
					$options['nof_links_requested'] = 0;
				}
				if(!isset($options['nof_links_displayed'])) {
					$options['nof_links_displayed'] = 0;
				}
				if(!isset($options['nof_obligatory'])) {
					$options['nof_obligatory'] = 0;
				}
				if(!isset($options['nof_conditional'])) {
					$options['nof_conditional'] = 0;
				}

				$html = '<sape_block nof_req="' . $options['nof_links_requested'] .
							'" nof_displ="' . $options['nof_links_displayed'] .
							'" nof_oblig="' . $options['nof_obligatory'] .
							'" nof_cond="' . $options['nof_conditional'] .
							'">' . $html .
						'</sape_block>';
			}
		}

		return $html;
	}

	/**
	 * Финальная обработка html перед выводом ссылок
	 *
	 * @param string $html
	 * @return string
	 */
	function _return_html($html) {

		 if ($this->_debug) {
            $html .= print_r($this, true);
        }

		return $html;
	}

    /**
     * Вывод ссылок в виде блока
     *
     * @param int $n Количествово
     * @param int $offset Смещение
     * @param array $options Опции
	 *
	 * <code>
	 * $options = array();
	 * $options['block_no_css'] = (false|true);
	 * // Переопределяет запрет на вывод css в коде страницы: false - выводить css
	 * $options['block_orientation'] = (1|0);
	 * // Переопределяет ориентацию блока: 1 - горизонтальная, 0 - вертикальная
	 * $options['block_width'] = ('auto'|'[?]px'|'[?]%'|'[?]');
	 * // Переопределяет ширину блока:
	 * // 'auto'  - определяется шириной блока-предка с фиксированной шириной,
	 * // если такового нет, то займет всю ширину
	 * // '[?]px' - значение в пикселях
	 * // '[?]%'  - значение в процентах от ширины блока-предка с фиксированной шириной
	 * // '[?]'   - любое другое значение, которое поддерживается спецификацией CSS
	 * </code>
	 *
     * @return string
     */
    function return_block_links($n = null, $offset = 0, $options = null) {

		// Объединить параметры
		if(empty($options)) {
			$options = array();
		}

        $defaults = array();
        $defaults['block_no_css'] 		= false;
		$defaults['block_orientation'] 	= 1;
		$defaults['block_width'] 		= '';

		$ext_options = array();
		if(isset($this->_block_tpl_options) && is_array($this->_block_tpl_options)) {
			$ext_options = $this->_block_tpl_options;
		}

        $options = array_merge($defaults, $ext_options, $options);

		// Ссылки переданы не массивом (чек-код) => выводим как есть + инфо о блоке
		if (!is_array($this->_links_page)) {
			$html = $this->_return_array_links_html('', array('is_block_links' => true));
			return $this->_return_html($this->_links_page . $html);
		}
		// Не переданы шаблоны => нельзя вывести блоком - ничего не делать
		elseif(!isset($this->_block_tpl)) {
			return $this->_return_html('');
		}

		// Определим нужное число элементов в блоке

        $total_page_links = count($this->_links_page);

		$need_show_obligatory_block = false;
		$need_show_conditional_block = false;
		$n_requested = 0;

		if(isset($this->_block_ins_itemobligatory)) {
			$need_show_obligatory_block = true;
		}

		if(is_numeric($n) && $n >= $total_page_links) {

			$n_requested = $n;

			if(isset($this->_block_ins_itemconditional)) {
				$need_show_conditional_block = true;
			}
		}

		if (!is_numeric($n) || $n > $total_page_links) {
			$n = $total_page_links;
		}

		// Выборка ссылок
		$links = array();
		for ($i = 1; $i <= $n; $i++) {
			if ($offset > 0 && $i <= $offset) {
				array_shift($this->_links_page);
			} else {
				$links[] = array_shift($this->_links_page);
			}
		}

		$html = '';

		// Подсчет числа опциональных блоков
		$nof_conditional = 0;
		if(count($links) < $n_requested && true == $need_show_conditional_block) {
			$nof_conditional = $n_requested - count($links);
		}

		//Если нет ссылок и нет вставных блоков, то ничего не выводим
		if(empty($links) && $need_show_obligatory_block == false && $nof_conditional == 0) {

			$return_links_options = array(
				'is_block_links' 		=> true,
				'nof_links_requested' 	=> $n_requested,
				'nof_links_displayed'	=> 0,
				'nof_obligatory'		=> 0,
				'nof_conditional'		=> 0
			);

			$html = $this->_return_array_links_html($html, $return_links_options);

			return $this->_return_html($html);
		}

		// Делаем вывод стилей, только один раз. Или не выводим их вообще, если так задано в параметрах
		if (!$this->_is_block_css_showed && false == $options['block_no_css']) {
			$html .= $this->_block_tpl['css'];
			$this->_is_block_css_showed = true;
		}

		// Вставной блок в начале всех блоков
		if (isset($this->_block_ins_beforeall) && !$this->_is_block_ins_beforeall_showed){
			$html .= $this->_block_ins_beforeall;
			$this->_is_block_ins_beforeall_showed = true;
		}

		// Вставной блок в начале блока
		if (isset($this->_block_ins_beforeblock)){
			$html .= $this->_block_ins_beforeblock;
		}

		// Получаем шаблоны в зависимости от ориентации блока
		$block_tpl_parts = $this->_block_tpl[$options['block_orientation']];

		$block_tpl 			= $block_tpl_parts['block'];
		$item_tpl 			= $block_tpl_parts['item'];
		$item_container_tpl = $block_tpl_parts['item_container'];
		$item_tpl_full 		= str_replace('{item}', $item_tpl, $item_container_tpl);
		$items 				= '';

		$nof_items_total = count($links);
		foreach ($links as $link){

			preg_match('#<a href="(https?://([^"/]+)[^"]*)"[^>]*>[\s]*([^<]+)</a>#i', $link, $link_item);

			if (function_exists('mb_strtoupper') && strlen($this->_sape_charset) > 0) {
				$header_rest = mb_substr($link_item[3], 1, mb_strlen($link_item[3], $this->_sape_charset) - 1, $this->_sape_charset);
				$header_first_letter = mb_strtoupper(mb_substr($link_item[3], 0, 1, $this->_sape_charset), $this->_sape_charset);
				$link_item[3] = $header_first_letter . $header_rest;
			} elseif(function_exists('ucfirst') && (strlen($this->_sape_charset) == 0 || strpos($this->_sape_charset, '1251') !== false) ) {
				$link_item[3][0] = ucfirst($link_item[3][0]);
			}

			// Если есть раскодированный URL, то заменить его при выводе

			if(isset($this->_block_uri_idna) && isset($this->_block_uri_idna[$link_item[2]])) {
				$link_item[2] = $this->_block_uri_idna[$link_item[2]];
			}

			$item = $item_tpl_full;
			$item = str_replace('{header}', $link_item[3], $item);
			$item = str_replace('{text}', trim($link), $item);
			$item = str_replace('{url}', $link_item[2], $item);
			$item = str_replace('{link}', $link_item[1], $item);
			$items .= $item;
		}

		// Вставной обязатльный элемент в блоке
		if(true == $need_show_obligatory_block) {
			$items .= str_replace('{item}', $this->_block_ins_itemobligatory, $item_container_tpl);
			$nof_items_total += 1;
		}

		// Вставные опциональные элементы в блоке
		if($need_show_conditional_block == true && $nof_conditional > 0) {
			for($i = 0; $i < $nof_conditional; $i++) {
				$items .= str_replace('{item}', $this->_block_ins_itemconditional, $item_container_tpl);
			}
			$nof_items_total += $nof_conditional;
		}

		if ($items != ''){
			$html .= str_replace('{items}', $items, $block_tpl);

			// Проставляем ширину, чтобы везде одинковая была
			if ($nof_items_total > 0){
				$html = str_replace('{td_width}', round(100/$nof_items_total), $html);
			} else {
				$html = str_replace('{td_width}', 0, $html);
			}

			// Если задано, то переопределить ширину блока
			if(isset($options['block_width']) && !empty($options['block_width'])) {
				$html = str_replace('{block_style_custom}', 'style="width: ' . $options['block_width'] . '!important;"', $html);
			}
		}

		unset($block_tpl_parts, $block_tpl, $items, $item, $item_tpl, $item_container_tpl);

		// Вставной блок в конце блока
		if (isset($this->_block_ins_afterblock)){
			$html .= $this->_block_ins_afterblock;
		}

		//Заполняем оставшиеся модификаторы значениями
		unset($options['block_no_css'], $options['block_orientation'], $options['block_width']);

		$tpl_modifiers = array_keys($options);
		foreach($tpl_modifiers as $k=>$m) {
			$tpl_modifiers[$k] = '{' . $m . '}';
		}
		unset($m, $k);

		$tpl_modifiers_values =  array_values($options);

		$html = str_replace($tpl_modifiers, $tpl_modifiers_values, $html);
		unset($tpl_modifiers, $tpl_modifiers_values);

		//Очищаем незаполненные модификаторы
		$clear_modifiers_regexp = '#\{[a-z\d_\-]+\}#';
		$html = preg_replace($clear_modifiers_regexp, ' ', $html);

		$return_links_options = array(
			'is_block_links' 		=> true,
			'nof_links_requested' 	=> $n_requested,
			'nof_links_displayed'	=> $n,
			'nof_obligatory'		=> ($need_show_obligatory_block == true ? 1 : 0),
			'nof_conditional'		=> $nof_conditional
		);

		$html = $this->_return_array_links_html($html, $return_links_options);

		return $this->_return_html($html);
    }

    /**
     * Вывод ссылок в обычном виде - текст с разделителем
     *
     * @param int $n Количествово
     * @param int $offset Смещение
     * @param array $options Опции
	 *
	 * <code>
	 * $options = array();
	 * $options['as_block'] = (false|true);
	 * // Показывать ли ссылки в виде блока
	 * </code>
	 *
	 * @see return_block_links()
	 * @return string
	 */
    function return_links($n = null, $offset = 0, $options = null) {

		//Опрелелить, как выводить ссылки
		$as_block = $this->_show_only_block;

		if(is_array($options) && isset($options['as_block']) && false == $as_block) {
			$as_block = $options['as_block'];
		}

		if(true == $as_block && isset($this->_block_tpl)) {
			return $this->return_block_links($n, $offset, $options);
		}

		//-------

        if (is_array($this->_links_page)) {

            $total_page_links = count($this->_links_page);

            if (!is_numeric($n) || $n > $total_page_links) {
                $n = $total_page_links;
            }

            $links = array();

            for ($i = 1; $i <= $n; $i++) {
                if ($offset > 0 && $i <= $offset) {
                    array_shift($this->_links_page);
                } else {
                    $links[] = array_shift($this->_links_page);
                }
            }

            $html = join($this->_links_delimiter, $links);

            // если запрошена определенная кодировка, и известна кодировка кеша, и они разные, конвертируем в заданную
            if (
                    strlen($this->_charset) > 0
                    &&
                    strlen($this->_sape_charset) > 0
                    &&
                    $this->_sape_charset != $this->_charset
                    &&
                    function_exists('iconv')
            ) {
                $new_html = @iconv($this->_sape_charset, $this->_charset, $html);
                if ($new_html) {
                    $html = $new_html;
                }
            }

            if ($this->_is_our_bot) {
                $html = '<sape_noindex>' . $html . '</sape_noindex>';
            }
        } else {
            $html = $this->_links_page;
			if ($this->_is_our_bot) {
				$html .= '<sape_noindex></sape_noindex>';
			}
        }

        if ($this->_debug) {
            $html .= print_r($this, true);
        }

        return $html;
    }

    function _get_db_file() {
        if ($this->_multi_site) {
            return dirname(__FILE__) . '/' . $this->_host . '.links.db';
        } else {
            return dirname(__FILE__) . '/links.db';
        }
    }

    function _get_dispenser_path() {
        return '/code.php?user=' . _SAPE_USER . '&host=' . $this->_host;
    }

    function set_data($data) {
        if ($this->_ignore_case) {
            $this->_links = array_change_key_case($data);
        } else {
            $this->_links = $data;
        }
        if (isset($this->_links['__sape_delimiter__'])) {
            $this->_links_delimiter = $this->_links['__sape_delimiter__'];
        }
        // определяем кодировку кеша
        if (isset($this->_links['__sape_charset__'])) {
            $this->_sape_charset = $this->_links['__sape_charset__'];
        } else {
            $this->_sape_charset = '';
        }
        if (@array_key_exists($this->_request_uri, $this->_links) && is_array($this->_links[$this->_request_uri])) {
            $this->_links_page = $this->_links[$this->_request_uri];
        } else {
            if (isset($this->_links['__sape_new_url__']) && strlen($this->_links['__sape_new_url__'])) {
                if ($this->_is_our_bot || $this->_force_show_code) {
                    $this->_links_page = $this->_links['__sape_new_url__'];
                }
            }
        }

		// Есть ли флаг блочных ссылок
		if (isset($this->_links['__sape_show_only_block__'])) {
            $this->_show_only_block = $this->_links['__sape_show_only_block__'];
        }
		else {
			$this->_show_only_block = false;
		}

        // Есть ли шаблон для красивых ссылок
        if (isset($this->_links['__sape_block_tpl__']) && !empty($this->_links['__sape_block_tpl__'])
				&& is_array($this->_links['__sape_block_tpl__'])){
            $this->_block_tpl = $this->_links['__sape_block_tpl__'];
        }

		// Есть ли параметры для красивых ссылок
        if (isset($this->_links['__sape_block_tpl_options__']) && !empty($this->_links['__sape_block_tpl_options__'])
				&& is_array($this->_links['__sape_block_tpl_options__'])){
            $this->_block_tpl_options = $this->_links['__sape_block_tpl_options__'];
        }

		// IDNA-домены
		if (isset($this->_links['__sape_block_uri_idna__']) && !empty($this->_links['__sape_block_uri_idna__'])
				&& is_array($this->_links['__sape_block_uri_idna__'])){
            $this->_block_uri_idna = $this->_links['__sape_block_uri_idna__'];
        }

		// Блоки
		$check_blocks = array(
			'beforeall',
			'beforeblock',
			'afterblock',
			'itemobligatory',
			'itemconditional',
			'afterall'
		);

		foreach($check_blocks as $block_name) {

			$var_name = '__sape_block_ins_' . $block_name . '__';
			$prop_name = '_block_ins_' . $block_name;

			if (isset($this->_links[$var_name]) && strlen($this->_links[$var_name]) > 0) {
				$this->$prop_name = $this->_links[$var_name];
			}

		}
    }
}
