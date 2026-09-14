# Practice Database Evolution

## Initial schema

```text
Customers
   |
   +---- Orders ---- Products
```

## Week 3 expansion

```text
Customers
   |
   +---- Orders ---- Products
           |
           +---- Payments
           |
           +---- Returns
```

The added tables make later JOIN, CTE and analytical exercises more realistic without making the schema unnecessarily large.
