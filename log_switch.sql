SET LINESIZE 160
SET HEAD ON

ALTER SESSION SET NLS_DATE_FORMAT='DD/MM/YYYY';

COLUMN DAY FORMAT A3
COLUMN Total FORMAT 99G990
COLUMN h00 FORMAT 999
COLUMN h01 FORMAT 999
COLUMN h02 FORMAT 999
COLUMN h03 FORMAT 999
COLUMN h04 FORMAT 999
COLUMN h05 FORMAT 999
COLUMN h06 FORMAT 999
COLUMN h07 FORMAT 999
COLUMN h08 FORMAT 999
COLUMN h09 FORMAT 999
COLUMN h10 FORMAT 999
COLUMN h11 FORMAT 999
COLUMN h12 FORMAT 999
COLUMN h13 FORMAT 999
COLUMN h14 FORMAT 999
COLUMN h15 FORMAT 999
COLUMN h16 FORMAT 999
COLUMN h17 FORMAT 999
COLUMN h18 FORMAT 999
COLUMN h19 FORMAT 999
COLUMN h20 FORMAT 999
COLUMN h21 FORMAT 999
COLUMN h22 FORMAT 999
COLUMN h23 FORMAT 999
COLUMN h24 FORMAT 999
BREAK ON REPORT
COMPUTE MAX OF "Total" ON REPORT
COMPUTE MAX OF "h00" ON REPORT
COMPUTE MAX OF "h01" ON REPORT
COMPUTE MAX OF "h02" ON REPORT
COMPUTE MAX OF "h03" ON REPORT
COMPUTE MAX OF "h04" ON REPORT
COMPUTE MAX OF "h05" ON REPORT
COMPUTE MAX OF "h06" ON REPORT
COMPUTE MAX OF "h07" ON REPORT
COMPUTE MAX OF "h08" ON REPORT
COMPUTE MAX OF "h09" ON REPORT
COMPUTE MAX OF "h10" ON REPORT
COMPUTE MAX OF "h11" ON REPORT
COMPUTE MAX OF "h12" ON REPORT
COMPUTE MAX OF "h13" ON REPORT
COMPUTE MAX OF "h14" ON REPORT
COMPUTE MAX OF "h15" ON REPORT
COMPUTE MAX OF "h16" ON REPORT
COMPUTE MAX OF "h17" ON REPORT
COMPUTE MAX OF "h18" ON REPORT
COMPUTE MAX OF "h19" ON REPORT
COMPUTE MAX OF "h20" ON REPORT
COMPUTE MAX OF "h21" ON REPORT
COMPUTE MAX OF "h22" ON REPORT
COMPUTE MAX OF "h23" ON REPORT

SELECT  TRUNC(first_time) AS "Date",
        TO_CHAR(first_time, 'Dy') AS "Day",
        COUNT(1) AS "Total",
        SUM(DECODE(TO_CHAR(first_time, 'HH24'),'00',1,0)) AS "h00",
        SUM(DECODE(TO_CHAR(first_time, 'HH24'),'01',1,0)) AS "h01",
        SUM(DECODE(TO_CHAR(first_time, 'HH24'),'02',1,0)) AS "h02",
        SUM(DECODE(TO_CHAR(first_time, 'HH24'),'03',1,0)) AS "h03",
        SUM(DECODE(TO_CHAR(first_time, 'HH24'),'04',1,0)) AS "h04",
        SUM(DECODE(TO_CHAR(first_time, 'HH24'),'05',1,0)) AS "h05",
        SUM(DECODE(TO_CHAR(first_time, 'HH24'),'06',1,0)) AS "h06",
        SUM(DECODE(TO_CHAR(first_time, 'HH24'),'07',1,0)) AS "h07",
        SUM(DECODE(TO_CHAR(first_time, 'HH24'),'08',1,0)) AS "h08",
        SUM(DECODE(TO_CHAR(first_time, 'HH24'),'09',1,0)) AS "h09",
        SUM(DECODE(TO_CHAR(first_time, 'HH24'),'10',1,0)) AS "h10",
        SUM(DECODE(TO_CHAR(first_time, 'HH24'),'11',1,0)) AS "h11",
        SUM(DECODE(TO_CHAR(first_time, 'HH24'),'12',1,0)) AS "h12",
        SUM(DECODE(TO_CHAR(first_time, 'HH24'),'13',1,0)) AS "h13",
        SUM(DECODE(TO_CHAR(first_time, 'HH24'),'14',1,0)) AS "h14",
        SUM(DECODE(TO_CHAR(first_time, 'HH24'),'15',1,0)) AS "h15",
        SUM(DECODE(TO_CHAR(first_time, 'HH24'),'16',1,0)) AS "h16",
        SUM(DECODE(TO_CHAR(first_time, 'HH24'),'17',1,0)) AS "h17",
        SUM(DECODE(TO_CHAR(first_time, 'HH24'),'18',1,0)) AS "h18",
        SUM(DECODE(TO_CHAR(first_time, 'HH24'),'19',1,0)) AS "h19",
        SUM(DECODE(TO_CHAR(first_time, 'HH24'),'20',1,0)) AS "h20",
        SUM(DECODE(TO_CHAR(first_time, 'HH24'),'21',1,0)) AS "h21",
        SUM(DECODE(TO_CHAR(first_time, 'HH24'),'22',1,0)) AS "h22",
        SUM(DECODE(TO_CHAR(first_time, 'HH24'),'23',1,0)) AS "h23"
FROM    v$log_history
WHERE   thread# = 1
GROUP BY TRUNC(first_time), TO_CHAR(first_time, 'Dy')
ORDER BY 1;
CLEAR BREAKS

ALTER SESSION SET NLS_DATE_FORMAT='DD/MM/YYYY HH24:MI:SS';