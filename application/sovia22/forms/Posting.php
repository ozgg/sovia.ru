<?php
/**
 * Date: 30.08.11
 * Time: 1:54
 */
 
class Form_Posting extends Zend_Form
{
    public function init()
    {
        $avatar = new Zend_Form_Element_Select(
            array(
                'name'  => 'avatar_id',
                'label' => 'Аватар',
            )
        );
        $avatar->addMultiOption('0', 'Не выбран');

        $this->addElement($avatar);

        $title = new Zend_Form_Element_Text(
            array(
                'name' => 'title',
                'label' => 'Название',
                'size' => 50,
            )
        );
        $title->setRequired();
        $title->addValidator('stringLength', false, array(3, 100));
        $this->addElement($title);
        unset($title);

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
}
