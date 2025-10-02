# etl-pipeline

https://github.com/ingwanelabs/etl-pipeline/blob/main/etl/data-enrichment_load.ipynb

## Structure of raw_data

|customer_id       |Unique Identifier for each Customer                                                                                                      |
|------------------|-----------------------------------------------------------------------------------------------------------------------------------------|
|firstname         |Customers First Name                                                                                                                     |
|lastname          |Customers Surname                                                                                                                        |
|email             |Customers Email Address                                                                                                                  |
|phone             |Customers Phone Number                                                                                                                   |
|postcode          |Customers Postcode                                                                                                                       |
|region            |Postcode Region                                                                                                                          |
|country           |Postcode Country                                                                                                                         |
|district          |Postcode District                                                                                                                        |
|latitude          |Postcode Latitude (-90 to 90)                                                                                                            |
|longitude         |Postcode Longitude(-180 to 180)                                                                                                          |
|business_id       |Unique Identifier for each Business                                                                                                      |
|company           |Company Name                                                                                                                             |
|companysize       |Small, Medium, Large, Enterprise                                                                                                         |
|industry          |Technology, Finance,Healthcare, Retail, Manufacturing                                                                                    |
|annual_revenue    |Revenue Value in £                                                                                                                       |
|calculated_risk   |Low, Medium, High                                                                                                                        |
|risk_score_numeric|risk score 0 - 5 inclusive. Higher number is higher risk                                                                                 |
|risk_factors      |High Risk Location (Brighton, Cardiff, Aberdeen), Small Business ( Companysize = Small), Account Suspended (status = suspended), Standard|
|status            |Active, Suspended                                                                                                                        |




## About Audit table / Child Audit table 

When the Python ETL script starts, it first generates a **unique batch identifier (batch_id)** using the `uuid` library. This batch_id acts as a correlation key that links all events and operations belonging to a single pipeline execution. By generating the batch_id at the very beginning, every record processed in that run — whether it results in an insert, update, or failure — can be traced back to the same batch.

During processing, the script attempts to upsert each record. For every successful insert or update, the audit table is updated with counters that reflect how many records were processed successfully. This allows the audit table to provide a clear breakdown of the type of operation performed, rather than just a total count of records. For example, one batch may show 100 inserts and 50 updates, while another shows mostly updates.

If errors occur while processing individual records, the script captures the **full error message** along with the corresponding record’s key information. Instead of storing every error detail in the parent audit table, these are written to a **child audit table** (for example, `enrichment_audit_errors`). The child table includes the same batch_id, ensuring that all errors can be traced back to the correct pipeline execution. This design keeps the parent audit table concise while still preserving complete error traceability in the child table.

---

✅ **Example of child table content:**

| error_id | batch_id                             | record_id | error_message                                  | error_timestamp     |
| -------- | ------------------------------------ | --------- | ---------------------------------------------- | ------------------- |
| 1        | a8098c1a-f86e-11da-bd1a-00112444be1e | CUST1001  | "Email field exceeds max length (varchar 50)"  | 2025-10-02 11:20:15 |
| 2        | a8098c1a-f86e-11da-bd1a-00112444be1e | CUST1005  | "Invalid date format in processed_date column" | 2025-10-02 11:20:16 |
| 3        | a8098c1a-f86e-11da-bd1a-00112444be1e | CUST1022  | "Primary key violation on customer_id"         | 2025-10-02 11:20:18 |

In this example, all three errors are tied to the same batch run (`a8098c1a-f86e-11da-bd1a-00112444be1e`). The parent table would summarize this run with totals (e.g., 200 records processed, 197 successful, 3 failed), while the child table gives engineers the exact rows and error details for debugging.


