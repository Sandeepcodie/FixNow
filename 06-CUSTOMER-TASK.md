# FixNow — Customer Module Task

## 1. Your Assignment

You are responsible for implementing the Customer-side
Customer Request functionality.

Your work will mainly cover:

1. Addresses
2. Service Requests
3. Attachments
4. Diagnoses

You are NOT responsible for:

- Identity module
- User entity
- CustomerProfile implementation
- Worker module
- WorkerProfile implementation
- Service module
- Booking implementation
- Payment
- Tracking
- Review

---

# 2. IMPORTANT — Existing Code Must Be Reused

The project already contains the Identity module.

It already contains:

- User
- CustomerProfile
- WorkerProfile

DO NOT create another CustomerProfile.

Use the existing:

Identity.entity.CustomerProfile

where required.

The Service module is also already implemented.

Use the existing:

service.entity.Service

where a service relationship is required.

DO NOT create another Service entity.

---

# 3. Database Tables You Own

Your main tables are:

- addresses
- service_requests
- attachments
- diagnoses

Database relationships:

customer_profiles
       ↓
   addresses

customer_profiles
       ↓
service_requests
       ↓
 ┌─────┴─────┐
 ↓           ↓
attachments diagnoses

service_requests
       ↓
service

---

# 4. API Contract You Must Implement

## Address APIs

```http
GET    /api/v1/customers/{customerId}/addresses
POST   /api/v1/customers/{customerId}/addresses
GET    /api/v1/addresses/{addressId}
PATCH  /api/v1/addresses/{addressId}
DELETE /api/v1/addresses/{addressId}
```

Customer ownership must be checked.

---

# 5. Service Request APIs

Create:

```http
POST /api/v1/service-requests
```

Get:

```http
GET /api/v1/service-requests/{requestId}
```

Customer list:

```http
GET /api/v1/customers/{customerId}/service-requests
```

Update:

```http
PATCH /api/v1/service-requests/{requestId}
```

Service request status must NOT be treated as an unrestricted
normal field update.

Follow the API Contract.

---

# 6. Attachment APIs

Upload:

```http
POST /api/v1/service-requests/{requestId}/attachments
```

List:

```http
GET /api/v1/service-requests/{requestId}/attachments
```

Get metadata:

```http
GET /api/v1/attachments/{attachmentId}
```

Delete where business rules permit:

```http
DELETE /api/v1/attachments/{attachmentId}
```

Upload uses:

multipart/form-data

The current database stores the file reference as file_url.

Do not introduce a new file-storage architecture without approval.

---

# 7. Diagnosis APIs

Create:

```http
POST /api/v1/service-requests/{requestId}/diagnoses
```

List:

```http
GET /api/v1/service-requests/{requestId}/diagnoses
```

Get:

```http
GET /api/v1/diagnoses/{diagnosisId}
```

The API contract says diagnosis source/authorization will be
finalized during LLD.

Do NOT invent an AI provider or external AI implementation.

---

# 8. Database — addresses

Table:

addresses

Columns:

- id
- customer_id
- address_line
- city
- state
- postal_code
- latitude
- longitude
- is_default
- created_at
- updated_at

Foreign key:

customer_id → customer_profiles.id

ID:

BIGINT IDENTITY

Required fields:

- customer_id
- address_line
- city
- state
- postal_code
- is_default
- created_at
- updated_at

latitude and longitude are nullable.

Follow schema.sql exactly.

---

# 9. Database — service_requests

Table:

service_requests

Columns:

- id
- customer_id
- service_id
- address_id
- description
- status
- created_at
- updated_at

Foreign keys:

customer_id → customer_profiles.id

service_id → services.id

address_id → addresses.id

Required:

- customer_id
- service_id
- address_id
- description
- status
- created_at
- updated_at

Request statuses defined by database:

- OPEN
- ASSIGNED
- CLOSED
- CANCELLED

Do not invent additional statuses.

---

# 10. Database — attachments

Table:

attachments

Columns:

- id
- service_request_id
- file_url
- file_type
- created_at

Foreign key:

