/* Сценарии для формы регистрации пользователя */

function checkRegisterForm()
{
	var result  = true;
	var message = '';
	if ($('#reg_login').val().length < 4) {
		message += 'Логин не может быть короче четырёх символов.\n';
		result = false;
	}
	if ($('#reg_password').val().length < 3) {
		message += 'Пароль не может быть короче трёх символов.\n';
		result = false;
	} else {
		if ($('#reg_password').val() != $('#reg_password_confirm').val()) {
			message += 'Пароль не совпадает с подтверждением.\n';
		}
	}
	if (messsage != '') {
		alert(message);
	}
	return result;
}

function normalizeLogin(loginField)
{
	if (loginField) {
		loginField.value = loginField.value.toLowerCase().replace(/[^0-9a-z_]/, '');
	}
}