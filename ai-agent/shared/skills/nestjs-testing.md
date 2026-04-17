---
name: nestjs-testing
description: NestJS testing specialist. Use when user asks about testing NestJS applications, unit tests, e2e tests, or mocking.
---

# NestJS Testing

## When to use
- User asks about testing NestJS applications
- User asks about unit tests and e2e tests
- User asks about mocking services
- User asks about testing with database

## Installation

```bash
npm install -D jest @types/jest ts-jest @nestjs/testing
npm install -D @nestjs/platform-express
npm install -D @golevelup/ts-jest
```

## Jest Configuration

```javascript
// jest.config.js
module.exports = {
  moduleFileExtensions: ['js', 'json', 'ts'],
  rootDir: 'src',
  testRegex: '.*\\.spec\\.ts$',
  transform: {
    '^.+\\.(t|j)s$': 'ts-jest',
  },
  collectCoverageFrom: ['**/*.(t|j)s'],
  coverageDirectory: '../coverage',
  testEnvironment: 'node',
  moduleNameMapper: {
    '^@/(.*)$': '<rootDir>/$1',
  },
  setupFilesAfterEnv: ['<rootDir>/../test/setup.ts'],
};
```

## Setup File

```typescript
// test/setup.ts
import { Test, TestingModule } from '@nestjs/testing';

declare global {
  namespace jest {
    interface Matchers<R> {
      toThrowUnprocessableEntityException(): R;
    }
  }
}
```

## Unit Tests

### Service Unit Test

```typescript
// users/users.service.spec.ts
import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { UsersService } from './users.service';
import { User } from './entities/user.entity';
import { NotFoundException, ConflictException } from '@nestjs/common';

describe('UsersService', () => {
  let service: UsersService;
  let repository: Repository<User>;

  const mockRepository = {
    find: jest.fn(),
    findOne: jest.fn(),
    findAndCount: jest.fn(),
    create: jest.fn(),
    save: jest.fn(),
    remove: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        UsersService,
        {
          provide: getRepositoryToken(User),
          useValue: mockRepository,
        },
      ],
    }).compile();

    service = module.get<UsersService>(UsersService);
    repository = module.get<Repository<User>>(getRepositoryToken(User));
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('findAll', () => {
    it('should return array of users', async () => {
      const users = [{ id: 1, name: 'John', email: 'john@example.com' }];
      mockRepository.findAndCount.mockResolvedValue([users, 1]);

      const result = await service.findAll();

      expect(result).toEqual({ data: users, meta: { total: 1, page: 1, limit: 10 } });
    });
  });

  describe('findOne', () => {
    it('should return a user', async () => {
      const user = { id: 1, name: 'John', email: 'john@example.com' };
      mockRepository.findOne.mockResolvedValue(user);

      const result = await service.findOne(1);

      expect(result).toEqual(user);
    });

    it('should throw NotFoundException', async () => {
      mockRepository.findOne.mockResolvedValue(null);

      await expect(service.findOne(999)).rejects.toThrow(NotFoundException);
    });
  });

  describe('create', () => {
    it('should create a user', async () => {
      const createDto = { name: 'John', email: 'john@example.com', password: 'password123' };
      const user = { id: 1, ...createDto };
      mockRepository.create.mockReturnValue(user);
      mockRepository.save.mockResolvedValue(user);

      const result = await service.create(createDto);

      expect(mockRepository.create).toHaveBeenCalledWith(createDto);
      expect(mockRepository.save).toHaveBeenCalledWith(user);
      expect(result).toEqual(user);
    });
  });
});
```

### Controller Unit Test

```typescript
// users/users.controller.spec.ts
import { Test, TestingModule } from '@nestjs/testing';
import { UsersController } from './users.controller';
import { UsersService } from './users.service';

describe('UsersController', () => {
  let controller: UsersController;
  let service: UsersService;

  const mockService = {
    findAll: jest.fn(),
    findOne: jest.fn(),
    create: jest.fn(),
    update: jest.fn(),
    remove: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [UsersController],
      providers: [
        { provide: UsersService, useValue: mockService },
      ],
    }).compile();

    controller = module.get<UsersController>(UsersController);
    service = module.get<UsersService>(UsersService);
  });

  describe('findAll', () => {
    it('should return users', async () => {
      const users = [{ id: 1, name: 'John' }];
      mockService.findAll.mockResolvedValue({ data: users, meta: { total: 1, page: 1, limit: 10 } });

      const result = await controller.findAll({ page: 1, limit: 10 });

      expect(result).toEqual({ data: users, meta: { total: 1, page: 1, limit: 10 } });
    });
  });

  describe('findOne', () => {
    it('should return a user', async () => {
      const user = { id: 1, name: 'John' };
      mockService.findOne.mockResolvedValue(user);

      const result = await controller.findOne(1);

      expect(result).toEqual(user);
    });
  });

  describe('create', () => {
    it('should create a user', async () => {
      const createDto = { name: 'John', email: 'john@example.com', password: 'password123' };
      const user = { id: 1, ...createDto };
      mockService.create.mockResolvedValue(user);

      const result = await controller.create(createDto);

      expect(result).toEqual(user);
    });
  });
});
```

## Integration Tests

### With Testing Database

```typescript
// test/users.e2e-spec.ts
import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../src/app.module';

describe('UsersController (e2e)', () => {
  let app: INestApplication;

  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    app.useGlobalPipes(new ValidationPipe({ whitelist: true }));
    await app.init();
  });

  afterAll(async () => {
    await app.close();
  });

  describe('/users (GET)', () => {
    it('should return array of users', async () => {
      const response = await request(app.getHttpServer())
        .get('/api/v1/users')
        .expect(200);

      expect(Array.isArray(response.body.data)).toBe(true);
    });
  });

  describe('/users (POST)', () => {
    it('should create a user', async () => {
      const createUserDto = {
        name: 'Test User',
        email: 'test@example.com',
        password: 'password123',
      };

      const response = await request(app.getHttpServer())
        .post('/api/v1/users')
        .send(createUserDto)
        .expect(201);

      expect(response.body.data).toHaveProperty('id');
      expect(response.body.data.email).toBe(createUserDto.email);
    });
  });
});
```

