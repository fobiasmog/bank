# README

## Assumptions
1. Each client make (in average) 5-10 transactions per day
2. Deadlocks on transactions is possible, and not very often (see 1.)
3. Instead of "Transactions" table we'll be use something write optimized (Cassandra)
4. Possible hard issue: outage between transaction commit and writing to transactions log DB
5. In "Transactions" table I didnt made ID columnn with UUID type, because if you'll create new database, you should turn some flag on in PG, so its KISS :)

## TODOs
* [ ] constraints, indexes, not nulls
* [ ] specs
* [ ] ui
* [ ] rake for user creation
* [ ] rake for user credit

## Auth0 vs Devise motivation
...
