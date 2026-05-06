# CCL to SQL Conversion Guide

This guide is intended for developers and AI assistants (LLMs) converting Cerner CCL (Cerner Command Language) queries into standard Oracle SQL within this repository. 

When performing conversions, please adhere to the following database-specific conventions and patterns.

## 1. Schema and Table Names
All Cerner database tables must be prefixed with the schema name `WESTERNHEALTH_P2031.`.
* **CCL Example**: `FROM ORDERS O`
* **SQL Example**: `FROM WESTERNHEALTH_P2031.ORDERS O`

## 2. Timestamps and Timezones
The database stores times in UTC, but reporting often requires the local timezone (`Australia/Melbourne`). 

**Selecting Timestamps:**
Always apply the `AT TIME ZONE` conversion and format the output as `YYYY-MM-DD HH24:MI:SS`.
```sql
-- SQL Example
SELECT 
    TO_CHAR(
        C_E.PERFORMED_DT_TM AT TIME ZONE 'Australia/Melbourne', 
        'YYYY-MM-DD HH24:MI:SS'
    ) AS COMPLETED
FROM WESTERNHEALTH_P2031.CLINICAL_EVENT C_E
```

**Filtering Timestamps (Static):**
Cast both sides appropriately to handle timezones.
```sql
-- SQL Example
WHERE CAST(C_E.PERFORMED_DT_TM AT TIME ZONE 'Australia/Melbourne' AS TIMESTAMP) 
      >= TO_TIMESTAMP('2024-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS')
```

**Filtering Timestamps (Dynamic/Relative):**
When converting relative time prompts (e.g., "last 2 months"), use `SYSTIMESTAMP` with `ADD_MONTHS` or `INTERVAL` while preserving the timezone cast.
```sql
-- SQL Example
WHERE CAST(C_E.PERFORMED_DT_TM AT TIME ZONE 'Australia/Melbourne' AS TIMESTAMP) 
      >= ADD_MONTHS(CAST(SYSTIMESTAMP AT TIME ZONE 'Australia/Melbourne' AS TIMESTAMP), -2)
```

## 3. Code Value Lookups (`UAR_GET_CODE_DISPLAY`)
CCL heavily relies on the `UAR_GET_CODE_DISPLAY(code_id)` function to get human-readable names for codes. In SQL, this must be translated into a `LEFT JOIN` on the `CODE_VALUE` table.

* **CCL Example**: 
  ```ccl
  SELECT PATIENT_SEX = UAR_GET_CODE_DISPLAY(P.SEX_CD)
  FROM PERSON P
  ```
* **SQL Translation**:
  ```sql
  SELECT CV_SEX.DISPLAY AS PATIENT_SEX
  FROM WESTERNHEALTH_P2031.PERSON P
  LEFT JOIN WESTERNHEALTH_P2031.CODE_VALUE CV_SEX 
      ON CV_SEX.CODE_VALUE = P.SEX_CD
  ```
*(Note: Be sure to use unique table aliases like `CV_SEX`, `CV_FACILITY` when joining the `CODE_VALUE` table multiple times in the same query).*

## 4. Outer Joins
CCL uses a proprietary `OUTERJOIN(table.column)` function within the `WHERE` clause. This should be refactored into a standard ANSI `LEFT JOIN ... ON` in SQL.

* **CCL Example**:
  ```ccl
  FROM CLINICAL_EVENT C_E, CE_MED_RESULT C_M_R
  WHERE C_M_R.EVENT_ID = OUTERJOIN(C_E.EVENT_ID)
  ```
* **SQL Translation**:
  ```sql
  FROM WESTERNHEALTH_P2031.CLINICAL_EVENT C_E
  LEFT JOIN WESTERNHEALTH_P2031.CE_MED_RESULT C_M_R 
      ON C_M_R.EVENT_ID = C_E.EVENT_ID
  ```

## 5. String Wildcards
CCL uses asterisks `*` for wildcard string matching. Translate these to `%` when converting to SQL `LIKE` or `NOT LIKE`.

* **CCL Example**: `WHERE P.NAME_LAST_KEY != "*TESTWHS*"`
* **SQL Translation**: `WHERE P.NAME_LAST_KEY NOT LIKE '%TESTWHS%'`

## 6. Proprietary Date Functions
CCL functions like `DATEBIRTHFORMAT()` or `CNVTDATETIME()` should be translated to standard Oracle SQL `TO_CHAR()` and `TO_DATE()` / `TO_TIMESTAMP()` functions.

* **CCL Example**: `DATEBIRTHFORMAT(P.BIRTH_DT_TM, P.BIRTH_TZ, P.BIRTH_PREC_FLAG, "DD-MMM-YYYY")`
* **SQL Translation**: `TO_CHAR(P.BIRTH_DT_TM, 'DD-MON-YYYY')`
