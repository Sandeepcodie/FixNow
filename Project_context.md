# FixNow — Project Context

## 1. Project Name

FixNow

FixNow is a backend system for a home-service platform where customers
can request services and workers/service providers can handle those
service requirements.

This is an existing team project.

You are contributing to the existing project.
You are NOT building a separate Spring Boot application.

---

# 2. Technology Stack

Backend:

- Java
- Spring Boot
- Spring Data JPA
- Hibernate / JPA
- Maven
- Microsoft SQL Server

API testing:

- Postman

Database management:

- SQL Server Management Studio (SSMS)

---

# 3. Current Project Status

The project is already under development.

Completed backend modules:

- Identity
- Service
- Common Exception Handling
- Basic Configuration

The Identity and Service modules have already been implemented
and tested.

These modules must be treated as the primary coding references
for new backend development.

---

# 4. High-Level Backend Architecture

The backend follows a layered architecture.

HTTP Request
     ↓
Controller
     ↓
Service
     ↓
Repository
     ↓
JPA / Hibernate
     ↓
SQL Server


Response flow:

SQL Server
     ↓
Entity
     ↓
Mapper
     ↓
Response DTO
     ↓
Controller
     ↓
JSON Response

---

# 5. Main Backend Modules

The FixNow backend contains the following major areas:

1. Identity
2. Service
3. Customer Request
4. Worker
5. Booking
6. Payment
7. Tracking
8. Review

The modules are related to each other.

High-level dependency:

Identity
   ↓
Service
   ↓
Customer Request
   ↓
Booking
   ↓
Payment
   ↓
Tracking
   ↓
Review


Worker functionality works alongside the customer/service/request
flow.

---

# 6. Existing Identity Module

Identity is already implemented.

Existing important entities include:

- User
- CustomerProfile
- WorkerProfile

Existing Identity components include:

- Controller
- DTOs
- Entities
- Enums
- Mapper
- Repositories
- Service
- ServiceImpl

Identity also contains:

- UserRole
- UserStatus
- VerificationStatus

IMPORTANT:

Do NOT create duplicate versions of these entities.

For example, do not create another:

CustomerProfile

inside a new customer package if the existing Identity module
already provides CustomerProfile.

Similarly, do not create another WorkerProfile.

Use the existing Identity entities and relationships.

---

# 7. Existing Service Module

The Service module is already implemented.

Existing components include:

- Service
- WorkerService
- Service DTOs
- ServiceMapper
- ServiceRepository
- WorkerServiceRepository
- ServiceService
- ServiceServiceImpl
- ServiceController

Use this module as a reference for the project's implementation
style.

Observe how the existing module handles:

- Entity mapping
- DTOs
- Mapper
- Repository
- Service interface
- Service implementation
- Controller
- Exceptions
- HTTP responses

Do not blindly copy the code.

Understand the pattern and apply it to your assigned module.

---

# 8. Existing Package Style

The current backend follows a feature/module-oriented structure.

Example:

src/main/java/com/fixnow/FixNow/

Identity/
    controller/
    dto/
    entity/
    enums/
    mapper/
    repository/
    service/
        imp1/

service/
    controller/
    dto/
    entity/
    mapper/
    repository/
    service/
        imp1/

common/
    exception/
    response/
    validation/

config/

Other planned/available module areas include:

- customerrequest
- worker
- payment
- tracking
- review

Follow the existing naming and package conventions.

---

# 9. Controller Responsibility

Controller is responsible for handling HTTP requests.

Typical flow:

HTTP Request
     ↓
Controller
     ↓
DTO
     ↓
Service

Controller should NOT contain large amounts of business logic.

Keep business logic in the Service layer.

---

# 10. Service Layer Responsibility

The Service layer contains business logic.

Example:

Controller
     ↓
Service method
     ↓
Validate business rule
     ↓
Repository
     ↓
Database

Examples of business rules may include:

- checking whether a resource exists
- checking ownership
- checking duplicate records
- validating state transitions
- performing business calculations

---

# 11. Repository Responsibility

Repositories are responsible for database access.

The project uses Spring Data JPA.

Typical pattern:

JpaRepository<Entity, Long>

Do not put business logic inside repositories.

Use repository methods for database operations.

---

# 12. Entity Responsibility

Entities represent database tables.

Entity mappings must follow the existing database schema.

Examples:

@Entity
@Table
@Id
@GeneratedValue
@Column
@ManyToOne
@OneToMany
@JoinColumn

Do not invent database relationships.

Use the provided database schema as the source of truth.

---

# 13. DTO Responsibility

DTOs are used to transfer data between the API and backend layers.

Typical types include:

- Create Request DTO
- Update Request DTO
- Response DTO

Do not automatically expose JPA entities directly through APIs.

Follow the pattern used by the existing modules.

---

# 14. Mapper Responsibility

Mapper converts between DTOs and entities.

Typical flow:

CreateRequest DTO
        ↓
     Mapper
        ↓
     Entity

Entity
   ↓
 Mapper
   ↓
Response DTO

Follow the existing Service/Identity mapper style.

---

# 15. Exception Handling

The project contains centralized exception handling.

Existing location:

common/exception/

Existing exceptions include examples such as:

- DuplicateEmailException
- DuplicatePhoneException
- UserNotFoundException
- ServiceNotFoundException
- DuplicateServiceException

Global exception handling is provided by:

GlobalExceptionHandler

New module-specific exceptions should follow the existing project
pattern.

