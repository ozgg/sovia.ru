Совия
=====

Это новая версия Совии на совершенно новой архитектуре (RoR + pgsql).

На заметку себе
---------------

Осталось реализовать следующий функционал для релиза версии 3:

 * отправка комментариев на почту
 * отказ добавления анонимных записей со спамом
 * учитывать количество меток для пользователя с личной интерпретацией
 * сохранение uri_title
 * учитывание uri_title
 * страница с архивом снов (/dreams/archive/:year/:month)
 * страница с пользовательским соглашением (/tos)
 * страница с соглашением о конфиденциальности (/privacy)
 * загрузка картинки пользователя
 * генерация файла sitemap

Последний шаг перед релизом – импорт старых данных

 * Импорт пользователей
 * Импорт сонника
 * Импорт публикаций (сны, статьи, сообщество, сущности)
 * Импорт комментариев

После релиза

 * ссылки на соседние записи
 * разбор текстов статей
 * разбор текстов снов
 * разбор текстов публикаций
 * разбор текстов комментариев
 * разбор текстов из сонника
 * механизм меток для каждого типа записи
 * перенаправление about/changelog на статьи с метками
