# Базовый SQL 

Описание данных, которые хранят таблицы:

Таблица `netflix_db`
Хранит всю информацию о фильмах, 
которые можно посмотреть на платформе Netflix.
* `show_id`	Идентификатор фильма, шоу, сериала
* `type`	тип проекта (фильм или ТВ-шоу)
* `title`	название
* `director`	режиссер
* `cast_names`	актеры
* `country`	страна производства
* `release_year`	год выпуска
* `rating`	возрастная категория

Таблица `game_db`
Содержит информацию об играх, их монетизации,
платформе, жанре, старте продаж.
* `game rank` ранг игры
* `name`	название
* `genre`	жанр
* `publisher`	издатель
* `na_sales`	продажи в Северной Америке
* `eu_sales`	продажи в Европе
* `jp_sales`	продажи в Японии
* `other_sales`	продажи в других странах
* `global_sales`	мировые продажи
* `release_year`	год выпуска
* `platform_name`	название платформы
* `sales_start`	начало продаж