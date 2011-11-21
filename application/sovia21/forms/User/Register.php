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
        $login = new Zend_Form_Element_Text(
            array(
                'name'  => 'login',
                'label' => 'Логин',
                'size'  => 16,
            )
        );
        $login->addFilter('stringToLower');
        $lengthOptions   = array('min' => 2, 'max' => 16);
        $lengthValidator = new Zend_Validate_StringLength($lengthOptions);
        $login->addValidator($lengthValidator, true);
        unset($lengthOptions, $lengthValidator);
        $recordOptions   = array('table' => 'user', 'field' => 'login');
        $recordValidator = new Zend_Validate_Db_NoRecordExists($recordOptions);
        $login->addValidator($recordValidator, true);
        unset($recordOptions, $recordValidator);
        $regexOptions    = '/^[a-z0-9][-a-z0-9]*[a-z0-9]$/';
        $regexValidator  = new Zend_Validate_Regex($regexOptions);
        $login->addValidator($regexValidator);
        unset($regexOptions, $regexValidator);
        $login->setRequired();
        $this->addElement($login);
        unset($login);

        $email = new Zend_Form_Element_Text(
            array(
                'name'  => 'email',
                'label' => 'E-mail',
                'size'  => 50,
            )
        );
        $email->addFilter('stringToLower');
        $email->addValidator('stringLength', false, array(6, 100));
        $email->addValidator('emailAddress', false);
        $recordOptions   = array('table' => 'user', 'field' => 'email');
        $recordValidator = new Zend_Validate_Db_NoRecordExists($recordOptions);
        $email->addValidator($recordValidator);
        unset($recordValidator, $recordOptions);
        $email->setRequired();
        $this->addElement($email);
        unset($email);

        $password = new Zend_Form_Element_Text(
            array(
                'name'  => 'password',
                'label' => 'Пароль',
                'size'  => 20,
            )
        );
        $password->addValidator('stringLength', false, array(5, 100));
        $password->setRequired();
        $this->addElement($password);
        unset($password);

        $key = new Zend_Form_Element_Text(
            array(
                'name'  => 'key',
                'label' => 'Ключ',
                'size'  => 32,
            )
        );
        $exclude = 'type_id = ' . User_Key::KEY_REGISTER . ' and updated_at is null';
        $validatorOptions = array(
            'table' => 'user_key',
            'field' => 'body',
            'exclude' => $exclude,
        );
        $validator = new Zend_Validate_Db_RecordExists($validatorOptions);
        $key->addValidator($validator);
        unset($exclude, $validator, $validatorOptions);
        $this->addElement($key);
        unset($key);

        $submit = new Zend_Form_Element_Submit(
            array(
                'name' => 'submit',
                'label' => 'Зарегистрироваться',
            )
        );
        $this->addElement($submit);
        unset($submit);
    }
}