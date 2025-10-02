CREATE TABLE business (
    business_id INT PRIMARY KEY IDENTITY(1,1),
    company VARCHAR(100) NOT NULL,
    companysize VARCHAR(20),
    industry VARCHAR(50),
    annual_revenue BIGINT
);

CREATE TABLE location (
    postcode VARCHAR(10) PRIMARY KEY,
    region VARCHAR(50),
    country VARCHAR(50) NOT NULL,
    district VARCHAR(50),
    latitude DECIMAL(10, 7),
    longitude DECIMAL(10, 7)
);

CREATE TABLE customer (
    customer_id INT PRIMARY KEY IDENTITY(1,1),
    firstname VARCHAR(50) NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    postcode VARCHAR(10),
    business_id INT,
    FOREIGN KEY (business_id) REFERENCES business(business_id),
    FOREIGN KEY (postcode) REFERENCES location(postcode)
);

