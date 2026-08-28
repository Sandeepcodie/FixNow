# FixNow — Identity Module Reference

## 1. Purpose of This Document

The Identity module is an already implemented part of the FixNow
backend.

This module is provided as a REFERENCE IMPLEMENTATION for developers
working on other modules.

The purpose is to understand:

- Project package structure
- Layered architecture
- Entity style
- DTO style
- Mapper style
- Repository style
- Service interface style
- ServiceImpl style
- Controller style
- Exception handling
- Validation approach
- Dependency injection
- Naming conventions
- Response handling

IMPORTANT:

This document is a coding-style reference.

It is NOT permission to modify or duplicate the Identity module.

---

# 2. Existing Identity Structure

The Identity module currently follows this structure:

Identity/
│
├── controller/
│
├── dto/
│
├── entity/
│
├── enums/
│
├── mapper/
│
├── repository/
│
└── service/
    └── imp1/

The exact existing files should be inspected directly from the
GitHub project before implementation.

---

# 3. Existing Identity Entities

The Identity module contains the existing user-related entities.

Important entities include:

- User
- CustomerProfile
- WorkerProfile

These entities already represent the corresponding database
concepts.

DO NOT create duplicate versions of these classes.

For example:

DO NOT create:

customer/entity/CustomerProfile.java

if:

Identity/entity/CustomerProfile.java

already exists.

Instead, import and use the existing entity.

---

# 4. Existing Identity Enums

The Identity module contains enums such as:

- UserRole
- UserStatus
- VerificationStatus

These represent existing project-level concepts.

Do not create duplicate enums with different names or values.

Before creating a new enum, check whether the required concept
already exists in Identity.

---

# 5. Entity Coding Style

When creating an entity for a new module, first inspect the existing
Identity and Service entities.

Typical structure:

@Entity
@Table(name = "...")
public class Example {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // fields

    protected Example() {
    }

    // getters/setters
}

Follow the existing project's conventions.

Do not automatically add:

- Lombok
- builders
- records
- custom constructors
- unnecessary annotations

unless the project already uses them or the project lead approves
the change.

---

# 6. JPA Mapping Style

Existing entities use standard JPA annotations.

Examples:

@Entity
@Table
@Id
@GeneratedValue
@Column
@ManyToOne
@OneToMany
@JoinColumn

When creating relationships:

1. Check schema.sql.
2. Identify the foreign key.
3. Identify the referenced entity.
4. Check whether that entity already exists.
5. Create the correct JPA mapping.
6. Verify the mapping against the database.

Do not create a relationship merely because it appears convenient.

---

# 7. DTO Pattern

The project uses separate DTOs for API operations.

Common pattern:

Create Request
      ↓
Service
      ↓
Response DTO

For update operations:

Update Request
      ↓
Service
      ↓
Response DTO

The exact fields must come from the API Contract.

Do not expose JPA entities directly when the project's DTO pattern
is applicable.

---

# 8. DTO Validation

When a request DTO requires validation, use the project's existing
validation approach.

Examples may include:

@NotBlank
@NotNull
@Email
@Size

Validation requirements must come from:

1. API Contract
2. Database constraints
3. Business requirements

Do not add arbitrary validation rules.

---

# 9. Mapper Pattern

The project uses a dedicated mapper.

Typical conceptual flow:

Request DTO
    ↓
Mapper
    ↓
Entity


Entity
    ↓
Mapper
    ↓
Response DTO

The mapper should be responsible for data conversion.

Do not move business logic into the mapper.

---

# 10. Mapper Responsibilities

A mapper may perform:

- DTO → Entity
- Entity → Response DTO
- Update DTO → Existing Entity

Example conceptual structure:

public static Entity toEntity(CreateRequest request)

public static Response toResponse(Entity entity)

public static void updateEntity(
        Entity entity,
        UpdateRequest request)

Follow the actual existing Mapper implementation as the primary
reference.

