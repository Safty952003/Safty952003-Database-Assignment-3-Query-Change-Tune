# LMS Training Lab — Query, Change & Tune Data

## Student Information

- **Name:** Mahmoud Mohamed Mahmoud Elsafty
- **Group:** [G1]

This repository contains my work on the **LmsTrainingLab** SQL Server database—practicing how a backend developer translates business requests into reliable T-SQL queries, performs safe data updates with audit trails, and diagnoses and tunes slow queries using execution plans.

## Overview

Working across schemas such as `[academic]`, `[delivery]`, `[identity]`, `[finance]`, and `[communication]`, the repository covers three main areas:

* **Business Reporting & Data Retrieval:** Writing readable, single-table reporting queries covering filtering, string and phone masking, date/time-zone handling, pagination (offset and keyset), ranking (`TOP`, `WITH TIES`, `PERCENT`), and grouped summaries—without relying on joins or subqueries where restricted.
* **Safe Data Changes, Auditing & Synchronization:** Setting up new academic structures, generating table-independent sequence numbers, bulk-copying term timetables, applying transactional end-of-semester updates, capturing change history and archives in single statements via `OUTPUT ... INTO`, and running an idempotent catalog sync using `MERGE`.
* **Execution Plan Analysis & Query Tuning:** Reading actual execution plans and `STATISTICS IO / TIME`, identifying non-SARGable filters, implicit conversions, parameter-sniffing edge cases, `tempdb` sort spills, and duplicate-removal costs, and evaluating primary key design trade-offs (`INT` vs. `GUID`).

## Repository Contents

* **SQL Scripts (`.sql`):** Organized solutions implementing the reporting, data modification, auditing, and performance-tuning exercises.
* **`NOTES.md`:** Written explanations covering execution plan operators, performance before/after comparisons, design trade-offs, and verification notes.
* **Screenshots:** Captures of actual execution plans, operator properties, and `STATISTICS IO / TIME` outputs supporting the analysis.

## Workflow & Practices

* Changes to live data are tested inside explicit transactions (`BEGIN TRAN`) and verified before committing or rolling back.
* Performance improvements are validated by comparing actual execution plans, warnings, and logical reads before and after rewriting queries.
* Sync and audit operations are designed to be single-statement and repeatable without unintended side effects.
