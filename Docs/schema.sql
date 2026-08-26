/*
    FixNow — SQL Server Database Schema
    Version: 1.0
    Iteration: 1
    Database: Microsoft SQL Server
    Tool: SQL Server Management Studio (SSMS)

    Source of truth:
    docs/03-Database-Schema.md
*/

IF DB_ID(N'FixNowDB') IS NULL
BEGIN
    CREATE DATABASE FixNowDB;
END;
GO

USE FixNowDB;
GO

/* =========================================================
   1. IDENTITY
   ========================================================= */

CREATE TABLE dbo.users (
    id BIGINT IDENTITY(1,1) NOT NULL,
    name NVARCHAR(100) NOT NULL,
    email NVARCHAR(150) NOT NULL,
    phone NVARCHAR(20) NOT NULL,
    password_hash NVARCHAR(255) NOT NULL,
    role NVARCHAR(20) NOT NULL,
    status NVARCHAR(20) NOT NULL
        CONSTRAINT DF_users_status DEFAULT 'ACTIVE',
    created_at DATETIME2 NOT NULL,
    updated_at DATETIME2 NOT NULL,

    CONSTRAINT PK_users PRIMARY KEY (id),
    CONSTRAINT UQ_users_email UNIQUE (email),
    CONSTRAINT UQ_users_phone UNIQUE (phone)
);
GO

CREATE TABLE dbo.customer_profiles (
    id BIGINT IDENTITY(1,1) NOT NULL,
    user_id BIGINT NOT NULL,
    profile_image_url NVARCHAR(500) NULL,
    date_of_birth DATE NULL,
    gender NVARCHAR(20) NULL,
    created_at DATETIME2 NOT NULL,
    updated_at DATETIME2 NOT NULL,

    CONSTRAINT PK_customer_profiles PRIMARY KEY (id),
    CONSTRAINT UQ_customer_profiles_user_id UNIQUE (user_id),
    CONSTRAINT FK_customer_profiles_users
        FOREIGN KEY (user_id) REFERENCES dbo.users(id)
);
GO

CREATE TABLE dbo.worker_profiles (
    id BIGINT IDENTITY(1,1) NOT NULL,
    user_id BIGINT NOT NULL,
    about_me NVARCHAR(MAX) NULL,
    experience_years INT NOT NULL
        CONSTRAINT DF_worker_profiles_experience_years DEFAULT 0,
    rating_avg DECIMAL(3,2) NOT NULL
        CONSTRAINT DF_worker_profiles_rating_avg DEFAULT 0.00,
    verification_status NVARCHAR(20) NOT NULL
        CONSTRAINT DF_worker_profiles_verification_status DEFAULT 'PENDING',
    created_at DATETIME2 NOT NULL,
    updated_at DATETIME2 NOT NULL,

    CONSTRAINT PK_worker_profiles PRIMARY KEY (id),
    CONSTRAINT UQ_worker_profiles_user_id UNIQUE (user_id),
    CONSTRAINT FK_worker_profiles_users
        FOREIGN KEY (user_id) REFERENCES dbo.users(id)
);
GO

/* =========================================================
   2. SERVICES
   ========================================================= */

CREATE TABLE dbo.services (
    id BIGINT IDENTITY(1,1) NOT NULL,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX) NULL,
    is_active BIT NOT NULL
        CONSTRAINT DF_services_is_active DEFAULT 1,
    created_at DATETIME2 NOT NULL,
    updated_at DATETIME2 NOT NULL,

    CONSTRAINT PK_services PRIMARY KEY (id),
    CONSTRAINT UQ_services_name UNIQUE (name)
);
GO

CREATE TABLE dbo.worker_services (
    id BIGINT IDENTITY(1,1) NOT NULL,
    worker_id BIGINT NOT NULL,
    service_id BIGINT NOT NULL,
    price DECIMAL(10,2) NULL,
    created_at DATETIME2 NOT NULL,

    CONSTRAINT PK_worker_services PRIMARY KEY (id),
    CONSTRAINT UQ_worker_services_worker_service
        UNIQUE (worker_id, service_id),
    CONSTRAINT FK_worker_services_worker
        FOREIGN KEY (worker_id) REFERENCES dbo.worker_profiles(id),
    CONSTRAINT FK_worker_services_service
        FOREIGN KEY (service_id) REFERENCES dbo.services(id)
);
GO

