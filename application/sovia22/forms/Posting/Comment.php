<?php
/**
 *
 *
 * Date: 27.07.12
 * Time: 0:58
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */
class Form_Posting_Comment extends Zend_Form
{
    public function init()
    {
        $comment = new Zend_Form_Element_Hidden(
            array(
                'name' => 'comment_id',
            )
        );
        $this->addElement($comment);

        $posting = new Zend_Form_Element_Hidden(
            array(
                'name' => 'posting_id',
            )
        );
        $this->addElement($posting);

        $avatar = new Zend_Form_Element_Select(
            array(
                'name'  => 'avatar_id',
                'label' => 'Аватар',
            )
        );
        $avatar->addMultiOption('0', 'Не выбран');
        $this->addElement($avatar);

        $body = new Zend_Form_Element_Textarea(
            array(
                'name' => 'body',
                'label' => 'Текст',
                'cols' => 80,
                'rows' => 25,
            )
        );
        $body->setRequired();
        $this->addElement($body);
        unset($body);

        $submit = new Zend_Form_Element_Submit(
            array(
                'name' => 'submit',
                'label' => 'Готово',
            )
        );
        $this->addElement($submit);
        unset($submit);
    }

    public function setUser(User_Interface $user)
    {
        $avatars = $user->getAvatars();
        /** @var $element Zend_Form_Element_Select */
        $element = $this->getElement('avatar_id');
        /** @var $avatar User_Avatar_Row */
        foreach ($avatars as $avatar) {
            $element->addMultiOption($avatar->getId(), $avatar->getName());
        }
        $element->setValue($user->getAvatarId());
    }

    public function setPosting(Posting_Row $posting)
    {

    }

    public function setComment(Posting_Comment_Row $comment)
    {

    }
}
