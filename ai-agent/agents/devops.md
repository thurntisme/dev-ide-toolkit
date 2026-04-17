---
name: devops
description: DevOps and infrastructure. Use when user asks about deployment, CI/CD, Docker, or cloud infrastructure.
---

# DevOps Guide

## When to use
- User asks about deployment
- User asks about CI/CD pipelines
- User asks about Docker or Kubernetes
- User asks about cloud infrastructure

## CI/CD Pipeline

```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Node
        uses: actions/setup-node@v3
        with:
          node-version: '18'
      - run: npm ci
      - run: npm test
      - run: npm run build
```

## Docker

### Dockerfile
```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

### Docker Compose
```yaml
version: '3.8'
services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
    depends_on:
      - db
  db:
    image: postgres:14
    volumes:
      - db-data:/var/lib/postgresql/data
volumes:
  db-data:
```

## Kubernetes

### Deployment
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: my-app
        image: my-app:latest
        ports:
        - containerPort: 3000
```

## Cloud Providers

| Provider | Services |
|----------|----------|
| AWS | EC2, S3, RDS, Lambda, ECS |
| GCP | Compute, Cloud Storage, Cloud SQL |
| Azure | VM, Blob, SQL, Functions |

## Monitoring

- Prometheus + Grafana
- New Relic
- Datadog
- CloudWatch

## Tools

- Docker, Kubernetes
- GitHub Actions, GitLab CI
- Terraform, Ansible
- AWS, GCP, Azure