Do not assume every module requires exactly the same methods.

---

# 11. Repository Pattern

The project uses Spring Data JPA repositories.

Typical pattern:

public interface ExampleRepository
        extends JpaRepository<Example, Long> {
}

Repositories are responsible for database access.

Do not put business rules inside repositories.

If a query is required, first check whether Spring Data JPA can
provide it using the existing project style.

---

# 12. Service Interface Pattern

The business operations are exposed through a Service interface.

Conceptual structure:

public interface ExampleService {

    ExampleResponse create(...);

    ExampleResponse getById(...);

    List<ExampleResponse> getAll(...);

    ExampleResponse update(...);

    void deactivate(...);
}

The exact methods depend on the assigned module and API Contract.

Do not add unnecessary methods.

---

# 13. Service Implementation Pattern

The ServiceImpl contains the business logic.

Typical dependency:

private final ExampleRepository exampleRepository;

Constructor injection:

public ExampleServiceImpl(
        ExampleRepository exampleRepository) {

    this.exampleRepository = exampleRepository;
}

Follow the existing project approach.

Do not use field injection:

@Autowired
private ExampleRepository repository;

unless the existing project explicitly requires it.

---

# 14. Service Implementation Flow

Typical create operation:

Request DTO
    ↓
ServiceImpl
    ↓
Business validation
    ↓
Mapper
    ↓
Entity
    ↓
Repository.save()
    ↓
Saved Entity
    ↓
Mapper
    ↓
Response DTO

---

# 15. Example — Existing Service Pattern

The existing Service module demonstrates logic such as:

Checking whether a service already exists.

Conceptually:

if (serviceRepository.existsByName(request.getName())) {

    throw new DuplicateServiceException(...);
}

Then:

Service service =
        ServiceMapper.toEntity(request);

Service savedService =
        serviceRepository.save(service);

return ServiceMapper.toResponse(savedService);

This demonstrates the project's preferred sequence:

Validation
    ↓
Mapping
    ↓
Repository
    ↓
Response Mapping

Use the pattern as a reference.

Do not copy the business rule itself into unrelated modules.

---

# 16. Not Found Pattern

Existing Service implementation uses a dedicated exception:

ServiceNotFoundException

Conceptual flow:

repository.findById(id)
        ↓
record exists?
   ├── YES → continue
   └── NO → throw exception

Example:

Service service = serviceRepository.findById(id)
        .orElseThrow(() ->
                new ServiceNotFoundException(
                        "Service not found with id: " + id
                )
        );

This pattern should be followed for similar resources.

Use an appropriate exception for the new resource.

---

# 17. Duplicate / Conflict Pattern

When a business rule prevents duplicate data, the project uses
specific exceptions.

Example:

DuplicateServiceException

Conceptual flow:

Request
   ↓
Check existing record
   ↓
Already exists?
   ├── YES → throw duplicate exception
   └── NO → continue

The GlobalExceptionHandler converts the exception into the
appropriate HTTP response.

---

# 18. Controller Pattern

Controller handles HTTP requests.

Typical structure:

@RestController
@RequestMapping("/api/v1/...")
public class ExampleController {

    private final ExampleService exampleService;

    public ExampleController(
            ExampleService exampleService) {

        this.exampleService = exampleService;
    }

    // endpoints
}

Follow the existing project's controller conventions.

---

# 19. Controller Responsibilities

Controller should:

- Receive HTTP request
- Bind request data to DTO
- Trigger validation
- Call Service
- Return appropriate response

Controller should NOT contain complex business logic.

Avoid:

Controller
    ↓
Repository directly

Prefer:

Controller
    ↓
Service
    ↓
Repository

---

# 20. Controller → Service Flow

Example conceptual flow:

POST /api/v1/example
        ↓
ExampleController
        ↓
ExampleCreateRequest
        ↓
ExampleService.create(...)
        ↓
ExampleServiceImpl
        ↓
Repository
        ↓
