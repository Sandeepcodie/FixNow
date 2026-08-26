# FixNow API Contract

**Version:** v1  
**Status:** Draft — Ready for LLD validation  
**Backend:** Java + Spring Boot  
**Database:** Microsoft SQL Server  
**Format:** REST + JSON  
**Base Path:** `/api/v1`

---

## 1. Purpose

This document defines the API contract for the FixNow backend.

The API is designed to remain completely independent of the frontend. React, mobile clients, Postman, or other clients will communicate with the backend through these REST APIs.

The API contract is designed from the finalized Iteration-1 database and business workflow.

---

# 2. API Design Principles

- REST-oriented resource naming.
- JSON for normal request and response bodies.
- `/api/v1` is the current API version.
- Database tables are not exposed as automatic CRUD APIs.
- APIs represent business resources and operations.
- Sensitive/internal database fields are not exposed directly.
- Authentication and authorization will later be implemented using Spring Security + JWT.
- Business ownership must be verified by the backend.
- Database constraints remain the final integrity layer.
- Payment success must never be trusted solely from the frontend.
- Historical business records should not be casually hard-deleted.

---

# 3. Base URL

All APIs use:

```text
/api/v1
```

Examples:

```text
/api/v1/customers
/api/v1/services
/api/v1/bookings
/api/v1/reviews
```

---

# 4. Content Type

Normal requests and responses use JSON.

```http
Content-Type: application/json
Accept: application/json
```

File uploads use:

```http
Content-Type: multipart/form-data
```

---

# 5. HTTP Methods

| Method | Purpose |
|---|---|
| GET | Retrieve resource(s) |
| POST | Create a resource / perform a business creation operation |
| PUT | Replace/set a resource representation |
| PATCH | Partially update a resource or perform a controlled state update |
| DELETE | Remove a resource where deletion is appropriate |

---

# 6. Resource Naming

Use plural resource nouns.

Good:

```text
GET /api/v1/services
GET /api/v1/bookings/5001
POST /api/v1/service-requests
```

Avoid action-oriented URLs such as:

```text
/getServices
/createBooking
/updateCustomer
/deleteReview
```

---

# 7. HTTP Status Codes

| Status | Meaning |
|---|---|
| 200 | Successful retrieval/update |
| 201 | Resource successfully created |
| 204 | Successful operation with no response body |
| 400 | Invalid request / validation failure |
| 401 | Authentication required or invalid |
| 403 | Authenticated but not authorized |
| 404 | Resource not found |
| 409 | Business/resource conflict |
| 500 | Unexpected server error |

`422 Unprocessable Entity` may be introduced later if the implementation requires a distinction between syntactically valid and semantically invalid requests.

---

# 8. Standard Error Response

The backend will use a consistent error structure.

Example:

```json
{
  "timestamp": "2026-08-26T18:30:00Z",
  "status": 404,
  "error": "RESOURCE_NOT_FOUND",
  "message": "Booking not found",
  "path": "/api/v1/bookings/999"
}
```

Validation example:

```json
{
  "timestamp": "2026-08-26T18:30:00Z",
  "status": 400,
  "error": "VALIDATION_ERROR",
  "message": "Request validation failed",
  "path": "/api/v1/reviews",
  "fieldErrors": {
    "rating": "Rating must be between 1 and 5"
  }
}
```

The exact Java exception classes and global exception handling mechanism will be defined during LLD.

---

# 9. Request/Response Rules

Clients should not directly control database-managed fields such as:

- `id`
- `created_at`
- `updated_at`
- internal foreign-key values when they can be derived from the authenticated context
- password hashes
- internal security fields
- payment gateway secrets
- internal audit fields

The API will use DTOs rather than exposing JPA entities directly.

---

# 10. Pagination

Collection endpoints that may grow significantly will support pagination.

Example:

```text
GET /api/v1/bookings?page=0&size=20
```

A standard paginated response will contain information such as:

```json
{
  "content": [],
  "page": 0,
  "size": 20,
  "totalElements": 150,
  "totalPages": 8
}
```

Exact pagination implementation will be finalized during LLD.

---

# 11. Filtering and Sorting

Filtering will use query parameters.

Example:

```text
GET /api/v1/bookings?status=CONFIRMED
```

Sorting:

```text
GET /api/v1/bookings?sort=scheduledStart,desc
```

Pagination, filtering, and sorting parameters will be defined per resource.

---

# 12. Authentication and Authorization

Authentication is not implemented in the current phase.

The planned security architecture is:

```text
Client
  ↓
Spring Security
  ↓
JWT Authentication
  ↓
Authenticated User
  ↓
Role/Ownership Authorization
```