/* =========================================================
   3. CUSTOMER REQUEST
   ========================================================= */

CREATE TABLE dbo.addresses (
    id BIGINT IDENTITY(1,1) NOT NULL,
    customer_id BIGINT NOT NULL,
    address_line NVARCHAR(255) NOT NULL,
    city NVARCHAR(100) NOT NULL,
    state NVARCHAR(100) NOT NULL,
    postal_code NVARCHAR(20) NOT NULL,
    latitude DECIMAL(10,7) NULL,
    longitude DECIMAL(10,7) NULL,
    is_default BIT NOT NULL
        CONSTRAINT DF_addresses_is_default DEFAULT 0,
    created_at DATETIME2 NOT NULL,
    updated_at DATETIME2 NOT NULL,

    CONSTRAINT PK_addresses PRIMARY KEY (id),
    CONSTRAINT FK_addresses_customer
        FOREIGN KEY (customer_id) REFERENCES dbo.customer_profiles(id)
);
GO

CREATE TABLE dbo.service_requests (
    id BIGINT IDENTITY(1,1) NOT NULL,
    customer_id BIGINT NOT NULL,
    service_id BIGINT NOT NULL,
    address_id BIGINT NOT NULL,
    description NVARCHAR(MAX) NOT NULL,
    status NVARCHAR(30) NOT NULL,
    created_at DATETIME2 NOT NULL,
    updated_at DATETIME2 NOT NULL,

    CONSTRAINT PK_service_requests PRIMARY KEY (id),
    CONSTRAINT FK_service_requests_customer
        FOREIGN KEY (customer_id) REFERENCES dbo.customer_profiles(id),
    CONSTRAINT FK_service_requests_service
        FOREIGN KEY (service_id) REFERENCES dbo.services(id),
    CONSTRAINT FK_service_requests_address
        FOREIGN KEY (address_id) REFERENCES dbo.addresses(id)
);
GO

CREATE TABLE dbo.attachments (
    id BIGINT IDENTITY(1,1) NOT NULL,
    service_request_id BIGINT NOT NULL,
    file_url NVARCHAR(500) NOT NULL,
    file_type NVARCHAR(20) NOT NULL,
    created_at DATETIME2 NOT NULL,

    CONSTRAINT PK_attachments PRIMARY KEY (id),
    CONSTRAINT FK_attachments_service_request
        FOREIGN KEY (service_request_id) REFERENCES dbo.service_requests(id)
);
GO

CREATE TABLE dbo.diagnoses (
    id BIGINT IDENTITY(1,1) NOT NULL,
    service_request_id BIGINT NOT NULL,
    problem_type NVARCHAR(150) NULL,
    description NVARCHAR(MAX) NULL,
    estimated_cost DECIMAL(10,2) NULL,
    estimated_duration INT NULL,
    confidence_score DECIMAL(5,2) NULL,
    created_at DATETIME2 NOT NULL,

    CONSTRAINT PK_diagnoses PRIMARY KEY (id),
    CONSTRAINT FK_diagnoses_service_request
        FOREIGN KEY (service_request_id) REFERENCES dbo.service_requests(id)
);
GO

/* =========================================================
   4. WORKER
   ========================================================= */

CREATE TABLE dbo.worker_availabilities (
    id BIGINT IDENTITY(1,1) NOT NULL,
    worker_id BIGINT NOT NULL,
    day_of_week TINYINT NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    is_available BIT NOT NULL
        CONSTRAINT DF_worker_availabilities_is_available DEFAULT 1,
    created_at DATETIME2 NOT NULL,
    updated_at DATETIME2 NOT NULL,

    CONSTRAINT PK_worker_availabilities PRIMARY KEY (id),
    CONSTRAINT FK_worker_availabilities_worker
        FOREIGN KEY (worker_id) REFERENCES dbo.worker_profiles(id)
);
GO

CREATE TABLE dbo.worker_documents (
    id BIGINT IDENTITY(1,1) NOT NULL,
    worker_id BIGINT NOT NULL,
    document_type NVARCHAR(50) NOT NULL,
    document_url NVARCHAR(500) NOT NULL,
    verification_status NVARCHAR(20) NOT NULL
        CONSTRAINT DF_worker_documents_verification_status DEFAULT 'PENDING',
    created_at DATETIME2 NOT NULL,
    updated_at DATETIME2 NOT NULL,

    CONSTRAINT PK_worker_documents PRIMARY KEY (id),
    CONSTRAINT FK_worker_documents_worker
        FOREIGN KEY (worker_id) REFERENCES dbo.worker_profiles(id)
);
GO

CREATE TABLE dbo.worker_locations (
    id BIGINT IDENTITY(1,1) NOT NULL,
    worker_id BIGINT NOT NULL,
    latitude DECIMAL(10,7) NOT NULL,
    longitude DECIMAL(10,7) NOT NULL,
    updated_at DATETIME2 NOT NULL,

    CONSTRAINT PK_worker_locations PRIMARY KEY (id),
    CONSTRAINT UQ_worker_locations_worker_id UNIQUE (worker_id),
    CONSTRAINT FK_worker_locations_worker
        FOREIGN KEY (worker_id) REFERENCES dbo.worker_profiles(id)
);
GO

/* =========================================================
   5. BOOKING
   ========================================================= */

CREATE TABLE dbo.bookings (
    id BIGINT IDENTITY(1,1) NOT NULL,
    service_request_id BIGINT NOT NULL,
    customer_id BIGINT NOT NULL,
    worker_id BIGINT NOT NULL,
    scheduled_at DATETIME2 NOT NULL,
    status NVARCHAR(30) NOT NULL,
    estimated_cost DECIMAL(10,2) NULL,
    final_cost DECIMAL(10,2) NULL,
    created_at DATETIME2 NOT NULL,
    updated_at DATETIME2 NOT NULL,

    CONSTRAINT PK_bookings PRIMARY KEY (id),
    CONSTRAINT UQ_bookings_service_request_id UNIQUE (service_request_id),
    CONSTRAINT FK_bookings_service_request
        FOREIGN KEY (service_request_id) REFERENCES dbo.service_requests(id),
    CONSTRAINT FK_bookings_customer
        FOREIGN KEY (customer_id) REFERENCES dbo.customer_profiles(id),
    CONSTRAINT FK_bookings_worker
        FOREIGN KEY (worker_id) REFERENCES dbo.worker_profiles(id)
);
GO

CREATE TABLE dbo.booking_status_history (
    id BIGINT IDENTITY(1,1) NOT NULL,
    booking_id BIGINT NOT NULL,
    status NVARCHAR(30) NOT NULL,
    changed_by_user_id BIGINT NOT NULL,
    changed_at DATETIME2 NOT NULL,
    notes NVARCHAR(500) NULL,

    CONSTRAINT PK_booking_status_history PRIMARY KEY (id),
    CONSTRAINT FK_booking_status_history_booking
        FOREIGN KEY (booking_id) REFERENCES dbo.bookings(id),
    CONSTRAINT FK_booking_status_history_user
        FOREIGN KEY (changed_by_user_id) REFERENCES dbo.users(id)
);
GO

/* =========================================================
   6. PAYMENT
   ========================================================= */

CREATE TABLE dbo.payments (
    id BIGINT IDENTITY(1,1) NOT NULL,
    booking_id BIGINT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_method NVARCHAR(30) NOT NULL,
    payment_status NVARCHAR(30) NOT NULL,
    paid_at DATETIME2 NULL,
    created_at DATETIME2 NOT NULL,
    updated_at DATETIME2 NOT NULL,

    CONSTRAINT PK_payments PRIMARY KEY (id),
    CONSTRAINT UQ_payments_booking_id UNIQUE (booking_id),
    CONSTRAINT FK_payments_booking
        FOREIGN KEY (booking_id) REFERENCES dbo.bookings(id)
);
GO

