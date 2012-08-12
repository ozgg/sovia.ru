<?php
/**
 *
 *
 * Date: 12.08.12
 * Time: 14:36
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */
class Form_Posting_Dream extends Form_Posting
{
    public function init()
    {
        parent::init();
        $this->addTags();
        $this->addIsInternal();
        $this->addSubmit();
    }

    public function setEntry(Posting_Row $entry)
    {
        $this->getElement('title')->setValue($entry->getTitle());
        $this->getElement('body')->setValue($entry->getBody());
        $this->getElement('avatar_id')->setValue($entry->getAvatarId());
        $this->getElement('tags')->setValue($entry->getTagsAsText());
        $this->getElement('is_internal')->setValue($entry->getIsInternal());
    }
}
