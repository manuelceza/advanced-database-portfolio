-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. patients pk duplicate. Expected: pk_patients, SQLSTATE 23505.
INSERT INTO portfolio."patients" ("patient_id", "patient_code", "birth_date", "active")
VALUES (101, 'PAT-PK-TEST', '1985-04-12', TRUE);

-- 2. patients unique duplicate. Expected: uq_patients_0, SQLSTATE 23505.
INSERT INTO portfolio."patients" ("patient_id", "patient_code", "birth_date", "active")
VALUES (1301, 'PAT-001', '1985-04-12', TRUE);

-- 3. patients null id. Expected: patient_id, SQLSTATE 23502.
INSERT INTO portfolio."patients" ("patient_id", "patient_code", "birth_date", "active")
VALUES (NULL, 'PAT-NN-01', '1985-04-12', TRUE);

-- 4. patients null code. Expected: patient_code, SQLSTATE 23502.
INSERT INTO portfolio."patients" ("patient_id", "patient_code", "birth_date", "active")
VALUES (1102, NULL, '1985-04-12', TRUE);

-- 5. patients null birth date. Expected: birth_date, SQLSTATE 23502.
INSERT INTO portfolio."patients" ("patient_id", "patient_code", "birth_date", "active")
VALUES (1103, 'PAT-NN-03', NULL, TRUE);

-- 6. patients null active. Expected: active, SQLSTATE 23502.
INSERT INTO portfolio."patients" ("patient_id", "patient_code", "birth_date", "active")
VALUES (1104, 'PAT-NN-04', '1985-04-12', NULL);

-- 7. clinicians pk duplicate. Expected: pk_clinicians, SQLSTATE 23505.
INSERT INTO portfolio."clinicians" ("clinician_id", "clinician_code", "specialty", "active")
VALUES (201, 'CLN-PK-TEST', 'Neurology', TRUE);

-- 8. clinicians unique duplicate. Expected: uq_clinicians_0, SQLSTATE 23505.
INSERT INTO portfolio."clinicians" ("clinician_id", "clinician_code", "specialty", "active")
VALUES (1302, 'CLN-001', 'Neurology', TRUE);

-- 9. clinicians null id. Expected: clinician_id, SQLSTATE 23502.
INSERT INTO portfolio."clinicians" ("clinician_id", "clinician_code", "specialty", "active")
VALUES (NULL, 'CLN-NN-01', 'Neurology', TRUE);

-- 10. clinicians null code. Expected: clinician_code, SQLSTATE 23502.
INSERT INTO portfolio."clinicians" ("clinician_id", "clinician_code", "specialty", "active")
VALUES (1112, NULL, 'Neurology', TRUE);

-- 11. clinicians null specialty. Expected: specialty, SQLSTATE 23502.
INSERT INTO portfolio."clinicians" ("clinician_id", "clinician_code", "specialty", "active")
VALUES (1113, 'CLN-NN-03', NULL, TRUE);

-- 12. clinicians null active. Expected: active, SQLSTATE 23502.
INSERT INTO portfolio."clinicians" ("clinician_id", "clinician_code", "specialty", "active")
VALUES (1114, 'CLN-NN-04', 'Neurology', NULL);

-- 13. appointments pk duplicate. Expected: pk_appointments, SQLSTATE 23505.
INSERT INTO portfolio."appointments" ("appointment_id", "patient_id", "clinician_id", "starts_at", "status", "reason")
VALUES (301, 101, 201, '2026-12-03T09:00:00Z', 'booked', 'PK test');

-- 14. appointments patient fk. Expected: fk_appointments_0, SQLSTATE 23503.
INSERT INTO portfolio."appointments" ("appointment_id", "patient_id", "clinician_id", "starts_at", "status", "reason")
VALUES (1201, 9001, 201, '2026-12-03T09:00:00Z', 'booked', 'FK test');

-- 15. appointments clinician fk. Expected: fk_appointments_1, SQLSTATE 23503.
INSERT INTO portfolio."appointments" ("appointment_id", "patient_id", "clinician_id", "starts_at", "status", "reason")
VALUES (1202, 101, 9002, '2026-12-03T09:30:00Z', 'booked', 'FK test');

-- 16. appointments null id. Expected: appointment_id, SQLSTATE 23502.
INSERT INTO portfolio."appointments" ("appointment_id", "patient_id", "clinician_id", "starts_at", "status", "reason")
VALUES (NULL, 101, 201, '2026-12-04T09:00:00Z', 'booked', NULL);

