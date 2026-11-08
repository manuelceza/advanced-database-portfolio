# Ardeliah Clinical System — ER diagram

```mermaid
erDiagram
    direction LR
    patients {
        bigint patient_id PK
        text patient_code UK
        date birth_date
        boolean active
    }
    clinicians {
        bigint clinician_id PK
        text clinician_code UK
        text specialty
        boolean active
    }
    appointments {
        bigint appointment_id PK
        bigint patient_id FK
        bigint clinician_id FK
        timestamptz starts_at
        text status
        text reason "Optional"
    }
    lab_results {
        bigint result_id PK
        bigint appointment_id FK
        text test_code
        date recorded_on
        text result_value
        boolean abnormal
    }
    patients ||--o{ appointments : "patient_id"
    clinicians ||--o{ appointments : "clinician_id"
    appointments ||--o{ lab_results : "appointment_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Olawuyi_Emmanuel_370192849_ERDiagram.png)
