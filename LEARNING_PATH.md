# Learning Path

The order is intentional.

## 00 — Practice Database
This is environment setup, not the first learning topic.

The setup script creates:
- Customers
- Products
- Orders

You can run it once and then focus on querying.

## Week 1 — Fundamentals
You first learn how to retrieve, filter, sort and transform individual rows.

No joins, grouping, CTEs or window functions are required.

## Week 2 — Aggregation
Once individual rows make sense, you learn to answer questions about groups of rows:
- how many?
- how much?
- average?
- maximum?
- which groups meet a condition?

## Week 3 — Relationships
Only after single-table querying and aggregation are comfortable do we expand the database with:
- Payments
- Returns

This gives a reason to learn JOINs rather than learning JOIN syntax in isolation.

## Week 4 — Analytical SQL
Subqueries and CTEs are introduced after normal SELECT/JOIN/GROUP BY queries.

Window functions come after grouping because it is easier to understand the key difference:

- GROUP BY reduces many rows into grouped rows.
- Window functions keep row detail while calculating across related rows.

## Week 5 — Reusable SQL
Views, procedures and functions package logic that you already understand.

Indexes come near the end because index design becomes meaningful only after you understand:
- filters
- joins
- ordering
- repeated access patterns

## Final Project
The Fraud Risk project combines the same ideas in a new domain, rather than introducing an entirely different set of SQL concepts.
