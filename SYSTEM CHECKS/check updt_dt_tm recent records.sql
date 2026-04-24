-- Query 2: Inspect a few recent raw values compared to the current system times
-- This helps visually confirm if the raw data aligns with UTC or Local time.
SELECT * FROM (
    SELECT 
        UPDT_DT_TM AS RAW_STORED_VALUE,
        SYS_EXTRACT_UTC(SYSTIMESTAMP) AS CURRENT_DB_UTC_TIME,
        SYSTIMESTAMP AS CURRENT_DB_LOCAL_TIME
    FROM WESTERNHEALTH_P2031.ORDERS
    ORDER BY UPDT_DT_TM DESC
) WHERE ROWNUM <= 5;
