# API Conventions

## HTTP Methods

| Action | Method | Example |
|--------|--------|---------|
| Create | POST | `POST /users` |
| Read | GET | `GET /users/:id` |
| Update (full) | PUT | `PUT /users/:id` |
| Update (partial) | PATCH | `PATCH /users/:id` |
| Delete | DELETE | `DELETE /users/:id` |
| List | GET | `GET /users` |

## Response Format

### Success Response

```json
{
  "data": { },
  "meta": {
    "timestamp": "2024-01-01T00:00:00Z",
    "requestId": "uuid"
  }
}
```

### List Response

```json
{
  "data": [ ],
  "meta": {
    "timestamp": "2024-01-01T00:00:00Z",
    "requestId": "uuid",
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 100,
      "totalPages": 5
    }
  }
}
```

### Error Response

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input",
    "details": [ ]
  },
  "meta": {
    "timestamp": "2024-01-01T00:00:00Z",
    "requestId": "uuid"
  }
}
```

## Status Codes

| Code | Meaning |
|------|---------|
| 200 | OK |
| 201 | Created |
| 204 | No Content |
| 400 | Bad Request |
| 401 | Unauthorized |
| 403 | Forbidden |
| 404 | Not Found |
| 422 | Unprocessable Entity |
| 500 | Internal Server Error |

## REST API Design

### Resource Naming
- Use plural nouns: `/users`, `/orders`, `/products`
- Use kebab-case for multi-word paths: `/user-profiles`
- Max 2 levels deep: `/users/:id/orders`

### Query Parameters
- `?page=1&limit=20` - Pagination
- `?sort=created_at&order=desc` - Sorting
- `?status=active` - Filtering

### Versioning
- Use URL versioning: `/api/v1/users`
- Maintain backward compatibility

## Request Validation

- Validate on server side (never trust client)
- Return 422 for validation errors
- Provide clear error messages

## Rate Limiting

- Return 429 when limit exceeded
- Include headers: `X-RateLimit-Limit`, `X-RateLimit-Remaining`

## Security

- Use HTTPS only
- Authenticate using Bearer tokens
- Sanitize all user inputs
- Implement CORS properly