ExampleResponse
        ↓
HTTP Response

---

# 21. Dependency Injection

The existing project uses constructor injection.

Example:

private final ExampleRepository repository;

public ExampleServiceImpl(
        ExampleRepository repository) {

    this.repository = repository;
}

Use constructor injection consistently.

Do not unnecessarily instantiate Spring-managed dependencies
using:

new ExampleRepository()

or similar manual creation.

---

# 22. Exception Handler Reference

The project contains:

GlobalExceptionHandler

under:

common/exception/

It uses:

@RestControllerAdvice

and:

@ExceptionHandler

Conceptual flow:

Service
   ↓
throws exception
   ↓
GlobalExceptionHandler
   ↓
HTTP error response

New exceptions should integrate with the existing global
exception-handling pattern.

---

# 23. Existing Error Response Style

Existing exception handling returns structured responses
for several exceptions.

Example conceptual response:

{
    "timestamp": "...",
    "status": 404,
    "error": "Not Found",
    "message": "..."
}

Follow the existing project response pattern.

Do not create a completely different error response format for
one module without approval.

---

# 24. Important Existing Inconsistency to Be Aware Of

The existing GlobalExceptionHandler contains some handlers with
different response structures.

For example, DuplicatePhoneException currently returns a
ResponseEntity<String>, while other exceptions return a
Map<String, Object>.

When implementing new modules, do NOT blindly reproduce an
inconsistency.

First check the current project convention and API Contract.

If a standardization change is required, inform the project lead
before changing the shared GlobalExceptionHandler.

---

# 25. Entity → DTO Rule

Never assume that every entity field must be returned by an API.

The Response DTO should contain only the fields required by the
API Contract.

Example:

Database Entity
    ↓
Mapper
    ↓
Response DTO
    ↓
JSON

The mapper controls what is exposed.

---

# 26. Avoid Entity Exposure

Avoid returning:

ResponseEntity<Entity>

when the project's DTO architecture is being used.

Prefer:

ResponseEntity<ResponseDTO>

or the equivalent response structure already established
in the project.

This prevents the API contract from becoming tightly coupled
to the database entity.

---

# 27. Transaction Boundary

Do not add @Transactional randomly.

Before using transactions, understand whether the operation
changes multiple related entities or requires atomic behavior.

If a new operation needs transaction management:

1. Identify why.
2. Explain the transaction boundary.
3. Follow existing project conventions.
4. Add it at the appropriate service layer.

---

# 28. Naming Convention

Follow existing naming.

Examples:

Entity:

Service

Repository:

ServiceRepository

Service interface:

ServiceService

Implementation:

ServiceServiceImpl

Controller:

ServiceController

Mapper:

ServiceMapper

DTO:

ServiceCreateRequest
ServiceUpdateRequest
ServiceResponse

For a new module, use the same naming pattern.

---

# 29. Package Naming

Follow the existing project package hierarchy.

Example:

com.fixnow.FixNow.<module>

Then:

<module>.controller
<module>.dto
<module>.entity
<module>.mapper
<module>.repository
<module>.service
<module>.service.imp1

Do not randomly introduce a different package architecture.

---

# 30. Do Not Copy Identity Business Logic

Identity is a REFERENCE.

Copy:

- architectural pattern
- naming pattern
- layering
- dependency injection approach
- DTO/Mapper concept
- exception-handling approach

Do NOT copy:

- user-specific business rules
- authentication logic
- customer-specific logic
- worker-specific logic

unless the assigned module actually requires them.

---

# 31. Validation Checklist — BEFORE Coding

Before creating a new class, verify:

[ ] Does this class already exist?

[ ] Does a similar entity already exist?

[ ] Is the database table already represented by an existing entity?

[ ] Is the required relationship already represented?

[ ] Is there an existing exception for this situation?

[ ] Is the API endpoint defined in the API Contract?

[ ] Are the request/response fields defined?

[ ] Is the operation already implemented elsewhere?

