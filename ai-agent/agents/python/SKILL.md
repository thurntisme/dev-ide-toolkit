---
name: coder-python
description: Python development. Use when user asks to create, modify, or debug Python applications.
---

# Python Development Guide

## When to use
- User asks to create a Python application
- User asks to add functionality to a Python project
- User asks about Python best practices
- User asks to debug Python issues

## Conventions

- Follow PEP 8 style guide
- Use type hints for function signatures
- Use virtual environments (venv/poetry/conda)
- Use meaningful variable names

## File Structure

```
project/
├── src/                  # Main source code
│   └── __init__.py
├── tests/                # Test files
├── pyproject.toml        # Project metadata
├── poetry.lock           # Locked dependencies
└── README.md
```

## Virtual Environments

```bash
# venv
python -m venv venv
source venv/bin/activate  # Linux/Mac
venv\Scripts\activate     # Windows

# poetry
poetry install
poetry add <package>
```

## Common Libraries

| Category | Libraries |
|----------|-----------|
| Web | FastAPI, Flask, Django |
| Data | pandas, numpy, polars |
| CLI | click, typer |
| Testing | pytest, unittest |
| ORM | SQLAlchemy, Django ORM |

## FastAPI Example

```python
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI()

class Item(BaseModel):
    name: str
    price: float
    is_available: bool = True

@app.get("/items/{item_id}")
async def read_item(item_id: int):
    return {"item_id": item_id}

@app.post("/items/")
async def create_item(item: Item):
    return item
```

## Pydantic Models

```python
from pydantic import BaseModel, Field, validator
from datetime import datetime

class User(BaseModel):
    username: str = Field(..., min_length=3, max_length=50)
    email: str
    age: int = Field(None, ge=0, le=150)
    created_at: datetime = Field(default_factory=datetime.now)

    @validator('email')
    def email_must_contain_at(cls, v):
        if '@' not in v:
            raise ValueError('Invalid email')
        return v
```

## Testing

```python
import pytest

def test_example():
    assert 1 + 1 == 2

@pytest.fixture
def sample_data():
    return {"key": "value"}

def test_with_fixture(sample_data):
    assert sample_data["key"] == "value"
```

## SQLAlchemy

```python
from sqlalchemy import create_engine, Column, Integer, String
from sqlalchemy.orm import declarative_base, sessionmaker

Base = declarative_base()

class User(Base):
    __tablename__ = 'users'
    id = Column(Integer, primary_key=True)
    name = Column(String(100))
    email = Column(String(100), unique=True)

engine = create_engine('sqlite:///app.db')
Base.metadata.create_all(engine)

Session = sessionmaker(bind=engine)
session = Session()
```

## Security Checklist

- [ ] Never commit .env files
- [ ] Use environment variables for secrets
- [ ] Validate input with Pydantic
- [ ] Use parameterized queries
- [ ] Hash passwords (bcrypt/argon2)
