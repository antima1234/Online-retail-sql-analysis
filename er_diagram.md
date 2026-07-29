# Entity-Relationship Diagram — Online Retail Sales Database

This diagram uses [Mermaid](https://mermaid.js.org/) syntax, which
renders automatically in GitHub's Markdown preview.

```mermaid
erDiagram
    CUSTOMERS ||--o{ ORDERS : places
    ORDERS ||--o{ ORDER_ITEMS : contains
    PRODUCTS ||--o{ ORDER_ITEMS : "appears in"

    CUSTOMERS {
        int customer_id PK
        varchar first_name
        varchar last_name
        varchar email
        varchar city
        varchar state
        date signup_date
    }

    PRODUCTS {
        int product_id PK
        varchar product_name
        varchar category
        decimal price
        int stock_quantity
    }

    ORDERS {
        int order_id PK
        int customer_id FK
        date order_date
        varchar order_status
    }

    ORDER_ITEMS {
        int order_item_id PK
        int order_id FK
        int product_id FK
        int quantity
        decimal unit_price
    }
```

## Relationship Summary

| Relationship                     | Type | Meaning                                              |
|-----------------------------------|------|-------------------------------------------------------|
| `customers` → `orders`            | 1:N  | One customer can place many orders                    |
| `orders` → `order_items`          | 1:N  | One order can contain many product line items          |
| `products` → `order_items`        | 1:N  | One product can appear as a line item in many orders   |

`order_items` is the bridge table that resolves the many-to-many
relationship between `orders` and `products` — this is a standard
pattern in retail/e-commerce data modeling.