service_request_id → service_requests.id

File types:

- IMAGE
- VIDEO

Do not invent additional file types.

---

# 11. Database — diagnoses

Table:

diagnoses

Columns:

- id
- service_request_id
- problem_type
- description
- estimated_cost
- estimated_duration
- confidence_score
- created_at

Foreign key:

service_request_id → service_requests.id

Nullable fields:

- problem_type
- description
- estimated_cost
- estimated_duration
- confidence_score

Do not invent additional database fields.

---

# 12. Package Structure

Follow the existing project style.

Recommended:

```text
customerrequest/
│
├── controller/
├── dto/
├── entity/
├── mapper/
├── repository/
└── service/
    └── imp1/
```

Use the exact existing project naming conventions.

Before creating a package, inspect the existing Identity and
Service modules.

---

# 13. Implementation Order

DO NOT create the entire module at once.

Implement in this order:

```text
Address Entity
     ↓
Validate
     ↓
Address DTOs
     ↓
Validate
     ↓
Address Mapper
     ↓
Validate
     ↓
Address Repository
     ↓
Validate
     ↓
Address Service
     ↓
Validate
     ↓
Address ServiceImpl
     ↓
Validate
     ↓
Address Controller
     ↓
Test Address APIs
```

Then implement:

```text
Service Request
     ↓
Validate + Test
     ↓
Attachments
     ↓
Validate + Test
     ↓
Diagnoses
     ↓
Validate + Test
```

Each part must be completed and tested before moving forward.

---

# 14. Step 1 — Address Entity

Create the Address entity according to schema.sql.

Required mapping concepts:

```java
@Entity
@Table
@Id
@GeneratedValue
@Column
@ManyToOne
@JoinColumn
```

The relationship should point to the existing:

CustomerProfile

entity.

Do NOT create:

Customer

or:

CustomerProfile

just to represent this relationship.

---

# 15. Address Entity Validation

Before moving forward, verify:

[ ] Correct table name

[ ] Correct column names

[ ] ID is Long

[ ] ID uses identity generation

[ ] customer_id maps to existing CustomerProfile

[ ] address_line is required

[ ] city is required

[ ] state is required

[ ] postal_code is required

[ ] latitude can be null

[ ] longitude can be null

[ ] is_default is present

[ ] created_at is present

[ ] updated_at is present

[ ] No unnecessary fields

[ ] Application compiles

---

# 16. Step 2 — Address DTOs

Create DTOs according to the API contract.

At minimum:

- AddressCreateRequest
- AddressUpdateRequest
- AddressResponse

Do not expose:

- created_at
- updated_at
- internal entity relationships

unless the API contract requires them.

Do not allow the client to arbitrarily control ownership.

---

# 17. Address DTO Validation

Check:

[ ] Create fields match API contract

[ ] Update fields match API contract

[ ] Response fields are correct

[ ] Required fields have validation

[ ] No password/security fields

[ ] No unnecessary database fields

[ ] ID is not required from client during create

---

# 18. Step 3 — Address Mapper

Implement:

CreateRequest → Address

Address → Response

UpdateRequest → existing Address

Do not put business logic inside Mapper.

Mapper should only convert data.

Validation:

[ ] All required fields mapped

[ ] Response correctly created

[ ] Update does not replace ID

[ ] customer relationship is not incorrectly overwritten

[ ] No business logic

---

# 19. Step 4 — Address Repository

Create:

AddressRepository

Use:

```java
JpaRepository<Address, Long>
```

Only add custom methods when required.

Use Spring Data naming conventions.

Do not put business logic in Repository.

---

# 20. Step 5 — Address Service

Create:

AddressService

The interface should expose only operations required by
the API.

Possible operations:

- create
- getById
- getCustomerAddresses
- update
- delete

Use the exact API requirements.

---

# 21. Step 6 — Address ServiceImpl

Business flow:

Create:

```text
Request
 ↓
Validate customer
 ↓
Map DTO → Entity
 ↓
Save
 ↓
Map Entity → Response
```

Get:

