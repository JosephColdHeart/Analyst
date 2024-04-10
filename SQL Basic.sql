/* Проект выполнялся в IDE Metabase, обращались к базам данных (PostgreSQL):
netflix_db, game_db их описания даны в README - файле.

/* 1. Вывести названия всех фильмов, в которых участвует Хоакин Феникс (Joaquin Phoenix) 

SELECT title
FROM netflix_db
WHERE type = 'Movie' 
	  AND cast_names like '%Joaquin Phoenix%'
---
/* 2. Дать всю имеющуюся информацию о не слишком старых фильмах (не раньше 2010 года) производства Netflix, 
которые сняли режиссеры пяти главных фильмов 2020 года по версии «КиноПоиска».

SELECT title
FROM netflix_db
WHERE type = 'Movie' 
	  AND release_year >= 2010 
	  AND director in ('Bong Joon Ho', 'Todd Phillips', 'Quentin Tarantino', 'Martin Scorsese', 'Sam Mendes')
ORDER BY title ASC

/* 3. Получить список платформ, у которых неплохой объем продаж в мире и на которых есть выбор шутеров, выпущенных не больше 10 лет назад. 
Важно, чтобы в отчет попала информация о производителях игр. Также не стоит упускать информацию о деньгах: маркетингу будет полезно увидеть 
среднюю выручку на одну игру и среднюю выручку на одного производителя. 


SELECT  platform_name,
      	SUM(global_sales) as revenue,
      	COUNT(DISTINCT name) as games_produced,
      	AVG(global_sales) as average_revenue_per_game,
      	SUM(global_sales)*1.0 /
      	COUNT(DISTINCT platform_name) as average_revenue_per_platform
FROM  public.game_db
WHERE sales_start >= '2010-01-01'
        AND genre = 'Shooter'
GROUP BY platform_name
HAVING SUM(global_sales)>= 50 
	      AND count(DISTINCT name) >= 10
ORDER BY revenue DESC
