# SAS Case Study: TSA Claims Data Analysis
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform - SAS 9.4](https://img.shields.io/badge/Platform-SAS_9.4-0766d1)](https://documentation.sas.com/doc/en/pgmsascdc/9.4_3.5/whatsnew/p07ec8vqwrr6i9n1ptnai8ui5ebo.htm)

<br>

In this case study, I performed the preparation and analysis of claims data provided by the Transportation Security Administration (TSA), a division of the US Department of Homeland Security tasked with ensuring the safety of travelers. These claims are filed by passengers who have experienced injuries, property loss, or damage during airport security screenings. The dataset spans the years 2002 to 2017. The primary goal of the analysis is to generate insights and reports that cover both nationwide trends and state-level breakdowns, where applicable.

The case study utilizes a CSV file titled TSAClaims2002_2017.csv. This dataset was compiled using publicly accessible information from the TSA and the Federal Aviation Administration (FAA). It includes TSA data on claims and FAA data on airport facilities across the US. The dataset was created by merging individual TSA airport claims files, cleaning unnecessary columns, and integrating the consolidated claims data with FAA airport facilities information.

The  **TSAClaims2002_2017.csv** file has 14 columns and over 220,000 rows. Below are columns it contains: 

- **Claim_Number:** Number for each claim. Some claims can have duplicate claim numbers, but different information for each claim. Those claims are considered valid for this case study.
- **Incident_Date**: Date when an incident occurred.
- **Date_Received**: Date when a claim was filed.
- **Claim_Type**: Type of a claim. There are 14 valid claim types.
- **Claim_Site**: The site where a claim occurred. There are 8 valid values for claims site.
- **Disposition**: Final settlement of a claim.
- **Close_Amount**: Dollar amount of the settlement.
- **Item_Category**: Type of items in a claim.
- **Airport_Code**: Code of airport where an incident occurred.
- **Airport_Name**: Name of airport where an incident occured.
- **County, City, State,** and **StateName**: Geographical information about the location of the airport. The **State** column has a two letter state code and **StateName** has the full state name.

The case study addresses the following data and report requirements.

<br>

## Data Requirements

- The raw data file [**TSAClaims2002_2017.csv**](https://drive.google.com/file/d/1MO6qu-XSiHWF1KA_sWMWfdLfIjRJ141d/view?usp=sharing) must be imported into SAS and stored in a file named **claims_cleaned** in the **tsa** library.
- Entirely duplicated records must be removed from the table.
- All missing and ‘-‘ values in the columns **Claim_Type**, **Claim_Site**, and **Disposition** must be changed to Unknown.
- If the claim is separated into two types by a slash, **Claim_Type** is the first type. Values in the column **Claim_Type** must be one of 14 valid values:
    - Bus Terminal
    - Complaint
    - Compliment
    - Employee Loss (MPCECA)
    - Missed Flight
    - Motor Vehicle
    - Not Provided
    - Passenger Property Loss
    - Passenger Theft
    - Personal Injury
    - Property Damage
    - Property Loss
    - Unknown
    - Wrongful Death
- Values in the column Claim_Site must be one of 8 valid values:
    - Bus Station
    - Checked Baggage
    - Checkpoint
    - Motor Vehicle
    - Not Provided
    - Other
    - Pre-Check
    - Unknown
- Values in the column Disposition must be one of 10 valid values:
    - *Insufficient
    - Approve in Full
    - Closed:Canceled
    - Closed:Contractor Claim
    - Deny
    - In Review
    - Pending Payment
    - Received
    - Settle
    - Unknown
- All **StateName** values should be in proper case.
- All **State** values should be in uppercase.
- The table must include a new column named **Date_Issues** with a value of Needs Review to indicate that a row has a date issue. Date issues consist of the following:
    - a missing value for **Incident_Date** or **Date_Received**
    - an **Incident_Date** or **Date_Received** value out of the predefined year range of 2002 through 2017
    - an **Incident_Date** value that occurs after the **Date_Received** value
- The **County** and **City** columns should not be included in the output table.
- Currency should be permanently formatted with a dollar sign and include two decimal points.
- All dates should be permanently formatted in the style 01JAN2000.
- Permanent labels should be assigned to columns by replacing any underscore with a space.
- Final data should be sorted in ascending order by **Incident_Date**.

<br>

## Report Requirements

The final single PDF report must answer the following questions:

1. How many date issues are in the overall data? 

    For the remaining analyses, **exclude all rows with date issues**. 

2. How many claims per year of **Incident_Date** are in the overall data? Be sure to include a plot.
3. Lastly, a user should be able to dynamically input a specific state value and answer the following: 
   3.1. What are the frequency values for **Claim_Type** for the selected state?
   3.2. What are the frequency values for **Claim_Site** for the selected state? 
   3.3 What are the frequency values for **Disposition** for the selected state? 
   3.4. What is the mean, minimum, maximum, and sum of **Close_Amount** for the selected state? The statistics should be rounded to the nearest integer.



<br>

## Prerequisites

To run the TSA Claims Data Analysis program, you need an active account for either [**SAS® OnDemand for Academics**](https://welcome.oda.sas.com/) or **[SAS® Viya](https://www.sas.com/en_au/software/viya.html)**. These platforms provide the necessary environment for executing SAS programs and analysing the data.

<br>


## **License**

This project is licensed under the **[MIT License](https://choosealicense.com/licenses/mit/)**.
