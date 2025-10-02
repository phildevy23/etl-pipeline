# etl-pipeline

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
