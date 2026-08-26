# FixNow — Database Schema

**Version:** 1.0  
**Iteration:** 1  
**Database:** Microsoft SQL Server  
**Database Tool:** SQL Server Management Studio (SSMS)

---

## 1. Identity

### 1.1 `users`

Stores common account information for all FixNow users.

| Column | SQL Server Type | Constraints |
|---|---|---|
| `id` | BIGINT | PK, IDENTITY(1,1) |
| `name` | NVARCHAR(100) | NOT NULL |
| `email` | NVARCHAR(150) | NOT NULL, UNIQUE |
| `phone` | NVARCHAR(20) | NOT NULL, UNIQUE |
| `password_hash` | NVARCHAR(255) | NOT NULL |
| `role` | NVARCHAR(20) | NOT NULL |
| `status` | NVARCHAR(20) | NOT NULL, DEFAULT 'ACTIVE' |
| `created_at` | DATETIME2 | NOT NULL |
| `updated_at` | DATETIME2 | NOT NULL |

**Allowed `role` values:** `CUSTOMER`, `WORKER`, `ADMIN`

**Allowed `status` values:** `ACTIVE`, `INACTIVE`

---

### 1.2 `customer_profiles`

Stores customer-specific profile information.

| Column | SQL Server Type | Constraints |
|---|---|---|
| `id` | BIGINT | PK, IDENTITY(1,1) |
| `user_id` | BIGINT | FK, UNIQUE, NOT NULL |
| `profile_image_url` | NVARCHAR(500) | NULL |
| `date_of_birth` | DATE | NULL |
| `gender` | NVARCHAR(20) | NULL |
| `created_at` | DATETIME2 | NOT NULL |
| `updated_at` | DATETIME2 | NOT NULL |

**Foreign Key:** `user_id → users.id`

**Relationship:** `users 1 ─── 0..1 customer_profiles`

---

### 1.3 `worker_profiles`

Stores professional information specific to a worker.

| Column | SQL Server Type | Constraints |
|---|---|---|
| `id` | BIGINT | PK, IDENTITY(1,1) |
| `user_id` | BIGINT | FK, UNIQUE, NOT NULL |
| `about_me` | NVARCHAR(MAX) | NULL |
| `experience_years` | INT | NOT NULL, DEFAULT 0 |
| `rating_avg` | DECIMAL(3,2) | NOT NULL, DEFAULT 0.00 |
| `verification_status` | NVARCHAR(20) | NOT NULL, DEFAULT 'PENDING' |
| `created_at` | DATETIME2 | NOT NULL |
| `updated_at` | DATETIME2 | NOT NULL |

**Foreign Key:** `user_id → users.id`

**Verification status:** `PENDING`, `APPROVED`, `REJECTED`

**Relationship:** `users 1 ─── 0..1 worker_profiles`

---

## 2. Services

### 2.1 `services`

Stores services available on FixNow.

| Column | SQL Server Type | Constraints |
|---|---|---|
| `id` | BIGINT | PK, IDENTITY(1,1) |
| `name` | NVARCHAR(100) | NOT NULL, UNIQUE |
| `description` | NVARCHAR(MAX) | NULL |
| `is_active` | BIT | NOT NULL, DEFAULT 1 |
| `created_at` | DATETIME2 | NOT NULL |
| `updated_at` | DATETIME2 | NOT NULL |

---

### 2.2 `worker_services`

Associates workers with the services they provide.

| Column | SQL Server Type | Constraints |
|---|---|---|
| `id` | BIGINT | PK, IDENTITY(1,1) |
| `worker_id` | BIGINT | FK, NOT NULL |
| `service_id` | BIGINT | FK, NOT NULL |
| `price` | DECIMAL(10,2) | NULL |
| `created_at` | DATETIME2 | NOT NULL |

**Foreign Keys:**
- `worker_id → worker_profiles.id`
- `service_id → services.id`

**Constraint:** `UNIQUE(worker_id, service_id)`

**Relationship:** `worker_profiles N ─── M services` through `worker_services`.

---

## 3. Customer Request

### 3.1 `addresses`

Stores customer service addresses.

