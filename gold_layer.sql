-- =========================
-- GOLD LAYER STAR SCHEMA
-- =========================

-- Dimension: Business
CREATE TABLE gold.dim_business (
    business_sk INT PRIMARY KEY IDENTITY(1,1),
    business_id INT NOT NULL,
    company VARCHAR(100) NOT NULL,
    companysize VARCHAR(20),
    industry VARCHAR(50),
    annual_revenue DECIMAL(15,2),
    effective_from DATE DEFAULT GETDATE(),
    effective_to DATE
);

-- Dimension: Location
CREATE TABLE gold.dim_location (
    location_sk INT PRIMARY KEY IDENTITY(1,1),
    postcode VARCHAR(10) NOT NULL,
    region VARCHAR(50),
    country VARCHAR(50) NOT NULL,
    district VARCHAR(50),
    latitude DECIMAL(10,7),
    longitude DECIMAL(10,7)
);

-- Dimension: Customer
CREATE TABLE gold.dim_customer (
    customer_sk INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT NOT NULL,
    firstname VARCHAR(50) NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    postcode VARCHAR(10),
    business_id INT,
    effective_from DATE DEFAULT GETDATE(),
    effective_to DATE
);

-- Fact: Sales
CREATE TABLE gold.fact_sales (
    sales_id BIGINT PRIMARY KEY IDENTITY(1,1),
    customer_sk INT NOT NULL,
    business_sk INT NOT NULL,
    location_sk INT NOT NULL,
    sale_date DATE NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    quantity INT,
    FOREIGN KEY (customer_sk) REFERENCES gold.dim_customer(customer_sk),
    FOREIGN KEY (business_sk) REFERENCES gold.dim_business(business_sk),
    FOREIGN KEY (location_sk) REFERENCES gold.dim_location(location_sk)
);