## Mocking

### Repository Mock

```typescript
const mockUserRepository = {
  find: jest.fn().mockResolvedValue([]),
  findOne: jest.fn().mockImplementation((id: number) => {
    if (id === 1) return Promise.resolve({ id: 1, name: 'John' });
    return Promise.resolve(null);
  }),
  create: jest.fn().mockImplementation((dto) => dto),
  save: jest.fn().mockImplementation((entity) => Promise.resolve({ id: 1, ...entity })),
  delete: jest.fn().mockResolvedValue({ affected: 1 }),
};
```

### Service Mock with Module Override

```typescript
const module: TestingModule = await Test.createTestingModule({
  providers: [
    {
      provide: UsersService,
      useValue: {
        findAll: jest.fn().mockResolvedValue([]),
        findOne: jest.fn().mockResolvedValue({ id: 1, name: 'John' }),
        create: jest.fn().mockImplementation((dto) => Promise.resolve({ id: 1, ...dto })),
        update: jest.fn().mockImplementation((id, dto) => Promise.resolve({ id, ...dto })),
        remove: jest.fn().mockResolvedValue(undefined),
      },
    },
  ],
}).compile();
```

### Repository Override

```typescript
const module: TestingModule = await Test.createTestingModule({
  imports: [TypeOrmModule.forRootAsync(TestTypeOrmModule.forRoot())],
  providers: [
    {
      provide: getRepositoryToken(User),
      useValue: mockRepository,
    },
  ],
}).compile();
```

## Testing with Database (TestContainers)

```typescript
// Using testcontainers
import { Test } from '@nestjs/testing';
import { TypeOrmModule } from '@nestjs/typeorm';
import {
  PostgreSqlContainer,
  StartedPostgreSqlContainer,
} from '@testcontainers/postgresql';
import { DataSource } from 'typeorm';

describe('UsersService (with DB)', () => {
  let datasource: DataSource;
  let container: StartedPostgreSqlContainer;

  beforeAll(async () => {
    container = await new PostgreSqlContainer().start();
    datasource = new DataSource({
      type: 'postgres',
      url: container.getConnectionUrl(),
      entities: [User],
      synchronize: true,
    });
    await datasource.initialize();
  });

  afterAll(async () => {
    await datasource.destroy();
    await container.stop();
  });

  it('should work with real database', async () => {
    const userRepo = datasource.getRepository(User);
    const user = userRepo.create({ name: 'John', email: 'john@test.com', password: 'password' });
    const saved = await userRepo.save(user);
    expect(saved.id).toBeDefined();
  });
});
```

## Spies

```typescript
describe('with Spies', () => {
  it('should call repository', async () => {
    const spy = jest.spyOn(repository, 'find');
    await service.findAll();
    expect(spy).toHaveBeenCalled();
  });

  it('should spy on private method', async () => {
    const spy = jest.spyOn(service as any, 'hashPassword');
    await service.create({ password: 'plain' });
    expect(spy).toHaveBeenCalledWith('plain');
  });
});
```

## Testing Guards

```typescript
// jwt-auth.guard.spec.ts
import { ExecutionContext, createMock } from '@golevelup/ts-jest';
import { JwtAuthGuard } from './jwt-auth.guard';

describe('JwtAuthGuard', () => {
  let guard: JwtAuthGuard;
  let reflector: Reflector;

  beforeEach(() => {
    reflector = new Reflector();
    guard = new JwtAuthGuard(reflector);
  });

  it('should allow authenticated user', () => {
    const context = createMock<ExecutionContext>({
      switchToHttp: () => ({
        getRequest: () => ({ user: { id: 1 } }),
      }),
    });
    expect(guard.canActivate(context)).toBe(true);
  });

  it('should deny unauthenticated user', () => {
    const context = createMock<ExecutionContext>({
      switchToHttp: () => ({ getRequest: () => ({}) }),
    });
    expect(guard.canActivate(context)).toBe(false);
  });
});
```

## Testing Interceptors

```typescript
// transform.interceptor.spec.ts
import { Test, TestingModule } from '@nestjs/testing';
import { Observable, of } from 'rxjs';
import { TransformInterceptor } from './transform.interceptor';

describe('TransformInterceptor', () => {
  let interceptor: TransformInterceptor;
  let mockedArgs: any;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [TransformInterceptor],
    }).compile();

    interceptor = module.get<TransformInterceptor>(TransformInterceptor);
    mockedArgs = {
      switchToHttp: () => ({
        getResponse: () => ({ statusCode: 200 }),
      }),
    };
  });

  it('should transform response', (done) => {
    const data = { id: 1, name: 'John' };
    const next = { handle: () => of(data) };

    interceptor.intercept(mockedArgs, next).subscribe((result) => {
      expect(result.data).toEqual(data);
      done();
    });
  });
});
```

## Running Tests

```bash
# Run all tests
npm run test

# Run with coverage
npm run test:cov

# Run in watch mode
npm run test:watch

# Run e2e tests
npm run test:e2e
```

## Testing Best Practices

| Practice | Description |
|---------|------------|
| AAA Pattern | Arrange, Act, Assert |
| One describe per method | Test each method in its own describe |
| Clear test names | Use descriptive test names |
| Test edge cases | Test edge cases and errors |
| Proper mocking | Mock external dependencies |
| Reset mocks | Reset mocks between tests |