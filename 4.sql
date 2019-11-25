/* Задание 4. Необходимо без применения PL/SQL посчитать величину начисления нарастающим итогом в порядке увеличения года. 
При этом если начисление текущего года меньше нарастающего итога предыдущих годов, то этот месяц не вносит свой вклад в нарастающий итог.
*/

--Создание и заполнение таблиц
CREATE TABLE accrual
 (amount NUMBER(18,2),
  num_year NUMBER(4) PRIMARY KEY
  );
/
INSERT ALL
 INTO accrual VALUES (10, 2008)
 INTO accrual VALUES (15, 2009)
 INTO accrual VALUES (12, 2010)
 INTO accrual VALUES (30, 2011)
SELECT 1 FROM DUAL;
/
COMMIT;
/
--Вариант с использованием реккурсивного WITH
WITH recurs(num_year, amount, sum_amount) AS
     (SELECT num_year,
             amount,
             amount sum_amount
      FROM accrual
      WHERE num_year = (SELECT min(num_year) FROM accrual)
      UNION ALL
      SELECT t.num_year,
             t.amount,
             CASE WHEN t.amount > r.sum_amount THEN (r.sum_amount+t.amount)
             ELSE r.sum_amount END sum_amount
      FROM recurs r,
           accrual t
      WHERE t.num_year = r.num_year + 1 
      )
SELECT * FROM  recurs
ORDER BY num_year;
/
--Вариант с использованием MODEL
SELECT amount, num_year, sum_amount FROM accrual
MODEL DIMENSION BY (num_year)
MEASURES (amount, 0 sum_amount)
    RULES( sum_amount[num_year] = CASE WHEN amount[cv()] > nvl(sum_amount[cv()-1],0) THEN amount[cv()] + nvl(sum_amount[cv()-1],0)
                              ELSE sum_amount[cv()-1]
                              END
    )
ORDER BY num_year;
     