CREATE TABLE dbo.transactions (
    id BIGINT IDENTITY(1,1) NOT NULL,
    payment_id BIGINT NOT NULL,
    gateway_transaction_id NVARCHAR(150) NOT NULL,
    gateway_name NVARCHAR(50) NOT NULL,
    transaction_status NVARCHAR(30) NOT NULL,
    transaction_amount DECIMAL(10,2) NOT NULL,
    transaction_time DATETIME2 NOT NULL,

    CONSTRAINT PK_transactions PRIMARY KEY (id),
    CONSTRAINT UQ_transactions_gateway_transaction_id
        UNIQUE (gateway_transaction_id),
    CONSTRAINT FK_transactions_payment
        FOREIGN KEY (payment_id) REFERENCES dbo.payments(id)
);
GO

CREATE TABLE dbo.invoices (
    id BIGINT IDENTITY(1,1) NOT NULL,
    payment_id BIGINT NOT NULL,
    invoice_number NVARCHAR(50) NOT NULL,
    invoice_url NVARCHAR(500) NULL,
    issued_at DATETIME2 NOT NULL,

    CONSTRAINT PK_invoices PRIMARY KEY (id),
    CONSTRAINT UQ_invoices_invoice_number UNIQUE (invoice_number),
    CONSTRAINT FK_invoices_payment
        FOREIGN KEY (payment_id) REFERENCES dbo.payments(id)
);
GO

/* =========================================================
   7. TRACKING
   ========================================================= */

CREATE TABLE dbo.tracking (
    id BIGINT IDENTITY(1,1) NOT NULL,
    booking_id BIGINT NOT NULL,
    started_at DATETIME2 NULL,
    ended_at DATETIME2 NULL,
    status NVARCHAR(20) NOT NULL,
    created_at DATETIME2 NOT NULL,

    CONSTRAINT PK_tracking PRIMARY KEY (id),
    CONSTRAINT UQ_tracking_booking_id UNIQUE (booking_id),
    CONSTRAINT FK_tracking_booking
        FOREIGN KEY (booking_id) REFERENCES dbo.bookings(id)
);
GO

CREATE TABLE dbo.tracking_points (
    id BIGINT IDENTITY(1,1) NOT NULL,
    tracking_id BIGINT NOT NULL,
    latitude DECIMAL(10,7) NOT NULL,
    longitude DECIMAL(10,7) NOT NULL,
    recorded_at DATETIME2 NOT NULL,

    CONSTRAINT PK_tracking_points PRIMARY KEY (id),
    CONSTRAINT FK_tracking_points_tracking
        FOREIGN KEY (tracking_id) REFERENCES dbo.tracking(id)
);
GO

/* =========================================================
   8. REVIEW
   ========================================================= */

CREATE TABLE dbo.reviews (
    id BIGINT IDENTITY(1,1) NOT NULL,
    booking_id BIGINT NOT NULL,
    customer_id BIGINT NOT NULL,
    worker_id BIGINT NOT NULL,
    rating INT NOT NULL,
    comment NVARCHAR(1000) NULL,
    created_at DATETIME2 NOT NULL,
    updated_at DATETIME2 NOT NULL,

    CONSTRAINT PK_reviews PRIMARY KEY (id),
    CONSTRAINT UQ_reviews_booking_id UNIQUE (booking_id),
    CONSTRAINT FK_reviews_booking
        FOREIGN KEY (booking_id) REFERENCES dbo.bookings(id),
    CONSTRAINT FK_reviews_customer
        FOREIGN KEY (customer_id) REFERENCES dbo.customer_profiles(id),
    CONSTRAINT FK_reviews_worker
        FOREIGN KEY (worker_id) REFERENCES dbo.worker_profiles(id),
    CONSTRAINT CK_reviews_rating
        CHECK (rating BETWEEN 1 AND 5)
);
GO
