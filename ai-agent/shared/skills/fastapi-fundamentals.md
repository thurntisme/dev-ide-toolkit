---
name: fastapi-fundamentals
description: FastAPI development specialist. Use when user asks to create FastAPI applications, endpoints, request handling, or response models.
---

# FastAPI Fundamentals

## When to use
- User asks to create a FastAPI application
- User asks about API endpoints and routing
- User asks about request/response models
- User asks about FastAPI best practices

## Project Structure

```
project/
├── app/
│   ├── __init__.py
│   ├── main.py
│   ├── config.py
│   ├── models/
│   │   ├── __init__.py
│   │   └── schemas.py
│   ├── routes/
│   │   ├── __init__.py
│   │   └── users.py
│   ├── services/
│   │   └── user_service.py
│   └── utils/
│       └── db.py
├── requirements.txt
└── .env
```

## Basic Application

```python
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(
    title="My API",
    description="API description",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc",
)

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
async def root():
    return {"message": "Hello World"}

@app.get("/items/{item_id}")
async def read_item(item_id: int, q: str | None = None):
    return {"item_id": item_id, "q": q}
```

## Path Parameters

```python
from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

# Integer path parameter
@app.get("/users/{user_id}")
async def get_user(user_id: int):
    return {"user_id": user_id}

# String path parameter
@app.get("/users/{username}")
async def get_user_by_username(username: str):
    return {"username": username}

# Path parameter with model
class UserPath(BaseModel):
    user_id: int

@app.get("/users/{user_id}")
async def get_user(user_id: int):
    return {"user_id": user_id}
```

## Query Parameters

```python
from fastapi import Query

@app.get("/users")
async def get_users(
    skip: int = 0,
    limit: int = 10,
    search: str | None = Query(None, min_length=2, max_length=50),
    active: bool = True,
):
    return {
        "skip": skip,
        "limit": limit,
        "search": search,
        "active": active,
    }

# Required query parameter
@app.get("/items")
async def get_items(category: str = Query(..., min_length=1)):
    return {"category": category}

# Multiple values
@app.get("/items")
async def get_items(tags: list[str] = Query([])):
    return {"tags": tags}
```

## Request Body

```python
from fastapi import FastAPI
from pydantic import BaseModel, EmailStr, Field
from datetime import datetime

app = FastAPI()

class UserCreate(BaseModel):
    name: str = Field(..., min_length=1, max_length=100)
    email: EmailStr
    password: str = Field(..., min_length=8)
    age: int | None = Field(None, ge=0, le=150)
    is_active: bool = True

class UserResponse(BaseModel):
    id: int
    name: str
    email: EmailStr
    created_at: datetime

    class Config:
        from_attributes = True

@app.post("/users", response_model=UserResponse, status_code=201)
async def create_user(user: UserCreate):
    # Create user logic
    return {"id": 1, **user.model_dump(), "created_at": datetime.now()}
```

## Response Models

```python
from fastapi import FastAPI
from pydantic import BaseModel
from typing import Optional

app = FastAPI()

class Item(BaseModel):
    id: int
    name: str
    price: float
    description: str | None = None

class ItemWithTax(Item):
    tax: float

class Message(BaseModel):
    message: str

# Different response models
@app.get("/items/{item_id}", response_model=Item)
async def get_item(item_id: int):
    pass

@app.get("/items/{item_id}/with-tax", response_model=ItemWithTax)
async def get_item_with_tax(item_id: int):
    pass

# Multiple response models
from fastapi.responses import JSONResponse
from fastapi import status

@app.get(
    "/items/{item_id}",
    responses={
        200: {"model": Item, "description": "Item found"},
        404: {"model": Message, "description": "Item not found"},
    },
)
async def get_item(item_id: int):
    if item_id == 999:
        return JSONResponse(status_code=404, content={"message": "Not found"})
    return Item(id=item_id, name="Item", price=10.0)
```

## Path Operations

```python
from fastapi import APIRouter, status

router = APIRouter(prefix="/api/v1", tags=["users"])

@router.get("/users", status_code=status.HTTP_200_OK)
async def get_users():
    return []

@router.post("/users", status_code=status.HTTP_201_CREATED)
async def create_user():
    return {"id": 1}

@router.get("/users/{user_id}", status_code=status.HTTP_200_OK)
async def get_user(user_id: int):
    return {"id": user_id}

@router.put("/users/{user_id}", status_code=status.HTTP_200_OK)
async def update_user(user_id: int):
    return {"id": user_id}

@router.delete("/users/{user_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_user(user_id: int):
    return None

# In main.py
app.include_router(router)
```

