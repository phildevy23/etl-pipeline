
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


-- populate the tables 

-- Insert into Master Audit Table (Batch-Level)
INSERT INTO enrichment_audit (
    batch_id, source_system, operation_mode, total_records,
    successful_inserts, successful_updates, successful_deletes, failed_records,
    processing_start, processing_end, error_summary, pipeline_version
)
VALUES 
(NEWID(), 'MongoDB', 'INCREMENTAL', 250,
 120, 100, 5, 25,
 '2025-10-02 10:00:00', '2025-10-02 10:05:00',
 'Customer 101: Invalid email; Customer 202: Null postcode; Customer 303: Invalid date',
 'ETL_v1.2');

INSERT INTO enrichment_audit (
    batch_id, source_system, operation_mode, total_records,
    successful_inserts, successful_updates, successful_deletes, failed_records,
    processing_start, processing_end, error_summary, pipeline_version
)
VALUES 
(NEWID(), 'MySQL', 'FULL_LOAD', 500,
 490, 0, 0, 10,
 '2025-10-02 09:00:00', '2025-10-02 09:10:00',
 'Customer 501: PK violation; Customer 505: Invalid phone number',
 'ETL_v1.2');


-- Insert into Child Error Table (Detailed Errors)
-- Assume first audit run got audit_id = 1 and second = 2

INSERT INTO enrichment_audit_errors (audit_id, record_id, operation_type, error_message)
VALUES 
(1, 'CUST101', 'INSERT', 'Invalid email format: user@@domain.com'),
(1, 'CUST202', 'UPDATE', 'Postcode cannot be NULL'),
(1, 'CUST303', 'INSERT', 'Invalid date format: 32-13-2025'),
(1, 'CUST310', 'UPDATE', 'Phone number exceeds max length'),
(1, 'CUST315', 'DELETE', 'Record not found for delete operation');

INSERT INTO enrichment_audit_errors (audit_id, record_id, operation_type, error_message)
VALUES 
(2, 'CUST501', 'INSERT', 'Primary key violation on customer_id'),
(2, 'CUST505', 'INSERT', 'Phone number must be numeric'),
(2, 'CUST509', 'INSERT', 'Email exceeds max length (varchar 100)'),
(2, 'CUST510', 'INSERT', 'Mandatory field region is missing'),
(2, 'CUST512', 'INSERT', 'Constraint check failed: annual_revenue < 0');

-- Example Query to Verify Parent–Child Link
-- See summary + detailed errors together
SELECT 
    a.audit_id, a.source_system, a.operation_mode, a.total_records, a.failed_records,
    e.record_id, e.operation_type, e.error_message
FROM enrichment_audit a
LEFT JOIN enrichment_audit_errors e
    ON a.audit_id = e.audit_id
ORDER BY a.audit_id, e.error_id;