Planned roles include:

```text
CUSTOMER
WORKER
ADMIN
```

Clients must not be allowed to arbitrarily submit or modify:

- user roles
- password hashes
- account security state
- ownership identifiers

Detailed security rules will be finalized during the Security/LLD phase.

---

# 13. API Module Map

```text
/api/v1
│
├── customers
├── workers
├── services
├── addresses
├── service-requests
├── attachments
├── diagnoses
├── availability
├── documents
├── bookings
├── payments
├── transactions
├── invoices
├── tracking
└── reviews
```

---

# 14. Module 1 — Identity

## Customer

### Create Customer

```http
POST /api/v1/customers
```

Request:

```json
{
  "name": "Rahul Sharma",
  "email": "rahul@example.com",
  "phone": "9876543210"
}
```

Response:

```http
201 Created
```

```json
{
  "id": 101,
  "name": "Rahul Sharma",
  "email": "rahul@example.com",
  "phone": "9876543210"
}
```

### Get Customer

```http
GET /api/v1/customers/{customerId}
```

### Update Customer

```http
PATCH /api/v1/customers/{customerId}
```

Only allowed profile fields may be updated.

### Worker

```http
POST  /api/v1/workers
GET   /api/v1/workers/{workerId}
PATCH /api/v1/workers/{workerId}
```

### Direct User CRUD

No unrestricted public CRUD API is exposed for `/users`.

User identity/security is an internal backend concern and will be integrated with authentication later.

---

# 15. Module 2 — Services

## Service Discovery

```http
GET /api/v1/services
GET /api/v1/services/{serviceId}
```

## Service Management

```http
POST  /api/v1/services
PATCH /api/v1/services/{serviceId}
```

Service creation/update will eventually be restricted to authorized administrative users.

Hard deletion of services is not part of the normal API. Service lifecycle should preserve historical records.

## Worker ↔ Service

Get worker services:

```http
GET /api/v1/workers/{workerId}/services
```

Add service to worker:

```http
POST /api/v1/workers/{workerId}/services/{serviceId}
```

Remove service from worker:

```http
DELETE /api/v1/workers/{workerId}/services/{serviceId}
```

Find workers for service:

```http
GET /api/v1/services/{serviceId}/workers
```

The `worker_services` join table is not exposed as raw CRUD.

---

# 16. Module 3 — Customer Request

## Addresses

```http
GET    /api/v1/customers/{customerId}/addresses
POST   /api/v1/customers/{customerId}/addresses
GET    /api/v1/addresses/{addressId}
PATCH  /api/v1/addresses/{addressId}
DELETE /api/v1/addresses/{addressId}
```

Customer ownership of the address must be verified.

## Service Requests

Create:

```http
POST /api/v1/service-requests
```

Example:

```json
{
  "serviceId": 2,
  "addressId": 501,
  "description": "AC is running but not cooling properly"
}
```

Retrieve:

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

Status changes are controlled business operations and must not be treated as unrestricted field updates.

## Attachments

Upload:

```http
POST /api/v1/service-requests/{requestId}/attachments
```

List:

```http
GET /api/v1/service-requests/{requestId}/attachments
```

Retrieve metadata:

```http
GET /api/v1/attachments/{attachmentId}
```

Delete where business rules permit:

```http
DELETE /api/v1/attachments/{attachmentId}
```

File uploads use `multipart/form-data`.

## Diagnoses

Create:

```http
POST /api/v1/service-requests/{requestId}/diagnoses
```

List:

```http
GET /api/v1/service-requests/{requestId}/diagnoses
```

Retrieve:

```http
GET /api/v1/diagnoses/{diagnosisId}
```

Diagnosis creation/source and authorization will be finalized during LLD.

Potential sources include AI-generated or worker-generated diagnosis.

---

# 17. Module 4 — Worker

## Availability

```http
GET    /api/v1/workers/{workerId}/availability
POST   /api/v1/workers/{workerId}/availability
PATCH  /api/v1/availability/{availabilityId}
DELETE /api/v1/availability/{availabilityId}
```

Basic validation:

```text
startTime < endTime
```

Overlapping schedule rules will be finalized during LLD.

## Worker Documents

List:

```http
GET /api/v1/workers/{workerId}/documents
```

Upload:

```http
POST /api/v1/workers/{workerId}/documents
```

Retrieve metadata:

```http
GET /api/v1/documents/{documentId}
```

Delete where business rules permit:

```http
DELETE /api/v1/documents/{documentId}
```

Document verification status is backend/admin controlled.

