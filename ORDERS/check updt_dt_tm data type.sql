-- Query 1: Check the exact data type in the Oracle data dictionary
-- This will tell you if it's a DATE, TIMESTAMP, or TIMESTAMP WITH TIME ZONE
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    DATA_LENGTH
FROM ALL_TAB_COLUMNS
WHERE OWNER = 'WESTERNHEALTH_P2031' 
  AND TABLE_NAME = 'ORDERS'
  AND COLUMN_NAME = 'UPDT_DT_TM';

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
