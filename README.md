# Oracle-Health-Analytics-Queries

A repository of SQL queries and scripts designed for **Oracle Health Data Intelligence (HDI)** and **Oracle Analytics Cloud (OAC)** platforms. 

These queries are built to run against mirrors of the Cerner Millennium database (using the `WESTERNHEALTH_P2031` schema).

## Overview

This repository serves as a centralized location for:
- Reporting queries and analytics specifically tailored for HDI/OAC.
- System checks and order monitoring queries.
- Examples of timestamp handling, timezone conversions, and database-specific dialect requirements.

## CCL to SQL Conversion

If you are migrating legacy Cerner Command Language (CCL) reports to standard Oracle SQL for HDI/OAC, please refer to our **[CCL to SQL Conversion Guide](CCL_TO_SQL_CONVERSION_GUIDE.md)**. 

The guide covers important concepts such as:
- Schema and table name prefixing.
- Properly casting UTC database timestamps to local time zones (e.g., `Australia/Melbourne`).
- Refactoring `UAR_GET_CODE_DISPLAY()` function calls into proper relational `LEFT JOIN`s against the `CODE_VALUE` table.
- Translating proprietary CCL `OUTERJOIN()` syntax and wildcards.
