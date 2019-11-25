/* Задание 1. Комнаты*/

--Создание и заполнение таблиц
CREATE TABLE rooms
  (room_id  number,
   floor number,
   light_is_on varchar2(1)
   );
/
INSERT ALL
 INTO rooms VALUES (101, 1, '0')
 INTO rooms VALUES (102, 1, '0')
 INTO rooms VALUES (103, 1, '1')
 INTO rooms VALUES (201, 2, '0')
 INTO rooms VALUES (202, 2, '0')
 INTO rooms VALUES (301, 3, '1')
 INTO rooms VALUES (302, 3, '1')
SELECT 1 FROM DUAL;
/
COMMIT;
/
-- 1. Вывести список всех этажей
-- первый вариант DISTINCT
SELECT DISTINCT floor FROM rooms;
/

-- второй вариант group by
SELECT floor FROM rooms
GROUP BY floor;
/

-- 2. Вывести список этажей и кол-во комнат в них
SELECT floor, COUNT(room_id) count_rooms
FROM rooms
GROUP BY floor;

-- 3. Вывести список всех этажей где выключен свет,  выключенном светом на этаже считается отсутствие света во всех комнатах этажа.
SELECT floor
FROM rooms
GROUP BY floor
HAVING max(light_is_on) = '0';

-- 4. Вывести макс номер комнаты(по последним двум цифрам) для всего здания
SELECT max(mod(room_id,100)) max_room_number
FROM rooms;

-- 5. Написать update который, который для каждой комнаты «нажмет на выключатель»
SELECT * FROM rooms;
UPDATE rooms SET light_is_on = decode(light_is_on, '1', '0', '1');
SELECT * FROM rooms;
ROLLBACK;

-- 6. Написать merge который, который для каждой нечетной комнаты «нажмет на выключатель»
SELECT * FROM rooms;
MERGE INTO rooms r
USING (SELECT room_id, ROW_NUMBER () OVER (ORDER BY room_id) AS rn FROM rooms) s
   ON (r.room_id = s.room_id AND mod(s.rn,2)=1)
   WHEN MATCHED THEN UPDATE SET r.light_is_on = decode(r.light_is_on, '1', '0', '1')
;
SELECT * FROM rooms;
ROLLBACK;

-- 7. Вывести список этажей и для каждого этажа признак наличия света в комнате с самым большим номером.
SELECT floor, light_is_on FROM rooms 
WHERE (floor, room_id) IN (
  SELECT floor, max(room_id) max_room_id
  FROM rooms t
  GROUP BY floor
);
/
-- 8. Вывести список этажей и для каждого этажа кол-во комнат с включенным светом на этажах ниже текущего(включая текущий).
SELECT floor, sum(cnt) OVER (ORDER BY floor ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) sum_cnt
FROM 
(SELECT floor, count(CASE WHEN light_is_on = '1' THEN 1 END) cnt
 FROM rooms
 GROUP BY floor)
