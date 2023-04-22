# README

## Simplifications
1. Each client can have only one account
2. Limit-offset pagination for transactions and clients list -- but sometimes it's not relevant (depends on the business case)

## Assumptions
1. Each client makes (on average) 5-10 transactions per day -- it's not a stock exchange :D
2. Deadlocks on transactions is possible, and not very often (see 1.)

## External services
1. For test purposes I'm using AWS RDS Postgres (you can use it too, I didn't hide credentials. It was done purposely for the test task)
2. For authenticating I'm using Auth0. Two reasons for this: you don't need to store sensitive data and I find these tools very useful either on the MVP stage and on the scale

## Scale
1. Instead of the "Transactions" table is better to use something write-optimized (NoSQL like Cassandra)
2. Make money swaps in an async way. In that way, we need:
    - 2.1 Create an additional transaction state, like 'processing'
    - 2.2 Make the Frontend to be able to show 'processing' transactions and receive some updates (via websocket for example)
3. Handle possible hard issue: outage between transaction commit and writing to transactions log DB (logging on very beginning of request)

## Solution
### MVP (current schema)
![](bank.png)

### Scale
![](bank_scale.png)



## TODOs
* [ ] constraints, indexes, not nulls
* [x] specs
* [ ] ui
* [ ] rake for user creation
* [ ] rake for user credit

## Auth0 vs Devise motivation
...
