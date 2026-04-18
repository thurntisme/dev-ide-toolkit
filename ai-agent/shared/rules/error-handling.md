# Error Handling Conventions

## Error Messages

### Be Specific
- Tell user what went wrong
- Avoid generic messages: "An error occurred"
- Example: "Unable to save order" not "Operation failed"

### User vs Developer
- User message: Clear, actionable
- Developer message: Technical details
- Log both with correlation ID

### Localization
- All user messages translatable
- Avoid hardcoded strings
- Use message keys

## Error Codes

### Structure
- `[DOMAIN]_[TYPE]`: `AUTH_INVALID_TOKEN`, `USER_NOT_FOUND`
- Consistent categorization
- Document all codes

### HTTP Mapping
| Code | Meaning |
|------|---------|
| 400 | Bad Request - invalid input |
| 401 | Unauthorized - not authenticated |
| 403 | Forbidden - no permission |
| 404 | Not Found - resource missing |
| 409 | Conflict - business rule violation |
| 422 | Unprocessable - validation failed |
| 429 | Too Many Requests |
| 500 | Internal Server Error |

## Logging

### What to Log
- Always: stack trace, timestamp
- Include: request ID, user ID
- Context: input values (sanitized)

### What Not to Log
- Passwords, tokens
- Credit card numbers
- Personal data (PII)

### Log Levels
- ERROR: Requires action
- WARNING: Needs attention
- INFO: General info
- DEBUG: Development only

## Exception Handling

### Catch Specific First
- Catch specific exceptions
- Fall back to generic
- Never swallow silently

### Rethrow with Context
- Wrap exceptions
- Add context information
- Preserve original stack trace

### Cleanup
- Use finally blocks
- Release resources
- Close connections

## Validation Errors

### Early Validation
- Validate at service entry
- Fail fast principle
- Return all errors at once

### Error Format
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input",
    "details": [
      { "field": "email", "message": "Invalid format" },
      { "field": "age", "message": "Must be positive" }
    ]
  }
}
```

## Async Error Handling

### Promises
- Always handle rejection
- Use .catch()
- Chain properly

### async/await
- Wrap in try/catch
- Handle specific errors
- Allow bubbling

## Recovery Strategies

### Retry Logic
- Exponential backoff
- Max retry attempts
- Jitter for distributed systems

### Circuit Breaker
- Track failures
- Open after threshold
- Timeout for recovery

### Fallbacks
- Default values
- Cache fallback
- Degraded mode

## API Error Response

### Structure
```json
{
  "error": {
    "code": "USER_NOT_FOUND",
    "message": "User with ID 123 not found",
    "details": {}
  },
  "meta": {
    "timestamp": "2024-01-01T00:00:00Z",
    "requestId": "abc-123"
  }
}
```

### Consistency
- Same format everywhere
- Same status codes
- Same error structure

## Best Practices

### Don't Expose Internals
- Hide implementation details
- Generic messages for 500
- Log technical details

### Fail Gracefully
- Show user-friendly message
- Keep app usable
- Don't crash the server

### Test Error Paths
- Unit test error cases
- Integration test failures
- Document expected errors