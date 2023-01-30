--Marketing team wants to create a rewards program for loyal customers, and wants to proactively reach out to the top 5 highest-spending customers. They also want to know the cities and countries where these customers reside in order to tailor their outreach.
--THere was also a marketing campaign held from Jan 2011-June 2011, and they want to determine the impact of this campaign on total sales.
--Determine: 1. Total number of customers, 2. The Top 5 highest spending customers, how much they spent and how many orders they made, 3. The top 5 cities that have the most customers

--Total number of customers
select distinct count(CustomerId)
from Customer
order by CustomerId 

--List of top 5 high-spend customers, Purchase Totals, and number of purcahses
SELECT Customer.LastName, Customer.FirstName, Customer.City, customer.Country, sum(Invoice.Total) as 'Purchase Total', count(Invoice.Total) as 'Number of Purchases'
FROM Customer 
LEFT JOIN Invoice
ON Customer.CustomerId  = Invoice.CustomerId
Group by Customer.CustomerId 
ORDER BY sum(Invoice.Total) DESC
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
SELECT Invoice.InvoiceDate, sum(Invoice.Total) as 'Purchase Total'
FROM Customer 
LEFT JOIN Invoice
ON Customer.CustomerId  = Invoice.CustomerId
Group by Invoice.InvoiceDate
ORDER BY sum(Invoice.Total) desc;

--List of customers aggregated by city
SELECT Customer.City, Invoice.BillingCountry, count(customer.CustomerId) as 'Total number of customers'
FROM Customer 
LEFT JOIN Invoice
ON Customer.CustomerId  = Invoice.CustomerId
group by customer.city
order by count (customer.CustomerId) desc

--List of customers aggregated by country
SELECT Invoice.BillingCountry, count(customer.CustomerId) as 'Total number of customers'
FROM Customer 
LEFT JOIN Invoice
ON Customer.CustomerId  = Invoice.CustomerId
group by Invoice.BillingCountry
order by count (customer.CustomerId) desc

--List of total sales aggregated by city
SELECT Customer.City, Invoice.BillingCountry, sum(Invoice.Total) as 'Invoice Total'
FROM Customer 
LEFT JOIN Invoice
ON Customer.CustomerId  = Invoice.CustomerId
group by customer.city
order by sum(Invoice.Total) desc

---List of total sales aggregated by country
SELECT BillingCountry, sum(Total) as 'Invoice Total'
FROM Invoice
group by BillingCountry
order by sum(Invoice.Total) desc



select b.CustomerId, a.LastName, a.FirstName, b.InvoiceId, b.Total
from Invoice AS b
LEFT JOIN Customer AS a
ON a.CustomerId  = b.CustomerId
group by b.Total
ORDER BY b.Total DESC;


select d.TrackId, d.Name as 'Song Name', c.AlbumId, c.Title as 'Album Title', c.Name as 'Artist Name' 
from (select a.Title, b.Name, a.AlbumId
from Album AS a
INNER JOIN Artist AS b
ON a.ArtistId  = b.ArtistId) as c
INNER JOIN Track as d
on c.AlbumId = d.AlbumId 


