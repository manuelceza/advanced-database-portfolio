# Ardeliah Clinical System — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| appointment_id | lab_results records (list) |
| --- | --- |
| 301 | [401] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| lab_results.result_id | lab_results.appointment_id | lab_results.test_code | appointments.appointment_id | appointments.patient_id | appointments.clinician_id | appointments.status | patients.patient_id |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 401 | 301 | CBC | 301 | 101 | 201 | booked | 101 |

Key: result_id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## lab_results_example

| lab_results.result_id | lab_results.appointment_id | lab_results.test_code | appointments.appointment_id | appointments.patient_id | appointments.clinician_id | appointments.status | patients.patient_id |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 401 | 301 | CBC | 301 | 101 | 201 | booked | 101 |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## patients

| patient_id | patient_code | birth_date | active |
| --- | --- | --- | --- |
| 101 | PAT-001 | 1985-04-12 | true |

## clinicians

| clinician_id | clinician_code | specialty | active |
| --- | --- | --- | --- |
| 201 | CLN-001 | Cardiology | true |

## appointments

| appointment_id | patient_id | clinician_id | starts_at | status | reason |
| --- | --- | --- | --- | --- | --- |
| 301 | 101 | 201 | 2026-12-01T09:00:00+00:00 | booked | Follow-up |
| 302 | 101 | 201 | 2026-12-02T10:30:00+00:00 | completed | NULL |

## lab_results

| result_id | appointment_id | test_code | recorded_on | result_value | abnormal |
| --- | --- | --- | --- | --- | --- |
| 401 | 301 | CBC | 2026-12-01 | Within range | false |

## Dependencies

- patients: (patient_id) → patient_code, birth_date, active
- clinicians: (clinician_id) → clinician_code, specialty, active
- appointments: (appointment_id) → patient_id, clinician_id, starts_at, status, reason
- lab_results: (result_id) → appointment_id, test_code, recorded_on, result_value, abnormal

Joining the decomposed sample tables reproduces the original 1 example rows. The design assumes the declared keys describe the relevant business dependencies.
