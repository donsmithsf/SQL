--Marketing team wants to create a rewards program for loyal customers, and wants to proactively reach out to the top 5 highest-spending customers. They also want to know the cities and countries where these customers reside in order to tailor their outreach.
--THere was also a marketing campaign held from Jan 2011-June 2011, and they want to determine the impact of this campaign on total sales.
--Determine: 1. Total number of customers, 2. The Top 5 highest spending customers, how much they spent and how many orders they made, 3. The top 5 cities that have the most customers

--Total number of customers
select distinct count(CustomerId)
from Customer
order by CustomerId 

--List of top 5 high-spend customers, Purchase Totals, and number of purcahses
SELECT a.CustomerId, a.LastName, a.FirstName, a.City, a.Country, sum(b.Total) as 'Purchase Total', count(b.Total) as 'Number of Purchases'
FROM Customer a
LEFT JOIN Invoice b
ON a.CustomerId  = b.CustomerId
Group by a.CustomerId 
ORDER BY sum(b.Total) DESC
LIMIT 5;

--Top 5 spenders'individual invoices
SELECT Customer.LastName, Customer.FirstName, Customer.City, Invoice.BillingCountry, Invoice.InvoiceDate, Invoice.Total as 'Purchase Total'
FROM Customer 
LEFT JOIN Invoice
ON Customer.CustomerId  = Invoice.CustomerId
where customer.lastname == 'Holý'
OR customer.lastname == 'Cunningham'
OR customer.lastname == 'Rojas'
OR customer.lastname == 'Kovács'
OR customer.lastname == "O'Reilly"
--Group by Customer.CustomerId 
ORDER BY customer.LastName ;

--Total purchases aggregated by date
SELECT (InvoiceDate), sum(Total) as 'Purchase Total'
FROM Invoice
Group by InvoiceDate
ORDER BY sum(Total) desc;

--Total purchases aggregated by year
SELECT strftime('%Y', invoicedate) AS "Year", sum(Total) as 'Purchase Total'
FROM Invoice
Group by "Year"
ORDER BY "Year" desc;


--List of customers aggregated by city
SELECT a.City, b.BillingCountry as 'Country', count(a.CustomerId) as 'Total number of customers'
FROM Customer a
LEFT JOIN Invoice b
ON a.CustomerId  = b.CustomerId
group by a.city
order by count (a.CustomerId) desc

--List of customers aggregated by country
SELECT b.BillingCountry, count(a.CustomerId) as 'Total number of customers'
FROM Customer a
LEFT JOIN Invoice b
ON a.CustomerId  = b.CustomerId
group by b.BillingCountry
order by count (a.CustomerId) desc

--List of total sales aggregated by city
SELECT a.City, b.BillingCountry, sum(b.Total) as 'Invoice Total'
FROM Customer a
LEFT JOIN Invoice b
ON a.CustomerId  = b.CustomerId
group by a.city
order by sum(b.Total) desc

---List of total sales aggregated by country
SELECT BillingCountry, sum(Total) as 'Invoice Total'
FROM Invoice
group by BillingCountry
order by sum(Invoice.Total) desc

--Number of purchases by day of the week
select
  case cast (strftime('%w', invoicedate) as integer)
  when 0 then 'Sunday'
  when 1 then 'Monday'
  when 2 then 'Tuesday'
  when 3 then 'Wednesday'
  when 4 then 'Thursday'
  when 5 then 'Friday'
  else 'Saturday' end as weekday, 
  sum(Total) as 'Purchase Total'
from invoice
group by "weekday"
order by "Purchase Total" desc

--Total purchases aggregated by month
SELECT 
	case cast (strftime('%m', invoicedate) as integer)
	when 1 then 'January'
	when 2 then 'February'
	when 3 then 'March'
	when 4 then 'April'
	when 5 then 'May'
	when 6 then 'June'
	when 7 then 'July'
	when 8 then 'August'
	when 9 then 'September'
	when 10 then 'October'
	when 11 then 'November'
	else 'December'end as "Month",
	sum(Total) as 'Purchase Total'
FROM Invoice
Group by "Month"
ORDER BY "Purchase Total" desc;


select distinct b.CustomerId, a.LastName, a.FirstName, sum(b.Total)
from Invoice b
LEFT JOIN Customer a
ON a.CustomerId  = b.CustomerId
group by b.CustomerId
ORDER BY b.CustomerId, sum(b.Total) DESC;


select d.TrackId, d.Name as 'Song Name', c.AlbumId, c.Title as 'Album Title', c.Name as 'Artist Name' 
from (select a.Title, b.Name, a.AlbumId
from Album AS a
INNER JOIN Artist AS b
ON a.ArtistId  = b.ArtistId) as c
INNER JOIN Track as d
on c.AlbumId = d.AlbumId 

select "Year", "Purchase Total"
From (SELECT 
    strftime('%Y', invoicedate) AS "Year",
    strftime('%m', invoicedate) AS "Month",
    strftime('%d', invoicedate) AS "Day",  
	sum(Total) as 'Purchase Total'
FROM Invoice
Group by "Year", "Month", "Day")
Group by "Year"
--ORDER BY "Year" desc;

