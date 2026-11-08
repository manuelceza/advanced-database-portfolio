// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("appointment_events")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("appointment_events", {
    validator: {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "_id",
            "schemaVersion",
            "simulation",
            "eventType",
            "occurredAt",
            "source",
            "embedded",
            "references",
            "details"
        ],
        "properties": {
            "_id": {
                "bsonType": "string",
                "minLength": 1
            },
            "schemaVersion": {
                "enum": [
                    1
                ]
            },
            "simulation": {
                "enum": [
                    true
                ]
            },
            "eventType": {
                "bsonType": "string",
                "enum": [
                    "appointment_booked",
                    "appointment_rescheduled"
                ]
            },
            "occurredAt": {
                "bsonType": "date"
            },
            "source": {
                "bsonType": "object",
                "required": [
                    "entity",
                    "key",
                    "snapshot"
                ],
                "properties": {
                    "entity": {
                        "enum": [
                            "lab_results"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "result_id"
                        ]
                    },
                    "snapshot": {
                        "bsonType": "object"
                    }
                }
            },
            "embedded": {
                "bsonType": "object"
            },
            "references": {
                "bsonType": "object"
            },
            "details": {
                "bsonType": "object"
            }
        }
    }
},
    validationLevel: 'strict', validationAction: 'error'
  });

  // Insert the four example events and show their IDs.
  printjson(await db.getCollection("appointment_events").insertMany([
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
    },
    {
        "_id": "event_000002",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "appointment_rescheduled",
        "occurredAt": ISODate("2030-01-01T10:01:00Z"),
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
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "attributes": [
                {
                    "entity": "lab_results",
                    "key": {
                        "result_id": 401
                    },
                    "field": "result_value",
                    "value": "Within range"
                },
                {
                    "entity": "lab_results",
                    "key": {
                        "result_id": 401
                    },
                    "field": "abnormal",
                    "value": false
                },
                {
                    "entity": "appointments",
                    "key": {
                        "appointment_id": 301
                    },
                    "field": "reason",
                    "value": "Follow-up"
                }
            ]
        }
    }
]));
  await db.getCollection("appointment_events").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("appointment_events").find({"eventType":"appointment_booked"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("appointment_events").find({"source.key.result_id":401}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("appointment_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("appointment_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("appointment_events").insertOne({...{
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
}, _id: 'invalid_date_example', occurredAt: 'not-a-date'});
  } catch (error) { print('Invalid date error: ' + error.code); }

  // Reusing an event ID should be rejected by the unique _id index.
  try { await db.getCollection("appointment_events").insertOne({
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
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("appointment_events").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });
