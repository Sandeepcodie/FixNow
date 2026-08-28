# FixNow — Worker Module Task

## 1. Your Assignment

You are responsible for implementing the Worker-side functionality
assigned to you.

Your main scope is:

1. Worker Services
2. Worker Availability
3. Worker Documents
4. Worker Locations

You are NOT responsible for:

- Identity module
- User entity
- WorkerProfile implementation
- Customer module
- Service catalog implementation
- Customer Service Requests
- Booking implementation
- Payment
- Tracking
- Reviews

---

# 2. IMPORTANT — Existing Code Must Be Reused

The project already contains the Identity module.

It already contains:

- User
- CustomerProfile
- WorkerProfile

DO NOT create another WorkerProfile.

Use the existing:

Identity/entity/WorkerProfile.java

where required.

The Service module is also already implemented.

Use the existing:

service/entity/Service.java

where required.

The Service module also already contains:

WorkerService

and:

WorkerServiceRepository

Check the existing implementation before creating anything new.

DO NOT create duplicate versions of these entities.

---

# 3. Your Main Database Tables

Your main database areas are:

- worker_services
- worker_availabilities
- worker_documents
- worker_locations

Conceptual relationships:

```text
WorkerProfile
     │
     ├── WorkerService ─── Service
     │
     ├── WorkerAvailability
     │
     ├── WorkerDocument
     │
     └── WorkerLocation
```

Follow schema.sql exactly.

---

# 4. Worker Service

IMPORTANT:

The project already contains:

```text
service/entity/WorkerService.java
service/repository/WorkerServiceRepository.java
```

Therefore:

DO NOT create another WorkerService entity unless the project
lead explicitly asks for it.

First inspect the existing implementation.

Your task is to implement only the Worker-side API functionality
that is still missing according to the API Contract.

---

# 5. Worker Service APIs

The API Contract defines Worker service operations around the
worker's offered services.

Before implementing, verify the exact endpoint and request/
response structure in the ORIGINAL API Contract.

Expected conceptual flow:

```text
Worker
   ↓
Worker Service
   ↓
Service
```

Business checks should include:

- Worker exists
- Service exists
- Worker is allowed to manage the relationship
- Duplicate relationship is prevented where required

Do not invent additional service relationship rules.

---

# 6. Worker Availability

Database table:

worker_availabilities

Fields:

- id
- worker_id
- day_of_week
- start_time
- end_time
- is_available

Relationship:

worker_id → worker_profiles.id

The worker availability represents the worker's availability
schedule.

Do not create a new WorkerProfile entity.

---

# 7. Worker Availability APIs

Implement the availability APIs defined in the ORIGINAL
API Contract.

Typical operations include:

- Create availability
- Get availability
- Update availability
- Delete availability

Use the exact URL, HTTP method, request DTO and response DTO
from the API Contract.

Do not invent additional endpoints.

---

# 8. Availability Validation

Before saving availability:

1. Worker exists.
2. Worker owns the availability being changed.
3. Day is valid.
4. Start time is valid.
5. End time is valid.
6. Start time and end time make sense.
7. Required fields are present.

Do not create overlapping or invalid schedules if the API/business
rules prohibit them.

If an exact overlap rule is not defined in the API Contract,
do not invent a complex scheduling system.

---

# 9. Worker Documents

Database table:

worker_documents

Fields:

- id
- worker_id
- document_type
- document_url
- verification_status
- uploaded_at
- verified_at

Relationship:

worker_id → worker_profiles.id

Document types and verification values must follow schema.sql
and the API Contract.

Do not invent additional document types.

---

# 10. Worker Document APIs

Implement only the Worker Document APIs defined in the
ORIGINAL API Contract.

Expected operations may include:

- Upload document
- List worker documents
- Get document
- Update/verify document where the contract permits

Check the original API contract for the exact endpoint and
authorization rules before coding.

Do not invent admin verification APIs unless explicitly defined.

---

# 11. Document Ownership

Documents belong to workers.

Example:

```text
Worker A
   ↓
Document A
```

Worker B must not be able to modify or access Worker A's
protected document data.

Always verify ownership where required.

---

# 12. Worker Locations

Database table:

worker_locations

Fields:

- id
- worker_id
- latitude
- longitude
- updated_at

Relationship:

worker_id → worker_profiles.id

A worker location belongs to a worker.

Do not create another WorkerProfile entity.

---

# 13. Worker Location APIs

Implement the exact location APIs from the ORIGINAL API Contract.

Expected conceptual operations:

- Get worker location
- Update worker location

Follow the exact API Contract for:

- URL
- HTTP method
- Request body
- Response body
- Status code
- Ownership rules

Do not invent tracking/history functionality here.

Worker Location is different from Tracking.

---

# 14. IMPORTANT — Location vs Tracking

Do not mix these concepts.

Worker Location:

```text
Current worker location
        ↓
worker_locations
```

Tracking:

```text
Booking
   ↓
Tracking
   ↓
Tracking Points
```

Tracking belongs to the later Booking/Tracking functionality.

Do not implement Tracking inside the Worker module.

---

# 15. Package Structure

Follow the existing project structure.

Recommended:

```text
worker/
│
├── controller/
├── dto/
├── entity/
├── mapper/
├── repository/
└── service/
    └── imp1/
```

However, before creating packages, inspect the existing project.

Reuse existing classes where they already exist.

---

# 16. Implementation Order

Do NOT create everything at once.

Use this order:

```text
Worker Service
     ↓
Validate + Test
     ↓
Worker Availability
     ↓
Validate + Test
     ↓
Worker Documents
     ↓
Validate + Test
     ↓
Worker Location
     ↓
Validate + Test
```

For each resource use:

```text
Entity
   ↓
Validate
   ↓
DTO
   ↓
Validate
   ↓
Mapper
   ↓
Validate
   ↓
Repository
   ↓
Validate
   ↓
Service
   ↓
Validate
   ↓
ServiceImpl
   ↓
Validate
   ↓
Controller
   ↓
Postman Test
   ↓
Database Test
```

Move to the next resource only after the current one works.

---

# 17. Coding Style Reference

Use the already completed modules as your reference.

Especially inspect:

```text
Identity/
```

and:

```text
service/
```

Follow their:

- Package structure
- Naming
- DTO pattern
- Mapper pattern
- Repository pattern
- Service interface pattern
- ServiceImpl pattern
- Controller pattern
- Constructor injection
- Exception handling

Do not introduce a completely different architecture.

---

# 18. Entity Rules

Before creating an Entity:

1. Check whether it already exists.
2. Check schema.sql.
3. Check existing relationships.
4. Check the API Contract.

Do not duplicate:

- WorkerProfile
- Service
- WorkerService

if they already exist.

---

# 19. DTO Rules

Use separate DTOs where required.

Typical pattern:

```text
CreateRequest
UpdateRequest
Response
```

Do not expose the JPA entity directly when DTOs are required.

Request fields must match the API Contract.

Response fields must match the API Contract.

Do not add random fields.

---

# 20. Mapper Rules

Mapper handles:

```text
Request DTO
     ↓
Entity
```

and:

```text
Entity
     ↓
Response DTO
```

For updates:

```text
Update DTO
     ↓
Existing Entity
```

Do not put business logic inside Mapper.

Do not overwrite entity IDs during update.

---

# 21. Repository Rules

Use Spring Data JPA.

Typical:

```java
public interface ExampleRepository
        extends JpaRepository<Example, Long> {
}
```

Add custom repository methods only when required.

Do not put business logic inside Repository.

---

# 22. Service Rules

Service layer handles business logic.

Typical flow:

```text
Controller
    ↓
Service
    ↓
Repository
```

Service should handle:

- Existence checks
- Ownership checks
- Duplicate checks
- Business validation
- Mapping coordination

Do not move business logic into Controller.

---

# 23. Constructor Injection

Follow the existing project style.

Example:

```java
private final ExampleRepository repository;

public ExampleServiceImpl(
        ExampleRepository repository) {

    this.repository = repository;
}
```

Do not manually create repository/service objects.

---

# 24. Not Found Handling

If a required Worker, Service, Availability, Document or
Location does not exist:

Use the project's exception-handling pattern.

First check existing exceptions.

If an appropriate exception does not exist, create a clear
module-specific exception following the existing style.

Do not use random RuntimeException messages when the project
already has a proper exception pattern.

---

# 25. Duplicate Handling

For Worker Service relationships:

```text
Worker + Service
       ↓
Already exists?
   ├── YES → Conflict
   └── NO  → Create
```

Prevent duplicate relationships where required.

Use the existing global exception pattern.

---

# 26. Ownership Validation

Ownership is important for Worker resources.

Example:

```text
Worker A
   ↓
Availability A
```

Worker B must not update Availability A.

Same principle applies to:

- Worker Documents
- Worker Locations
- Worker Services where applicable

Do not rely only on resource ID existence.

---

# 27. Availability Testing

Test at minimum:

### Valid Create

Valid worker + valid schedule → success

### Invalid Worker

Non-existing worker → 404

### Invalid Data

Invalid/missing required fields → 400

### Ownership

Another worker attempting to modify it → rejected

### Get

Existing availability → success

### Update

Valid update → success

### Delete

Valid permitted deletion → success

---

# 28. Worker Service Testing

Test:

### Create

Valid Worker + Service → success

### Invalid Worker

Non-existing worker → 404

### Invalid Service

Non-existing service → 404

### Duplicate

Same Worker + Service again → 409

### Ownership

Unauthorized worker operation → rejected

### List/Get

Correct Worker Service data → success

---

# 29. Worker Document Testing

Test:

### Upload/Create

Valid document → success

### Invalid Worker

Non-existing worker → 404

### Invalid Document Type

→ 400

### Ownership

Another worker accessing protected document → rejected

### Get/List

Correct document information → success

### Verification

Only perform verification if the API Contract defines it.

---

# 30. Worker Location Testing

Test:

### Create/Update

Valid latitude + longitude → success

### Invalid Worker

Non-existing worker → 404

### Invalid Coordinates

Invalid latitude/longitude → 400

### Ownership

Another worker modifying location → rejected

### Get

Correct worker location → success

---

# 31. Database Verification

After successful API tests, verify SSMS.

Example:

```text
API request
    ↓
201/200 response
    ↓
Open SSMS
    ↓
Check correct table
    ↓
Verify record
```

Verify:

- Worker ID
- Foreign keys
- Values
- Dates/times
- Status fields
- No duplicate records

Do not manually change database records just to make the API
test pass.

---

# 32. Final Architecture Check

Before completion:

```text
Controller
    ↓
Service
    ↓
Repository
    ↓
Database
```

Response:

```text
Entity
    ↓
Mapper
    ↓
Response DTO
    ↓
JSON
```

Request:

```text
JSON
    ↓
Request DTO
    ↓
Service
    ↓
Entity
    ↓
Repository
```

---

# 33. Final Validation Checklist

## Worker Service

[ ] Existing WorkerService checked first

[ ] No duplicate WorkerService entity

[ ] Existing Service entity reused

[ ] Worker existence checked

[ ] Service existence checked

[ ] Duplicate relationship handled

[ ] Ownership/business rules handled

[ ] APIs tested

---

## Availability

[ ] Table matches schema.sql

[ ] worker_id correct

[ ] day_of_week correct

[ ] start_time correct

[ ] end_time correct

[ ] is_available correct

[ ] Ownership checked

[ ] APIs tested

---

## Documents

[ ] Table matches schema.sql

[ ] worker_id correct

[ ] document_type correct

[ ] document_url correct

[ ] verification_status correct

[ ] uploaded_at correct

[ ] verified_at correct

[ ] Ownership checked

[ ] APIs tested

---

## Location

[ ] Table matches schema.sql

[ ] worker_id correct

[ ] latitude correct

[ ] longitude correct

[ ] updated_at correct

[ ] Ownership checked

[ ] APIs tested

---

# 34. Project Safety Check

Before completing the task:

[ ] Application starts successfully

[ ] No compilation errors

[ ] No duplicate entities

[ ] No duplicate repositories

[ ] No duplicate services

[ ] Existing Identity module still works

[ ] Existing Service module still works

[ ] Customer module was not unnecessarily modified

[ ] API Contract followed

[ ] schema.sql followed

[ ] Postman tests passed

[ ] SSMS verified

---

# 35. DO NOT MODIFY

Without project lead approval, do not modify:

- Identity module
- Customer module
- Existing Service module
- Booking module
- Payment module
- Tracking module
- Review module
- Security configuration
- Database schema
- API Contract
- Global architecture

---

# 36. If Something Is Missing

If the API Contract, schema.sql and existing code do not clearly
define something:

DO NOT GUESS.

Ask the project lead.

Example:

"I need clarification about ______."

Wait for the decision before introducing a new architecture,
database field or API.

---

# 37. Final Git Submission

After the Worker module is fully tested:

Check:

```bash
git branch
```

It must be:

```text
feature/worker-module
```

Then:

```bash
git status
```

Review the changes.

Then:

```bash
git add .
```

Then:

```bash
git status
```

Commit:

```bash
git commit -m "feat: implement worker module"
```

Push:

```bash
git push origin feature/worker-module
```

Then create a Pull Request:

```text
feature/worker-module
        ↓
       main
```

Do NOT merge the Pull Request yourself.

---

# 38. If Review Changes Are Requested

Continue on the SAME branch:

```text
feature/worker-module
```

Make the requested changes.

Test again.

Then:

```bash
git add .
git commit -m "fix: review changes"
git push origin feature/worker-module
```

The existing Pull Request will update automatically.

---

# 39. Final Rule

Your responsibility is:

```text
Worker Services
       ↓
Worker Availability
       ↓
Worker Documents
       ↓
Worker Locations
```

Use:

```text
Existing Identity
       +
Existing Service
       +
Database Schema
       +
Original API Contract
       +
Existing Coding Style
```

Do not redesign the project.

Do not duplicate existing entities.

Do not invent APIs.

Do not invent database fields.

Do not invent business rules.

Build one part.

Validate it.

Test it.

Then move to the next part.
