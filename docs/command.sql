CREATE TABLE JS020
(
    Sno    char(10)      NOT NULL,
    Sname  Char(8)       NOT NULL,
    Sex    char(3)       NOT NULL DEFAULT '男',
    Bdate  date          NOT NULL DEFAULT '1970-01-01',
    Height decimal(3, 2) NOT NULL DEFAULT 0,
    Dorm   char(15),
    PRIMARY KEY (Sno)
);


INSERT INTO js020 (Sno, SNAME, SEX, BDATE, Heihgt, DORM)
VALUES ('01032010',
        '王涛',
        '男',
        '1992-4-5',
        '1.72',
        '东14舍221'),
       ('01032023',
        '孙文',
        '男',
        '1993-6-10',
        '1.80',
        '东14舍221'),
       ('01032001',
        '张晓梅',
        '女',
        '1993-11-17',
        '1.58',
        '东1舍312'),
       ('01032005',
        '刘静',
        '女',
        '1992-1-10',
        '1.63',
        '东1舍312'),
       ('01032112',
        '董蔚',
        '男',
        '1992-2-20',
        '1.71',
        '东14舍221'),
       ('03031011',
        '王倩',
        '女',
        '1993-12-20',
        '1.66',
        '东2舍104'),
       ('03031014',
        '赵思扬',
        '男',
        '1991-6-6',
        '1.85',
        '东18舍421'),
       ('03031051',
        '周剑',
        '男',
        '1991-5-8',
        '1.68',
        '东18舍422'),
       ('03031009',
        '田婷',
        '女',
        '1992-8-11',
        '1.60',
        '东2舍104'),
       ('03031033',
        '蔡明明',
        '男',
        '1992-3-12',
        '1.75',
        '东18舍423');


CREATE TABLE JC020
(
    Cno     char(12)      NOT NULL,
    Cname   char(30)      NOT NULL,
    Period decimal (4, 1) NOT NULL DEFAULT 0,
    Credit  decimal(2, 1) NOT NULL DEFAULT 0,
    Teacher char(10)      NOT NULL,
    PRIMARY KEY (Cno)
);


INSERT INTO jc020 (Cno, CNAME, PERIOD, CREDIT, TEACHER)
VALUES ('CS-01', '数据结构', '60', '3', '张军'),
       ('CS-02', '计算机组成原理', '80', '4', '王亚伟'),
       ('CS-04', '人工智能', '40', '2', '李蕾'),
       ('EE-01', '信号与系统', '40', '2', '张明'),
       ('EE-02', '数字逻辑电路', '100', '5', '胡海东');


CREATE TABLE jSC020
(
    Sno   Char(10) NOT NULL,
    Cno   char(8)  NOT NULL,
    Grade decimal(4, 1) DEFAULT NULL,
    PRIMARY KEY (Sno, Cno),
    FOREIGN KEY (Sno) REFERENCES jS020 ON DELETE CASCADE,
    FOREIGN KEY (Cno) REFERENCES jc020 ON DELETE RESTRICT,
    CHECK (
            (Grade IS NULL)
            OR (
                Grade BETWEEN 0 AND 100
                )
        )
);


INSERT INTO jsc020 (Sno, Cno, GRADE)
VALUES ('01032010', 'CS-01', '82.0'),
       ('01032010', 'CS-02', '91.0'),
       ('01032010', 'CS-04', '83.5'),
       ('01032001', 'CS-01', '77.5'),
       ('01032001', 'CS-02', '85.0'),
       ('01032001', 'CS-04', '83.0'),
       ('01032005', 'CS-01', '62.0'),
       ('01032005', 'CS-02', '77.0'),
       ('01032005', 'CS-04', '82.0'),
       ('01032023', 'CS-01', '55.0'),
       ('01032023', 'CS-02', '81.0'),
       ('01032023', 'CS-04', '76.0'),
       ('01032112', 'CS-01', '88.0'),
       ('01032112', 'CS-02', '91.5'),
       ('01032112', 'CS-04', '86.0'),
       ('03031033', 'EE-01', '93.0'),
       ('03031033', 'EE-02', '89.0'),
       ('03031009', 'EE-01', '88.0'),
       ('03031009', 'EE-02', '78.5'),
       ('03031011', 'EE-01', '91.0'),
       ('03031011', 'EE-02', '86.0'),
       ('03031051', 'EE-01', '78.0'),
       ('03031051', 'EE-02', '58.0'),
       ('03031014', 'EE-01', '79.0'),
       ('03031014', 'EE-02', '71.0');