| Column | SQL Server Type | Constraints |
|---|---|---|
| `id` | BIGINT | PK, IDENTITY(1,1) |
| `customer_id` | BIGINT | FK, NOT NULL |
| `address_line` | NVARCHAR(255) | NOT NULL |
| `city` | NVARCHAR(100) | NOT NULL |
| `state` | NVARCHAR(100) | NOT NULL |
| `postal_code` | NVARCHAR(20) | NOT NULL |
| `latitude` | DECIMAL(10,7) | NULL |
| `longitude` | DECIMAL(10,7) | NULL |
| `is_default` | BIT | NOT NULL, DEFAULT 0 |
| `created_at` | DATETIME2 | NOT NULL |
| `updated_at` | DATETIME2 | NOT NULL |

**Foreign Key:** `customer_id → customer_profiles.id`

---

### 3.2 `service_requests`

Represents a customer's request for a service.

| Column | SQL Server Type | Constraints |
|---|---|---|
| `id` | BIGINT | PK, IDENTITY(1,1) |
| `customer_id` | BIGINT | FK, NOT NULL |
| `service_id` | BIGINT | FK, NOT NULL |
| `address_id` | BIGINT | FK, NOT NULL |
| `description` | NVARCHAR(MAX) | NOT NULL |
| `status` | NVARCHAR(30) | NOT NULL |
| `created_at` | DATETIME2 | NOT NULL |
| `updated_at` | DATETIME2 | NOT NULL |

**Foreign Keys:**
- `customer_id → customer_profiles.id`
- `service_id → services.id`
- `address_id → addresses.id`

**Request statuses:** `OPEN`, `ASSIGNED`, `CLOSED`, `CANCELLED`

---

### 3.3 `attachments`

Stores references to images/videos uploaded for a service request.

| Column | SQL Server Type | Constraints |
|---|---|---|
| `id` | BIGINT | PK, IDENTITY(1,1) |
| `service_request_id` | BIGINT | FK, NOT NULL |
| `file_url` | NVARCHAR(500) | NOT NULL |
| `file_type` | NVARCHAR(20) | NOT NULL |
| `created_at` | DATETIME2 | NOT NULL |

**Foreign Key:** `service_request_id → service_requests.id`

**File types:** `IMAGE`, `VIDEO`

---

### 3.4 `diagnoses`

Stores AI diagnosis and estimation results for a service request.

| Column | SQL Server Type | Constraints |
|---|---|---|
| `id` | BIGINT | PK, IDENTITY(1,1) |
| `service_request_id` | BIGINT | FK, NOT NULL |
| `problem_type` | NVARCHAR(150) | NULL |
| `description` | NVARCHAR(MAX) | NULL |
| `estimated_cost` | DECIMAL(10,2) | NULL |
| `estimated_duration` | INT | NULL |
| `confidence_score` | DECIMAL(5,2) | NULL |
| `created_at` | DATETIME2 | NOT NULL |

**Foreign Key:** `service_request_id → service_requests.id`

---

## 4. Worker

### 4.1 `worker_availabilities`

Stores worker availability schedules.

| Column | SQL Server Type | Constraints |
|---|---|---|
| `id` | BIGINT | PK, IDENTITY(1,1) |
| `worker_id` | BIGINT | FK, NOT NULL |
| `day_of_week` | TINYINT | NOT NULL |
| `start_time` | TIME | NOT NULL |
| `end_time` | TIME | NOT NULL |
| `is_available` | BIT | NOT NULL, DEFAULT 1 |
| `created_at` | DATETIME2 | NOT NULL |
| `updated_at` | DATETIME2 | NOT NULL |

**Foreign Key:** `worker_id → worker_profiles.id`

---

### 4.2 `worker_documents`

Stores worker KYC and professional documents.

| Column | SQL Server Type | Constraints |
|---|---|---|
| `id` | BIGINT | PK, IDENTITY(1,1) |
| `worker_id` | BIGINT | FK, NOT NULL |
| `document_type` | NVARCHAR(50) | NOT NULL |
| `document_url` | NVARCHAR(500) | NOT NULL |
| `verification_status` | NVARCHAR(20) | NOT NULL, DEFAULT 'PENDING' |
| `created_at` | DATETIME2 | NOT NULL |
| `updated_at` | DATETIME2 | NOT NULL |

**Foreign Key:** `worker_id → worker_profiles.id`

**Document types:** `IDENTITY`, `CERTIFICATE`, `OTHER`

**Verification status:** `PENDING`, `APPROVED`, `REJECTED`

---

### 4.3 `worker_locations`

Stores the worker's current/latest location for nearby-worker search and worker tracking support.

| Column | SQL Server Type | Constraints |
|---|---|---|
| `id` | BIGINT | PK, IDENTITY(1,1) |
| `worker_id` | BIGINT | FK, UNIQUE, NOT NULL |
| `latitude` | DECIMAL(10,7) | NOT NULL |
| `longitude` | DECIMAL(10,7) | NOT NULL |
| `updated_at` | DATETIME2 | NOT NULL |

**Foreign Key:** `worker_id → worker_profiles.id`

**Relationship:** `worker_profiles 1 ─── 0..1 worker_locations`

---

## 5. Booking

### 5.1 `bookings`

Stores the actual service booking between a customer and worker.

| Column | SQL Server Type | Constraints |
|---|---|---|
| `id` | BIGINT | PK, IDENTITY(1,1) |
| `service_request_id` | BIGINT | FK, UNIQUE, NOT NULL |
| `customer_id` | BIGINT | FK, NOT NULL |
| `worker_id` | BIGINT | FK, NOT NULL |
| `scheduled_at` | DATETIME2 | NOT NULL |
| `status` | NVARCHAR(30) | NOT NULL |
| `estimated_cost` | DECIMAL(10,2) | NULL |
| `final_cost` | DECIMAL(10,2) | NULL |
| `created_at` | DATETIME2 | NOT NULL |
| `updated_at` | DATETIME2 | NOT NULL |

**Foreign Keys:**
- `service_request_id → service_requests.id`
- `customer_id → customer_profiles.id`
- `worker_id → worker_profiles.id`

**Constraint:** `UNIQUE(service_request_id)`

**Relationship:** `service_requests 1 ─── 0..1 bookings`

**Booking statuses:** `PENDING`, `ACCEPTED`, `ON_THE_WAY`, `STARTED`, `COMPLETED`, `CANCELLED`

---

### 5.2 `booking_status_history`

Stores every status change made to a booking.

| Column | SQL Server Type | Constraints |
|---|---|---|
| `id` | BIGINT | PK, IDENTITY(1,1) |
| `booking_id` | BIGINT | FK, NOT NULL |
| `status` | NVARCHAR(30) | NOT NULL |
| `changed_by_user_id` | BIGINT | FK, NOT NULL |
| `changed_at` | DATETIME2 | NOT NULL |
| `notes` | NVARCHAR(500) | NULL |

**Foreign Keys:**
- `booking_id → bookings.id`
- `changed_by_user_id → users.id`

---

## 6. Payment

### 6.1 `payments`

Stores payment information associated with a booking.

| Column | SQL Server Type | Constraints |
|---|---|---|
| `id` | BIGINT | PK, IDENTITY(1,1) |
| `booking_id` | BIGINT | FK, UNIQUE, NOT NULL |
| `amount` | DECIMAL(10,2) | NOT NULL |
| `payment_method` | NVARCHAR(30) | NOT NULL |
| `payment_status` | NVARCHAR(30) | NOT NULL |
| `paid_at` | DATETIME2 | NULL |
| `created_at` | DATETIME2 | NOT NULL |
| `updated_at` | DATETIME2 | NOT NULL |

**Foreign Key:** `booking_id → bookings.id`

**Constraint:** `UNIQUE(booking_id)`

**Relationship:** `bookings 1 ─── 0..1 payments`

**Payment statuses:** `PENDING`, `SUCCESS`, `FAILED`, `REFUNDED`

**Payment methods:** `RAZORPAY`, `UPI`, `CARD`, `COD`

---

### 6.2 `transactions`

Stores payment gateway transaction details.

| Column | SQL Server Type | Constraints |
|---|---|---|
| `id` | BIGINT | PK, IDENTITY(1,1) |
| `payment_id` | BIGINT | FK, NOT NULL |
| `gateway_transaction_id` | NVARCHAR(150) | UNIQUE, NOT NULL |
| `gateway_name` | NVARCHAR(50) | NOT NULL |
| `transaction_status` | NVARCHAR(30) | NOT NULL |
| `transaction_amount` | DECIMAL(10,2) | NOT NULL |
| `transaction_time` | DATETIME2 | NOT NULL |

**Foreign Key:** `payment_id → payments.id`

---

