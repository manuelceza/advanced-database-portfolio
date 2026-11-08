# Ardeliah Clinical System — SQL queries

## 1. Find patients records where patient_code matches "PAT-001" (up to 20).

```sql
SELECT * FROM portfolio."patients"
WHERE "patient_code" IS NOT DISTINCT FROM 'PAT-001'
ORDER BY "patient_id"
LIMIT 20;
```

| patient_id | patient_code | birth_date | active |
| --- | --- | --- | --- |
| 101 | PAT-001 | 1985-04-12 | true |

## 2. Show related appointments, clinicians, patients records (up to 20).

```sql
SELECT t0."appointment_id" AS "appointments_appointment_id",
       t0."starts_at" AS "appointments_starts_at",
       t2."clinician_id" AS "clinicians_clinician_id",
       t2."clinician_code" AS "clinicians_clinician_code",
       t1."patient_id" AS "patients_patient_id",
       t1."patient_code" AS "patients_patient_code"
FROM portfolio."appointments" t0
JOIN portfolio."patients" t1 ON t0."patient_id" = t1."patient_id"
JOIN portfolio."clinicians" t2 ON t0."clinician_id" = t2."clinician_id"
ORDER BY t0."appointment_id", t2."clinician_id", t1."patient_id"
LIMIT 20;
```

| appointments_appointment_id | appointments_starts_at | clinicians_clinician_id | clinicians_clinician_code | patients_patient_id | patients_patient_code |
| --- | --- | --- | --- | --- | --- |
| 301 | 2026-12-01T09:00:00+00:00 | 201 | CLN-001 | 101 | PAT-001 |
| 302 | 2026-12-02T10:30:00+00:00 | 201 | CLN-001 | 101 | PAT-001 |

## 3. Count lab_results records for each appointment_id (up to 20 groups).

```sql
SELECT "appointment_id", count(*) AS record_count
FROM portfolio."lab_results"
GROUP BY "appointment_id"
ORDER BY record_count DESC, "appointment_id" NULLS LAST
LIMIT 20;
```

| appointment_id | record_count |
| --- | --- |
| 301 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 1.018 | 1.005, 1.018, 1.703 | Sort → Seq Scan | 112 |
| After index | 0.174 | 0.172, 0.194, 0.174 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 25 |

The median execution time changed from 1.018 ms to 0.174 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=0.98..0.982 rows=20 loops=1)
  Seq Scan on appointments (actual time=0.018..0.946 rows=20 loops=1)
Planning Time: 0.323 ms
Execution Time: 1.005 ms
```

### Before index, run 2

```text
Sort (actual time=0.992..0.993 rows=20 loops=1)
  Seq Scan on appointments (actual time=0.019..0.958 rows=20 loops=1)
Planning Time: 0.346 ms
Execution Time: 1.018 ms
```

### Before index, run 3

```text
Sort (actual time=1.668..1.67 rows=20 loops=1)
  Seq Scan on appointments (actual time=0.026..1.623 rows=20 loops=1)
Planning Time: 0.465 ms
Execution Time: 1.703 ms
```

### After index, run 1

```text
Sort (actual time=0.124..0.125 rows=20 loops=1)
  Bitmap Heap Scan on appointments (actual time=0.029..0.09 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.013..0.013 rows=20 loops=1)
Planning Time: 0.562 ms
Execution Time: 0.172 ms
```

### After index, run 2

```text
Sort (actual time=0.142..0.144 rows=20 loops=1)
  Bitmap Heap Scan on appointments (actual time=0.047..0.109 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.013..0.013 rows=20 loops=1)
Planning Time: 0.545 ms
Execution Time: 0.194 ms
```

### After index, run 3

```text
Sort (actual time=0.126..0.127 rows=20 loops=1)
  Bitmap Heap Scan on appointments (actual time=0.03..0.092 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.013..0.013 rows=20 loops=1)
Planning Time: 0.537 ms
Execution Time: 0.174 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Olawuyi_Emmanuel_370192849_P2_Queries.sql, then Olawuyi_Emmanuel_370192849_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/P2_QueryResults.png) · [Index comparison](screenshots/P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

