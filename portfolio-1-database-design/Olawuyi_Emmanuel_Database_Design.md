# Ardeliah Clinical System database design

My case study records patients, clinicians, appointments, lab_results.

## Users

- Patients
- Doctors and physicians
- Receptionists and administrative staff
- Laboratory technicians

## Main operations

- Book and manage outpatient appointments
- Record patient and clinician details
- Record laboratory results linked to appointments

## Entities

| Entity | Information stored |
| --- | --- |
| patients | Stores the minimum synthetic patient details needed to associate outpatient appointments. |
| clinicians | Stores synthetic outpatient clinician identifiers and specialties. |
| appointments | Stores scheduled outpatient visits and links each visit to one patient and one clinician. |
| lab_results | Stores synthetic laboratory results associated with outpatient appointments. |

## patients

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| patient_id | BIGINT | PK | Yes |
| patient_code | TEXT | Unique | Yes |
| birth_date | DATE |  | Yes |
| active | BOOLEAN |  | Yes |
- Unique key: (patient_code).

## clinicians

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| clinician_id | BIGINT | PK | Yes |
| clinician_code | TEXT | Unique | Yes |
| specialty | TEXT |  | Yes |
| active | BOOLEAN |  | Yes |
- Unique key: (clinician_code).

## appointments

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| appointment_id | BIGINT | PK | Yes |
| patient_id | BIGINT | FK | Yes |
| clinician_id | BIGINT | FK | Yes |
| starts_at | TIMESTAMPTZ |  | Yes |
| status | TEXT |  | Yes |
| reason | TEXT |  | No |
- patient_id → patients.patient_id
- clinician_id → clinicians.clinician_id

## lab_results

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| result_id | BIGINT | PK | Yes |
| appointment_id | BIGINT | FK | Yes |
| test_code | TEXT |  | Yes |
| recorded_on | DATE |  | Yes |
| result_value | TEXT |  | Yes |
| abnormal | BOOLEAN |  | Yes |
- appointment_id → appointments.appointment_id

## Relationships and business rules

- Appointment status must be booked, completed, or cancelled.
- A clinician may have at most one booked appointment at a given start time; enforce with a partial unique index on clinician_id and starts_at where status is booked.
- Every appointment must reference an existing patient.
- Every appointment must reference an existing clinician.
- Every laboratory result must reference an existing appointments.

## Assumptions

- Each appointment has exactly one patient and one clinician.
- A laboratory result in this exercise is linked to an appointment; a separate lab-request workflow is out of scope.
- Consultation notes, diagnoses, and electronic prescriptions are out of scope for this intentionally small schema.
- All identifiers and records used in examples are synthetic; student names and IDs are omitted. Primary-key values are unique across the modeled entities.