### 6.3 `invoices`

Stores invoice information generated for a payment.

| Column | SQL Server Type | Constraints |
|---|---|---|
| `id` | BIGINT | PK, IDENTITY(1,1) |
| `payment_id` | BIGINT | FK, NOT NULL |
| `invoice_number` | NVARCHAR(50) | UNIQUE, NOT NULL |
| `invoice_url` | NVARCHAR(500) | NULL |
| `issued_at` | DATETIME2 | NOT NULL |

**Foreign Key:** `payment_id → payments.id`

---

## 7. Tracking

### 7.1 `tracking`

Stores the tracking session for a booking.

| Column | SQL Server Type | Constraints |
|---|---|---|
| `id` | BIGINT | PK, IDENTITY(1,1) |
| `booking_id` | BIGINT | FK, UNIQUE, NOT NULL |
| `started_at` | DATETIME2 | NULL |
| `ended_at` | DATETIME2 | NULL |
| `status` | NVARCHAR(20) | NOT NULL |
| `created_at` | DATETIME2 | NOT NULL |

**Foreign Key:** `booking_id → bookings.id`

**Constraint:** `UNIQUE(booking_id)`

**Relationship:** `bookings 1 ─── 0..1 tracking`

**Tracking statuses:** `ACTIVE`, `COMPLETED`

---

### 7.2 `tracking_points`

Stores worker location points during live tracking.

| Column | SQL Server Type | Constraints |
|---|---|---|
| `id` | BIGINT | PK, IDENTITY(1,1) |
| `tracking_id` | BIGINT | FK, NOT NULL |
| `latitude` | DECIMAL(10,7) | NOT NULL |
| `longitude` | DECIMAL(10,7) | NOT NULL |
| `recorded_at` | DATETIME2 | NOT NULL |

**Foreign Key:** `tracking_id → tracking.id`

---

## 8. Review

### 8.1 `reviews`

Stores customer ratings and reviews for completed bookings.

| Column | SQL Server Type | Constraints |
|---|---|---|
| `id` | BIGINT | PK, IDENTITY(1,1) |
| `booking_id` | BIGINT | FK, UNIQUE, NOT NULL |
| `customer_id` | BIGINT | FK, NOT NULL |
| `worker_id` | BIGINT | FK, NOT NULL |
| `rating` | INT | NOT NULL |
| `comment` | NVARCHAR(1000) | NULL |
| `created_at` | DATETIME2 | NOT NULL |
| `updated_at` | DATETIME2 | NOT NULL |

**Foreign Keys:**
- `booking_id → bookings.id`
- `customer_id → customer_profiles.id`
- `worker_id → worker_profiles.id`

**Constraints:**
- `rating BETWEEN 1 AND 5`
- `UNIQUE(booking_id)`

---

## 9. Table Summary

| # | Table |
|---:|---|
| 1 | `users` |
| 2 | `customer_profiles` |
| 3 | `worker_profiles` |
| 4 | `services` |
| 5 | `worker_services` |
| 6 | `addresses` |
| 7 | `service_requests` |
| 8 | `attachments` |
| 9 | `diagnoses` |
| 10 | `worker_availabilities` |
| 11 | `worker_documents` |
| 12 | `worker_locations` |
| 13 | `bookings` |
| 14 | `booking_status_history` |
| 15 | `payments` |
| 16 | `transactions` |
| 17 | `invoices` |
| 18 | `tracking` |
| 19 | `tracking_points` |
| 20 | `reviews` |

---

## 10. Main Database Flow

```text
users
├── customer_profiles
│   ├── addresses
│   └── service_requests
│       ├── attachments
│       ├── diagnoses
│       └── bookings
│           ├── booking_status_history
│           ├── payments
│           │   ├── transactions
│           │   └── invoices
│           ├── tracking
│           │   └── tracking_points
│           └── reviews
│
└── worker_profiles
    ├── worker_services
    │   └── services
    ├── worker_availabilities
    ├── worker_documents
    └── worker_locations
```

---

## 11. Database Schema Status

| Module | Status |
|---|---|
| Identity | Complete |
| Services | Complete |
| Customer Request | Complete |
| Worker | Complete |
| Booking | Complete |
| Payment | Complete |
| Tracking | Complete |
| Review | Complete |

**DB Schema Design — Version 1.0 — Validated**
