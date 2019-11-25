/*������� 3. ���� ������� � �������� ��������� ���. ���� ������ � ����������� �� �������� �� ��������� �����.
�������� ���������: ���� ���������� �� �������� �� ������ ��������� ���� �� ����, �� �������� �������� ��������, ��������� ���� � ����������, ������ 0
*/

--������� � ��������� ������� ��������� ���
CREATE TABLE time_zones
   (name VARCHAR2(30));
/
INSERT ALL
 INTO time_zones VALUES ('����')
 INTO time_zones VALUES ('����')
 INTO time_zones VALUES ('�������������')
SELECT 1 FROM DUAL;
/
--������� � ��������� ������� � ������������ �� �������� �� ���������� �����
CREATE TABLE abonent_accrual
     (abonent VARCHAR2(20),
      accrual_time_zone VARCHAR2(30),
      amount NUMBER);
/
INSERT ALL
 INTO abonent_accrual VALUES ('�������_1', '����', 2)
 INTO abonent_accrual VALUES ('�������_1', '����', 1)
 INTO abonent_accrual VALUES ('�������_2', '�������������', 3)
SELECT 1 FROM DUAL;
/
COMMIT;
/
-- ���������� ������������������ ������� ����������� ��� ���������� ���������
SELECT a.abonent, t.name, NVL(a.amount, 0) value 
FROM time_zones t LEFT JOIN abonent_accrual a PARTITION BY (a.abonent) 
ON t.name = a.ACCRUAL_TIME_ZONE
;