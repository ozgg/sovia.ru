Совия
=====

Это новая версия Совии на совершенно новой архитектуре (RoR + pgsql).

На заметку себе
---------------

Осталось реализовать следующий функционал для релиза версии 3:

 * учитывать количество меток для пользователя с личной интерпретацией
 * ссылки на интерпретации из меток сна
 * изменение профиля пользователя
 * добавление комментариев
 * отправка комментариев на почту
 * восстановление пароля
 * страница "о проекте" (/about)
 * страница с пользовательским соглашением (/tos)
 * страница с соглашением о конфиденциальности (/privacy)
 * блок "чаще всего снится"
 * блок "случайный сон"
 * заглушка для страницы случайного сна
 * заглушка для страницы описания сущностей (/entities)
 * заглушка для бредового генератора снов (/fun/rave)
 * сохранение uri_title
 * учитывание uri_title
 * страница /about/features
 * страница /about/changelog
 * заглушка для /user/profile/of/*
 * страница со снами пользователя (/dreams/of/*)
 * разбор текстов статей
 * страница "мои сны" (/my/dreams)
 * виджет addthis на страницах
 * кнопка google plus
 * ссылки на соседние записи
 * генерация файла sitemap
 * страница /statistics
 * страница /statistics/symbols
 * отказ добавления анонимных записей со спамом

Последний шаг перед релизом – импорт старых данных

 * Импорт пользователей
 * Импорт сонника
 * Импорт публикаций (сны, статьи, сообщество)
 * Импорт комментариев

После релиза

 * разбор текстов снов
 * разбор текстов публикаций
 * разбор текстов комментариев
 * разбор текстов из сонника
 * загрузка картинки пользователя

