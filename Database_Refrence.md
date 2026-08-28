# FixNow — Database Reference

## 1. Database Overview

FixNow backend uses:

- Microsoft SQL Server
- Database name: FixNowDB
- JPA / Hibernate for ORM
- Spring Data JPA for repository access

The database design is shared across the entire backend project.

The database schema must be treated as a common contract between
all backend developers.

---

# 2. Database Source of Truth

The actual database implementation is defined by the project's
database schema/script.

Primary database source:

schema.sql

The schema defines:

- Database
- Tables
- Columns
- Primary keys
- Foreign keys
- Unique constraints
- Check constraints
- Relationships
- Indexes
- Default values

Developers must inspect schema.sql before creating or modifying
JPA entities.

---

# 3. IMPORTANT — Database vs GitHub

GitHub stores the source code and database scripts.

GitHub does NOT store the live SQL Server database.

Therefore:

GitHub
   │
   ├── Java source code
   ├── schema.sql
   └── Documentation
          │
          ↓
Developer's computer
          │
          ↓
Local SQL Server
          │
          ↓
FixNowDB

The database running on the project lead's computer is NOT
automatically available to other developers.

---

# 4. Developer Database Model

Each backend developer should work with a local development
database.

Example:

Developer 1
    ↓
Local SQL Server
    ↓
FixNowDB

Developer 2
    ↓
Local SQL Server
    ↓
FixNowDB

Project Lead
    ↓
Local SQL Server
    ↓
FixNowDB

These can be separate SQL Server instances.

The important requirement is:

ALL developers must use the SAME DATABASE SCHEMA.

---

# 5. Do Not Share Personal Database Credentials

Do NOT use or request the project lead's personal SQL Server
password.

Do NOT commit database credentials into GitHub.

Do NOT put real passwords inside:

- Java source code
- application.properties committed to Git
- documentation
- ChatGPT prompts
- Pull Requests

Use local environment variables or local configuration.

Example:

DB_USERNAME=your_local_username
DB_PASSWORD=your_local_password

Spring Boot configuration example:

spring.datasource.username=${DB_USERNAME}
spring.datasource.password=${DB_PASSWORD}

---

# 6. Database Setup

The developer should first ensure that SQL Server is installed
and running locally.

Then open SQL Server Management Studio (SSMS).

The provided schema.sql should be used to create the FixNow
database structure.

General process:

SQL Server
    ↓
SSMS
    ↓
Open schema.sql
    ↓
Execute script
    ↓
FixNowDB
    ↓
Tables + relationships + constraints

Do not manually recreate tables one by one if the provided
schema.sql already creates them.

---

# 7. Existing Database Areas

The current FixNow database contains the following major areas.

## Identity

- users
- customer_profiles
- worker_profiles

## Service

- services
- worker_services

## Customer Request

- addresses
- service_requests
- attachments
- diagnoses

## Worker

- worker_availability
- worker_documents
- worker_locations

## Booking

- bookings
- booking_status_history

## Payment

- payments
- transactions
- invoices

## Tracking

- tracking
- tracking_points

## Review

- reviews

---

# 8. Identity Tables

## users

Central user table.

It contains the common user/account information.

Important relationships:

users
  ├── customer_profiles
  └── worker_profiles

The existing Identity module owns the corresponding Java
entities.

Do not create another User entity in another module.

---

## customer_profiles

Contains customer-specific profile information.

Relationship:

users
   ↓
customer_profiles

The existing Identity module already contains:

CustomerProfile

Do not create a duplicate CustomerProfile entity.

Other modules should use the existing Identity entity when a
relationship to a customer is required.

---

## worker_profiles

Contains worker-specific profile information.

Relationship:

users
   ↓
worker_profiles

The existing Identity module already contains:

WorkerProfile

Do not create a duplicate WorkerProfile entity.

Other modules should use the existing Identity entity when a
relationship to a worker is required.

---

# 9. Service Tables

## services

Represents the services available on the FixNow platform.

The existing Service module owns:

Service

and its related DTOs, mapper, repository, service and controller.

Do not create another Service entity.

---

## worker_services

Connects workers with services they provide.

Conceptually:

