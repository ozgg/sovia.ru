<?php
/**
 * Date: 30.08.11
 * Time: 1:54
 */
 
class Form_Posting extends Zend_Form
{
    public function init()
    {
        $this->addAvatar();
        $this->addTitle();
        $this->addBody();
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

    protected function addAvatar()
    {
        $element = new Zend_Form_Element_Select(
            array(
                'name'  => 'avatar_id',
                'label' => 'Аватар',
            )
        );
        $element->addMultiOption('0', 'Не выбран');
        $this->addElement($element);
    }

    protected function addTitle()
    {
        $element = new Zend_Form_Element_Text(
            array(
                'name'  => 'title',
                'label' => 'Название',
                'size'  => 50,
            )
        );
        $element->setRequired();
        $element->addValidator('stringLength', false, array(1, 100));
        $this->addElement($element);
    }

    protected function addBody()
    {
        $element = new Zend_Form_Element_Textarea(
            array(
                'name'  => 'body',
                'label' => 'Текст',
                'cols'  => 80,
                'rows'  => 25,
            )
        );
        $element->setRequired();
        $this->addElement($element);
    }

    protected function addTags()
    {
        $element = new Zend_Form_Element_Textarea(
            array(
                'name'  => 'tags',
                'label' => 'Метки',
                'cols'  => 80,
                'rows'  => 3,
            )
        );
        $this->addElement($element);
    }

    protected function addDescription()
    {
        $element = new Zend_Form_Element_Textarea(
            array(
                'name'  => 'description',
                'label' => 'Описание',
                'cols'  => 80,
                'rows'  => 5,
            )
        );
        $this->addElement($element);
    }

    protected function addIsInternal()
    {
        $element = new Zend_Form_Element_Select(
            array(
                'name'  => 'is_internal',
                'label' => 'Кто может прочитать',
            )
        );
        $element->addMultiOption(Posting_Row::VIS_PUBLIC, 'Все');
        $element->addMultiOption(Posting_Row::VIS_REGISTERED, 'Пользователи');
        $element->addMultiOption(Posting_Row::VIS_PRIVATE, 'Только я');
        $element->setRequired();
        $element->setValue(Posting_Row::VIS_PUBLIC);

        $this->addElement($element);
    }

    protected function addSubmit()
    {
        $submit = new Zend_Form_Element_Submit(
            array(
                'name' => 'submit',
                'label' => 'Готово',
            )
        );
        $this->addElement($submit);
    }
}