-- 1．在上述基本表上完成以下查询：
-- (1) 查询电子工程系（EE）所开课程的课程编号、课程名称及学分数。
SELECT cno,
       cname,
       credit
FROM jc020
WHERE cno LIKE 'EE-%';


-- (2) 查询未选修课程'CS-01'的女生学号及其已选各课程编号、成绩。
SELECT *
FROM jsc020
WHERE sno NOT IN (
    SELECT sno
    FROM jsc020
    WHERE cno = 'CS-01'
)
  AND sno IN (
    SELECT sno
    FROM js020
    WHERE sex = '女'
);


-- (3) 查询2000年～2001年出生的学生的基本信息。
SELECT *
FROM js020
WHERE to_char(bdate, 'YYYY') IN ('2000', '2001');


-- (4) 查询每位学生的学号、学生姓名及其已选修课程的学分总数。
SELECT js.sno,
       js.sname,
       sum(jc.credit)
FROM js020 AS js
         INNER JOIN jsc020 AS jsc ON js.sno = jsc.sno
         INNER JOIN jc020 AS jc ON jsc.cno = jc.cno
GROUP BY js.sno,
         js.sname
ORDER BY js.sno DESC;


SELECT js.sno,
       js.sname,
       sum(jc.credit)
FROM (
         SELECT sno,
                sname
         FROM js020
     ) AS js
         INNER JOIN (
    SELECT sno,
           cno
    FROM jsc020
) AS jsc ON js.sno = jsc.sno
         INNER JOIN (
    SELECT cno,
           credit
    FROM jc020
) AS jc ON jsc.cno = jc.cno
GROUP BY js.sno,
         js.sname
ORDER BY js.sno DESC;


-- ok
SELECT stu.sno,
       stu.sname,
       sum(cus.credit)
FROM js020 AS stu
         INNER JOIN jsc020 AS sc ON stu.sno = sc.sno
         INNER JOIN jc020 AS cus ON sc.cno = cus.cno
GROUP BY stu.sno
ORDER BY stu.sno DESC;


-- (5) 查询选修课程'CS-02'的学生中成绩第二高的学生学号。AUTO200127
SELECT Sno
FROM jsc020
WHERE Grade IN (
    SELECT max(Grade)
    FROM jsc020
    WHERE cno = 'AUTO200127'
      AND Grade < (
        SELECT max(Grade)
        FROM jsc020
        WHERE cno = 'AUTO200127'
    )
)
  AND cno = 'AUTO200127';


SELECT Sno
FROM jsc020
WHERE Grade IN (
    SELECT min(grade)
    FROM (
             SELECT DISTINCT grade
             FROM jsc020
             WHERE cno = 'AUTO200127'
               AND grade IS NOT NULL
             ORDER BY grade DESC LIMIT 2
         )
)
  AND cno = 'AUTO200127';


-- (6) 查询平均成绩超过'王涛'同学的学生学号、姓名和平均成绩，并按学号进行降序排列。
SELECT js020.sno,
       js020.sname,
       avg.avg_grade
FROM js020
         INNER JOIN (
    SELECT jsc020.sno,
           avg(jsc020.grade) AS avg_grade
    FROM jsc020
    GROUP BY jsc020.sno
    HAVING (
                   avg_grade > (
                   SELECT avg_grade
                   FROM (
                            SELECT jsc020.sno,
                                   avg(jsc020.grade) AS avg_grade
                            FROM jsc020
                            GROUP BY jsc020.sno
                        )
                   WHERE sno IN (
                       SELECT js020.sno
                       FROM js020
                       WHERE js020.sname = '李凯'
                   )
               )
               )
) AS avg
ON js020.sno = avg.sno
ORDER BY js020.sno DESC;


SELECT *
FROM (
         SELECT js020.sno         AS stu_sno,
                js020.sname       AS stu_name,
                avg(jsc020.grade) AS avg_grade
         FROM js020
                  INNER JOIN jsc020 ON js020.sno = jsc020.sno
         GROUP BY js020.sno,
                  js020.sname
     ) AS js_avg
WHERE avg_grade > (
    SELECT avg_grade
    FROM (
             SELECT js020.sname       AS stu_name,
                    avg(jsc020.grade) AS avg_grade
             FROM js020
                      INNER JOIN jsc020 ON js020.sno = jsc020.sno
             GROUP BY js020.sname
         )
    WHERE stu_name = '李凯'
)
ORDER BY stu_sno DESC;


-- (7) 查询选修了3门以上课程（包括3门）的学生中平均成绩最高的同学学号及姓名。
SELECT sno,
       sname