-- 17. appointments null patient. Expected: patient_id, SQLSTATE 23502.
INSERT INTO portfolio."appointments" ("appointment_id", "patient_id", "clinician_id", "starts_at", "status", "reason")
VALUES (1122, NULL, 201, '2026-12-04T09:15:00Z', 'booked', NULL);

-- 18. appointments null clinician. Expected: clinician_id, SQLSTATE 23502.
INSERT INTO portfolio."appointments" ("appointment_id", "patient_id", "clinician_id", "starts_at", "status", "reason")
VALUES (1123, 101, NULL, '2026-12-04T09:30:00Z', 'booked', NULL);

-- 19. appointments null starts at. Expected: starts_at, SQLSTATE 23502.
INSERT INTO portfolio."appointments" ("appointment_id", "patient_id", "clinician_id", "starts_at", "status", "reason")
VALUES (1124, 101, 201, NULL, 'booked', NULL);

-- 20. appointments null status. Expected: status, SQLSTATE 23502.
INSERT INTO portfolio."appointments" ("appointment_id", "patient_id", "clinician_id", "starts_at", "status", "reason")
VALUES (1125, 101, 201, '2026-12-04T09:45:00Z', NULL, NULL);

-- 21. appointments bad status. Expected: appointment_status_check, SQLSTATE 23514.
INSERT INTO portfolio."appointments" ("appointment_id", "patient_id", "clinician_id", "starts_at", "status", "reason")
VALUES (1401, 101, 201, '2026-12-05T09:00:00Z', 'pending', 'Check test');

-- 22. appointments duplicate booked slot. Expected: active_clinician_slot_unique, SQLSTATE 23505.
INSERT INTO portfolio."appointments" ("appointment_id", "patient_id", "clinician_id", "starts_at", "status", "reason")
VALUES (1402, 101, 201, '2026-12-01T09:00:00Z', 'booked', 'Partial unique test');

-- 23. lab results pk duplicate. Expected: pk_lab_results, SQLSTATE 23505.
INSERT INTO portfolio."lab_results" ("result_id", "appointment_id", "test_code", "recorded_on", "result_value", "abnormal")
VALUES (401, 302, 'PK-TEST', '2026-12-02', 'Within range', FALSE);

-- 24. lab results appointment fk. Expected: fk_lab_results_0, SQLSTATE 23503.
INSERT INTO portfolio."lab_results" ("result_id", "appointment_id", "test_code", "recorded_on", "result_value", "abnormal")
VALUES (1203, 9003, 'FK-TEST', '2026-12-03', 'Within range', FALSE);

-- 25. lab results null id. Expected: result_id, SQLSTATE 23502.
INSERT INTO portfolio."lab_results" ("result_id", "appointment_id", "test_code", "recorded_on", "result_value", "abnormal")
VALUES (NULL, 301, 'NN-01', '2026-12-01', 'Within range', FALSE);

-- 26. lab results null appointment. Expected: appointment_id, SQLSTATE 23502.
INSERT INTO portfolio."lab_results" ("result_id", "appointment_id", "test_code", "recorded_on", "result_value", "abnormal")
VALUES (1132, NULL, 'NN-02', '2026-12-01', 'Within range', FALSE);

-- 27. lab results null test code. Expected: test_code, SQLSTATE 23502.
INSERT INTO portfolio."lab_results" ("result_id", "appointment_id", "test_code", "recorded_on", "result_value", "abnormal")
VALUES (1133, 301, NULL, '2026-12-01', 'Within range', FALSE);

-- 28. lab results null recorded on. Expected: recorded_on, SQLSTATE 23502.
INSERT INTO portfolio."lab_results" ("result_id", "appointment_id", "test_code", "recorded_on", "result_value", "abnormal")
VALUES (1134, 301, 'NN-04', NULL, 'Within range', FALSE);

-- 29. lab results null value. Expected: result_value, SQLSTATE 23502.
INSERT INTO portfolio."lab_results" ("result_id", "appointment_id", "test_code", "recorded_on", "result_value", "abnormal")
VALUES (1135, 301, 'NN-05', '2026-12-01', NULL, FALSE);

-- 30. lab results null abnormal. Expected: abnormal, SQLSTATE 23502.
INSERT INTO portfolio."lab_results" ("result_id", "appointment_id", "test_code", "recorded_on", "result_value", "abnormal")
VALUES (1136, 301, 'NN-06', '2026-12-01', 'Within range', NULL);

