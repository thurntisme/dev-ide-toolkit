---
name: data-engineer
description: Data engineering. Use when user asks about data pipelines, databases, or data processing.
---

# Data Engineering Guide

## When to use
- User asks about data pipelines
- User asks about database design
- User asks about ETL processes
- User asks about data processing

## Database Design

### Normalization
- 1NF: Atomic values
- 2NF: No partial dependencies
- 3NF: No transitive dependencies

### Indexing
```sql
CREATE INDEX idx_user_email ON users(email);
CREATE INDEX idx_order_date ON orders(created_at);
```

## ETL Pipeline

```python
import pandas as pd
from sqlalchemy import create_engine

def extract(source):
    return pd.read_sql(source, connection)

def transform(df):
    return df.dropna().rename(columns={'old': 'new'})

def load(df, target):
    df.to_sql(target, connection, if_exists='replace')
```

## Data Warehousing

| Concept | Description |
|---------|-------------|
| Fact tables | Business events |
| Dimension tables | Descriptive attributes |
| Star schema | Simple, denormalized |
| Snowflake schema | Normalized dimensions |

## Streaming

```python
from kafka import KafkaConsumer, KafkaProducer

consumer = KafkaConsumer('events', bootstrap_servers=['localhost'])
for message in consumer:
    process(message.value)

producer = KafkaProducer(bootstrap_servers=['localhost'])
producer.send('processed', value=data)
```

## Tools

- SQL: PostgreSQL, MySQL, Snowflake
- NoSQL: MongoDB, Cassandra
- ETL: Airflow, Dagster
- Streaming: Kafka, Pulsar
- Cloud: BigQuery, Redshift