FROM js020
WHERE sno IN (
    SELECT sno
    FROM (
             SELECT sno,
                    avg(grade) AS avg_grade,
                    COUNT(cno) AS c_amount
             FROM jsc020
             GROUP BY sno
             HAVING c_amount > 2
         )
    WHERE avg_grade = (
        SELECT max(avg_grade)
        FROM (
                 SELECT sno,
                        avg(grade) AS avg_grade,
                        COUNT(cno) AS c_amount
                 FROM jsc020
                 GROUP BY sno
             )
        WHERE c_amount > 2
    )
);


SELECT final.sno,
       js020.sname
FROM (
         SELECT sno_avg.sno
         FROM (
                  SELECT sno,
                         avg(grade) AS avg_grade
                  FROM jsc020
                  GROUP BY sno
                  HAVING COUNT(*) > 2
                  ORDER BY avg_grade
              ) AS sno_avg
         WHERE sno_avg.avg_grade = (
             SELECT max(cno_count.avg_grade)
             FROM (
                      SELECT avg(grade) AS avg_grade,
                             sno
                      FROM jsc020
                      GROUP BY sno
                      HAVING COUNT(*) > 2
                  ) AS cno_count
         )
     ) AS final
         LEFT JOIN js020 ON js020.sno = final.sno;


-- 2．分别在JS×××和JC×××表中加入记录('01032005','刘竞','男','1993-12-10',
1.75,
'东14舍312'
) 及('CS-03', '离散数学', 64, 4, '陈建明') 。
INSERT INTO js020 (Sno, SNAME, SEX, BDATE, Heihgt, DORM)
VALUES(
    '01032005',
    '刘竞',
    '男',
    '1993-12-10',
    '1.75',
    '东14舍312'
  ) -- ERROR:  duplicate key value violates unique constraint "js020_pkey" 
  -- DETAIL:  Key (sno)=(01032005  ) already exists.
;


INSERT INTO jc020 (Cno, CNAME, PERIOD, CREDIT, TEACHER)
VALUES ('CS-03', '离散数学', '64', '4', '陈建明');


-- 3．将JS×××表中已修学分数大于60的学生记录删除。
DELETE
FROM js020
WHERE sno IN (
    SELECT sno
    FROM (
             SELECT sno,
                    sum(credit) AS all_credit
             FROM jsc020
                      LEFT OUTER JOIN jc020 ON jsc020.cno = jc020.cno
             WHERE grade > 59
             GROUP BY sno
         )
    WHERE all_credit > 60
);


-- 4．将“张明”老师负责的“信号与系统”课程的学时数调整为64，同时增加一个学分。
UPDATE course
SET period_ = 64,
    credit  = credit + 1
WHERE cname = '信号与系统'
  AND teacher = '张明';


-- 5．建立如下视图：
-- (1)居住在“东18舍”的男生视图，包括学号、姓名、出生日期、身高等属性。
CREATE VIEW e18m AS
(
SELECT snum,
       sname,
       bdate,
       heihgt
FROM student
WHERE sex = '男'
  AND dorm LIKE '东18%'
    );


-- (2)“张明”老师所开设课程情况的视图，包括课程编号、课程名称、平均成绩等属性。
CREATE VIEW zmtech AS
(
SELECT course.cnum,
       course.cname,
       tmp.avg_grade
FROM course,
     (
         SELECT cnum,
                avg(grade) AS avg_grade
         FROM sc
         GROUP BY cnum
     ) AS tmp
WHERE course.cnum = tmp.cnum
  AND course.teacher = '张明'
    );


-- (3)所有选修了“人工智能”课程的学生视图，包括学号、姓名、成绩等属性。
CREATE VIEW rgzn AS
(
SELECT student.snum,
       student.sname,
       sc.grade
FROM student,
     sc
WHERE student.snum = sc.snum
  AND sc.cnum IN (
    SELECT cnum
    FROM course
    WHERE cname = '人工智能'
)
    );


-- TRIGGER
CREATE
OR REPLACE FUNCTION give_100() RETURNS TRIGGER AS $$
DECLARE
stu_num char(10);


BEGIN
SELECT sno
INTO stu_num
FROM js020 LIMIT 1;


INSERT INTO jsc020 (Sno, Cno, GRADE)
VALUES (stu_num, new.cno, '100.0');


RETURN new;


END;


$$
language plpgsql;


CREATE TRIGGER give_100
    AFTER
        INSERT
    ON jc020
    FOR EACH ROW EXECUTE PROCEDURE give_100();