Workers cannot mark their own documents as verified.

## Worker Current Location

Get:

```http
GET /api/v1/workers/{workerId}/location
```

Set/update:

```http
PUT /api/v1/workers/{workerId}/location
```

Remove:

```http
DELETE /api/v1/workers/{workerId}/location
```

`worker_locations` represents the worker's current/latest location.

---

# 18. Module 5 — Booking

## Create Booking

```http
POST /api/v1/service-requests/{requestId}/bookings
```

Request:

```json
{
  "workerId": 205,
  "scheduledStart": "2026-08-28T10:00:00",
  "scheduledEnd": "2026-08-28T11:30:00"
}
```

Backend must validate:

- service request exists
- request is eligible for booking
- request does not already have a booking
- worker exists
- worker provides the requested service
- worker is available
- schedule is valid
- current user is authorized

Database constraint:

```text
UNIQUE(service_request_id)
```

ensures one service request has at most one booking.

## Booking Retrieval

```http
GET /api/v1/bookings/{bookingId}
```

## Customer Bookings

```http
GET /api/v1/customers/{customerId}/bookings
```

## Worker Bookings

```http
GET /api/v1/workers/{workerId}/bookings
```

## Update Allowed Booking Details

```http
PATCH /api/v1/bookings/{bookingId}
```

Only fields explicitly allowed by business rules may be updated.

## Booking Status

```http
PATCH /api/v1/bookings/{bookingId}/status
```

Example:

```json
{
  "status": "CONFIRMED"
}
```

Status changes are controlled state transitions.

Conceptual lifecycle:

```text
REQUESTED
   ├── CONFIRMED
   ├── REJECTED
   └── CANCELLED

CONFIRMED
   ├── IN_PROGRESS
   └── CANCELLED

IN_PROGRESS
   └── COMPLETED
```

Exact transition permissions will be finalized during LLD.

## Status History

```http
GET /api/v1/bookings/{bookingId}/status-history
```

Status history records who changed the status and when.

---

# 19. Module 6 — Payment

Payment is intentionally separated from transactions and invoices.

```text
Booking
   ↓
Payment
   ├── Transactions
   └── Invoice(s)
```

## Create Payment

```http
POST /api/v1/bookings/{bookingId}/payments
```

The client must not arbitrarily control the payable amount.

The backend determines/validates the amount.

## Get Payment

```http
GET /api/v1/bookings/{bookingId}/payment
```

Database constraint:

```text
UNIQUE(booking_id)
```

ensures at most one payment record per booking.

## Transactions

```http
GET /api/v1/payments/{paymentId}/transactions
```

Transactions are backend/gateway-generated records.

There is no normal client-facing `POST /transactions`.

## Invoices

```http
GET /api/v1/payments/{paymentId}/invoices
GET /api/v1/invoices/{invoiceId}
```

Invoice generation is backend controlled.

## Payment Security

Frontend confirmation alone must never be treated as authoritative.

Planned flow:

```text
Customer
   ↓
Payment Gateway
   ↓
Gateway confirmation/webhook
   ↓
FixNow Backend
   ↓
Verify
   ↓
Transaction
   ↓
Payment status
   ↓
Invoice
```

Razorpay integration will be implemented later.

---

# 20. Module 7 — Tracking

Tracking is different from worker current location.

```text
worker_locations
    ↓
Current worker location

tracking_points
    ↓
Booking-specific movement history
```

## Start Tracking

```http
POST /api/v1/bookings/{bookingId}/tracking
```

## Get Booking Tracking

```http
GET /api/v1/bookings/{bookingId}/tracking
```

Database constraint:

```text
UNIQUE(booking_id)
```

ensures at most one tracking resource per booking.

## Get Tracking

```http
GET /api/v1/tracking/{trackingId}
```

## Add Tracking Point

```http
POST /api/v1/tracking/{trackingId}/points
```

Example:

```json
{
  "latitude": 28.6139,
  "longitude": 77.2090,
  "recordedAt": "2026-08-28T09:55:00Z"
}
```

## Get Tracking Points

```http
GET /api/v1/tracking/{trackingId}/points
```

This endpoint must support pagination because tracking points can grow rapidly.

## Tracking Status

```http
PATCH /api/v1/tracking/{trackingId}/status
```

Normal tracking history should not be hard-deleted.

Real-time tracking may later use WebSocket/SSE, but that is an implementation decision and is not required for the REST contract.

---

# 21. Module 8 — Review

Review relationship:

```text
Booking → Review = 1 : 0..1
```

Database constraint:

```text
UNIQUE(booking_id)
```

