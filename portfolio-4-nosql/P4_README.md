# Portfolio 4 — NoSQL and Advanced Data Models

I used MongoDB collection appointment_events for appointment_booked and appointment_rescheduled events. These are fictional event examples based on appointments, patients, clinicians, lab_results.

## Document model

| Field | Meaning |
| --- | --- |
| _id | Unique string event ID |
| eventType | One of the two selected case event labels |
| occurredAt | Native BSON Date; sample timestamps are in 2030 |
| source | Original entity, primary key and saved JSON snapshot |
| embedded | Linked record snapshots read with the event |
| references | Keys for linked sources kept outside the embedded snapshots |
| details | Event metadata whose fields vary |

Related patients, clinicians details are stored as snapshots with the event. This makes an event readable in one document. It duplicates some information, and later SQL changes do not automatically update the snapshots. PostgreSQL continues to enforce the relational rules.

## Example document

```javascript
{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "appointment_booked",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "lab_results",
        "key": {
            "result_id": 401
        },
        "snapshot": {
            "result_id": 401,
            "appointment_id": 301,
            "test_code": "CBC",
            "recorded_on": "2026-12-01",
            "result_value": "Within range",
            "abnormal": false
        }
    },
    "embedded": {
        "patients": [
            {
                "key": {
                    "patient_id": 101
                },
                "snapshot": {
                    "patient_id": 101,
                    "patient_code": "PAT-001",
                    "birth_date": "1985-04-12",
                    "active": true
                },
                "via": [
                    "lab_results.appointment_id → appointments.patient_id → patients"
                ]
            }
        ],
        "clinicians": [
            {
                "key": {
                    "clinician_id": 201
                },
                "snapshot": {
                    "clinician_id": 201,
                    "clinician_code": "CLN-001",
                    "specialty": "Cardiology",
                    "active": true
                },
                "via": [
                    "lab_results.appointment_id → appointments.clinician_id → clinicians"
                ]
            }
        ]
    },
    "references": {
        "appointments": [
            {
                "key": {
                    "appointment_id": 301
                },
                "via": [
                    "lab_results.appointment_id → appointments"
                ]
            }
        ]
    },
    "details": {
        "channel": "web"
    }
}
```

## Queries and results

| Query | Returned documents |
| --- | --- |
| Find the first sample event type (up to five documents). | 1 |
| Find events for the first source record using nested key fields (up to five). | 2 |
| Find events in the sample time range using a MongoDB Date filter (up to five). | 2 |
| Count documents for each event type. | 2 |

## 1. Find the first sample event type (up to five documents).

```javascript
db.getCollection("appointment_events").find({"eventType":"appointment_booked"}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "appointment_booked",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "result_id": 401
    }
  }
]
```

## 2. Find events for the first source record using nested key fields (up to five).

```javascript
db.getCollection("appointment_events").find({"source.key.result_id":401}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "appointment_booked",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "result_id": 401
    }
  },
  {
    "_id": "event_000002",
    "eventType": "appointment_rescheduled",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "result_id": 401
    }
  }
]
```

## 3. Find events in the sample time range using a MongoDB Date filter (up to five).

```javascript
db.getCollection("appointment_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "appointment_booked",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "result_id": 401
    }
  },
  {
    "_id": "event_000002",
    "eventType": "appointment_rescheduled",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "result_id": 401
    }
  }
]
```

## 4. Count documents for each event type.

```javascript
db.getCollection("appointment_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray();
```

| _id | documentCount |
| --- | --- |
| appointment_booked | 1 |
| appointment_rescheduled | 1 |


## References

- [MongoDB — data modelling](https://www.mongodb.com/docs/manual/data-modeling/)

