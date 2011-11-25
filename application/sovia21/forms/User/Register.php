<?php
/**
 * Date: 30.08.11
 * Time: 21:24
 */

/**
 * Форма регистрации нового пользователя
 */
class Form_User_Register extends Zend_Form
{
    public function init()
    {
        $this->_addLogin();
        $this->_addEmail();
        $this->_addPassword();
        $this->_addKey();

        $submit = new Zend_Form_Element_Submit(
            array(
                'name'  => 'submit',
                'label' => 'Зарегистрироваться',
            )
        );
        $this->addElement($submit);
    }

    private function _addLogin()
    {
        $lengthOptions   = array('min' => 2, 'max' => 16);
        $recordOptions   = array('table' => 'user_item', 'field' => 'login');
        $regexOptions    = '/^[a-z0-9][-a-z0-9]*[a-z0-9]$/';
        $lengthValidator = new Ext_Validate_StringLength($lengthOptions);
        $recordValidator = new Ext_Validate_Db_NoRecordExists($recordOptions);
        $regexValidator  = new Ext_Validate_Regex($regexOptions);

        $login = new Zend_Form_Element_Text(
            array(
                'name'  => 'login',
                'label' => 'Логин',
                'size'  => 16,
            )
        );
        $login->addFilter('stringToLower');
        $login->addValidator(new Ext_Validate_NotEmpty(), true);
        $login->addValidator($lengthValidator, true);
        $login->addValidator($recordValidator, true);
        $login->addValidator($regexValidator);
        $login->setRequired();

        $this->addElement($login);
    }

    private function _addEmail()
    {
        $lengthOptions   = array('min' => 6, 'max' => 100);
        $recordOptions   = array('table' => 'user_item', 'field' => 'email');
        $lengthValidator = new Ext_Validate_StringLength($lengthOptions);
        $recordValidator = new Ext_Validate_Db_NoRecordExists($recordOptions);

        $email = new Zend_Form_Element_Text(
            array(
                'name'  => 'email',
                'label' => 'E-mail',
                'size'  => 50,
            )
        );
        $email->addFilter('stringToLower');
        $email->addValidator(new Ext_Validate_NotEmpty(), true);
        $email->addValidator($lengthValidator, true);
        $email->addValidator(new Ext_Validate_EmailAddress(), true);
        $email->addValidator($recordValidator);
        $email->setRequired();

        $this->addElement($email);
    }

    private function _addPassword()
    {
        $lengthOptions   = array('min' => 5, 'max' => 100);
        $lengthValidator = new Ext_Validate_StringLength($lengthOptions);
        
        $password = new Zend_Form_Element_Text(
            array(
                'name'  => 'password',
                'label' => 'Пароль',
                'size'  => 20,
            )
        );
        $password->addValidator(new Ext_Validate_NotEmpty(), true);
        $password->addValidator($lengthValidator);
        $password->setRequired();

        $this->addElement($password);
    }

    private function _addKey()
    {
        $key = new Zend_Form_Element_Text(
            array(
                'name'  => 'key',
                'label' => 'Ключ',
                'size'  => 32,
            )
        );
/*
        $exclude = 'type_id = ' . User_Key::KEY_REGISTER . ' and updated_at is null';
        $validatorOptions = array(
            'table' => 'user_key',
            'field' => 'body',
            'exclude' => $exclude,
        );
        $validator = new Ext_Validate_Db_RecordExists($validatorOptions);
        $key->addValidator($validator);
        unset($exclude, $validator, $validatorOptions);
//*/
        $this->addElement($key);
    }
}