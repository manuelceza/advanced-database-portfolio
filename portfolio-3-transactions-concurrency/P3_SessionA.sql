
-- 1. Session A: read 1.
BEGIN ISOLATION LEVEL READ COMMITTED;
SELECT "appointment_id", "p3_processed_count" FROM portfolio."appointments" WHERE "appointment_id" IS NOT DISTINCT FROM 301;

-- 3. Session A: write the value calculated from its earlier read.
UPDATE portfolio."appointments" SET "p3_processed_count" = 2 WHERE "appointment_id" IS NOT DISTINCT FROM 301 RETURNING json_build_object('processed_count',"p3_processed_count");
COMMIT;

-- 5. Reset for an equal starting point. Run outside both transactions.
UPDATE portfolio."appointments" SET "p3_processed_count" = 1 WHERE "appointment_id" IS NOT DISTINCT FROM 301 RETURNING json_build_object('processed_count',"p3_processed_count");

-- 6. Session A: lock the row before reading.
BEGIN ISOLATION LEVEL READ COMMITTED;
SELECT "appointment_id", "p3_processed_count" FROM portfolio."appointments" WHERE "appointment_id" IS NOT DISTINCT FROM 301 FOR UPDATE;

-- 8. Session A: update and release the lock by committing.
UPDATE portfolio."appointments" SET "p3_processed_count" = 2 WHERE "appointment_id" IS NOT DISTINCT FROM 301 RETURNING json_build_object('processed_count',"p3_processed_count");
COMMIT;
