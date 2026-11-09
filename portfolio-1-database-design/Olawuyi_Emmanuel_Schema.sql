Ardeliah Clinical System: tables, keys and business constraints.
  
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."patients" (
  "patient_id" bigint NOT NULL,
  "patient_code" text NOT NULL,
  "birth_date" date NOT NULL,
  "active" boolean NOT NULL,
  CONSTRAINT "pk_patients" PRIMARY KEY ("patient_id"),
  CONSTRAINT "uq_patients_0" UNIQUE ("patient_code")
);
CREATE TABLE portfolio."clinicians" (
  "clinician_id" bigint NOT NULL,
  "clinician_code" text NOT NULL,
  "specialty" text NOT NULL,
  "active" boolean NOT NULL,
  CONSTRAINT "pk_clinicians" PRIMARY KEY ("clinician_id"),
  CONSTRAINT "uq_clinicians_0" UNIQUE ("clinician_code")
);
CREATE TABLE portfolio."appointments" (
  "appointment_id" bigint NOT NULL,
  "patient_id" bigint NOT NULL,
  "clinician_id" bigint NOT NULL,
  "starts_at" timestamptz NOT NULL,
  "status" text NOT NULL,
  "reason" text,
  CONSTRAINT "pk_appointments" PRIMARY KEY ("appointment_id")
);
CREATE TABLE portfolio."lab_results" (
  "result_id" bigint NOT NULL,
  "appointment_id" bigint NOT NULL,
  "test_code" text NOT NULL,
  "recorded_on" date NOT NULL,
  "result_value" text NOT NULL,
  "abnormal" boolean NOT NULL,
  CONSTRAINT "pk_lab_results" PRIMARY KEY ("result_id")
);
ALTER TABLE portfolio."appointments" ADD CONSTRAINT "fk_appointments_0" FOREIGN KEY ("patient_id") REFERENCES portfolio."patients" ("patient_id");
ALTER TABLE portfolio."appointments" ADD CONSTRAINT "fk_appointments_1" FOREIGN KEY ("clinician_id") REFERENCES portfolio."clinicians" ("clinician_id");
ALTER TABLE portfolio."lab_results" ADD CONSTRAINT "fk_lab_results_0" FOREIGN KEY ("appointment_id") REFERENCES portfolio."appointments" ("appointment_id");
ALTER TABLE portfolio."appointments" ADD CONSTRAINT "appointment_status_check" CHECK (("status" = 'booked') OR ("status" = 'completed') OR ("status" = 'cancelled'));
CREATE UNIQUE INDEX "active_clinician_slot_unique" ON portfolio."appointments" ("clinician_id", "starts_at") WHERE ("status" = 'booked');
COMMIT;
