---
name: fastapi-testing
description: FastAPI testing specialist. Use when user asks about testing FastAPI applications, pytest, fixtures, or mocking.
---

# FastAPI Testing

## When to use
- User asks about testing FastAPI applications
- User asks about pytest configuration
- User asks about test fixtures and mocking
- User asks about integration tests

## Installation

```bash
pip install pytest pytest-asyncio httpx
pip install pytest-cov pytest-xdist
pip install faker pytest-factory
```

## Pytest Configuration

```python
# pytest.ini
[pytest]
testpaths = tests
python_files = test_*.py
python_classes = Test*
python_functions = test_*
asyncio_mode = auto
addopts = -v --tb=short

# conftest.py
import pytest
from httpx import AsyncClient, ASGITransport
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from main import app
from database import Base

# Test database URL
TEST_DATABASE_URL = "sqlite:///./test.db"

engine = create_engine(TEST_DATABASE_URL, connect_args={"check_same_thread": False})
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

@pytest.fixture(scope="function")
def db_session():
    Base.metadata.create_all(bind=engine)
    session = TestingSessionLocal()
    try:
        yield session
    finally:
        session.close()
        Base.metadata.drop_all(bind=engine)

@pytest.fixture(scope="function")
async def async_client(db_session):
    async with AsyncClient(
        transport=ASGITransport(app=app),
        base_url="http://test"
    ) as client:
        yield client
```

## Basic Tests

### Test Routes

```python
# tests/test_users.py
import pytest
from httpx import AsyncClient
from main import app

@pytest.mark.asyncio
async def test_get_users():
    async with AsyncClient(app=app, base_url="http://test") as client:
        response = await client.get("/users")
        assert response.status_code == 200
        assert isinstance(response.json(), dict)

@pytest.mark.asyncio
async def test_create_user():
    async with AsyncClient(app=app, base_url="http://test") as client:
        response = await client.post(
            "/users",
            json={"name": "John", "email": "john@example.com", "password": "password123"}
        )
        assert response.status_code == 201
        data = response.json()
        assert data["name"] == "John"
        assert data["email"] == "john@example.com"
        assert "id" in data
        assert "password" not in data

@pytest.mark.asyncio
async def test_create_user_validation_error():
    async with AsyncClient(app=app, base_url="http://test") as client:
        response = await client.post(
            "/users",
            json={"name": "John"}
        )
        assert response.status_code == 422

@pytest.mark.asyncio
async def test_get_user_not_found():
    async with AsyncClient(app=app, base_url="http://test") as client:
        response = await client.get("/users/999")
        assert response.status_code == 404
```

### Test with Fixtures

```python
# tests/conftest.py
import pytest
from httpx import AsyncClient, ASGITransport
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from main import app
from database import Base, get_db

TEST_DATABASE_URL = "sqlite:///./test.db"
engine = create_engine(TEST_DATABASE_URL, connect_args={"check_same_thread": False})
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

@pytest.fixture
def override_db():
    Base.metadata.create_all(bind=engine)
    yield
    Base.metadata.drop_all(bind=engine)

@pytest.fixture
async def client(override_db):
    async def override_get_db():
        db = TestingSessionLocal()
        try:
            yield db
        finally:
            db.close()

    app.dependency_overrides[get_db] = override_get_db
    
    async with AsyncClient(
        transport=ASGITransport(app=app),
        base_url="http://test"
    ) as ac:
        yield ac
    
    app.dependency_overrides.clear()
```

## Testing Services

```python
# tests/test_services.py
import pytest
from sqlalchemy.ext.asyncio import AsyncSession
from app.services.user_service import UserService

@pytest.mark.asyncio
async def test_create_user(db_session: AsyncSession):
    service = UserService(db_session)
    
    user = await service.create(
        name="John",
        email="john@example.com",
        password="password123"
    )
    
    assert user.id is not None
    assert user.name == "John"
    assert user.email == "john@example.com"

@pytest.mark.asyncio
async def test_create_duplicate_email(db_session: AsyncSession):
    service = UserService(db_session)
    
    await service.create(
        name="John",
        email="john@example.com",
        password="password123"
    )
    
    with pytest.raises(Exception) as exc_info:
        await service.create(
            name="Jane",
            email="john@example.com",
            password="password123"
        )
    
    assert "Email already exists" in str(exc_info.value)

@pytest.mark.asyncio
async def test_get_user_by_email(db_session: AsyncSession):
    service = UserService(db_session)
    
    created = await service.create(
        name="John",
        email="john@example.com",
        password="password123"
    )
    
    user = await service.get_by_email("john@example.com")
    
    assert user is not None
    assert user.id == created.id
```

