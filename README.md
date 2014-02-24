Совия
=====

Это новая версия Совии на совершенно новой архитектуре (RoR + pgsql).

На заметку себе
---------------

Осталось реализовать следующий функционал для релиза версии 3:

 * страница "мои сны"
 * подтверждение почты
 * сброс и восстановление пароля
 * добавление комментариев
 * отправка комментариев на почту
 * отказ добавления анонимных записей со спамом
 * разбор текстов статей
 * ссылки на соседние записи
 * сохранение uri_title
 * учитывание uri_title
 * страница с архивом снов (/dreams/archive/:year/:month)
 * страница "о проекте" (/about)
 * страница с пользовательским соглашением (/tos)
 * страница с соглашением о конфиденциальности (/privacy)
 * страница /about/features
 * страница /about/changelog
 * загрузка картинки пользователя
 * учитывать количество меток для пользователя с личной интерпретацией
 * генерация файла sitemap
 * метрика, spyLog, GA

Последний шаг перед релизом – импорт старых данных

 * Импорт пользователей
 * Импорт сонника
 * Импорт публикаций (сны, статьи, сообщество, сущности)
 * Импорт комментариев

После релиза

 * разбор текстов снов
 * разбор текстов публикаций
 * разбор текстов комментариев
 * разбор текстов из сонника
