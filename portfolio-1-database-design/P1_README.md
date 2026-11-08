# Portfolio 1: Database Design and Modelling

I organised the data into patients, clinicians, appointments, lab_results. The design document explains the fields, keys, relationships and business rules. The normalisation document shows the sample tables at 1NF, 2NF and 3NF.

## Database checks

| Table | Rows |
| --- | --- |
| patients | 1 |
| clinicians | 1 |
| appointments | 2 |
| lab_results | 1 |

The 30 invalid inserts were rejected at their expected constraints, and the valid sample rows remained unchanged.

## Files

- [Design](P1_Design.md)
- [ER diagram](Olawuyi_Emmanuel_370192849_P1_ERDiagram.md)
- [Normalisation](Olawuyi_Emmanuel_370192849_P1_Normalisation.md)
- [Schema](Olawuyi_Emmanuel_370192849_P1_Schema.sql)
- [Sample data](Olawuyi_Emmanuel_370192849_P1_SampleData.sql)
- [Constraint tests](Olawuyi_Emmanuel_370192849_P1_ConstraintTests.sql)
- [Table and constraint evidence](screenshots/Olawuyi_Emmanuel_370192849_P1_DatabaseResults.png)

## Run the SQL

Create a fresh PostgreSQL database. Run the schema first, then the sample data. Run the deliberately invalid statements in ConstraintTests.sql individually outside a transaction; each is expected to produce an error.

## References

- [PostgreSQL — constraints](https://www.postgresql.org/docs/17/ddl-constraints.html)

