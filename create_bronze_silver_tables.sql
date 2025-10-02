create schema bronze
create table bronze.raw_data (
	customer_id varchar(255),
	firstname varchar(255),
	lastname varchar(255),
	email varchar(255),
	phone varchar(255),
	postcode varchar(255),
	region varchar(255),
	country varchar(255),
	district varchar(255),
	longitude varchar(255),
	latitude varchar(255),
	geo_enriched varchar(255),
	company varchar(255),
	companysize varchar(255),
	industry varchar(255),
	annual_revenue varchar(255),
	is_business varchar(255),
	calculated_risk varchar(255),
	risk_score_numeric varchar(255),
	risk_factors varchar(255),
	status varchar(255),
	ingestion_datetime datetime2(3)
	)

create schema silver 
create table silver.raw_data (
	customer_id int,
	firstname varchar(255),
	lastname varchar(255),
	email varchar(255),
	phone varchar(50),
	postcode varchar(10),
	region varchar(255),
	country varchar(255),
	district varchar(255),
	latitude decimal(10,7),
	longitude decimal(10,7),
	geo_enriched bit,
	company varchar(255),
	companysize varchar(255),
	industry varchar(255),
	annual_revenue int,
	is_business bit,
	calculated_risk varchar(50),
	risk_score_numeric int,
	risk_factors varchar(255),
	status varchar(20),
	inserted_datetime datetime2(3),
	modified_datetime datetime2(3),
	revision_id int
	)