## Form Data & File Uploads

```python
from fastapi import FastAPI, File, UploadFile, Form
from typing import Annotated

app = FastAPI()

# File upload
@app.post("/upload")
async def upload_file(file: UploadFile = File(...)):
    contents = await file.read()
    return {"filename": file.filename, "size": len(contents)}

# Multiple files
@app.post("/upload-multiple")
async def upload_multiple(files: list[UploadFile] = File(...)):
    return {"count": len(files)}

# Form data
@app.post("/login")
async def login(
    username: str = Form(...),
    password: str = Form(...),
):
    return {"username": username}

# Mixed form and file
@app.post("/register")
async def register(
    name: str = Form(...),
    email: str = Form(...),
    avatar: UploadFile = File(...),
):
    return {"name": name, "email": email, "filename": avatar.filename}
```

## Header Parameters

```python
from fastapi import FastAPI, Header

app = FastAPI()

@app.get("/items")
async def get_items(x_request_id: str = Header(...)):
    return {"request_id": x_request_id}

# Optional header
@app.get("/items")
async def get_items(
    x_custom_header: str | None = Header(None),
):
    return {"header": x_custom_header}

# Case-insensitive headers
@app.get("/items")
async def get_items(
    x_request_id: Annotated[str, Header(alias="X-Request-Id")],
):
    return {"request_id": x_request_id}
```

## Dependencies

```python
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from typing import Annotated

# Simple dependency
async def pagination_params(
    skip: int = 0,
    limit: int = 10,
):
    return {"skip": skip, "limit": limit}

@app.get("/items")
async def get_items(params: dict = Depends(pagination_params)):
    return params

# Dependency with database
def get_db():
    db = Database()
    try:
        yield db
    finally:
        db.close()

@app.get("/users")
async def get_users(db: Annotated[Database, Depends(get_db)]):
    return db.query("SELECT * FROM users")

# Security dependency
security = HTTPBearer()

async def verify_token(credentials: Annotated[HTTPAuthorizationCredentials, Depends(security)]):
    if credentials.scheme != "Bearer":
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid authentication scheme",
        )
    if not verify_jwt(credentials.credentials):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or expired token",
        )
    return {"user_id": get_user_from_token(credentials.credentials)}

@app.get("/protected")
async def protected_route(auth: dict = Depends(verify_token)):
    return auth
```

## Exception Handling

```python
from fastapi import FastAPI, HTTPException, status

app = FastAPI()

@app.get("/items/{item_id}")
async def get_item(item_id: int):
    if item_id not in items:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Item with id {item_id} not found",
            headers={"X-Error": "Item not found"},
        )
    return items[item_id]

# Custom exception handler
from fastapi.responses import JSONResponse

class UnicornException(Exception):
    def __init__(self, name: str):
        self.name = name

@app.exception_handler(UnicornException)
async def unicorn_exception_handler(request: Request, exc: UnicornException):
    return JSONResponse(
        status_code=418,
        content={"message": f"Unicorn {exc.name} not allowed"},
    )
```

## Background Tasks

```python
from fastapi import FastAPI, BackgroundTasks

app = FastAPI()

def send_email(email: str, message: str):
    # Send email logic
    print(f"Sending email to {email}: {message}")

@app.post("/send-notification/{email}")
async def send_notification(
    email: str,
    background_tasks: BackgroundTasks,
):
    background_tasks.add_task(send_email, email, "Hello!")
    return {"message": "Notification queued"}
```

## WebSocket

```python
from fastapi import FastAPI, WebSocket, WebSocketDisconnect

app = FastAPI()

class ConnectionManager:
    def __init__(self):
        self.active_connections: list[WebSocket] = []

    async def connect(self, websocket: WebSocket):
        await websocket.accept()
        self.active_connections.append(websocket)

    def disconnect(self, websocket: WebSocket):
        self.active_connections.remove(websocket)

    async def broadcast(self, message: str):
        for connection in self.active_connections:
            await connection.send_text(message)

manager = ConnectionManager()

@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await manager.connect(websocket)
    try:
        while True:
            data = await websocket.receive_text()
            await manager.broadcast(f"User said: {data}")
    except WebSocketDisconnect:
        manager.disconnect(websocket)
```
