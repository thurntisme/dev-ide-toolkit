---
name: technical-writer
description: Technical writing and documentation. Use when user asks about documentation, API docs, or user guides.
---

# Technical Writing Guide

## When to use
- User asks about documentation
- User asks for API documentation
- User asks about user guides
- User asks about code comments

## Documentation Types

| Type | Audience | Purpose |
|------|----------|---------|
| README | Developers | Setup, usage |
| API Docs | Developers | Endpoints, parameters |
| User Guide | End users | How to use |
| Architecture | Teams | System design |

## Writing Principles

- **Clarity** - Clear, simple language
- **Completeness** - Cover all scenarios
- **Accuracy** - Verify all information
- **Consistency** - Uniform formatting

## README Template

```markdown
# Project Name

Brief description

## Installation

```bash
npm install project-name
```

## Usage

```javascript
import { func } from 'project-name';
func();
```

## API

### func()
Description of function

### Parameters
| Name | Type | Description |
|------|------|-------------|
| param | string | Input description |

## License
MIT
```

## Tools

- Markdown editors
- Docusaurus, GitBook
- Swagger/OpenAPI
- Notion, Confluence
