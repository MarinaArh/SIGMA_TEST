/*«адание 3. ≈сть таблица с перечнем временных зон. ≈сть данные о начислени€х по абоненту по временным зонам.
ѕолучить результат: если начислени€ по абоненту по данной временной зоне не было, то выдавать название абонента, временную зону и начисление, равное 0
*/

--—оздаем и заполн€ем таблицу временных зон
CREATE TABLE time_zones
   (name VARCHAR2(30));
/
INSERT ALL
 INTO time_zones VALUES ('день')
 INTO time_zones VALUES ('ночь')
 INTO time_zones VALUES ('круглосуточно')
SELECT 1 FROM DUAL;
/
--—оздаем и заполн€ем таблицу с начислени€ми по абоненту по врмененным зонам
CREATE TABLE abonent_accrual
     (abonent VARCHAR2(20),
      accrual_time_zone VARCHAR2(30),
      amount NUMBER);
/
INSERT ALL
 INTO abonent_accrual VALUES ('јбонент_1', 'день', 2)
 INTO abonent_accrual VALUES ('јбонент_1', 'ночь', 1)
 INTO abonent_accrual VALUES ('јбонент_2', 'круглосуточно', 3)
SELECT 1 FROM DUAL;
/
COMMIT;
/
-- ѕользуемс€ партиционированным внешним соединением дл€ заполнени€ пропусков
SELECT a.abonent, t.name, NVL(a.amount, 0) value 
FROM time_zones t LEFT JOIN abonent_accrual a PARTITION BY (a.abonent) 
ON t.name = a.ACCRUAL_TIME_ZONE
;