## Testing Authentication

```python
# tests/test_auth.py
import pytest
from httpx import AsyncClient
from main import app
from app.auth.utils import create_access_token

@pytest.mark.asyncio
async def test_login_success(client: AsyncClient):
    response = await client.post(
        "/auth/login",
        data={
            "username": "john@example.com",
            "password": "password123"
        }
    )
    
    assert response.status_code == 200
    data = response.json()
    assert "access_token" in data
    assert "refresh_token" in data

@pytest.mark.asyncio
async def test_login_invalid_credentials(client: AsyncClient):
    response = await client.post(
        "/auth/login",
        data={
            "username": "john@example.com",
            "password": "wrongpassword"
        }
    )
    
    assert response.status_code == 401

@pytest.mark.asyncio
async def test_protected_route_without_token(client: AsyncClient):
    response = await client.get("/users/me")
    
    assert response.status_code == 401

@pytest.mark.asyncio
async def test_protected_route_with_token(client: AsyncClient):
    # Create token
    token = create_access_token({"sub": 1, "email": "john@example.com"})
    
    response = await client.get(
        "/users/me",
        headers={"Authorization": f"Bearer {token}"}
    )
    
    assert response.status_code == 200
```

## Testing with Mock

```python
# tests/test_mock.py
import pytest
from unittest.mock import Mock, AsyncMock, patch
from httpx import AsyncClient
from main import app

@pytest.mark.asyncio
async def test_send_email_mock():
    mock_send = AsyncMock()
    
    with patch("app.services.email_service.send_email", mock_send):
        mock_send.return_value = True
        
        result = await send_email("test@example.com", "Subject", "Body")
        
        assert result is True
        mock_send.assert_called_once_with("test@example.com", "Subject", "Body")

@pytest.mark.asyncio
async def test_external_api_mock():
    mock_response = Mock()
    mock_response.status_code = 200
    mock_response.json = AsyncMock(return_value={"data": "test"})
    
    with patch("httpx.AsyncClient.get", return_value=mock_response):
        async with AsyncClient() as client:
            response = await client.get("http://external-api.com/data")
            assert response.status_code == 200
```

## Testing WebSocket

```python
# tests/test_websocket.py
import pytest
from httpx import AsyncClient, ASGITransport
from main import app

@pytest.mark.asyncio
async def test_websocket():
    async with AsyncClient(
        transport=ASGITransport(app=app),
        base_url="http://test"
    ) as client:
        async with client.websocket_connect("/ws") as ws:
            ws.send_text("Hello")
            response = ws.receive_text()
            assert response == "Echo: Hello"
```

## Test parametrization

```python
# tests/test_parametrized.py
import pytest
from httpx import AsyncClient
from main import app

@pytest.mark.parametrize("email,expected_status", [
    ("john@example.com", 200),
    ("invalid-email", 422),
    ("", 422),
])
async def test_email_validation(email, expected_status):
    async with AsyncClient(app=app, base_url="http://test") as client:
        response = await client.post(
            "/auth/register",
            json={
                "name": "John",
                "email": email,
                "password": "password123"
            }
        )
        assert response.status_code == expected_status
```

## Database Testing Pattern

```python
# tests/conftest.py
import pytest
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession, async_sessionmaker
from app.database import Base

@pytest.fixture(scope="function")
async def engine():
    engine = create_async_engine(
        "sqlite+aiosqlite:///:memory:",
        echo=False,
    )
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    yield engine
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.drop_all)
    await engine.dispose()

@pytest.fixture(scope="function")
async def db_session(engine):
    async_session = async_sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)
    async with async_session() as session:
        yield session
        await session.rollback()
```

## Testing Best Practices

| Practice | Description |
|----------|-------------|
| Use pytest fixtures | Reusable test setup |
| Mock external services | Test in isolation |
| Use async/await | Test async code properly |
| Test edge cases | Error handling, validation |
| Clean state between tests | Use function scope fixtures |
| Use parametrize | Test multiple inputs |

## Running Tests

```bash
# Run all tests
pytest

# Run with coverage
pytest --cov=app --cov-report=html

# Run in parallel
pytest -n auto

# Run specific file
pytest tests/test_users.py

# Run specific test
pytest tests/test_users.py::test_create_user

# Run with verbose output
pytest -vv
```