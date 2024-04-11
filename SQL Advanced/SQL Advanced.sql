## Задача 1

Было бы круто отметить 10 лучших режиссеров фильмов и сериалов (movie и tvSeries) 2020 года, у которых самый высокий средний рейтинг. <br>Если у режиссера выходило два фильма в 2020 году, нам нужна одна цифра — средний рейтинг по обоим фильмам. Давайте выведем данные в порядке убывания.


select   name_basics."primaryName"
  	,avg(title_ratings."averageRating") as avg_rt
from imdb.title_basics
inner join imdb.title_ratings
      on title_ratings.tconst = title_basics.tconst
      and title_ratings."numVotes">= 100000
inner join imdb.title_crew_long
      on title_crew_long.tconst = title_basics.tconst
inner join imdb.name_basics
      on name_basics.nconst = title_crew_long.directors
where title_basics."startYear" = 2020
group by name_basics."primaryName"
order by avg(title_ratings."averageRating") desc
limit 10

Задача 2
Напишите запрос, который позволит выбрать до 10 учителей из каждого департамента. 

with data_with_id as
(
select id_teacher,
       department,
       max_teaching_level,
       city,
       country,
       row_number() over(partition by department order by id_teacher) as id_in_dept
from skyeng_db.teachers
where department is not null
)
select *
from data_with_id
where id_in_dept <= 10
order by department, id_in_dept


Задача 3
Какое место по времени создания занимает заказ номер 110551:

 Среди всех заказов?
 Среди заказов своего города?
 Среди заказов своего тарифа?
 Среди заказов своего города и своего тарифа?

select *
from (select  t.*
              , name_tariff
              , name_city
              , row_number() over (order by order_time) as rn_all
              , row_number() over (partition by name_city order by order_time) as rn_city
              , row_number() over (partition by name_tariff order by order_time) as rn_tariff
              , row_number() over (partition by name_city, name_tariff order by order_time) as rn_city_tariff
      from skytaxi.order_list t
          left join skytaxi.city_dict a
              on t.id_city = a.id_city
          left join skytaxi.tariff_dict b
              on t.id_tariff = b.id_tariff
    ) t
where id_order = 110551


Задача 4*
Есть таблица с некоторым списком компаний, их принадлежности к стране и значением капитализации (рыночная стоимость самой компании) на конец 2020 года.
Необходимо выявить в каждой стране компанию, капитализация которой максимальна. 

Делать запросы поочередно!

create temp table temp_companies - 1 запрос
(country varchar(50),
 company varchar(50),
capitalization int);

insert into temp_companies — 2 запрос
values
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

                            

select country,
max(capitalization) as max — 3 запрос
into temp table
temp_second_result
from temp_companies
group by country;

                                  

select temp_companies.* — 4 запрос
from temp_second_result
inner join temp_companies
     on temp_companies.country = temp_second_result.country 
        and temp_companies.capitalization = temp_second_result.max;
