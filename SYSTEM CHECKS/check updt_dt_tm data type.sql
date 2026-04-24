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
