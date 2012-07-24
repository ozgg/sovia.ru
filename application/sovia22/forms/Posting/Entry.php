<?php
/**
 * Date: 30.08.11
 * Time: 1:54
 */
 
class Form_Posting_Entry extends Zend_Form
{
    public function init()
    {
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
}