Worker
   │
   └── WorkerService
             │
             └── Service

This is a relationship between:

worker_profiles

and

services

The database also enforces uniqueness for the worker/service
combination.

The existing Service module already contains:

WorkerService

and

WorkerServiceRepository.

Do not create a duplicate relationship entity without a specific
approved requirement.

---

# 10. Customer Request Tables

## addresses

Stores customer addresses used by service requests.

Conceptually:

Customer
   ↓
Address
   ↓
Service Request

An address belongs to a customer.

Ownership must be checked when a customer accesses or modifies
their address.

---

## service_requests

Represents a customer's request for a service.

Conceptually:

Customer
   ↓
Service Request
   ↓
Service

A service request connects the customer requirement with the
requested service and related information.

The service request is an important dependency for later
booking functionality.

---

## attachments

Stores attachment information associated with a service request.

Relationship:

service_request
      ↓
attachments

The database stores attachment metadata.

Actual file-storage implementation must follow the project's
approved implementation.

Do not independently introduce a file-storage architecture.

---

## diagnoses

Stores diagnosis information associated with a service request.

Relationship:

service_request
      ↓
diagnoses

A diagnosis may contain worker/service-side diagnostic information
related to the request.

Follow the API contract and existing database schema when
implementing this area.

---

# 11. Worker Tables

## worker_availability

Stores worker availability information.

Relationship:

worker
   ↓
worker_availability

Availability is worker-specific.

Backend operations must respect ownership.

A worker must not modify another worker's availability.

---

## worker_documents

Stores worker document information.

Relationship:

worker
   ↓
worker_documents

Examples may include document metadata required by the platform.

The exact API behavior must follow the API contract.

Do not invent additional document requirements.

---

## worker_locations

Stores worker location information.

Relationship:

worker
   ↓
worker_locations

Location is worker-specific.

Ownership must be verified before modifying location information.

---

# 12. Booking Tables

## bookings

Represents a confirmed booking associated with a service request.

Relationship:

service_request
      ↓
   booking

The database enforces the relationship between service request
and booking.

Booking is a core integration module and depends on earlier
customer/request/worker functionality.

Do not independently redesign booking relationships.

---

## booking_status_history

Stores historical booking status changes.

Relationship:

booking
   ↓
booking_status_history

Status transitions must follow the project's business rules
and API contract.

Do not invent arbitrary status values.

---

# 13. Payment Tables

## payments

Stores payment information associated with a booking.

Relationship:

booking
   ↓
payment

Payment implementation must follow the API contract and approved
payment architecture.

Do not add real payment gateway credentials to the repository.

---

## transactions

Stores transaction-level payment information.

Relationship:

payment
   ↓
transaction

The exact payment lifecycle must follow the project design.

---

## invoices

Stores invoice information associated with payments/bookings
according to the database schema.

Do not invent additional invoice fields or relationships.

---

# 14. Tracking Tables

## tracking

Stores tracking information related to a booking.

Relationship:

booking
   ↓
tracking

Tracking may contain the current/latest tracking state.

---

## tracking_points

Stores historical/location tracking points.

Relationship:

tracking
   ↓
tracking_points

Tracking points represent location history associated with
tracking.

---

# 15. Review Table

## reviews

Stores customer reviews related to completed service/booking
activity.

Reviews are part of the final service lifecycle.

Review creation must follow the API contract and any required
ownership/completion rules.

---

# 16. High-Level Database Relationship

The major flow is:

User
 │
 ├── CustomerProfile
 │      │
 │      └── Address
 │             │
 │             └── ServiceRequest
 │                    │
 │                    ├── Attachment
 │                    ├── Diagnosis
 │                    │
 │                    └── Booking
 │                           │
 │                           ├── Payment
 │                           │      ├── Transaction
 │                           │      └── Invoice
 │                           │
 │                           ├── Tracking
 │                           │      └── TrackingPoint
 │                           │
 │                           ├── BookingStatusHistory
 │                           │
 │                           └── Review
 │
 └── WorkerProfile
        │
        ├── WorkerService
        ├── WorkerAvailability
        ├── WorkerDocument
        └── WorkerLocation

Service
   │
   └── WorkerService
         │
         ├── WorkerProfile
         └── Service

