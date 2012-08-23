<?php
/**
 * Date: 14.01.12
 * Time: 13:47
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */

/**
 * Метка записи
 */
class Posting_Tag extends Ext_Db_Table_Abstract
{
    /**
     * Название таблицы
     *
     * @var string
     */
    protected $_name = 'posting_tag';

    /**
     * Преобразователь для конкретизации выборки
     *
     * @var Posting_Tag_Mapper
     */
    protected $_mapper;

    /**
     * Класс для представления записи
     *
     * @var string
     * @see Posting_Tag_Row
     */
    protected $_rowClass = 'Posting_Tag_Row';

    protected $_referenceMap = array(
        'Posting' => array(
            'columns'       => 'post_id',
            'refTableClass' => 'Posting',
            'refColumns'    => 'id',
        ),
    );

    /**
     * Получить преобразователь
     *
     * @return Posting_Tag_Mapper
     */
    public function getMapper()
    {
        if (is_null($this->_mapper)) {
            $this->_mapper = new Posting_Tag_Mapper($this);
        }

        return $this->_mapper;
    }

    /**
     * @param Posting_Row $post
     * @param $tagName
     * @return null|Posting_Tag_Row
     */
    public function getTagForPost(Posting_Row $post, $tagName)
    {
        $select = $this->select();
        $select->where('name = ?', $tagName)
               ->where('type_id = ?', $post->getType()->getId());

        return $select->fetchRow();
    }
}
