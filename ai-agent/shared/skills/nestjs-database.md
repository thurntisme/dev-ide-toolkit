---
name: nestjs-database
description: NestJS database specialist. Use when user asks about TypeORM, database operations, migrations, or async database access.
---

# NestJS Database

## When to use
- User asks about NestJS with TypeORM
- User asks about database entities and repositories
- User asks about async database operations
- User asks about migrations

## Installation

```bash
npm install @nestjs/typeorm typeorm pg mysql2 sqlite3
npm install @nestjs/config
npm install -D @types/node
```

## TypeORM Setup

### Basic Configuration

```typescript
// app.module.ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { User } from './users/entities/user.entity';
import { Post } from './posts/entities/post.entity';

@Module({
  imports: [
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      useFactory: (config: ConfigService) => ({
        type: 'postgres',
        host: config.get('DB_HOST'),
        port: config.get('DB_PORT'),
        username: config.get('DB_USERNAME'),
        password: config.get('DB_PASSWORD'),
        database: config.get('DB_NAME'),
        entities: [User, Post],
        synchronize: false, // Never use in production!
        logging: process.env.NODE_ENV === 'development',
      }),
      inject: [ConfigService],
    }),
  ],
})
export class AppModule {}
```

### Multiple Connections

```typescript
TypeOrmModule.forRootAsync({
  name: 'default',
  // ...
}),

TypeOrmModule.forRootAsync({
  name: 'replica',
  // ...
}),
```

## Entities

### Basic Entity

```typescript
// users/entities/user.entity.ts
import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
  OneToMany,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { Exclude } from 'class-transformer';
import { Post } from '../../posts/entities/post.entity';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ length: 100 })
  name: string;

  @Column({ unique: true })
  email: string;

  @Column()
  @Exclude()
  password: string;

  @Column({ default: 'user' })
  role: string;

  @Column({ default: true })
  isActive: boolean;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  @OneToMany(() => Post, (post) => post.author)
  posts: Post[];
}
```

### Relationships

```typescript
// OneToMany
@OneToMany(() => Post, (post) => post.author)
posts: Post[];

// ManyToOne
@ManyToOne(() => User, (user) => user.posts)
@JoinColumn({ name: 'author_id' })
author: User;

// OneToOne
@OneToOne(() => Profile, (profile) => profile.user)
profile: Profile;

// ManyToMany
@ManyToMany(() => Tag, (tag) => tag.posts)
@JoinTable({
  name: 'post_tags',
  joinColumn: { name: 'post_id', referencedColumnName: 'id' },
  inverseJoinColumn: { name: 'tag_id', referencedColumnName: 'id' },
})
tags: Tag[];
```

### Column Types

```typescript
// Basic types
@Column()
name: string;

@Column({ length: 100 })
name: string;

@Column({ type: 'text' })
description: string;

@Column({ type: 'decimal', precision: 10, scale: 2 })
price: number;

@Column({ type: 'boolean', default: true })
isActive: boolean;

// Timestamps
@CreateDateColumn()
createdAt: Date;

@UpdateDateColumn()
updatedAt: Date;

// Special types
@Column({ type: 'simple-array' })
tags: string[];

@Column({ type: 'simple-json' })
metadata: Record<string, any>;

@Column({ type: 'enum', enum: UserRole })
role: UserRole;
```

## Repositories

### Module Setup

```typescript
// users/users.module.ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UsersController } from './users.controller';
import { UsersService } from './users.service';
import { User } from './entities/user.entity';

@Module({
  imports: [TypeOrmModule.forFeature([User])],
  controllers: [UsersController],
  providers: [UsersService],
  exports: [UsersService],
})
export class UsersModule {}
```

### Service with Repository

```typescript
// users/users.service.ts
import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, Like, In } from 'typeorm';
import { User } from './entities/user.entity';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
  ) {}

  async findAll(page = 1, limit = 10) {
    const [users, total] = await this.userRepository.findAndCount({
      skip: (page - 1) * limit,
      take: limit,
      order: { createdAt: 'DESC' },
      relations: ['posts'],
    });
    return { data: users, meta: { total, page, limit } };
  }

  async findOne(id: number) {
    const user = await this.userRepository.findOne({
      where: { id },
      relations: ['posts'],
    });
    if (!user) throw new NotFoundException(`User ${id} not found`);
    return user;
  }

  async findByEmail(email: string) {
    return this.userRepository.findOne({ where: { email } });
  }

  async create(data: Partial<User>) {
    const user = this.userRepository.create(data);
    return this.userRepository.save(user);
  }

  async update(id: number, data: Partial<User>) {
    const user = await this.findOne(id);
    Object.assign(user, data);
    return this.userRepository.save(user);
  }

  async remove(id: number) {
    const user = await this.findOne(id);
    await this.userRepository.remove(user);
  }

  async search(query: string) {
    return this.userRepository.find({
      where: [
        { name: Like(`%${query}%`) },
        { email: Like(`%${query}%`) },
      ],
    });
  }

  async findByRoles(roles: string[]) {
    return this.userRepository.find({ where: { role: In(roles) } });
  }
}
```