Do not create a completely different exception-handling architecture.

---

# 16. Database

Database engine:

Microsoft SQL Server

Database:

FixNowDB

The database design is already defined by the project.

The database schema and project documentation must be consulted
before implementing entities.

IMPORTANT:

The Java application and database are separate systems.

GitHub stores the project source code.

GitHub does NOT automatically contain the live SQL Server database.

---

# 17. Database Source of Truth

The project has a database schema/script.

Use the provided schema as the source of truth for the actual
database implementation.

Do not independently redesign:

- tables
- columns
- primary keys
- foreign keys
- relationships
- constraints
- data types

If the implementation appears to require a database change,
inform the project lead before making the change.

---

# 18. Local Database

Each developer may use their own local SQL Server instance.

Example:

Developer A
    ↓
Local SQL Server
    ↓
FixNowDB

Developer B
    ↓
Local SQL Server
    ↓
FixNowDB

The physical database instance can be different,
but the schema must remain consistent.

The developer should use the provided database setup/schema
instead of independently designing the database.

---

# 19. Database Credentials

NEVER commit database passwords into GitHub.

NEVER put the following into source code:

- database passwords
- API secrets
- JWT secrets
- payment secrets
- access tokens
- private credentials

Use local configuration/environment variables.

Example:

spring.datasource.username=${DB_USERNAME}
spring.datasource.password=${DB_PASSWORD}

Each developer configures their own local credentials.

---

# 20. API Contract

The FixNow API contract is already defined.

Base API path:

/api/v1

The API contract defines resources, endpoints, request/response
structures, HTTP methods and expected status codes.

Developers must follow the provided API contract.

Do NOT invent alternate endpoint names unless the project lead
approves the change.

---

# 21. API Status Codes

Use the status codes defined by the API contract.

Common examples include:

200 - Successful request
201 - Resource created
204 - Successful request with no response body
400 - Bad Request
401 - Authentication required/failed
403 - Forbidden
404 - Resource not found
409 - Conflict

The exact response behavior must follow the API contract.

---

# 22. Ownership and Authorization

Existence of a record is not enough.

For resources belonging to a specific user, the backend must also
consider ownership/authorization.

Example:

Customer A owns Address A.

Customer B must not be allowed to modify Address A.

Similarly:

Worker A owns their worker-specific information.

Worker B must not be allowed to modify Worker A's information.

Follow the API contract and existing project security approach.

---

# 23. Validation

Use validation where required by the API contract.

Examples:

@NotBlank
@NotNull
@Email
@Size

Validation should be implemented at the appropriate request DTO
level and supported by business-level validation where necessary.

Do not add arbitrary validation that conflicts with the project
requirements.

---

# 24. Existing Modules Must Not Be Broken

When implementing a new module:

DO NOT unnecessarily modify:

- Identity
- Service
- Common
- Configuration

If your module requires a change to an existing module:

1. Identify the reason.
2. Explain the dependency.
3. Inform the project lead.
4. Make the change only after approval.

---

# 25. GitHub Team Development

The project uses GitHub for source-code collaboration.

The main branch is the stable integration branch.

Developers should work on feature branches.

Current planned branches:

feature/customer-module

feature/worker-module

Do not directly develop on main.

---

# 26. Pull Request Workflow

Developer workflow:

main
 ↓
feature branch
 ↓
development
 ↓
testing
 ↓
commit
 ↓
push
 ↓
Pull Request
 ↓
Project Lead Review
 ↓
Changes if required
 ↓
Approval
 ↓
Merge into main

The project lead is responsible for final review and merge.

---

# 27. Definition of Done

A module is NOT complete simply because the code compiles.

Before creating a Pull Request, verify:

- Application starts successfully.
- Code compiles successfully.
- Required APIs work.
- Request validation works.
- Not-found cases work.
- Conflict/duplicate cases work where applicable.
- Database mappings work.
- Existing modules still work.
- No secrets are committed.
- No unrelated files are modified.
- Code follows the existing architecture.
- Git changes are reviewed.
- Feature branch is pushed.
- Pull Request is created.

---

# 28. How ChatGPT Should Be Used

ChatGPT is an assistant, not the project architect.

Before generating implementation, ChatGPT must first understand:

1. Existing project structure
2. Existing Identity module
3. Existing Service module
4. Database schema
5. API contract
6. Assigned task

ChatGPT must NOT immediately generate an independent implementation.

---

# 29. ChatGPT Must Not Invent

ChatGPT must not independently invent:

- database tables
- database relationships
- API endpoints
- API request formats
- API response formats
- existing entities
- project architecture
- authentication rules
- business rules

If the provided project documents do not define something,
ChatGPT should clearly identify the missing information instead
of silently inventing it.

---

# 30. Development Philosophy

The goal is not just to make the API work.

Every developer should understand:

WHAT is being implemented?

WHY is it required?

WHERE should the code belong?

HOW does the request flow through the application?

HOW does it interact with the database?

HOW does it interact with other modules?

WHAT happens when an error occurs?

WHAT should be tested?

---

# 31. Final Rule

This is a shared existing project.

You are contributing ONE assigned part.

Do not redesign the entire application.

Do not duplicate existing modules.

Do not change the database contract without approval.

Do not modify unrelated modules.

Do not commit secrets.

Follow:

Existing Architecture
        +
Database Schema
        +
API Contract
        +
Identity Reference
        +
Service Reference
        +
Assigned Task

The final goal is to integrate every independently developed
module into one stable FixNow backend.
