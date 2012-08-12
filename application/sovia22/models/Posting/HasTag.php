<?php
/**
 *
 *
 * Date: 12.08.12
 * Time: 14:54
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */
class Posting_HasTag extends Ext_Db_Table_Abstract
{
    /**
     * Название таблицы
     *
     * @var string
     */
    protected $_name = 'posting_has_tag';

    protected $_referenceMap = array(
        'Posting' => array(
            'columns'       => 'posting_id',
            'refTableClass' => 'Posting',
            'refColumns'    => 'id',
        ),
        'Tag' => array(
            'columns'       => 'tag_id',
            'refTableClass' => 'Posting_Tag',
            'refColumns'    => 'id',
        ),
    );

}
