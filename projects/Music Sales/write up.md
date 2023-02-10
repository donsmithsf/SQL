# Background
The owner of a music business

  

# Problem statement: 

The owner wants to increase sales. He wants to incentivise customers to spend more, and also wants to reward customers who spend the most.

His ideas:

* Create a rewards program that specifically targets high-spending customers
* Create promotional deals/coupons to incentivize pre-existing by low spending customers to spend more

## Part 1

He asks you to do an exploratory analysis to determine:

* Total number of customers
* Total number of invoices per customer
* The Top 5 highest spending customers, how much they spent and how many orders they made
* The top 5 cities that have the most customers


Total number of customers:

```sql
--Total number of customers
select distinct count(CustomerId)
from Customer
order by CustomerId
```
[output]: 56

Total number of invoices per customer
The Top 5 highest spending customers, how much they spent and how many orders they made
The top 5 cities that have the most customers

## Part 2
  Now that we have categorized each customer by spending habits and know who the top spenders are, we can now determine what days customers buy the most and least. Once these days are determined, we can set the promotional deal on the days customers spend the least.
  

--Marketing team wants to create a rewards program for loyal customers, and wants to proactively reach out to the top 5 highest-spending customers. They also want to know the cities and countries where these customers reside in order to tailor their outreach.

--THere was also a marketing campaign held from Jan 2011-June 2011, and they want to determine the impact of this campaign on total sales.

--Determine: 1. Total number of customers, 2. The Top 5 highest spending customers, how much they spent and how many orders they made, 3. The top 5 cities that have the most customers

  
  
  
  
  

Project: marketing wants to target people who spend >=5 dollars in the last 3 months

  

Queries: Number of customers who spent >=5 dollars in last three months (aggregate by customerid, filter by month, sum invoice dollar amount)

  

Once the number of clients who spent above this amount have been determined, sort them into categories:

  

20>= - Mega spenders

15>= - Big spenders

10>= - Moderate spenders

5>= - Solid spenders

<5 = - Casual spenders

  

COnclusion: Loyalty program should target +10 and above. To get people >10 spending more, we should do sales and offer coupons

**