各ユーザー (mn_id) が特定の日 (date) に活動した後、
7日後・14日後・30日後にも活動しているかどうかを判定

SELECT
DATE(`time`) AS date, mn_id
FROM acts_output
GROUP BY date, mn_id;


SELECT
    a.mn_id,
    a.date,

    -- 7日後に同じユーザーが活動しているか判定
    MAX(
        CASE 
            WHEN DATEDIFF(
                    IFNULL(b.date, '9999-12-31'),
                    a.date
                 ) = 7 THEN 1
            ELSE 0
        END
    ) AS flag_day7,

    -- 14日後に同じユーザーが活動しているか判定
    MAX(
        CASE 
            WHEN DATEDIFF(
                    IFNULL(b.date, '9999-12-31'),
                    a.date
                 ) = 14 THEN 1
            ELSE 0
        END
    ) AS flag_day14,

    -- 30日後に同じユーザーが活動しているか判定
    MAX(
        CASE 
            WHEN DATEDIFF(
                    IFNULL(b.date, '9999-12-31'),
                    a.date
                 ) = 30 THEN 1
            ELSE 0
        END
    ) AS flag_day30

FROM
    (
        -- 日付ごとのユーザー一覧を作成
        SELECT
            DATE(time) AS date,
            mn_id
        FROM acts_output
        GROUP BY DATE(time), mn_id
    ) AS a

LEFT JOIN
    (
        -- 同じく日付ごとのユーザー一覧
        SELECT
            DATE(time) AS date,
            mn_id
        FROM acts_output
        GROUP BY DATE(time), mn_id
    ) AS b
    ON a.mn_id = b.mn_id

GROUP BY
    a.mn_id,
    a.date
ORDER BY
    a.mn_id,
    a.date
LIMIT 10;


+-------+------------+-----------+------------+------------+
| mn_id | date       | flag_day7 | flag_day14 | flag_day30 |
+-------+------------+-----------+------------+------------+
|     1 | 2020-08-16 |         0 |          0 |          0 |
|     2 | 2020-09-27 |         0 |          0 |          0 |
|     3 | 2020-08-22 |         0 |          0 |          0 |
|     4 | 2020-08-21 |         0 |          0 |          0 |
|     5 | 2020-08-22 |         0 |          0 |          0 |
|     6 | 2020-09-25 |         0 |          0 |          0 |
|     7 | 2020-08-23 |         1 |          1 |          0 |
|     7 | 2020-08-24 |         1 |          1 |          0 |
|     7 | 2020-08-25 |         0 |          1 |          0 |
|     7 | 2020-08-26 |         1 |          0 |          0 |
+-------+------------+-----------+------------+------------+
10 rows in set (0.11 sec)


