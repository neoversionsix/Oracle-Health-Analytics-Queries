SELECT
/*This query is for a rough overview of incoming messages into Cerner EMR*/
	E.MSH_SENDING_APP
	, TO_CHAR(
        E.CREATE_DT_TM AT TIME ZONE 'Australia/Melbourne', 
        'YYYY-MM-DD HH24:MI:SS'
    ) AS CREATED
	, E.ERROR_STAT -- Did it load?
	, E.ERROR_TEXT -- load errors eg no order id
	, E.MSH_MSG_TYPE AS MESSAGE_TYPE

FROM
	WESTERNHEALTH_P2031.ESI_LOG E

WHERE CAST(E.CREATE_DT_TM AT TIME ZONE 'Australia/Melbourne' AS TIMESTAMP) 
      > CAST(SYSTIMESTAMP AT TIME ZONE 'Australia/Melbourne' AS TIMESTAMP) - INTERVAL '3' DAY