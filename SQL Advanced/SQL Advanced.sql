/* Проект выполнялся в IDE Metabase, обращались к базам данных (PostgreSQL):
imdb, skyeng_db, skytaxi их описания даны в README - файле.


/* 1. Было бы круто отметить 10 лучших режиссеров фильмов и сериалов (movie и tvSeries) 2020 года, у которых самый высокий средний рейтинг.
Если у режиссера выходило два фильма в 2020 году, нам нужна одна цифра — средний рейтинг по обоим фильмам. Давайте выведем данные в порядке убывания.

SELECT    name_basics."primaryName"
  	    , AVG(title_ratings."averageRating") as avg_rt
FROM imdb.title_basics
INNER JOIN imdb.title_ratings
      ON title_ratings.tconst = title_basics.tconst
      AND title_ratings."numVotes">= 100000
INNER JOIN imdb.title_crew_long
      ON title_crew_long.tconst = title_basics.tconst
INNER JOIN imdb.name_basics
      ON name_basics.nconst = title_crew_long.directors
WHERE title_basics."startYear" = 2020
GROUP BY name_basics."primaryName"
ORDER BY AVG(title_ratings."averageRating") DESC
LIMIT 10

/* 2. Напишите запрос, который позволит выбрать до 10 учителей из каждого департамента. 

WITH data_with_id as
    (
    SELECT id_teacher,
           department,
           max_teaching_level,
           city,
           country,
           ROW_NUMBER() OVER (PARTITION BY department ORDER BY id_teacher) as id_in_dept
    FROM skyeng_db.teachers
    WHERE department IS NOT NULL
    )
SELECT *
FROM data_with_id
WHERE id_in_dept <= 10
ORDER BY department, id_in_dept


/* 3. Какое место по времени создания занимает заказ номер 110551:
 Среди всех заказов?
 Среди заказов своего города?
 Среди заказов своего тарифа?
 Среди заказов своего города и своего тарифа?

SELECT *
FROM (
      SELECT  t.*
            , name_tariff
            , name_city
            , ROW_NUMBER() OVER (ORDER BY order_time) as rn_all
            , ROW_NUMBER() OVER (PARTITION BY name_city ORDER BY order_time) as rn_city
            , ROW_NUMBER() OVER (PARTITION BY name_tariff ORDER BY order_time) as rn_tariff
            , ROW_NUMBER() OVER (PARTITION BY name_city, name_tariff ORDER BY order_time) as rn_city_tariff
      FROM skytaxi.order_list t
      LEFT JOIN skytaxi.city_dict a
          ON t.id_city = a.id_city
      LEFT JOIN skytaxi.tariff_dict b
          ON t.id_tariff = b.id_tariff
      ) t
WHERE id_order = 110551


/* 4. Есть таблица с некоторым списком компаний, их принадлежности к стране 
и значением капитализации (рыночная стоимость самой компании) на конец 2020 года.
Необходимо выявить в каждой стране компанию, капитализация которой максимальна. 

Делать запросы поочередно!

CREATE TEMP TABLE temp_companies - 1 запрос
(country VARCHAR(50),
 company VARCHAR(50),
capitalization INT);

INSERT INTO temp_companies — 2 запрос
VALUES
('Россия', 'Сбербанк',	79504),
('Россия', 'Газпром',	68012),
('Россия', 'Яндекс',	22122),
('Россия', 'Татнефть',	15176),
('Россия', 'X5 Retail Group',	9809),
('Китай',  'Alibaba',  522000),
('Саудовская Аравия', 'Saudi Aramco', 1602000),
('США', 'Apple', 1113000),
('США', 'Amazon', 1000000),
('США', 'Facebook', 475000);

                            

SELECT country,
MAX(capitalization) as max — 3 запрос
INTO TEMP TABLE temp_second_result
FROM temp_companies
GROUP BY country;

                                  

SELECT temp_companies.* — 4 запрос
FROM temp_second_result
INNER JOIN temp_companies
     ON temp_companies.country = temp_second_result.country 
        AND temp_companies.capitalization = temp_second_result.max;