```text
ID
 ↓
Repository
 ↓
Found?
 ├── YES → Response
 └── NO → Exception
```

Update:

```text
ID
 ↓
Find Address
 ↓
Verify ownership
 ↓
Update
 ↓
Save
 ↓
Response
```

Delete:

```text
ID
 ↓
Find Address
 ↓
Verify ownership
 ↓
Delete/deactivate according to business rules
```

---

# 22. Address Ownership

This is IMPORTANT.

An address belongs to a customer.

Example:

```text
Customer A
   ↓
Address A
```

Customer B must not be allowed to update Address A.

Do not only check:

```java
addressRepository.findById(addressId)
```

You must also verify that the address belongs to the customer
performing the operation.

The exact authenticated-user integration will be finalized with
Spring Security/JWT.

For the current implementation, follow the project's agreed
ownership approach and do not invent a new authentication system.

---

# 23. Address Testing

Test:

### Create

Valid address → 201

### Validation

Missing:

- address_line
- city
- state
- postal_code

→ 400

### Get

Existing ID → 200

### Not Found

Invalid ID → 404

### Update

Existing address → successful update

### Ownership

Customer B attempting Customer A's address → rejected

### Delete

Valid permitted address → expected response

---

# 24. Step 7 — Service Request Entity

Create:

ServiceRequest

Relationship requirements:

customer_id
    ↓
existing CustomerProfile

service_id
    ↓
existing Service

address_id
    ↓
Address entity

Do NOT create duplicate CustomerProfile or Service entities.

---

# 25. Service Request Validation

Entity must match:

service_requests

Columns:

- id
- customer_id
- service_id
- address_id
- description
- status
- created_at
- updated_at

Verify every column against schema.sql before proceeding.

---

# 26. Service Request DTOs

Create appropriate:

- ServiceRequestCreateRequest
- ServiceRequestUpdateRequest
- ServiceRequestResponse

Request example from API contract:

```json
{
  "serviceId": 2,
  "addressId": 501,
  "description": "AC is running but not cooling properly"
}
```

The customer should be derived from the authenticated context
when authentication is implemented.

Do not trust arbitrary customer ownership supplied by the client.

---

# 27. Service Request Business Validation

Before creating a service request:

1. Customer exists.
2. Service exists.
3. Address exists.
4. Address belongs to the customer.
5. Required description is present.
6. Initial status follows project rules.

Do not allow a customer to create a request using another
customer's address.

---

# 28. Service Request Status

Database statuses:

- OPEN
- ASSIGNED
- CLOSED
- CANCELLED

Do not treat status as an arbitrary string that can freely change
from one value to another.

The API contract explicitly says status changes are controlled
business operations.

If exact transition rules are not defined, do not invent them.

---

# 29. Service Request Testing

Test:

### Create

Valid request → 201

### Invalid service

Non-existing service → 404

### Invalid address

Non-existing address → 404

### Wrong customer address

Ownership violation → rejected

### Invalid description

Validation → 400

### Get

Existing request → 200

### Not Found

Invalid request ID → 404

### Update

Valid update → successful

---

# 30. Step 8 — Attachments

Create:

Attachment

according to the database.

Fields:

- id
- service_request_id
- file_url
- file_type
- created_at

File types:

- IMAGE
- VIDEO

Relationship:

```text
ServiceRequest
      ↓
Attachment
```

---

# 31. Attachment Rules

Attachment must belong to an existing service request.

Before adding an attachment:

1. Find service request.
2. Verify request exists.
3. Verify current user/customer is allowed to access the request.
4. Store the file reference.
5. Save Attachment.

Do not allow attachment records for non-existing requests.

---

# 32. Attachment Testing

Test:

[ ] Upload valid file

[ ] IMAGE accepted

[ ] VIDEO accepted

[ ] Invalid file type rejected

[ ] Non-existing service request rejected

[ ] Unauthorized request rejected

[ ] List attachments works

[ ] Get attachment metadata works

[ ] Delete works where allowed

---

# 33. Step 9 — Diagnoses

Create:

Diagnosis

