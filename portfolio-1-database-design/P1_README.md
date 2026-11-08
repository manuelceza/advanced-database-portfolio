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
- [ER diagram](ERDiagram.md)
- [Normalisation](P1_Normalisation.md)
- [Schema](Schema.sql)
- [Sample data](SampleData.sql)
- [Constraint tests](ConstraintTests.sql)
- [Table and constraint evidence](screenshots/DatabaseResults.png)

## Run the SQL

Create a fresh PostgreSQL database. Run the schema first, then the sample data. Run the deliberately invalid statements in ConstraintTests.sql individually outside a transaction; each is expected to produce an error.

## References

- [PostgreSQL — constraints](https://www.postgresql.org/docs/17/ddl-constraints.html)

