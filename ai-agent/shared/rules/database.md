# Database Conventions

## Naming

### Tables
- Plural nouns: `users`, `orders`, `products`
- kebab-case in migrations: `user_profiles`
- No prefixes like `tbl_` or `tb_`

### Columns
- snake_case: `created_at`, `user_id`
- Use `_id` for primary keys: `user_id`, `order_id`
- Use `_at` for timestamps: `created_at`, `updated_at`
- Use `is_` for booleans: `is_active`, `is_verified`

### Indexes
- `idx_[table]_[columns]`: `idx_users_email`
- Unique indexes: `uq_[table]_[columns]`

### Foreign Keys
- `fk_[table]_[ref_table]`: `fk_orders_user_id`
- Or use column naming: `user_id` references `users(id)`

## Schema

### Primary Keys
- Use `id` as auto-incrementing integer
- UUID for distributed systems
- Never use natural keys

### Timestamps
- Always include: `created_at`, `updated_at`
- Use timezone-aware types
- Default `created_at` to `NOW()`

### Soft Deletes
- Use `deleted_at` timestamp
- Never hard delete data
- filter `WHERE deleted_at IS NULL`

### Auditing
- Created by/updated by when needed
- Version for optimistic locking

## Constraints

### NOT NULL
- Apply to required fields
- Document why nullable

### UNIQUE
- Enforce at database level
- Use for business rules

### Foreign Keys
- Always reference primary key
- Use `ON DELETE CASCADE` carefully
- Consider `ON DELETE SET NULL`

### Check Constraints
- Validate ranges: `price > 0`
- Validate lengths
- Validate formats

## Indexing

### When to Index
- Foreign key columns
- Columns in WHERE clauses
- Columns in JOINs
- Columns in ORDER BY

### Composite Indexes
- Put high-cardinality columns first
- Consider query patterns
- Avoid too many columns

### Performance
- Don't over-index
- Monitor slow queries
- Use EXPLAIN ANALYZE

## Migrations

### Naming
- Clear description: `add_users_table`
- One migration per change
- Never modify old migrations

### Rollback
- Always include down
- Test rollback
- Keep migrations small

### Data
- Seed in migrations if needed
- Use idempotent scripts
- Handle existing data

## Queries

### SELECT
- Select only needed columns
- Avoid SELECT *
- Use aliases for clarity

### WHERE
- Use parameterized queries
- Avoid leading wildcards
- Consider indexed columns

### JOINs
- Use explicit joins
- Limit number of joins
- Consider denormalization

### Aggregation
- Use HAVING for filtered groups
- Use LIMIT for top results
- Consider materialized views

## Performance

### Query Optimization
- Monitor slow queries
- Use EXPLAIN plans
- Add missing indexes

### Connection Management
- Use connection pooling
- Close connections properly
- Handle timeouts

### Data Types
- Use appropriate sizes
- Avoid text for fixed data
- Use JSON for semi-structured

## Security

### Access Control
- Principle of least privilege
- Separate read/write users
- Encrypt sensitive data

### SQL Injection
- Never concatenate strings
- Use parameterized queries
- Validate all input

### Backup Strategy
- Automated backups
- Test restore process
- Off-site storage