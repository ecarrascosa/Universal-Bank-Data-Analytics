# Universal-Bank-Data-Analytics

## Project Background

### As part of customer acquisition efforts, Universal Bank wants to run a campaign to convince more of their current customers to accept personal loan offers. In order to improve targeting quality, they want to find customers that are most likely to accept the personal loan offer

## The Data

## The data is from a previous campaign on 5000 customers, 480 of them accepted

! [Data] (\Users\mtj5jyz\Documents\universalbank.png)



* id:	Customer ID
* age:	Customer's age in completed years
* experience:	# years of professional experience
* income:	Annual income of the customer ($000)
* zip:	Home Address ZIP code.
* family:	Family size of the customer
* credit_card_spend:	Avg. spending on credit cards per month ($000)
* education: 	Education Level. 1: Undergrad; 2: Graduate; 3: Advanced/Professional
* mortgage:	Value of house mortgage if any. ($000)
* personal_loan:	Did this customer accept the personal loan offered in the last campaign?
* securities_account:	Does the customer have a securities account with the bank?
*  cd_account:	Does the customer have a certificate of deposit (CD) account with the bank?
* online:	Does the customer use internet banking facilities?
* credit_card:	Does the customer use a credit card issued by UniversalBank?

## Formulation

-  Partition the data:
  - 50% training; 25% validation; 25% test

- Dependent variable:
  - personal_loan

- Method
  - kNN
