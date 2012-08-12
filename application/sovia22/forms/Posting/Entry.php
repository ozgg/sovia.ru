<?php
/**
 *
 *
 * Date: 13.08.12
 * Time: 0:56
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */
class Form_Posting_Entry extends Form_Posting
{
    public function init()
    {
        parent::init();
        $this->addIsInternal(false);
        $this->addSubmit();
    }

    public function setEntry(Posting_Row $entry)
    {
        $this->getElement('title')->setValue($entry->getTitle());
        $this->getElement('body')->setValue($entry->getBody());
        $this->getElement('avatar_id')->setValue($entry->getAvatarId());
        $this->getElement('is_internal')->setValue($entry->getIsInternal());
    }
}
