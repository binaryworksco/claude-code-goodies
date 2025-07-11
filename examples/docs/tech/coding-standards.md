# Keystone Coding Standards

This document outlines the coding standards and conventions for the Keystone project. All contributors should follow these guidelines to maintain consistency and quality across the codebase.

## Table of Contents

1. [General Principles](#general-principles)
2. [C# Coding Conventions](#c-coding-conventions)
3. [Architecture Standards](#architecture-standards)
4. [API Design Standards](#api-design-standards)
5. [Testing Standards](#testing-standards)
6. [Database Standards](#database-standards)
7. [Documentation Standards](#documentation-standards)
8. [Multi-Tenancy Standards](#multi-tenancy-standards)
9. [Error Handling Standards](#error-handling-standards)
10. [Performance Guidelines](#performance-guidelines)

## General Principles

### Core Values
- **Clarity over Cleverness**: Write code that is easy to understand and maintain
- **Consistency over Personal Preference**: Follow established patterns even if you prefer alternatives
- **Explicit over Implicit**: Make intentions clear in your code
- **Composition over Inheritance**: Favor object composition for flexibility
- **SOLID Principles**: Apply Single Responsibility, Open/Closed, Liskov Substitution, Interface Segregation, and Dependency Inversion
- **DRY (Don't Repeat Yourself)**: Avoid duplication, but don't over-abstract
- **YAGNI (You Aren't Gonna Need It)**: Don't add functionality until it's needed

## C# Coding Conventions

### Naming Conventions

#### Classes and Interfaces
```csharp
// Classes use PascalCase
public class UserRepository { }

// Interfaces are prefixed with 'I'
public interface IUserRepository { }

// Domain entities are singular nouns
public class User { }
public class Employee { }

// Commands and Queries are descriptive
public sealed record RegisterUserCommand { }
public sealed record GetUserByIdQuery { }

// Handlers are suffixed with 'Handler'
public class RegisterUserCommandHandler { }
```

#### Methods and Properties
```csharp
// Public members use PascalCase
public string FirstName { get; set; }
public async Task<User> GetByIdAsync(Guid id) { }

// Private fields use underscore prefix
private readonly IUserRepository _userRepository;
private readonly ILogger<UserService> _logger;

// Local variables and parameters use camelCase
var userId = Guid.NewGuid();
public void ProcessUser(string firstName, string lastName) { }

// Async methods are suffixed with 'Async'
public async Task<Result<User>> CreateAsync(User user) { }
```

#### Constants and Enums
```csharp
// Constants use PascalCase
public const string DefaultConnectionString = "Server=localhost";

// Enum types use PascalCase
public enum UserStatus
{
    Active,
    Inactive,
    Suspended
}
```

### Language Features

#### C# 12+ Features
```csharp
// Use primary constructors
public class UserService(IUserRepository repository, ILogger<UserService> logger)
{
    // Implementation
}

// Use file-scoped namespaces
namespace Keystone.Modules.Users.Application;

// Use target-typed new
User user = new("John", "Doe");

// Use pattern matching
var message = status switch
{
    UserStatus.Active => "User is active",
    UserStatus.Inactive => "User is inactive",
    _ => "Unknown status"
};
```

#### Records and Immutability
```csharp
// Use records for DTOs and immutable data
public sealed record UserResponse(
    Guid Id,
    string Email,
    string FirstName,
    string LastName);

// Use init-only properties for optional immutability
public class UserConfiguration
{
    public string DefaultRole { get; init; }
    public int MaxLoginAttempts { get; init; }
}
```

#### LINQ Usage
```csharp
// Prefer method syntax over query syntax
var activeUsers = users
    .Where(u => u.Status == UserStatus.Active)
    .OrderBy(u => u.LastName)
    .ThenBy(u => u.FirstName)
    .ToList();

// Always materialize queries explicitly
var userCount = await context.Users.CountAsync(cancellationToken);
var userList = await query.ToListAsync(cancellationToken);

// Use projection for DTOs
var userDtos = await context.Users
    .Where(u => u.IsActive)
    .Select(u => new UserDto
    {
        Id = u.Id,
        Name = $"{u.FirstName} {u.LastName}"
    })
    .ToListAsync(cancellationToken);
```

### Code Organization

#### File Organization
```
/Modules/Users/
├── Keystone.Modules.Users.Domain/
│   ├── Entities/
│   │   └── User.cs
│   ├── Events/
│   │   └── UserRegisteredDomainEvent.cs
│   └── Repositories/
│       └── IUserRepository.cs
├── Keystone.Modules.Users.Application/
│   ├── Users/
│   │   ├── RegisterUser/
│   │   │   ├── RegisterUserCommand.cs
│   │   │   ├── RegisterUserCommandHandler.cs
│   │   │   └── RegisterUserCommandValidator.cs
│   │   └── GetUser/
│   │       ├── GetUserQuery.cs
│   │       └── GetUserQueryHandler.cs
│   └── Common/
│       └── UserMappings.cs
```

#### Class Organization
```csharp
public class UserService
{
    // 1. Fields
    private readonly IUserRepository _repository;
    private readonly ILogger<UserService> _logger;

    // 2. Constructors
    public UserService(IUserRepository repository, ILogger<UserService> logger)
    {
        _repository = repository;
        _logger = logger;
    }

    // 3. Public properties
    public int MaxRetries { get; init; } = 3;

    // 4. Public methods
    public async Task<Result<User>> CreateUserAsync(CreateUserRequest request)
    {
        // Implementation
    }

    // 5. Protected methods
    protected virtual void OnUserCreated(User user)
    {
        // Implementation
    }

    // 6. Private methods
    private bool ValidateEmail(string email)
    {
        // Implementation
    }

    // 7. Nested types
    public sealed record CreateUserRequest(string Email, string Password);
}
```

## Architecture Standards

### Clean Architecture Layers

#### Domain Layer
```csharp
// Entities are clean - no infrastructure concerns
public class User : Entity
{
    public string Email { get; private set; }
    public string FirstName { get; private set; }
    public string LastName { get; private set; }
    
    // Business logic methods
    public void UpdateProfile(string firstName, string lastName)
    {
        FirstName = firstName;
        LastName = lastName;
        
        // Raise domain event
        RaiseDomainEvent(new UserProfileUpdatedDomainEvent(Id, firstName, lastName));
    }
}

// Domain events are immutable records
public sealed record UserProfileUpdatedDomainEvent(
    Guid UserId,
    string FirstName,
    string LastName) : IDomainEvent;

// Repository interfaces belong in domain
public interface IUserRepository
{
    Task<User?> GetByIdAsync(Guid id, CancellationToken cancellationToken = default);
    Task<User?> GetByEmailAsync(string email, CancellationToken cancellationToken = default);
    void Add(User user);
    void Update(User user);
    void Remove(User user);
}
```

#### Application Layer
```csharp
// Commands modify state
public sealed record CreateUserCommand(
    string Email,
    string Password,
    string FirstName,
    string LastName) : ICommand<Result<Guid>>;

// Command handlers contain business logic
public sealed class CreateUserCommandHandler : ICommandHandler<CreateUserCommand, Result<Guid>>
{
    private readonly IUserRepository _userRepository;
    private readonly IUnitOfWork _unitOfWork;

    public CreateUserCommandHandler(
        IUserRepository userRepository,
        IUnitOfWork unitOfWork)
    {
        _userRepository = userRepository;
        _unitOfWork = unitOfWork;
    }

    public async Task<Result<Guid>> Handle(
        CreateUserCommand command,
        CancellationToken cancellationToken)
    {
        // Check if user exists
        var existingUser = await _userRepository.GetByEmailAsync(
            command.Email, 
            cancellationToken);
            
        if (existingUser is not null)
        {
            return Result.Failure<Guid>(UserErrors.EmailAlreadyExists);
        }

        // Create user
        var user = User.Create(
            command.Email,
            command.Password,
            command.FirstName,
            command.LastName);

        // Add to repository
        _userRepository.Add(user);

        // Save changes
        await _unitOfWork.SaveChangesAsync(cancellationToken);

        return Result.Success(user.Id);
    }
}

// Validators use FluentValidation
public sealed class CreateUserCommandValidator : AbstractValidator<CreateUserCommand>
{
    public CreateUserCommandValidator()
    {
        RuleFor(x => x.Email)
            .NotEmpty()
            .EmailAddress()
            .MaximumLength(256);

        RuleFor(x => x.Password)
            .NotEmpty()
            .MinimumLength(8)
            .Matches(@"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)")
            .WithMessage("Password must contain at least one uppercase letter, one lowercase letter, and one number");

        RuleFor(x => x.FirstName)
            .NotEmpty()
            .MaximumLength(100);

        RuleFor(x => x.LastName)
            .NotEmpty()
            .MaximumLength(100);
    }
}
```

#### Infrastructure Layer
```csharp
// Repository implementations
public sealed class UserRepository : IUserRepository
{
    private readonly UsersDbContext _context;

    public UserRepository(UsersDbContext context)
    {
        _context = context;
    }

    public async Task<User?> GetByIdAsync(Guid id, CancellationToken cancellationToken = default)
    {
        return await _context.Users
            .FirstOrDefaultAsync(u => u.Id == id, cancellationToken);
    }

    public async Task<User?> GetByEmailAsync(string email, CancellationToken cancellationToken = default)
    {
        return await _context.Users
            .FirstOrDefaultAsync(u => u.Email == email, cancellationToken);
    }

    public void Add(User user)
    {
        _context.Users.Add(user);
    }

    public void Update(User user)
    {
        _context.Users.Update(user);
    }

    public void Remove(User user)
    {
        _context.Users.Remove(user);
    }
}

// DbContext configuration
public sealed class UsersDbContext : TenantAwareDbContext
{
    public DbSet<User> Users => Set<User>();

    public UsersDbContext(DbContextOptions<UsersDbContext> options, ITenantContext tenantContext)
        : base(options, tenantContext)
    {
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);
        
        modelBuilder.HasDefaultSchema("users");
        modelBuilder.ApplyConfigurationsFromAssembly(typeof(UsersDbContext).Assembly);
    }
}

// Entity configuration
public sealed class UserConfiguration : IEntityTypeConfiguration<User>
{
    public void Configure(EntityTypeBuilder<User> builder)
    {
        builder.ToTable("users");

        builder.HasKey(u => u.Id);

        builder.Property(u => u.Email)
            .HasMaxLength(256)
            .IsRequired();

        builder.HasIndex(u => u.Email)
            .IsUnique();

        builder.Property(u => u.FirstName)
            .HasMaxLength(100)
            .IsRequired();

        builder.Property(u => u.LastName)
            .HasMaxLength(100)
            .IsRequired();

        // Configure shadow property for multi-tenancy
        builder.Property<Guid>("TenantId");
        builder.HasIndex("TenantId");
    }
}
```

### CQRS Pattern

#### Commands and Queries
```csharp
// Commands modify state and return results
public sealed record UpdateUserCommand(Guid Id, string FirstName, string LastName) 
    : ICommand<Result>;

// Queries read state and return data
public sealed record GetUserByIdQuery(Guid Id) 
    : IQuery<Result<UserResponse>>;

// Queries can include pagination
public sealed record GetUsersQuery(
    string? SearchTerm,
    int Page = 1,
    int PageSize = 20) : IQuery<Result<PagedList<UserResponse>>>;
```

#### Result Pattern
```csharp
// Use Result pattern for all operations
public async Task<Result<UserResponse>> Handle(
    GetUserByIdQuery query,
    CancellationToken cancellationToken)
{
    var user = await _userRepository.GetByIdAsync(query.Id, cancellationToken);
    
    if (user is null)
    {
        return Result.Failure<UserResponse>(UserErrors.NotFound(query.Id));
    }

    var response = new UserResponse(
        user.Id,
        user.Email,
        user.FirstName,
        user.LastName);

    return Result.Success(response);
}

// Define errors as static methods
public static class UserErrors
{
    public static Error NotFound(Guid userId) => 
        new("User.NotFound", $"User with ID '{userId}' was not found.");

    public static readonly Error EmailAlreadyExists = 
        new("User.EmailAlreadyExists", "A user with this email already exists.");
}
```

### Event-Driven Architecture

#### Domain Events
```csharp
// Domain events for intra-module communication
public sealed record UserRegisteredDomainEvent(
    Guid UserId,
    string Email,
    DateTime RegisteredAt) : IDomainEvent;

// Domain event handlers
public sealed class UserRegisteredDomainEventHandler 
    : IDomainEventHandler<UserRegisteredDomainEvent>
{
    private readonly IEmailService _emailService;

    public UserRegisteredDomainEventHandler(IEmailService emailService)
    {
        _emailService = emailService;
    }

    public async Task Handle(
        UserRegisteredDomainEvent notification, 
        CancellationToken cancellationToken)
    {
        // Send welcome email
        await _emailService.SendWelcomeEmailAsync(
            notification.Email, 
            cancellationToken);
    }
}
```

#### Integration Events
```csharp
// Integration events for cross-module communication
public sealed record UserRegisteredIntegrationEvent(
    Guid UserId,
    string Email,
    string FirstName,
    string LastName,
    DateTime OccurredOn) : IIntegrationEvent;

// Publishing integration events
public sealed class PublishIntegrationEventsOnUserRegisteredDomainEventHandler
    : IDomainEventHandler<UserRegisteredDomainEvent>
{
    private readonly IEventBus _eventBus;
    private readonly IUserRepository _userRepository;

    public PublishIntegrationEventsOnUserRegisteredDomainEventHandler(
        IEventBus eventBus,
        IUserRepository userRepository)
    {
        _eventBus = eventBus;
        _userRepository = userRepository;
    }

    public async Task Handle(
        UserRegisteredDomainEvent notification,
        CancellationToken cancellationToken)
    {
        var user = await _userRepository.GetByIdAsync(
            notification.UserId, 
            cancellationToken);

        if (user is null)
            return;

        await _eventBus.PublishAsync(
            new UserRegisteredIntegrationEvent(
                user.Id,
                user.Email,
                user.FirstName,
                user.LastName,
                DateTime.UtcNow),
            cancellationToken);
    }
}
```

## API Design Standards

### Minimal API Endpoints
```csharp
public sealed class CreateUserEndpoint : IEndpoint
{
    public void MapEndpoint(IEndpointRouteBuilder app)
    {
        app.MapPost("users", async (
            CreateUserRequest request,
            ISender sender,
            CancellationToken cancellationToken) =>
        {
            var command = new CreateUserCommand(
                request.Email,
                request.Password,
                request.FirstName,
                request.LastName);

            var result = await sender.Send(command, cancellationToken);

            return result.Match(
                userId => Results.Created($"users/{userId}", new { id = userId }),
                error => Results.BadRequest(error));
        })
        .WithName("CreateUser")
        .WithTags("Users")
        .RequireAuthorization(UsersPermissions.Create)
        .WithOpenApi();
    }

    // Nested request/response classes
    public sealed record CreateUserRequest(
        string Email,
        string Password,
        string FirstName,
        string LastName);
}
```

### RESTful Conventions
```csharp
// Resource naming (plural nouns)
app.MapGet("/users", GetUsers);
app.MapGet("/users/{id:guid}", GetUserById);
app.MapPost("/users", CreateUser);
app.MapPut("/users/{id:guid}", UpdateUser);
app.MapDelete("/users/{id:guid}", DeleteUser);

// Sub-resources
app.MapGet("/users/{userId:guid}/roles", GetUserRoles);
app.MapPost("/users/{userId:guid}/roles", AssignRole);

// Actions that don't fit REST
app.MapPost("/users/{id:guid}/activate", ActivateUser);
app.MapPost("/users/{id:guid}/deactivate", DeactivateUser);
```

### Response Standards
```csharp
// Success responses
return Results.Ok(userResponse);
return Results.Created($"/users/{user.Id}", userResponse);
return Results.NoContent();

// Error responses using Problem Details
return Results.Problem(
    title: "Validation Error",
    detail: "One or more validation errors occurred.",
    statusCode: StatusCodes.Status400BadRequest,
    extensions: new Dictionary<string, object?>
    {
        ["errors"] = validationErrors
    });

// Consistent error response structure
public sealed record ErrorResponse(
    string Type,
    string Title,
    int Status,
    string Detail,
    Dictionary<string, string[]>? Errors = null);
```

## Testing Standards

### Test Naming
```csharp
// Pattern: {Method}_When{Condition}_Should{ExpectedBehavior}
[Fact]
public async Task Handle_WhenUserDoesNotExist_ShouldReturnNotFoundError()
{
    // Arrange
    var query = new GetUserByIdQuery(Guid.NewGuid());
    _userRepositoryMock
        .Setup(x => x.GetByIdAsync(It.IsAny<Guid>(), It.IsAny<CancellationToken>()))
        .ReturnsAsync((User?)null);

    // Act
    var result = await _handler.Handle(query, CancellationToken.None);

    // Assert
    result.IsFailure.Should().BeTrue();
    result.Error.Code.Should().Be("User.NotFound");
}

// Alternative pattern for handlers
[Fact]
public async Task Handle_WithValidCommand_ShouldCreateUser()
{
    // Test implementation
}
```

### Unit Testing
```csharp
public sealed class CreateUserCommandHandlerTests
{
    private readonly Mock<IUserRepository> _userRepositoryMock;
    private readonly Mock<IUnitOfWork> _unitOfWorkMock;
    private readonly CreateUserCommandHandler _handler;

    public CreateUserCommandHandlerTests()
    {
        _userRepositoryMock = new Mock<IUserRepository>();
        _unitOfWorkMock = new Mock<IUnitOfWork>();
        _handler = new CreateUserCommandHandler(
            _userRepositoryMock.Object,
            _unitOfWorkMock.Object);
    }

    [Fact]
    public async Task Handle_WhenEmailAlreadyExists_ShouldReturnConflictError()
    {
        // Arrange
        var command = new CreateUserCommand(
            "existing@example.com",
            "Password123!",
            "John",
            "Doe");

        _userRepositoryMock
            .Setup(x => x.GetByEmailAsync(command.Email, It.IsAny<CancellationToken>()))
            .ReturnsAsync(new User());

        // Act
        var result = await _handler.Handle(command, CancellationToken.None);

        // Assert
        result.IsFailure.Should().BeTrue();
        result.Error.Should().Be(UserErrors.EmailAlreadyExists);
        _userRepositoryMock.Verify(x => x.Add(It.IsAny<User>()), Times.Never);
        _unitOfWorkMock.Verify(x => x.SaveChangesAsync(It.IsAny<CancellationToken>()), Times.Never);
    }
}
```

### Integration Testing
```csharp
public sealed class CreateUserEndpointTests : BaseIntegrationTest
{
    public CreateUserEndpointTests(IntegrationTestWebFactory factory) 
        : base(factory)
    {
    }

    [Fact]
    public async Task CreateUser_WithValidRequest_ShouldReturnCreated()
    {
        // Arrange
        var request = new
        {
            email = "newuser@example.com",
            password = "Password123!",
            firstName = "John",
            lastName = "Doe"
        };

        // Act
        var response = await Client.PostAsJsonAsync("/users", request);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Created);
        response.Headers.Location.Should().NotBeNull();

        // Verify in database
        var dbContext = GetService<UsersDbContext>();
        var user = await dbContext.Users
            .FirstOrDefaultAsync(u => u.Email == request.email);
        
        user.Should().NotBeNull();
        user!.FirstName.Should().Be(request.firstName);
        user.LastName.Should().Be(request.lastName);
    }
}
```

### Architecture Testing
```csharp
public sealed class ArchitectureTests
{
    private const string UsersNamespace = "Keystone.Modules.Users";

    [Fact]
    public void Domain_Should_Not_HaveDependencyOn_Application()
    {
        // Arrange
        var assembly = typeof(User).Assembly;

        // Act
        var result = Types
            .InAssembly(assembly)
            .Should()
            .NotHaveDependencyOn($"{UsersNamespace}.Application")
            .GetResult();

        // Assert
        result.IsSuccessful.Should().BeTrue();
    }

    [Fact]
    public void Handlers_Should_BeSealed()
    {
        // Arrange
        var assembly = typeof(CreateUserCommandHandler).Assembly;

        // Act
        var result = Types
            .InAssembly(assembly)
            .That()
            .ImplementInterface(typeof(IRequestHandler<,>))
            .Should()
            .BeSealed()
            .GetResult();

        // Assert
        result.IsSuccessful.Should().BeTrue();
    }
}
```

## Database Standards

### Entity Framework Core Conventions
```csharp
// Use snake_case for database objects
protected override void OnModelCreating(ModelBuilder modelBuilder)
{
    // Configure snake_case naming
    modelBuilder.UseSnakeCaseNamingConvention();
    
    // Schema per module
    modelBuilder.HasDefaultSchema("users");
    
    // Apply configurations
    modelBuilder.ApplyConfigurationsFromAssembly(Assembly.GetExecutingAssembly());
}

// Entity configuration
public void Configure(EntityTypeBuilder<User> builder)
{
    builder.ToTable("users");
    
    builder.HasKey(u => u.Id);
    
    builder.Property(u => u.Email)
        .HasColumnName("email")
        .HasMaxLength(256)
        .IsRequired();
        
    builder.HasIndex(u => u.Email)
        .HasDatabaseName("ix_users_email")
        .IsUnique();
        
    // Configure value objects
    builder.OwnsOne(u => u.Name, name =>
    {
        name.Property(n => n.FirstName)
            .HasColumnName("first_name")
            .HasMaxLength(100)
            .IsRequired();
            
        name.Property(n => n.LastName)
            .HasColumnName("last_name")
            .HasMaxLength(100)
            .IsRequired();
    });
}
```

### Migration Standards
```bash
# Naming convention: InitialCreate, AddUserRoles, UpdateUserEmailIndex
dotnet ef migrations add AddUserRoles \
    --project src/Modules/Users/Keystone.Modules.Users.Infrastructure \
    --startup-project src/API/Keystone.Api \
    --context UsersDbContext

# Each module maintains its own migrations
/Modules/Users/Infrastructure/Persistence/Migrations/
/Modules/Employees/Infrastructure/Persistence/Migrations/
```

### Query Optimization
```csharp
// Use projection to avoid fetching unnecessary data
var userSummaries = await context.Users
    .Where(u => u.IsActive)
    .Select(u => new UserSummaryDto
    {
        Id = u.Id,
        FullName = $"{u.FirstName} {u.LastName}",
        Email = u.Email
    })
    .ToListAsync(cancellationToken);

// Use AsNoTracking for read-only queries
var users = await context.Users
    .AsNoTracking()
    .Where(u => u.Status == UserStatus.Active)
    .ToListAsync(cancellationToken);

// Use Include judiciously
var usersWithRoles = await context.Users
    .Include(u => u.Roles)
    .Where(u => u.Id == userId)
    .FirstOrDefaultAsync(cancellationToken);

// Use split queries for multiple includes
var order = await context.Orders
    .AsSplitQuery()
    .Include(o => o.OrderItems)
    .Include(o => o.Customer)
    .FirstOrDefaultAsync(o => o.Id == orderId, cancellationToken);
```

## Documentation Standards

### Code Documentation
```csharp
/// <summary>
/// Represents a user in the system.
/// </summary>
public class User : Entity
{
    /// <summary>
    /// Gets the user's email address.
    /// </summary>
    public string Email { get; private set; }

    /// <summary>
    /// Creates a new user with the specified details.
    /// </summary>
    /// <param name="email">The user's email address.</param>
    /// <param name="firstName">The user's first name.</param>
    /// <param name="lastName">The user's last name.</param>
    /// <returns>A new instance of <see cref="User"/>.</returns>
    /// <exception cref="ArgumentException">Thrown when email is invalid.</exception>
    public static User Create(string email, string firstName, string lastName)
    {
        // Implementation
    }
}
```

### README Files
```markdown
# Users Module

This module handles user management and authentication within the Keystone system.

## Features

- User registration and profile management
- Role-based access control
- Password management
- User search and filtering

## Architecture

The module follows Clean Architecture principles with the following layers:

- **Domain**: Core business logic and entities
- **Application**: Use cases and application services
- **Infrastructure**: Data access and external services
- **Presentation**: API endpoints and contracts

## Key Components

### Commands
- `RegisterUserCommand`: Creates a new user account
- `UpdateUserProfileCommand`: Updates user profile information
- `ChangePasswordCommand`: Changes user password

### Queries
- `GetUserByIdQuery`: Retrieves a user by their ID
- `SearchUsersQuery`: Searches users with pagination

## Testing

Run tests using:
\`\`\`bash
dotnet test src/Modules/Users/Keystone.Modules.Users.UnitTests
dotnet test src/Modules/Users/Keystone.Modules.Users.IntegrationTests
\`\`\`
```

## Multi-Tenancy Standards

### Shadow Properties
```csharp
// Configure tenant shadow property in DbContext
protected override void OnModelCreating(ModelBuilder modelBuilder)
{
    base.OnModelCreating(modelBuilder);
    
    // Configure shadow property for all entities
    foreach (var entityType in modelBuilder.Model.GetEntityTypes())
    {
        if (typeof(Entity).IsAssignableFrom(entityType.ClrType))
        {
            modelBuilder.Entity(entityType.ClrType)
                .Property<Guid>("TenantId");
                
            modelBuilder.Entity(entityType.ClrType)
                .HasIndex("TenantId");
        }
    }
}

// Access shadow property when needed
var userWithTenant = await context.Users
    .Select(u => new
    {
        User = u,
        TenantId = EF.Property<Guid>(u, "TenantId")
    })
    .FirstOrDefaultAsync();
```

### Tenant Context
```csharp
// Use ITenantContext for tenant information
public sealed class TenantAwareService
{
    private readonly ITenantContext _tenantContext;
    
    public TenantAwareService(ITenantContext tenantContext)
    {
        _tenantContext = tenantContext;
    }
    
    public async Task<Result> ProcessForCurrentTenant()
    {
        var tenantId = _tenantContext.TenantId;
        
        // Process for current tenant
        return Result.Success();
    }
}

// Special operations for service accounts
public async Task<Result> ProcessForSpecificTenant(Guid tenantId)
{
    // Validate service account permissions
    if (!_currentUser.IsServiceAccount)
    {
        return Result.Failure(CommonErrors.Forbidden);
    }
    
    // Process for specific tenant
    return Result.Success();
}
```

## Error Handling Standards

### Domain Errors
```csharp
public static class UserErrors
{
    public static Error NotFound(Guid userId) => 
        new("User.NotFound", $"User with ID '{userId}' was not found.");
        
    public static Error InvalidEmail(string email) => 
        new("User.InvalidEmail", $"The email '{email}' is not valid.");
        
    public static readonly Error EmailAlreadyExists = 
        new("User.EmailAlreadyExists", "A user with this email already exists.");
        
    public static readonly Error Unauthorized = 
        new("User.Unauthorized", "You are not authorized to perform this action.");
}
```

### Exception Handling
```csharp
// Global exception handler via pipeline behavior
public sealed class ExceptionHandlingPipelineBehavior<TRequest, TResponse>
    : IPipelineBehavior<TRequest, TResponse>
    where TRequest : class
    where TResponse : Result
{
    private readonly ILogger<ExceptionHandlingPipelineBehavior<TRequest, TResponse>> _logger;

    public ExceptionHandlingPipelineBehavior(
        ILogger<ExceptionHandlingPipelineBehavior<TRequest, TResponse>> logger)
    {
        _logger = logger;
    }

    public async Task<TResponse> Handle(
        TRequest request,
        RequestHandlerDelegate<TResponse> next,
        CancellationToken cancellationToken)
    {
        try
        {
            return await next();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Unhandled exception for request {RequestName}", typeof(TRequest).Name);
            
            return CreateExceptionResult<TResponse>(ex);
        }
    }
}
```

## Performance Guidelines

### Async/Await Best Practices
```csharp
// Always use async/await for I/O operations
public async Task<Result<User>> GetUserAsync(Guid id)
{
    // Don't use .Result or .Wait()
    var user = await _repository.GetByIdAsync(id);
    
    return user is not null 
        ? Result.Success(user) 
        : Result.Failure<User>(UserErrors.NotFound(id));
}

// Use ValueTask for hot paths
public async ValueTask<bool> ExistsAsync(Guid id)
{
    return await _context.Users.AnyAsync(u => u.Id == id);
}

// Parallel operations with Task.WhenAll
public async Task<Result> ProcessMultipleUsers(List<Guid> userIds)
{
    var tasks = userIds.Select(ProcessUserAsync);
    var results = await Task.WhenAll(tasks);
    
    return results.All(r => r.IsSuccess) 
        ? Result.Success() 
        : Result.Failure(CommonErrors.ProcessingFailed);
}
```

### Caching
```csharp
public sealed class CachedUserService : IUserService
{
    private readonly IUserService _innerService;
    private readonly ICacheService _cacheService;
    
    public CachedUserService(
        IUserService innerService,
        ICacheService cacheService)
    {
        _innerService = innerService;
        _cacheService = cacheService;
    }
    
    public async Task<Result<UserDto>> GetUserAsync(Guid userId)
    {
        var cacheKey = $"user:{userId}";
        
        var cachedUser = await _cacheService.GetAsync<UserDto>(cacheKey);
        if (cachedUser is not null)
        {
            return Result.Success(cachedUser);
        }
        
        var result = await _innerService.GetUserAsync(userId);
        
        if (result.IsSuccess)
        {
            await _cacheService.SetAsync(
                cacheKey, 
                result.Value, 
                TimeSpan.FromMinutes(5));
        }
        
        return result;
    }
}
```

### Database Performance
```csharp
// Use bulk operations for multiple entities
public async Task<Result> CreateMultipleUsers(List<User> users)
{
    await _context.BulkInsertAsync(users);
    return Result.Success();
}

// Implement pagination
public async Task<PagedList<UserDto>> GetUsersAsync(
    int page, 
    int pageSize,
    CancellationToken cancellationToken)
{
    var query = _context.Users
        .AsNoTracking()
        .OrderBy(u => u.LastName)
        .ThenBy(u => u.FirstName);
        
    var totalCount = await query.CountAsync(cancellationToken);
    
    var items = await query
        .Skip((page - 1) * pageSize)
        .Take(pageSize)
        .Select(u => new UserDto
        {
            Id = u.Id,
            Email = u.Email,
            FullName = $"{u.FirstName} {u.LastName}"
        })
        .ToListAsync(cancellationToken);
        
    return new PagedList<UserDto>(items, page, pageSize, totalCount);
}
```

## Code Review Checklist

Before submitting code for review, ensure:

### General
- [ ] Code follows naming conventions
- [ ] No commented-out code
- [ ] No TODO comments (create issues instead)
- [ ] Appropriate use of access modifiers
- [ ] No hardcoded values (use configuration)

### Architecture
- [ ] Follows Clean Architecture principles
- [ ] No cross-layer dependencies
- [ ] Proper use of CQRS pattern
- [ ] Domain logic in domain layer
- [ ] Infrastructure concerns isolated

### Testing
- [ ] Unit tests for business logic
- [ ] Integration tests for API endpoints
- [ ] Tests follow naming conventions
- [ ] Good test coverage (aim for >80%)
- [ ] Tests are deterministic

### Performance
- [ ] Async/await used appropriately
- [ ] No blocking calls (.Result, .Wait())
- [ ] Efficient database queries
- [ ] Proper use of caching
- [ ] No memory leaks

### Security
- [ ] Input validation implemented
- [ ] No sensitive data in logs
- [ ] Proper authorization checks
- [ ] SQL injection prevention
- [ ] No hardcoded secrets

### Documentation
- [ ] Public APIs documented
- [ ] Complex logic explained
- [ ] README updated if needed
- [ ] Breaking changes noted

## Conclusion

These coding standards ensure consistency, maintainability, and quality across the Keystone project. They should be treated as living guidelines that evolve with the project's needs. When in doubt, prioritize clarity and consistency over personal preferences.

For questions or suggestions about these standards, please open an issue or discussion in the project repository.