Fields:

- id
- service_request_id
- problem_type
- description
- estimated_cost
- estimated_duration
- confidence_score
- created_at

Relationship:

```text
ServiceRequest
      ↓
Diagnosis
```

---

# 34. Diagnosis Rules

Diagnosis belongs to a service request.

Before creating:

1. Service request must exist.
2. Authorization must be checked.
3. Required data must be valid.
4. Save diagnosis.

The API Contract states that diagnosis source and authorization
will be finalized during LLD.

Therefore:

DO NOT invent:

- AI provider
- AI API
- automatic diagnosis algorithm
- worker/admin authorization rules

Implement only what is currently defined.

---

# 35. Diagnosis Validation

Check:

[ ] service_request exists

[ ] problem_type can be null

[ ] description can be null

[ ] estimated_cost can be null

[ ] estimated_duration can be null

[ ] confidence_score can be null

[ ] created_at is generated correctly

[ ] no unnecessary fields

---

# 36. Final Module Validation

Before saying "Customer Module Complete":

## Architecture

[ ] Controller → Service → Repository

[ ] DTOs used

[ ] Mapper used

[ ] No direct Entity exposure where DTO is required

[ ] Constructor injection used

---

## Database

[ ] All four tables match schema.sql

[ ] Foreign keys correct

[ ] Column names correct

[ ] Data types correct

[ ] Nullable fields correct

[ ] Existing entities reused

[ ] No duplicate entities

---

## API

[ ] Address APIs implemented

[ ] Service Request APIs implemented

[ ] Attachment APIs implemented

[ ] Diagnosis APIs implemented

[ ] URLs match API Contract

[ ] HTTP methods match API Contract

[ ] Response status codes correct

---

## Validation

[ ] Invalid input → 400

[ ] Missing resource → 404

[ ] Ownership violation handled

[ ] Invalid relationship handled

[ ] Duplicate/business conflict handled where required

---

## Testing

[ ] Application starts

[ ] Address APIs tested

[ ] Service Request APIs tested

[ ] Attachment APIs tested

[ ] Diagnosis APIs tested

[ ] Database verified in SSMS

[ ] Existing Identity APIs still work

[ ] Existing Service APIs still work

---

# 37. DO NOT MODIFY

Without project lead approval, do not modify:

- Identity module
- Service module
- Booking module
- Payment module
- Worker module
- Security configuration
- Database schema
- API Contract
- Global architecture

---

# 38. If You Need an Existing Entity

Before creating a new entity, search the project.

For example:

Need Customer?

Check:

```text
Identity/entity/CustomerProfile.java
```

Need Worker?

Check:

```text
Identity/entity/WorkerProfile.java
```

Need Service?

Check:

```text
service/entity/Service.java
```

Need WorkerService?

Check:

```text
service/entity/WorkerService.java
```

Reuse existing classes.

---

# 39. If Something Is Missing

If the API Contract and database schema do not define something:

DO NOT GUESS.

Tell the project lead:

"I need clarification about ______."

Wait for the decision before changing the architecture.

---

# 40. Final Git Submission

After the Customer module is fully tested:

Check branch:

```bash
git branch
```

It must be:

```text
feature/customer-module
```

Then:

```bash
git status
```

Review changes.

Then:

```bash
git add .
```

Then:

```bash
git status
```

Then commit:

```bash
git commit -m "feat: implement customer module"
```

Push:

```bash
git push origin feature/customer-module
```

Then create:

Pull Request

```text
feature/customer-module
        ↓
       main
```

Do NOT merge the Pull Request yourself.

---

# 41. Final Rule

Your responsibility is:

```text
Addresses
   ↓
Service Requests
   ↓
Attachments
   ↓
Diagnoses
```

Use:

```text
Existing Identity
       +
Existing Service
       +
Database Schema
       +
API Contract
       +
Existing Coding Style
```

Do not redesign the project.

Do not duplicate existing entities.

Do not invent APIs.

Do not invent database fields.

Do not invent business rules that are not defined.

Build one part, validate it, test it, then move to the next part.
