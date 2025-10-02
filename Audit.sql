
-- Master Audit Table (Batch-Level)


CREATE TABLE enrichment_audit (
    audit_id INT IDENTITY(1,1) PRIMARY KEY,
    batch_id UNIQUEIDENTIFIER DEFAULT NEWID(),
    source_system NVARCHAR(50),       -- e.g., MongoDB, MySQL, API
    operation_mode NVARCHAR(20),      -- e.g., FULL_LOAD, INCREMENTAL
    total_records INT,
    successful_inserts INT DEFAULT 0,
    successful_updates INT DEFAULT 0,
    successful_deletes INT DEFAULT 0,
    failed_records INT DEFAULT 0,
    processing_start DATETIME2,
    processing_end DATETIME2,
    duration_seconds AS DATEDIFF(SECOND, processing_start, processing_end),
    error_summary NVARCHAR(1000),     -- first 5 errors only
    pipeline_version NVARCHAR(20),
    created_at DATETIME2 DEFAULT SYSDATETIME()
);


-- Child Error Table (Detailed Errors)

-- Full traceability of which record failed and why.

-- Links back to audit_id.

-- Allows you to query error patterns (e.g., same column failing multiple times).

CREATE TABLE enrichment_audit_errors (
    error_id INT IDENTITY(1,1) PRIMARY KEY,
    audit_id INT FOREIGN KEY REFERENCES enrichment_audit(audit_id),
    record_id NVARCHAR(100),          -- request_id, customer_id, etc.
    operation_type NVARCHAR(20),      -- INSERT / UPDATE / DELETE
    error_message NVARCHAR(MAX),
    created_at DATETIME2 DEFAULT SYSDATETIME()
);



