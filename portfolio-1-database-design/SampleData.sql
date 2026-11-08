-- Fictional sample records for Ardeliah Clinical System.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."patients" ("patient_id", "patient_code", "birth_date", "active") VALUES (101, 'PAT-001', '1985-04-12', TRUE);
INSERT INTO portfolio."clinicians" ("clinician_id", "clinician_code", "specialty", "active") VALUES (201, 'CLN-001', 'Cardiology', TRUE);
INSERT INTO portfolio."appointments" ("appointment_id", "patient_id", "clinician_id", "starts_at", "status", "reason") VALUES (301, 101, 201, '2026-12-01T09:00:00Z', 'booked', 'Follow-up');
INSERT INTO portfolio."appointments" ("appointment_id", "patient_id", "clinician_id", "starts_at", "status", "reason") VALUES (302, 101, 201, '2026-12-02T10:30:00+00:00', 'completed', NULL);
INSERT INTO portfolio."lab_results" ("result_id", "appointment_id", "test_code", "recorded_on", "result_value", "abnormal") VALUES (401, 301, 'CBC', '2026-12-01', 'Within range', FALSE);
COMMIT;