## Custom Repository

```typescript
// users/users.repository.ts
import { Injectable } from '@nestjs/common';
import { DataSource, Repository } from 'typeorm';
import { User } from './entities/user.entity';

@Injectable()
export class UsersRepository {
  constructor(private dataSource: DataSource) {}

  async findActive() {
    return this.dataSource
      .getRepository(User)
      .createQueryBuilder('user')
      .where('user.isActive = :isActive', { isActive: true })
      .getMany();
  }

  async findWithPosts() {
    return this.dataSource
      .getRepository(User)
      .createQueryBuilder('user')
      .leftJoinAndSelect('user.posts', 'posts')
      .where('user.isActive = :isActive', { isActive: true })
      .getMany();
  }

  async countPostsByUser(userId: number) {
    const result = await this.dataSource
      .getRepository(User)
      .createQueryBuilder('user')
      .leftJoin('user.posts', 'posts')
      .where('user.id = :userId', { userId })
      .select('COUNT(*)', 'count')
      .getRawOne();
    return result.count;
  }
}
```

## Transactions

```typescript
async createUserWithPosts(userData: Partial<User>, postsData: Partial<Post>[]) {
  return this.dataSource.transaction(async (manager) => {
    const user = manager.create(User, userData);
    const savedUser = await manager.save(user);
    
    for (const postData of postsData) {
      const post = manager.create(Post, { ...postData, authorId: savedUser.id });
      await manager.save(post);
    }
    
    return savedUser;
  });
}
```

## Migrations

### Enable Migrations

```typescript
// TypeOrmModule config
{
  synchronize: false,
  migrations: ['dist/**/migrations/*.js'],
  migrationsRun: true,
}
```

### Create Migration

```bash
nest g class users/migrations/CreateUsersTable
```

```typescript
// migration file
import { MigrationInterface, QueryRunner, Table, TableForeignKey, TableIndex } from 'typeorm';

export class CreateUsersTable1700000000000 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.createTable(
      new Table({
        name: 'users',
        columns: [
          new TableColumn({ name: 'id', type: 'int', isPrimary: true, generationStrategy: 'increment' }),
          new TableColumn({ name: 'name', type: 'varchar', length: '100' }),
          new TableColumn({ name: 'email', type: 'varchar', isUnique: true }),
          new TableColumn({ name: 'password', type: 'varchar' }),
          new TableColumn({ name: 'role', type: 'varchar', default: "'user'" }),
          new TableColumn({ name: 'createdAt', type: 'timestamp', default: 'now()' }),
          new TableColumn({ name: 'updatedAt', type: 'timestamp', default: 'now()' }),
        ],
      }),
    );
    
    await queryRunner.createIndex(
      'users',
      new TableIndex({ name: 'IDX_USERS_EMAIL', columnNames: ['email'] }),
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropTable('users');
  }
}
```

### Run Migrations

```bash
# Run all pending migrations
npm run migration:run

# Generate migration from changes
npm run migration:generate -- --name CreatePostsTable

# Revert last migration
npm run migration:revert
```

## Query Builder

```typescript
// Advanced queries
async findWithPagination(query: UserQueryDto) {
  const qb = this.userRepository.createQueryBuilder('user');
  
  if (query.search) {
    qb.andWhere(
      '(user.name ILIKE :search OR user.email ILIKE :search)',
      { search: `%${query.search}%` },
    );
  }
  
  if (query.role) {
    qb.andWhere('user.role = :role', { role: query.role });
  }
  
  if (query.isActive !== undefined) {
    qb.andWhere('user.isActive = :isActive', { isActive: query.isActive });
  }
  
  qb.orderBy('user.createdAt', query.sortOrder || 'DESC')
    .skip(query.skip)
    .take(query.take);
  
  return qb.getManyAndCount();
}

// Join queries
async findUsersWithPosts() {
  return this.userRepository
    .createQueryBuilder('user')
    .leftJoinAndSelect('user.posts', 'post')
    .where('post.isPublished = :published', { published: true })
    .getMany();
}
```

## Events (Subscribers)

```typescript
// user.subscriber.ts
import {
  EntitySubscriber,
  EventSubscriber,
  InsertEvent,
  UpdateEvent,
  RemoveEvent,
} from 'typeorm';
import { User } from './entities/user.entity';

@EventSubscriber()
export class UserSubscriber implements EntitySubscriber<User> {
  listenTo() {
    return User;
  }

  beforeInsert(event: InsertEvent<User>) {
    console.log('Before Insert:', event.entity);
  }

  afterInsert(event: InsertEvent<User>) {
    console.log('After Insert:', event.entity);
  }

  beforeUpdate(event: UpdateEvent<User>) {
    console.log('Before Update:', event.entity);
  }

  afterRemove(event: RemoveEvent<User>) {
    console.log('After Remove:', event.entity);
  }
}
```