---

# 17. Important Foreign-Key Principle

When creating JPA relationships, the Java entity mapping must
match the actual SQL foreign keys.

For example:

Database:

worker_services.worker_id
        ↓
worker_profiles.id

Java should represent the same relationship using the existing
WorkerProfile entity.

Similarly:

worker_services.service_id
        ↓
services.id

should use the existing Service entity.

Do not invent a different relationship simply because it is
easier to code.

---

# 18. JPA Mapping Principle

When implementing database relationships, inspect the schema
first.

Then decide the correct JPA mapping.

Common mappings include:

@ManyToOne

@OneToMany

@OneToOne

@JoinColumn

The exact mapping depends on the actual database relationship.

Do not automatically use bidirectional relationships everywhere.

Only create the relationship required by the module and existing
architecture.

---

# 19. Lazy Loading

Existing project entities may use:

FetchType.LAZY

Understand why it is being used before changing it.

Do not change fetch strategy just to make a particular response
work.

If a response requires related data, solve the requirement using
the project's approved data-access approach.

---

# 20. Unique Constraints

Database uniqueness rules are important business constraints.

For example, the worker/service relationship has a unique
combination.

Therefore application code should not assume that duplicate
relationships are valid.

Where appropriate:

Application validation
       +
Database constraint

should work together.

---

# 21. Database Changes

Developers must NOT independently modify the database design.

Do not change:

- table names
- column names
- primary keys
- foreign keys
- unique constraints
- check constraints
- data types
- relationships

without project-lead approval.

If a change is required:

1. Identify the problem.
2. Explain why the change is required.
3. Inform the project lead.
4. Get approval.
5. Update the central schema.
6. Update affected Java mappings.
7. Test all affected modules.

---

# 22. schema.sql Rule

schema.sql is the central database implementation reference.

If a developer modifies the database design with approval,
the schema.sql must also be updated.

Never make a database change only inside your local SSMS and
forget to update the project's schema.

Otherwise other developers will have inconsistent databases.

---

# 23. Local Database vs Shared Schema

Remember:

The database INSTANCE can be different.

The DATABASE SCHEMA must be consistent.

Example:

Developer A:

FixNowDB
    └── schema version X

Developer B:

FixNowDB
    └── schema version X

Project Lead:

FixNowDB
    └── schema version X

All developers must remain compatible with the same schema.

---

# 24. Before Coding a Module

Always identify:

1. Which database tables belong to the module?
2. Which tables are dependencies?
3. Which existing Java entities already represent those tables?
4. Which foreign keys are involved?
5. Which API endpoints use those tables?
6. Which ownership rules apply?
7. Which existing module must be reused?

Only then create the new implementation.

---

# 25. Example — Customer Request

Before implementing Customer Request, inspect:

addresses
service_requests
attachments
diagnoses

Also inspect:

CustomerProfile
User
Service

because these are existing/dependent concepts.

Do NOT create:

NewUser
NewCustomerProfile
NewService

just for the Customer Request module.

---

# 26. Example — Worker

Before implementing Worker functionality, inspect:

worker_profiles
worker_services
worker_availability
worker_documents
worker_locations

Also inspect existing:

WorkerProfile
WorkerService
Service

Do not recreate existing entities.

---

# 27. Database Testing

After implementing a module:

1. Start the application.
2. Call the API.
3. Verify the response.
4. Check the corresponding database record in SSMS.
5. Verify foreign keys.
6. Verify timestamps.
7. Verify constraints.
8. Test invalid data.
9. Test ownership.
10. Test duplicate/conflict scenarios where applicable.

The API response and database state should remain consistent.

---

# 28. Important Security Rule

Never share:

- SQL Server password
- Database user password
- API secret
- JWT secret
- Payment gateway secret

through:

- GitHub
- source code
- documentation
- screenshots
- ChatGPT prompts
- Pull Requests

Use local environment configuration.

---

# 29. Final Database Rule

Before changing anything related to the database, ask:

"Is this already defined in schema.sql?"

If YES:

Follow it.

If NO:

Do not invent it.

Discuss the required change with the project lead.

The database is a shared contract for the entire backend team.
