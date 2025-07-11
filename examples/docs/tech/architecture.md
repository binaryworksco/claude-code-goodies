# Keystone Architecture Overview

## Table of Contents

1. [Introduction](#introduction)
2. [System Overview](#system-overview)
3. [Architectural Principles](#architectural-principles)
4. [Technology Stack](#technology-stack)
5. [Module Architecture](#module-architecture)
6. [Multi-Tenancy Architecture](#multi-tenancy-architecture)
7. [Event-Driven Architecture](#event-driven-architecture)
8. [Security Architecture](#security-architecture)
9. [Data Architecture](#data-architecture)
10. [Infrastructure Architecture](#infrastructure-architecture)
11. [API Architecture](#api-architecture)
12. [Development Architecture](#development-architecture)
13. [Deployment Architecture](#deployment-architecture)
14. [Architectural Decisions](#architectural-decisions)
15. [Future Considerations](#future-considerations)

## Introduction

Keystone is a multi-tenant SaaS application built as a modular monolith using .NET 9. It's designed to provide a scalable, maintainable, and secure platform that can evolve from a monolith to microservices if needed. The architecture emphasizes clean boundaries, eventual consistency, and tenant isolation.

### Key Characteristics

- **Modular Monolith**: Single deployable unit with clear module boundaries
- **Multi-Tenant**: Complete tenant isolation at application and database levels
- **Event-Driven**: Asynchronous communication between modules
- **Clean Architecture**: Separation of concerns with clear dependencies
- **CQRS Pattern**: Command/Query separation for all operations
- **Domain-Driven Design**: Rich domain models with business logic

## System Overview

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         Load Balancer                           │
└─────────────────────────────────────────────────────────────────┘
                                 │
┌─────────────────────────────────────────────────────────────────┐
│                        Keystone API                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐              │
│  │   Users     │  │  Employees  │  │   Tenants   │              │
│  │   Module    │  │   Module    │  │   Module    │              │
│  └─────────────┘  └─────────────┘  └─────────────┘              │
│  ┌───────────────────────────────────────────────┐              │
│  │            Common Infrastructure              │              │
│  │  (Auth, Events, Caching, Logging, Tracing)   │               │
│  └───────────────────────────────────────────────┘              │
└─────────────────────────────────────────────────────────────────┘
                │               │               │
    ┌───────────┴────┐   ┌──────┴──────┐   ┌────┴───────┐
    │  PostgreSQL    │   │    Redis    │   │  Keycloak  │
    │  (Multi-DB)    │   │  (Cache &   │   │   (IAM)    │
    │                │   │  Messages)  │   │            │
    └────────────────┘   └─────────────┘   └────────────┘
```

### Component Overview

1. **API Layer**: Single API surface hosting all modules
2. **Modules**: Self-contained business capabilities
3. **Common Infrastructure**: Shared technical capabilities
4. **External Services**: PostgreSQL, Redis, Keycloak, monitoring tools
5. **Client Applications**: Web (Blazor), BackOffice (Blazor)

## Architectural Principles

### 1. Modularity
- Each module is independent with its own domain, data, and API
- Modules communicate only through integration events
- No direct references between modules
- Each module can be developed, tested, and deployed independently

### 2. Clean Architecture
```
┌─────────────────────────────────────┐
│          Presentation               │  ← API Endpoints
├─────────────────────────────────────┤
│          Application                │  ← Use Cases (CQRS)
├─────────────────────────────────────┤
│            Domain                   │  ← Business Logic
├─────────────────────────────────────┤
│         Infrastructure              │  ← External Concerns
└─────────────────────────────────────┘
```

### 3. Domain-Driven Design
- Rich domain models encapsulating business logic
- Ubiquitous language reflected in code
- Bounded contexts aligned with modules
- Aggregate roots ensuring consistency

### 4. CQRS (Command Query Responsibility Segregation)
- Commands modify state through domain models
- Queries bypass domain for optimized reads
- Clear separation of write and read models
- MediatR for request/response handling

### 5. Event-Driven Architecture
- Domain events for intra-module communication
- Integration events for inter-module communication
- Eventual consistency between modules
- Event sourcing capabilities (future)

## Technology Stack

### Core Platform
- **.NET 9**: Latest LTS version with C# 13
- **ASP.NET Core**: Web framework for APIs
- **Blazor Server**: UI framework for web applications
- **Entity Framework Core 9**: ORM for data access

### Infrastructure
- **PostgreSQL**: Primary database (multi-tenant)
- **Redis**: Distributed cache and message transport
- **Keycloak**: Identity and access management
- **Docker**: Containerization platform

### Libraries & Frameworks
- **MediatR**: CQRS implementation
- **MassTransit**: Message bus abstraction
- **FluentValidation**: Input validation
- **Serilog**: Structured logging
- **OpenTelemetry**: Distributed tracing
- **Polly**: Resilience and transient fault handling
- **Quartz.NET**: Job scheduling

### Development Tools
- **Swagger/OpenAPI**: API documentation
- **xUnit**: Testing framework
- **Moq**: Mocking framework
- **FluentAssertions**: Assertion library
- **NetArchTest**: Architecture testing
- **TestContainers**: Integration testing

## Module Architecture

### Module Structure
```
/Modules/{ModuleName}/
├── Keystone.Modules.{ModuleName}.Domain/
│   ├── Entities/
│   ├── ValueObjects/
│   ├── Events/
│   ├── Errors/
│   └── Repositories/
├── Keystone.Modules.{ModuleName}.Application/
│   ├── {Feature}/
│   │   ├── Commands/
│   │   ├── Queries/
│   │   └── Validators/
│   └── Common/
│       ├── Behaviors/
│       └── Mappings/
├── Keystone.Modules.{ModuleName}.Infrastructure/
│   ├── Persistence/
│   │   ├── Configurations/
│   │   ├── Migrations/
│   │   └── Repositories/
│   ├── BackgroundJobs/
│   └── ExternalServices/
├── Keystone.Modules.{ModuleName}.IntegrationEvents/
│   └── Events/
├── Keystone.Modules.{ModuleName}.Presentation/
│   ├── Endpoints/
│   └── Permissions/
└── Tests/
    ├── UnitTests/
    ├── IntegrationTests/
    └── ArchitectureTests/
```

### Module Independence
- **No Direct References**: Modules cannot reference each other
- **Shared Contracts**: Integration events are the only shared contracts
- **Independent Deployment**: Each module is independently deployable (future)
- **Technology Freedom**: Modules can use different technologies (within reason)

### Module Communication
```
┌──────────────┐     Integration      ┌──────────────┐
│   Module A   │───────Event──────────►│   Module B   │
│              │                       │              │
│  Domain Event│                       │   Inbox      │
│      ↓       │                       │     ↓        │
│   Outbox     │                       │  Handler     │
└──────────────┘                       └──────────────┘
```

### Current Modules

1. **Users Module**
   - User registration and authentication
   - Profile management
   - Role and permission assignment

2. **Employees Module**
   - Employee records management
   - Department and position tracking
   - Integration with Users module

3. **Tenants Module**
   - Tenant provisioning
   - Subscription management
   - Tenant configuration

## Multi-Tenancy Architecture

### Design Philosophy
Multi-tenancy is implemented using a hybrid approach:
- **Row-Level Security**: Data isolation at the database level
- **Application-Level Filtering**: Automatic tenant context injection
- **Shadow Properties**: Clean domain models without tenant concerns

### Tenant Isolation Layers

#### 1. Authentication Layer
```
Keycloak Realms:
├── keystone (master realm)
└── tenant-{subdomain} (per-tenant realm)
    ├── Users
    ├── Clients
    └── Permissions
```

#### 2. Application Layer
```csharp
// Automatic tenant context injection
public class TenantMiddleware
{
    public async Task InvokeAsync(HttpContext context)
    {
        // Extract tenant from JWT issuer
        var tenantId = ExtractTenantFromToken(context);
        
        // Set tenant context
        _tenantContext.SetTenant(tenantId);
        
        await _next(context);
    }
}
```

#### 3. Data Access Layer
```csharp
// Global query filters
protected override void OnModelCreating(ModelBuilder modelBuilder)
{
    modelBuilder.Entity<User>()
        .HasQueryFilter(u => EF.Property<Guid>(u, "TenantId") == _tenantContext.TenantId);
}

// Shadow properties keep domain clean
public class User : Entity
{
    // No TenantId property here - it's a shadow property
    public string Email { get; private set; }
    public string FirstName { get; private set; }
}
```

### Tenant Resolution Strategy

1. **Authenticated Users**: Tenant extracted from JWT issuer
2. **Service Accounts**: Can specify target tenant via query parameter
3. **Development Mode**: Subdomain or query parameter
4. **BackOffice**: Special permissions for cross-tenant operations

### Database Architecture
```sql
-- Each table includes tenant_id
CREATE TABLE users.users (
    id UUID PRIMARY KEY,
    tenant_id UUID NOT NULL,
    email VARCHAR(256) NOT NULL,
    -- other columns
    CONSTRAINT uk_users_tenant_email UNIQUE (tenant_id, email)
);

-- Row-Level Security Policy
CREATE POLICY tenant_isolation ON users.users
    USING (tenant_id = current_setting('app.current_tenant')::uuid);
```

## Event-Driven Architecture

### Event Types

#### Domain Events
- **Purpose**: Intra-module communication
- **Processing**: Synchronous, within same transaction
- **Naming**: Past tense with "DomainEvent" suffix
- **Example**: `UserRegisteredDomainEvent`

```csharp
public sealed record UserRegisteredDomainEvent(
    Guid UserId,
    string Email,
    DateTime OccurredOn) : IDomainEvent;
```

#### Integration Events
- **Purpose**: Inter-module communication
- **Processing**: Asynchronous, eventual consistency
- **Transport**: Redis via MassTransit
- **Naming**: Past tense with "IntegrationEvent" suffix
- **Example**: `UserRegisteredIntegrationEvent`

```csharp
public sealed record UserRegisteredIntegrationEvent(
    Guid UserId,
    string Email,
    string FirstName,
    string LastName,
    DateTime OccurredOn) : IIntegrationEvent;
```

### Event Flow Architecture

```
Domain Layer          Application Layer       Infrastructure Layer
     │                      │                        │
User.Register() ──────► Domain Event ──────► Domain Handler
                            │                        │
                            └──────────────────► Outbox Table
                                                     │
                                            Background Job
                                                     │
                                            Integration Event
                                                     │
                                               Message Bus
                                                     │
                                              Other Modules
```

### Outbox/Inbox Pattern

#### Outbox (Publishing)
```csharp
public class OutboxMessageInterceptor : SaveChangesInterceptor
{
    public override async ValueTask<InterceptionResult<int>> SavingChangesAsync(
        DbContextEventData eventData,
        InterceptionResult<int> result)
    {
        // Convert domain events to outbox messages
        var domainEvents = GetDomainEvents(eventData.Context);
        var outboxMessages = ConvertToOutboxMessages(domainEvents);
        
        // Save to outbox table
        await eventData.Context.Set<OutboxMessage>().AddRangeAsync(outboxMessages);
        
        return result;
    }
}
```

#### Inbox (Consuming)
```csharp
public class IntegrationEventConsumer<TEvent> : IConsumer<TEvent>
    where TEvent : IIntegrationEvent
{
    public async Task Consume(ConsumeContext<TEvent> context)
    {
        // Idempotency check
        if (await _inbox.ExistsAsync(context.MessageId))
            return;
            
        // Process event
        await _handler.Handle(context.Message);
        
        // Mark as processed
        await _inbox.MarkAsProcessedAsync(context.MessageId);
    }
}
```

### Event Bus Configuration
```csharp
services.AddMassTransit(x =>
{
    // Register consumers
    x.AddConsumers(Assembly.GetExecutingAssembly());
    
    // Configure Redis transport
    x.UsingRedis((context, cfg) =>
    {
        cfg.Host(configuration.GetConnectionString("Cache"));
        
        // Configure retry policy
        cfg.UseMessageRetry(retry => retry.Exponential(
            retryCount: 3,
            minInterval: TimeSpan.FromSeconds(5),
            maxInterval: TimeSpan.FromSeconds(30),
            intervalDelta: TimeSpan.FromSeconds(5)));
    });
});
```

## Security Architecture

### Authentication Architecture

#### Keycloak Integration
```
┌─────────────────┐         ┌─────────────────┐
│   Client App    │────────►│   Keycloak      │
│                 │         │                 │
│                 │◄────────│  - Multi-realm  │
│                 │  JWT    │  - OIDC/OAuth2  │
└─────────────────┘         └─────────────────┘
         │
         │ JWT with permissions
         ▼
┌─────────────────┐
│  Keystone API   │
│                 │
│ - JWT validation│
│ - Permission    │
│   enforcement   │
└─────────────────┘
```

#### JWT Token Structure
```json
{
  "sub": "user-id",
  "email": "user@example.com",
  "iss": "http://keycloak/realms/tenant-acme",
  "permissions": [
    "users:read",
    "users:write",
    "employees:read"
  ],
  "tenant_id": "acme-corp-guid"
}
```

### Authorization Architecture

#### Permission-Based Access Control
```csharp
// Permission definitions
public static class UsersPermissions
{
    public const string View = "users:read";
    public const string Create = "users:write";
    public const string Update = "users:write";
    public const string Delete = "users:delete";
}

// Endpoint authorization
app.MapGet("/users", GetUsers)
   .RequireAuthorization(UsersPermissions.View);
```

#### Authorization Pipeline
```
Request ──► JWT Validation ──► Extract Permissions ──► Check Endpoint
   │                                                         │
   │                                                         ▼
   │                                                   Authorized?
   │                                                    │      │
   │                                                   Yes     No
   │                                                    │      │
   └────────────────────────► Process ◄────────────────┘      │
                                                               │
                                                          403 Forbidden
```

### Tenant Isolation Security

#### Application Layer
- Automatic tenant filtering via global query filters
- Tenant context validation in pipeline behaviors
- Cross-tenant access only for service accounts

#### Database Layer
- Row-Level Security policies
- Unique constraints include tenant_id
- Separate schemas per module

#### API Layer
- Tenant extraction from JWT
- Tenant validation middleware
- Audit logging of all operations

## Data Architecture

### Database Design

#### Schema Organization
```
PostgreSQL Database
├── public (default schema)
├── users (Users module)
│   ├── users
│   ├── roles
│   └── user_roles
├── employees (Employees module)
│   ├── employees
│   ├── departments
│   └── positions
├── tenants (Tenants module)
│   ├── tenants
│   └── subscriptions
└── common (Shared tables)
    ├── outbox_messages
    └── inbox_messages
```

#### Entity Design Patterns

##### Base Entity
```csharp
public abstract class Entity
{
    public Guid Id { get; protected set; }
    
    private readonly List<IDomainEvent> _domainEvents = new();
    public IReadOnlyList<IDomainEvent> DomainEvents => _domainEvents.AsReadOnly();
    
    protected void RaiseDomainEvent(IDomainEvent domainEvent)
    {
        _domainEvents.Add(domainEvent);
    }
    
    public void ClearDomainEvents()
    {
        _domainEvents.Clear();
    }
}
```

##### Audit Fields (Shadow Properties)
```csharp
public class AuditInterceptor : SaveChangesInterceptor
{
    public override ValueTask<InterceptionResult<int>> SavingChangesAsync(...)
    {
        foreach (var entry in context.ChangeTracker.Entries<Entity>())
        {
            if (entry.State == EntityState.Added)
            {
                entry.Property("CreatedAt").CurrentValue = DateTime.UtcNow;
                entry.Property("CreatedBy").CurrentValue = _currentUser.Id;
            }
            
            if (entry.State == EntityState.Modified)
            {
                entry.Property("ModifiedAt").CurrentValue = DateTime.UtcNow;
                entry.Property("ModifiedBy").CurrentValue = _currentUser.Id;
            }
        }
    }
}
```

### Data Access Patterns

#### Repository Pattern
```csharp
public interface IRepository<T> where T : Entity
{
    Task<T?> GetByIdAsync(Guid id, CancellationToken cancellationToken = default);
    void Add(T entity);
    void Update(T entity);
    void Remove(T entity);
}

public class Repository<T> : IRepository<T> where T : Entity
{
    protected readonly DbContext Context;
    protected readonly DbSet<T> DbSet;
    
    public Repository(DbContext context)
    {
        Context = context;
        DbSet = context.Set<T>();
    }
    
    public virtual async Task<T?> GetByIdAsync(
        Guid id, 
        CancellationToken cancellationToken = default)
    {
        return await DbSet.FirstOrDefaultAsync(
            e => e.Id == id, 
            cancellationToken);
    }
}
```

#### Unit of Work Pattern
```csharp
public interface IUnitOfWork
{
    Task<int> SaveChangesAsync(CancellationToken cancellationToken = default);
}

public class UnitOfWork<TContext> : IUnitOfWork
    where TContext : DbContext
{
    private readonly TContext _context;
    
    public UnitOfWork(TContext context)
    {
        _context = context;
    }
    
    public async Task<int> SaveChangesAsync(
        CancellationToken cancellationToken = default)
    {
        return await _context.SaveChangesAsync(cancellationToken);
    }
}
```

### Caching Architecture

#### Cache Layers
1. **Distributed Cache (Redis)**
   - User sessions
   - Frequently accessed reference data
   - Query results

2. **In-Memory Cache**
   - Configuration data
   - Permission mappings
   - Tenant metadata

#### Cache Patterns
```csharp
public class CachedUserRepository : IUserRepository
{
    private readonly IUserRepository _inner;
    private readonly ICacheService _cache;
    
    public async Task<User?> GetByIdAsync(Guid id, CancellationToken ct)
    {
        var cacheKey = $"user:{id}";
        
        // Try cache first
        var cached = await _cache.GetAsync<User>(cacheKey, ct);
        if (cached != null)
            return cached;
            
        // Get from database
        var user = await _inner.GetByIdAsync(id, ct);
        
        // Cache for next time
        if (user != null)
        {
            await _cache.SetAsync(
                cacheKey, 
                user, 
                TimeSpan.FromMinutes(5), 
                ct);
        }
        
        return user;
    }
}
```

## Infrastructure Architecture

### Service Architecture

#### Core Services
```
┌────────────────────────────────────────────────────┐
│                 Infrastructure Services             │
├─────────────────┬────────────────┬─────────────────┤
│  Authentication │     Caching    │     Events      │
│    - JWT        │   - Redis      │  - MassTransit  │
│    - Keycloak   │   - Memory     │  - Outbox       │
├─────────────────┼────────────────┼─────────────────┤
│    Logging      │   Monitoring   │   Persistence   │
│  - Serilog      │ - OpenTelemetry│  - EF Core      │
│  - Seq          │ - Jaeger       │  - PostgreSQL   │
└─────────────────┴────────────────┴─────────────────┘
```

#### Background Services
```csharp
// Outbox processor
public class OutboxProcessor : BackgroundService
{
    protected override async Task ExecuteAsync(CancellationToken ct)
    {
        while (!ct.IsCancellationRequested)
        {
            // Process outbox messages
            var messages = await _outboxRepository.GetUnprocessedAsync(ct);
            
            foreach (var message in messages)
            {
                await _messageBus.PublishAsync(message, ct);
                await _outboxRepository.MarkAsProcessedAsync(message.Id, ct);
            }
            
            await Task.Delay(TimeSpan.FromSeconds(10), ct);
        }
    }
}
```

### Observability Architecture

#### Logging
```csharp
// Structured logging with Serilog
Log.Logger = new LoggerConfiguration()
    .MinimumLevel.Information()
    .Enrich.FromLogContext()
    .Enrich.WithTenantId()
    .Enrich.WithCorrelationId()
    .WriteTo.Console()
    .WriteTo.Seq(configuration["Seq:ServerUrl"])
    .CreateLogger();
```

#### Distributed Tracing
```csharp
// OpenTelemetry configuration
services.AddOpenTelemetry()
    .WithTracing(builder =>
    {
        builder
            .SetResourceBuilder(ResourceBuilder.CreateDefault()
                .AddService("Keystone.Api"))
            .AddAspNetCoreInstrumentation()
            .AddHttpClientInstrumentation()
            .AddEntityFrameworkCoreInstrumentation()
            .AddRedisInstrumentation()
            .AddJaegerExporter();
    });
```

#### Health Checks
```csharp
services.AddHealthChecks()
    .AddNpgSql(connectionString, name: "postgresql")
    .AddRedis(redisConnection, name: "redis")
    .AddUrlGroup(new Uri(keycloakUrl), name: "keycloak");
```

### Resilience Patterns

#### Retry Policies
```csharp
services.AddHttpClient<IKeycloakService, KeycloakService>()
    .AddPolicyHandler(GetRetryPolicy());

static IAsyncPolicy<HttpResponseMessage> GetRetryPolicy()
{
    return HttpPolicyExtensions
        .HandleTransientHttpError()
        .WaitAndRetryAsync(
            retryCount: 3,
            sleepDurationProvider: retryAttempt => 
                TimeSpan.FromSeconds(Math.Pow(2, retryAttempt)),
            onRetry: (outcome, timespan, retryCount, context) =>
            {
                Log.Warning(
                    "Retry {RetryCount} after {Timespan}s", 
                    retryCount, 
                    timespan.TotalSeconds);
            });
}
```

#### Circuit Breaker
```csharp
services.AddHttpClient<IExternalService, ExternalService>()
    .AddPolicyHandler(GetCircuitBreakerPolicy());

static IAsyncPolicy<HttpResponseMessage> GetCircuitBreakerPolicy()
{
    return HttpPolicyExtensions
        .HandleTransientHttpError()
        .CircuitBreakerAsync(
            handledEventsAllowedBeforeBreaking: 5,
            durationOfBreak: TimeSpan.FromSeconds(30));
}
```

## API Architecture

### Minimal API Design

#### Endpoint Pattern
```csharp
public interface IEndpoint
{
    void MapEndpoint(IEndpointRouteBuilder app);
}

public sealed class GetUserEndpoint : IEndpoint
{
    public void MapEndpoint(IEndpointRouteBuilder app)
    {
        app.MapGet("/users/{id:guid}", async (
            Guid id,
            ISender sender,
            CancellationToken cancellationToken) =>
        {
            var query = new GetUserByIdQuery(id);
            var result = await sender.Send(query, cancellationToken);
            
            return result.Match(
                user => Results.Ok(user),
                error => Results.Problem(error.ToProblemDetails()));
        })
        .WithName("GetUser")
        .WithTags("Users")
        .RequireAuthorization(UsersPermissions.View)
        .Produces<UserResponse>(StatusCodes.Status200OK)
        .Produces<ProblemDetails>(StatusCodes.Status404NotFound)
        .WithOpenApi();
    }
}
```

#### Module Registration
```csharp
public static class UsersModule
{
    public static IServiceCollection AddUsersModule(
        this IServiceCollection services,
        IConfiguration configuration)
    {
        // Add module services
        services
            .AddDomain()
            .AddApplication()
            .AddInfrastructure(configuration)
            .AddPresentation();
            
        return services;
    }
    
    public static IEndpointRouteBuilder MapUsersEndpoints(
        this IEndpointRouteBuilder app)
    {
        var endpoints = app.ServiceProvider
            .GetServices<IEndpoint>()
            .Where(e => e.GetType().Namespace!.Contains("Users"));
            
        foreach (var endpoint in endpoints)
        {
            endpoint.MapEndpoint(app);
        }
        
        return app;
    }
}
```

### API Versioning Strategy
```csharp
// Future implementation
app.MapGet("/v1/users", GetUsersV1);
app.MapGet("/v2/users", GetUsersV2);

// Header-based versioning alternative
app.MapGet("/users", (HttpContext context) =>
{
    var version = context.Request.Headers["API-Version"];
    return version switch
    {
        "2.0" => GetUsersV2(),
        _ => GetUsersV1()
    };
});
```

### Request/Response Pipeline

```
Request
   │
   ▼
Middleware Pipeline
   ├── Exception Handling
   ├── Request Logging
   ├── Authentication
   ├── Tenant Resolution
   ├── Authorization
   └── Request Validation
   │
   ▼
Endpoint Handler
   │
   ▼
MediatR Pipeline
   ├── Validation Behavior
   ├── Logging Behavior
   ├── Tenant Validation
   └── Exception Handling
   │
   ▼
Command/Query Handler
   │
   ▼
Domain Logic
   │
   ▼
Response
```

## Development Architecture

### Project Structure
```
/Keystone
├── src/
│   ├── API/
│   │   └── Keystone.Api/
│   ├── Common/
│   │   ├── Keystone.Common.Domain/
│   │   ├── Keystone.Common.Application/
│   │   ├── Keystone.Common.Infrastructure/
│   │   └── Keystone.Common.Presentation/
│   ├── Modules/
│   │   ├── Users/
│   │   ├── Employees/
│   │   └── Tenants/
│   └── Apps/
│       ├── Keystone.Web/
│       └── Keystone.BackOffice/
├── tests/
│   ├── Architecture/
│   └── Performance/
├── tools/
│   └── create-module.sh
├── scripts/
│   ├── start-infrastructure.sh
│   └── run-migrations.sh
└── docs/
    ├── architecture/
    ├── api/
    └── deployment/
```

### Development Workflow

#### Local Development Setup
```bash
# 1. Start infrastructure
docker-compose up -d

# 2. Run migrations
dotnet ef database update --project src/Modules/Users/Infrastructure

# 3. Start API
dotnet run --project src/API/Keystone.Api

# 4. Start Web UI
dotnet run --project src/Apps/Keystone.Web
```

#### Module Development
```bash
# Create new module
./tools/create-module.sh

# Interactive wizard guides through:
# - Module name
# - Entity definition
# - Properties and types
# - Permissions
# - Initial migration
```

### Testing Architecture

#### Test Pyramid
```
         ┌─────┐
        /       \      Architecture Tests
       /─────────\     - Module boundaries
      /           \    - Dependency rules
     /─────────────\   
    /               \  Integration Tests
   /─────────────────\ - API endpoints
  /                   \- Database operations
 /─────────────────────\
/                       \ Unit Tests
─────────────────────────  - Business logic
                           - Domain rules
```

#### Test Infrastructure
```csharp
// Base integration test
public abstract class BaseIntegrationTest : IAsyncLifetime
{
    protected HttpClient Client { get; private set; }
    protected IServiceProvider Services { get; private set; }
    
    public async Task InitializeAsync()
    {
        // Start test containers
        await _postgresContainer.StartAsync();
        await _redisContainer.StartAsync();
        
        // Configure test services
        var factory = new WebApplicationFactory<Program>()
            .WithWebHostBuilder(builder =>
            {
                builder.ConfigureServices(services =>
                {
                    // Override with test services
                });
            });
            
        Client = factory.CreateClient();
        Services = factory.Services;
    }
}
```

## Deployment Architecture

### Container Architecture
```dockerfile
# Multi-stage build
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copy and restore
COPY ["src/API/Keystone.Api/Keystone.Api.csproj", "API/Keystone.Api/"]
COPY ["src/Modules/", "Modules/"]
RUN dotnet restore "API/Keystone.Api/Keystone.Api.csproj"

# Build and publish
COPY . .
RUN dotnet publish "API/Keystone.Api/Keystone.Api.csproj" \
    -c Release -o /app/publish

# Runtime image
FROM mcr.microsoft.com/dotnet/aspnet:9.0
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "Keystone.Api.dll"]
```

### Kubernetes Architecture (Future)
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: keystone-api
spec:
  replicas: 3
  selector:
    matchLabels:
      app: keystone-api
  template:
    metadata:
      labels:
        app: keystone-api
    spec:
      containers:
      - name: api
        image: keystone/api:latest
        ports:
        - containerPort: 8080
        env:
        - name: ConnectionStrings__Database
          valueFrom:
            secretKeyRef:
              name: keystone-secrets
              key: db-connection
        livenessProbe:
          httpGet:
            path: /health
            port: 8080
        readinessProbe:
          httpGet:
            path: /health/ready
            port: 8080
```

### Infrastructure as Code
```terraform
# Example Terraform configuration
resource "aws_rds_instance" "keystone_db" {
  identifier = "keystone-postgres"
  engine     = "postgres"
  engine_version = "15.3"
  instance_class = "db.t3.medium"
  
  allocated_storage = 100
  storage_encrypted = true
  
  db_name  = "keystone"
  username = "keystone_admin"
  password = var.db_password
  
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
  
  backup_retention_period = 30
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"
  
  enabled_cloudwatch_logs_exports = ["postgresql"]
  
  tags = {
    Name        = "keystone-postgres"
    Environment = var.environment
  }
}
```

## Architectural Decisions

### ADR-001: Modular Monolith Architecture
**Status**: Accepted

**Context**: Need to build a scalable SaaS platform that can evolve over time.

**Decision**: Build as a modular monolith with clear boundaries that can be split into microservices later.

**Consequences**:
- ✅ Simpler deployment and operations initially
- ✅ Easier development and debugging
- ✅ Can evolve to microservices when needed
- ❌ All modules must use same technology stack
- ❌ Single point of failure

### ADR-002: Shadow Properties for Multi-Tenancy
**Status**: Accepted

**Context**: Need tenant isolation without polluting domain models.

**Decision**: Use EF Core shadow properties for TenantId rather than explicit properties.

**Consequences**:
- ✅ Clean domain models
- ✅ Automatic tenant filtering
- ✅ Database-level security possible
- ❌ More complex EF configuration
- ❌ Shadow properties not visible in domain

### ADR-003: CQRS with MediatR
**Status**: Accepted

**Context**: Need clear separation between commands and queries.

**Decision**: Use MediatR for CQRS implementation with separate command and query models.

**Consequences**:
- ✅ Clear separation of concerns
- ✅ Optimized read models
- ✅ Easy to add cross-cutting concerns
- ❌ More boilerplate code
- ❌ Learning curve for developers

### ADR-004: Permission-Based Authorization
**Status**: Accepted

**Context**: Need flexible authorization that can scale with features.

**Decision**: Use permission-based rather than role-based authorization.

**Consequences**:
- ✅ Fine-grained access control
- ✅ Easier to add new features
- ✅ No role explosion
- ❌ More permissions to manage
- ❌ Complex permission assignment UI

## Future Considerations

### Scalability Path

#### Phase 1: Current (Monolith)
- Single deployable unit
- Shared database
- In-process communication

#### Phase 2: Distributed Monolith
- Multiple instances with load balancing
- Read replicas for queries
- Distributed caching

#### Phase 3: Selective Extraction
- Extract high-traffic modules (e.g., Users)
- Separate databases per module
- API gateway for routing

#### Phase 4: Full Microservices
- All modules as separate services
- Service mesh for communication
- Independent deployment pipelines

### Technology Evolution

#### Database
- **Current**: Single PostgreSQL instance
- **Future**: 
  - Read replicas for scaling
  - Sharding by tenant
  - Module-specific databases
  - Event store for audit trail

#### Messaging
- **Current**: Redis + MassTransit
- **Future**:
  - Apache Kafka for high throughput
  - RabbitMQ for reliability
  - Event streaming platform

#### Search
- **Current**: Database queries
- **Future**:
  - Elasticsearch for full-text search
  - Dedicated search service
  - AI-powered search capabilities

### Performance Optimizations

#### Caching Strategy Evolution
```
Current:                    Future:
┌─────────────┐            ┌─────────────┐
│   Redis     │            │    CDN      │
│  (Simple)   │            └─────────────┘
└─────────────┘                   │
                           ┌─────────────┐
                           │  Edge Cache │
                           └─────────────┘
                                  │
                           ┌─────────────┐
                           │   Redis     │
                           │  (Advanced) │
                           └─────────────┘
```

#### Query Optimization
- Materialized views for complex queries
- CQRS read models in separate database
- GraphQL for flexible querying
- Real-time updates via SignalR

### Security Enhancements

#### Zero Trust Architecture
- Mutual TLS between services
- Service mesh for security policies
- Network segmentation
- Encrypted data at rest and in transit

#### Advanced Threat Protection
- Web Application Firewall (WAF)
- DDoS protection
- Intrusion detection
- Security event correlation

### Monitoring Evolution

#### Current State
- Basic logging with Serilog
- Simple tracing with Jaeger
- Health checks

#### Future State
- Full observability platform
- AI-powered anomaly detection
- Business metrics dashboard
- Cost optimization insights

## Conclusion

The Keystone architecture is designed to be:

1. **Scalable**: From startup to enterprise
2. **Maintainable**: Clear boundaries and patterns
3. **Secure**: Multi-layered security approach
4. **Flexible**: Can evolve with business needs
5. **Observable**: Built-in monitoring and tracing

The modular monolith approach provides the benefits of both monolithic and microservices architectures, allowing the system to start simple and evolve as needed. The use of modern patterns like CQRS, event-driven architecture, and clean architecture ensures the codebase remains maintainable and testable as it grows.

For detailed implementation guidelines, refer to the [Coding Standards](coding-standards.md) document.