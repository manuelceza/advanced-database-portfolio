-- Find patients records where patient_code matches "PAT-001" (up to 20).
SELECT * FROM portfolio."patients"
WHERE "patient_code" IS NOT DISTINCT FROM 'PAT-001'
ORDER BY "patient_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."patients"
WHERE "patient_code" IS NOT DISTINCT FROM 'PAT-001'
ORDER BY "patient_id"
LIMIT 20;

-- Show related appointments, clinicians, patients records (up to 20).
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

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
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

-- Count lab_results records for each appointment_id (up to 20 groups).
SELECT "appointment_id", count(*) AS record_count
FROM portfolio."lab_results"
GROUP BY "appointment_id"
ORDER BY record_count DESC, "appointment_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "appointment_id", count(*) AS record_count
FROM portfolio."lab_results"
GROUP BY "appointment_id"
ORDER BY record_count DESC, "appointment_id" NULLS LAST
LIMIT 20;
