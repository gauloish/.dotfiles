# SQL Code Documentation Guide (`references/sql.md`)

## Standard
**ANSI SQL Comments** (`--` for line/block headers, `/* ... */` for file headers, and `COMMENT ON` for catalog metadata).

## Mandatory Rules
1. **File Header (Migrations, Views, Functions, Procedures):** At the top of every `.sql` file, document the purpose of the script, affected tables/indexes, locking or performance considerations, and rollback expectations.
2. **Functions & Stored Procedures:** Explicitly list each parameter with its SQL data type (`IN`/`OUT`) and the returned data type/table structure.
3. **CTEs (`WITH`) & Complex Joins:** Place a concise `--` comment above each CTE explaining what intermediate dataset it produces and why specific filters or window functions are applied.
4. **Catalog Documentation (`COMMENT ON`):** When defining persistent schema tables or columns in PostgreSQL and compatible RDBMSs, include `COMMENT ON TABLE` and `COMMENT ON COLUMN` statements where appropriate.

## Examples

### English (`lang-en`)
```sql
-- =============================================================================
-- Migration: 20261114_add_active_subscriptions_view.sql
-- Purpose:   Exposes active recurring subscriptions with aggregated billing totals.
-- Tables:    subscriptions (read), invoices (read)
-- =============================================================================

-- Filter invoices paid within the last 12 months to avoid full-history scans.
WITH recent_paid_invoices AS (
    SELECT subscription_id, SUM(amount_cents) AS total_paid_cents
    FROM invoices
    WHERE status = 'paid' AND paid_at >= NOW() - INTERVAL '12 months'
    GROUP BY subscription_id
)
SELECT s.id, s.user_id, COALESCE(r.total_paid_cents, 0) AS annual_spend_cents
FROM subscriptions s
LEFT JOIN recent_paid_invoices r ON r.subscription_id = s.id
WHERE s.status = 'active';
```

### Portuguese (`lang-pt`)
```sql
-- =============================================================================
-- Migration: 20261114_add_active_subscriptions_view.sql
-- Objetivo:  Expõe assinaturas recorrentes ativas com totais de faturamento agregados.
-- Tabelas:   subscriptions (leitura), invoices (leitura)
-- =============================================================================

-- Filtra faturas pagas nos últimos 12 meses para evitar varredura completa do histórico.
WITH recent_paid_invoices AS (
    SELECT subscription_id, SUM(amount_cents) AS total_paid_cents
    FROM invoices
    WHERE status = 'paid' AND paid_at >= NOW() - INTERVAL '12 months'
    GROUP BY subscription_id
)
SELECT s.id, s.user_id, COALESCE(r.total_paid_cents, 0) AS annual_spend_cents
FROM subscriptions s
LEFT JOIN recent_paid_invoices r ON r.subscription_id = s.id
WHERE s.status = 'active';
```