If YES to any existing implementation:

REUSE / EXTEND instead of duplicating.

---

# 32. Entity Validation Checklist

Before finalizing an Entity:

[ ] @Entity present

[ ] Correct @Table name

[ ] Correct primary key

[ ] Correct ID generation strategy

[ ] Column names match schema.sql

[ ] Nullable rules match database

[ ] Data types match database

[ ] Foreign keys match database

[ ] JPA relationships match database

[ ] Existing entities reused

[ ] No unnecessary relationships

[ ] No duplicate entity

---

# 33. DTO Validation Checklist

Before finalizing DTOs:

[ ] Request fields match API Contract

[ ] Response fields match API Contract

[ ] Required validation added

[ ] No unnecessary database fields exposed

[ ] Correct Java data types

[ ] Validation messages follow project style

[ ] Create and Update requirements are correctly separated

---

# 34. Mapper Validation Checklist

Before finalizing Mapper:

[ ] Request DTO → Entity works

[ ] Entity → Response DTO works

[ ] Update DTO correctly updates existing entity

[ ] ID is not accidentally overwritten during update

[ ] Relationships are mapped correctly

[ ] No business logic inside mapper

[ ] Null handling is considered

---

# 35. Repository Validation Checklist

Before finalizing Repository:

[ ] Correct Entity

[ ] Correct ID type

[ ] Required query methods exist

[ ] Method names follow Spring Data JPA conventions

[ ] No unnecessary custom query

[ ] No business logic

---

# 36. Service Validation Checklist

Before finalizing ServiceImpl:

[ ] Required entity exists check

[ ] Required ownership check

[ ] Required duplicate check

[ ] Required validation

[ ] Correct mapper usage

[ ] Correct repository usage

[ ] Correct exception thrown

[ ] Correct response DTO returned

[ ] No controller logic

[ ] No unnecessary database calls

---

# 37. Controller Validation Checklist

Before finalizing Controller:

[ ] Correct @RestController

[ ] Correct @RequestMapping

[ ] Correct endpoint path

[ ] Correct HTTP method

[ ] Correct DTO

[ ] Correct path variables

[ ] Correct query parameters

[ ] Correct service method

[ ] Correct HTTP status

[ ] No business logic

[ ] No direct repository access

---

# 38. Integration Validation

After implementation:

1. Start Spring Boot.
2. Confirm application starts successfully.
3. Test successful API calls.
4. Test invalid input.
5. Test validation failure.
6. Test non-existing resource.
7. Test duplicate/conflict scenario.
8. Test ownership/security.
9. Verify database changes in SSMS.
10. Verify existing Identity APIs.
11. Verify existing Service APIs.
12. Confirm no unrelated module broke.

---

# 39. Git Validation

Before committing:

Run:

git status

Review every changed file.

Make sure:

[ ] Only assigned work is included.

[ ] No unrelated changes.

[ ] No passwords.

[ ] No API keys.

[ ] No tokens.

[ ] No local IDE files.

[ ] No generated files that should not be committed.

Then:

git add .

git commit -m "feat: <description>"

git push -u origin <feature-branch>

---

# 40. Pull Request Validation

Before creating the Pull Request, verify:

[ ] Correct branch

[ ] Code compiles

[ ] Application starts

[ ] APIs tested

[ ] Database tested

[ ] Existing modules tested

[ ] No secrets

[ ] No unrelated changes

[ ] API Contract followed

[ ] Database schema followed

Then create the Pull Request.

Do not merge your own work unless the project lead explicitly
asks you to do so.

---

# 41. Golden Rule

Use the existing Identity and Service modules to answer:

"How does this project write code?"

Use schema.sql to answer:

"What does the database look like?"

Use the API Contract to answer:

"What should the API do?"

Use the assigned task to answer:

"What am I responsible for?"

Use the Project Lead when these sources conflict or leave
something undefined.

Never solve ambiguity by inventing your own architecture.