## Create Review

```http
POST /api/v1/bookings/{bookingId}/review
```

Request:

```json
{
  "rating": 5,
  "comment": "Very professional and quick."
}
```

Backend derives the customer and worker from the booking.

Client should not submit arbitrary:

```text
customerId
workerId
bookingId
```

as ownership data.

## Get Booking Review

```http
GET /api/v1/bookings/{bookingId}/review
```

## Get Review

```http
GET /api/v1/reviews/{reviewId}
```

## Update Review

```http
PATCH /api/v1/reviews/{reviewId}
```

Only the review owner may update it.

## Worker Reviews

```http
GET /api/v1/workers/{workerId}/reviews
```

## Worker Rating Summary

```http
GET /api/v1/workers/{workerId}/reviews/summary
```

Example:

```json
{
  "workerId": 205,
  "averageRating": 4.6,
  "totalReviews": 128
}
```

## Review Rules

A review requires:

- booking exists
- authenticated user owns the booking
- booking is completed
- review does not already exist
- rating is between 1 and 5

Normal customer-facing hard deletion of reviews is not supported.

---

# 22. End-to-End FixNow Workflow

```text
Customer
   ↓
Create Customer
   ↓
Create Address
   ↓
Discover Service
   ↓
Create Service Request
   ↓
Upload Attachments
   ↓
Diagnosis
   ↓
Find Suitable Worker
   ↓
Create Booking
   ↓
Confirm Booking
   ↓
Create Payment
   ↓
Payment Gateway
   ↓
Payment Verification
   ↓
Start Tracking
   ↓
Worker Performs Service
   ↓
Booking Completed
   ↓
Invoice
   ↓
Customer Creates Review
```

---

# 23. Ownership and Authorization Model

Ownership must be checked at the backend.

Examples:

```text
Customer A
  └── Address A
```

Customer B must not be able to use Address A.

```text
Customer A
  └── Booking A
```

Customer B must not be able to view or review Booking A.

```text
Worker A
  └── Location A
```

Worker B must not update Worker A's location.

These checks are separate from database foreign keys.

```text
Foreign Key
    ↓
Data relationship

Authorization
    ↓
Who is allowed to perform the operation
```

---

# 24. API-to-Database Boundary

The API must not become a direct mirror of the database.

Example:

```text
Database:
worker_services

API:
POST /workers/{workerId}/services/{serviceId}
```

Database:

```text
transactions
```

API:

```text
GET /payments/{paymentId}/transactions
```

Database:

```text
users
customer_profiles
```

API:

```text
POST /customers
```

This keeps business logic in the backend rather than exposing storage structure.

---

# 25. Deferred Design Decisions

The following are intentionally deferred to LLD/implementation:

1. Exact Spring Security + JWT implementation.
2. Exact booking state transition authorization.
3. Exact service-request status state machine.
4. Diagnosis source and authorization.
5. File storage provider.
6. AI provider/integration details.
7. Razorpay integration details.
8. Real-time tracking using REST vs WebSocket/SSE.
9. Exact DTO class structure.
10. Exact validation annotations and business validation services.
11. Global exception handling implementation.
12. Transaction boundaries using `@Transactional`.

These should not be invented inside the API contract.

---

# 26. API Contract Completion Status

| Area | Status |
|---|---|
| API Foundation | ✅ |
| Versioning | ✅ |
| HTTP conventions | ✅ |
| Error format | ✅ |
| Identity | ✅ |
| Services | ✅ |
| Customer Request | ✅ |
| Worker | ✅ |
| Booking | ✅ |
| Payment | ✅ |
| Tracking | ✅ |
| Review | ✅ |
| Cross-module validation | ✅ |
| Security boundary | ✅ |
| LLD-specific decisions | Deferred intentionally |

---

# 27. Next Development Phase

The API contract now becomes the input for the next engineering phase:

```text
SRS
 ↓
ERD
 ↓
Database Schema
 ↓
SQL Server
 ↓
Database Validation
 ↓
API Contract              ← THIS DOCUMENT
 ↓
Backend LLD               ← NEXT
 ↓
Spring Boot Architecture
 ↓
Implementation
```

The next document should be:

```text
docs/05-Backend-LLD.md
```

It will define:

```text
Controller
    ↓
Service
    ↓
Repository
    ↓
Entity
    ↓
Database

DTO
Mapper
Validation
Exception Handling
Configuration
Security boundary
Package structure
Dependency flow
```

The API contract should be treated as the **baseline**. Any future API change during LLD must be deliberate and documented rather than changing endpoints randomly.
