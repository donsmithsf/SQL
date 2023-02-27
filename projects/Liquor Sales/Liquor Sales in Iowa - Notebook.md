# Liquor Sales in Iowa, USA

## Problem Statement
You’ve been hired as an analyst for a consulting company tasked with running a marketing campaign on liquor sales in Iowa, USA on behalf of a coalition of 10 liquor vendors who sell bottles of alcohol wholesales to stores around Iowa. These vendors want to increase their state-wide marketing efforts, and your boss has asked you to analyze consumer purchasing data in order to make smarter decisions about their upcoming marketing campaigns, to determine which stores to target and which products to market. The vendors are hyper-focused on increasing sales and getting an edge on their competitors, i.e., the other liquor venders in Iowa.

You’ll focus on how to allocate a marketing budget throughout the state. You could concentrate on specific types of liquor, counties in the state, or on a certain group of vendors–how you structure your analysis is up to you.

You will need to decide if the marketing budget should be focused on growth opportunities in small- or mid-sized liquor stores, or on dealing with brands or types of liquor that already have large market shares in Iowa.


## High-Level Summary of Analysis
1. Determined revenue for each store
2. Determined top liquor categories and brands, and highest earning stores and counties
3. Determined revenue and total bottles sold by month
4. Explored possible data errors and excluded NULLS from analysis
5. Used SQL to clean, catalog, organize and export data for further analysis
6. Used Excel to analyze and visualize data

To review raw data exports and graphs created using Excel, see this spreadsheet: [Liquor Sales in Iowa - Data and Analysis](https://docs.google.com/spreadsheets/d/10UyaPNjSQ5P8mbF65DzHEpd5mrrnMyNY/edit?usp=sharing&ouid=109339496547627177726&rtpof=true&sd=true)

## Analysis

### 01. What types of products are sold? What is the average cost per case?

```sql

--Type of Product Sold and Average Cost per Case    
SELECT DISTINCT category_name AS "Type of Product Sold", round((AVG(case_cost)), 2) AS "Average Cost per Case"
FROM products
WHERE category_name IS NOT NULL 
GROUP BY category_name
ORDER BY "Average Cost per Case" DESC;

```

![alt text](https://github.com/donsmithsf/sql/blob/main/projects/Liquor%20Sales/images/01.JPG "Title")

&rarr; For full data output, see [sheet 01](https://docs.google.com/spreadsheets/d/10UyaPNjSQ5P8mbF65DzHEpd5mrrnMyNY/edit#gid=14798079).


### 02. What are total sales aggregated by Store, Vendor and Type of Product?

```sql

--Total Sales by Store, Vendor and Type of Product  
SELECT stores.name AS "Store Name", products.vendor_name AS "Vendor Name", products.category_name AS "Type of Product", SUM(sales.total) AS "Total Sales"
FROM products

INNER JOIN sales
ON products.item_no = sales.item

INNER JOIN stores
ON stores.store = sales.store

GROUP BY products.vendor_name, products.category_name, sales.total, stores.store
ORDER BY "Total Sales" DESC
LIMIT 100;

```

![alt text](https://github.com/donsmithsf/sql/blob/main/projects/Liquor%20Sales/images/02.JPG "Title")

&rarr; For full data output, see [sheet 02](https://docs.google.com/spreadsheets/d/10UyaPNjSQ5P8mbF65DzHEpd5mrrnMyNY/edit#gid=654930356).


### 03. How many products, vendors and categories are in the product table?

```sql

--Total products in the product table
SELECT DISTINCT category_name, COUNT(category_name)
FROM sales
WHERE category_name IS NOT NULL
GROUP BY category_name; 

```

![alt text](https://github.com/donsmithsf/sql/blob/main/projects/Liquor%20Sales/images/03-2.JPG "Title")

There are **68 unique products**.

&rarr; For full data output, see [sheet 03](https://docs.google.com/spreadsheets/d/10UyaPNjSQ5P8mbF65DzHEpd5mrrnMyNY/edit#gid=1449464661).

```sql

--Products agregatted by vendor and category
SELECT DISTINCT vendor, category_name, COUNT(category_name) AS "Number of item"
FROM sales
WHERE category_name IS NOT NULL and vendor IS NOT NULL
GROUP BY category_name, vendor
ORDER BY vendor;

```

![alt text](https://github.com/donsmithsf/sql/blob/main/projects/Liquor%20Sales/images/03-1.JPG "Title")


&rarr; For full data output, see [sheet 03](https://docs.google.com/spreadsheets/d/10UyaPNjSQ5P8mbF65DzHEpd5mrrnMyNY/edit#gid=1449464661).


### 04. Which products sell the best? Which types of alcohol are the most popular?

```sql

--Reviewing the Sales table: Which products sell the best?   
SELECT "Type of Product Sold", SUM(total) as "Total Sales"
FROM (SELECT category_name AS "Type of Product Sold", total
    FROM sales
    WHERE category_name IS NOT NULL) AS l
GROUP BY "Type of Product Sold"
ORDER BY "Total Sales" DESC; 

```

![alt text](https://github.com/donsmithsf/sql/blob/main/projects/Liquor%20Sales/images/04-1.JPG "Title")
![alt text](https://github.com/donsmithsf/sql/blob/main/projects/Liquor%20Sales/images/04-1-graph.JPG "Title")


&rarr; For full data output, see [sheet 04](https://docs.google.com/spreadsheets/d/10UyaPNjSQ5P8mbF65DzHEpd5mrrnMyNY/edit#gid=1499019211).


```sql

--Most popular types of alcohol
SELECT description, category_name, SUM(total) AS "Total Sales"
FROM (SELECT description, category_name, total
    FROM sales
    WHERE category_name IS NOT NULL) AS l
GROUP BY description, category_name
ORDER BY "Total Sales" DESC;    

```

![alt text](https://github.com/donsmithsf/sql/blob/main/projects/Liquor%20Sales/images/04-2.JPG "Title")
![alt text](https://github.com/donsmithsf/sql/blob/main/projects/Liquor%20Sales/images/04-2-graph.JPG "Title")

**CANADIAN WHISKIES** have the highest sales, totaling **$48,053,061.91**. Whiskies are also the most popular type of alcohol, occupying 7 of the 20 most popular categories.

&rarr; For full data output, see [sheet 04](https://docs.google.com/spreadsheets/d/10UyaPNjSQ5P8mbF65DzHEpd5mrrnMyNY/edit#gid=1499019211).


### 05. What areas of the state sell more liquor than others? 

```sql

--Which counties ell more liquor than others?  
SELECT sales.county, counties.population, SUM(sales.total) as "Total Sales"
FROM sales
LEFT JOIN counties
ON sales.county = counties.county
GROUP BY sales.county, counties.population
ORDER BY "Total Sales" DESC;

```

![alt text](https://github.com/donsmithsf/sql/blob/main/projects/Liquor%20Sales/images/05-1.JPG "Title")
![alt text](https://github.com/donsmithsf/sql/blob/main/projects/Liquor%20Sales/images/05-1-graph-1.JPG "Title")
![alt text](https://github.com/donsmithsf/sql/blob/main/projects/Liquor%20Sales/images/05-1-graph-2.JPG "Title")

The top 5 counties are **Polk**, **Linn**, **Scott**, **Johnson** and **Black Hawk**. This strongly correlates with the population size of each county.

&rarr; For full data output, see [sheet 05](https://docs.google.com/spreadsheets/d/10UyaPNjSQ5P8mbF65DzHEpd5mrrnMyNY/edit#gid=1688657117).



### 06. What are the top 10 categories of liquor sold based on the total amount of sales revenue? 	

```sql
---Total Sales by Type of Product

SELECT "Type of Product Sold", SUM(total) AS "Total Sales"
FROM (SELECT category_name AS "Type of Product Sold", total
FROM sales
WHERE category_name IS NOT NULL) AS l
GROUP BY "Type of Product Sold"
ORDER BY "Total Sales" DESC;


---Whiskey/Bourbon:

SELECT SUM("Total Sales") AS "Total Whiskey Sales"
FROM (SELECT category_name AS "Type of Product Sold", SUM(total) AS "Total Sales"
    FROM sales
    WHERE category_name IS NOT NULL AND (category_name LIKE '%WHISK%' OR category_name LIKE '%BOURBON%')
    GROUP BY category_name, total
    ORDER BY "Total Sales" DESC) AS l;


---Vodka:

SELECT SUM("Total Sales") AS "Total Vodka Sales"
FROM (SELECT category_name AS "Type of Product Sold", SUM(total) AS "Total Sales"
    FROM sales
    WHERE category_name IS NOT NULL AND category_name LIKE '%VODKA%'
    GROUP BY category_name, total
    ORDER BY "Total Sales" DESC) AS l;


---Rum:

SELECT SUM("Total Sales") AS "Total Rum Sales"
FROM (SELECT category_name AS "Type of Product Sold", SUM(total) AS "Total Sales"
    FROM sales
    WHERE category_name IS NOT NULL AND category_name LIKE '%RUM%'
    GROUP BY category_name, total
    ORDER BY "Total Sales" DESC) AS l;


---Schnapps/Liqueur/Crème de Cacao/Anisette/Triple Sec:

SELECT SUM("Total Sales") AS "Total Schnapps/Liqueur/Crème de Cacao/Anisette/Triple Sec Sales"
FROM (SELECT category_name AS "Type of Product Sold", SUM(total) AS "Total Sales"
    FROM sales
    WHERE category_name IN NOT NULL AND 
      (category_name LIKE '%SCHNAPPS%' 
      OR category_name LIKE '%CREME DE%'
      OR category_name LIKE '%ANISETTE%'
      OR category_name LIKE '%TRIPLE SEC%')
    GROUP BY category_name, total
    ORDER BY "Total Sales" DESC) AS l;


---Gin and other Spirits:

SELECT SUM("Total Sales") AS "Total Gin and other Spirits Sales"
FROM (SELECT category_name AS "Type of Product Sold", SUM(total) AS "Total Sales"
    FROM sales
    WHERE category_name IS NOT NULL AND 
      (category_name LIKE '%GIN%' 
      OR category_name LIKE '%SPIRIT%')
GROUP BY category_name, total
ORDER BY "Total Sales" DESC) AS l;


---Brandy:

SELECT SUM("Total Sales") AS "Total Brandy Sales"
FROM (SELECT category_name AS "Type of Product Sold", SUM(total) AS "Total Sales"
    FROM sales
    WHERE category_name IS NOT NULL AND (category_name LIKE '%BRAND%' OR category_name LIKE '%BOURBON%')
    GROUP BY category_name, total
    ORDER BY "Total Sales" DESC) AS l;


---Beer/Ale:

SELECT SUM("Total Sales") AS "Total Beer/Ale Sales"
FROM (SELECT category_name AS "Type of Product Sold", SUM(total) AS "Total Sales"
    FROM sales
    WHERE category_name IS NOT NULL AND (category_name LIKE '%BEER%' or category_name LIKE '%ALE%')
    GROUP BY category_name, total
    ORDER BY "Total Sales" DESC) AS l;


---Cocktail:

SELECT SUM("Total Sales") AS "Total Cocktail Sales"
FROM (SELECT category_name AS "Type of Product Sold", SUM(total) AS "Total Sales"
    FROM sales
    WHERE category_name IS NOT NULL AND (category_name LIKE '%COCKTAIL%')
    GROUP BY category_name, total
    ORDER BY "Total Sales" DESC) AS l;


---Tequila:

SELECT SUM("Total Sales") AS "Total Tequila Sales"
FROM (SELECT category_name AS "Type of Product Sold", SUM(total) AS "Total Sales"
    FROM sales
    WHERE category_name IS NOT NULL AND (category_name LIKE '%TEQUILA%')
    GROUP BY category_name, total
    ORDER BY "Total Sales" DESC) AS l;  


```

![alt text](https://github.com/donsmithsf/sql/blob/main/projects/Liquor%20Sales/images/06-1.JPG "Title")

![alt text](https://github.com/donsmithsf/sql/blob/main/projects/Liquor%20Sales/images/06-1-graph-1.JPG "Title")

![alt text](https://github.com/donsmithsf/sql/blob/main/projects/Liquor%20Sales/images/06-1-graph-2.JPG "Title")

&rarr; For full data output, see [sheet 06](https://docs.google.com/spreadsheets/d/10UyaPNjSQ5P8mbF65DzHEpd5mrrnMyNY/edit#gid=300400124).


### 07. Which rum, whiskey and vodka products have sales greater than $10,000?

```sql

---Rum:

SELECT "Type of Rum Products Sold"
FROM (SELECT category_name AS "Type of Rum Products Sold", total
    FROM sales
    WHERE category_name IS NOT NULL AND category_name LIKE '%RUM%' AND total > 10000
    GROUP BY ""Type of Rum Products Sold"", total
    ORDER BY total DESC) AS l
GROUP BY "Type of Rum Products Sold";

```

![alt text](https://github.com/donsmithsf/sql/blob/main/projects/Liquor%20Sales/images/07-1.JPG "Title")

&rarr; For full data output, see [sheet 07](https://docs.google.com/spreadsheets/d/10UyaPNjSQ5P8mbF65DzHEpd5mrrnMyNY/edit#gid=970534761).

```sql

---Whiskey:

SELECT "Type of Whiskey Products Sold"
FROM (SELECT category_name AS "Type of Whiskey Products Sold", total
    FROM sales
    WHERE category_name IS NOT NULL AND category_name LIKE '%WHISK%'AND category_name LIKE '%BOURBON%' AND total > 10000
    GROUP BY "Type of Whiskey Products Sold", total
    ORDER BY total DESC) AS l
GROUP BY "Type of Whiskey Products Sold";

```

![alt text](https://github.com/donsmithsf/sql/blob/main/projects/Liquor%20Sales/images/07-2.JPG "Title")

&rarr; For full data output, see [sheet 07](https://docs.google.com/spreadsheets/d/10UyaPNjSQ5P8mbF65DzHEpd5mrrnMyNY/edit#gid=970534761).


```sql

---Vodka: 

SELECT "Type of Vodka Products Sold"
FROM (SELECT category_name AS "Type of Vodka Products Sold", total
    FROM sales
    WHERE category_name IS NOT NULL AND category_name LIKE '%VODKA%' AND total > 10000
    GROUP BY "Type of Vodka Products Sold", total
    ORDER BY total DESC) AS l
GROUP BY "Type of Vodka Products Sold"; 

```

![alt text](https://github.com/donsmithsf/sql/blob/main/projects/Liquor%20Sales/images/07-3.JPG "Title")

&rarr; For full data output, see [sheet 07](https://docs.google.com/spreadsheets/d/10UyaPNjSQ5P8mbF65DzHEpd5mrrnMyNY/edit#gid=970534761).



### 08. Which county sold the most amount of vodka during February 2014? Is this among the counties that sold the most vodka in other months of 2014 as well?

```sql

--Which county sold the most amount of vodka during February 2014? 

SELECT county, SUM(total) AS "Vodka Sales in February 2014"
FROM (
    SELECT county, category_name, total, 
date_part('month', date) AS month_date, 
date_part('year', date) AS year_date
    FROM sales
    WHERE category_name IS NOT NULL
    AND category_name like '%VODKA%'
    GROUP BY category_name, county, total, date
    ORDER BY month_date, year_date) AS l
WHERE month_date = 2 AND year_date = 2014
GROUP BY county
ORDER BY "Vodka Sales in February 2014" DESC

```

![alt text](https://github.com/donsmithsf/sql/blob/main/projects/Liquor%20Sales/images/08-1.JPG "Title")

![alt text](https://github.com/donsmithsf/sql/blob/main/projects/Liquor%20Sales/images/08-1-graph.JPG "Title")

**Polk** by far sold the largest amount of vodka.

_Note: The top 5 counties listed above are exactly the same for each month of 2014, while the others change their relative positions from month to month._

&rarr; For full data output, see [sheet 08](https://docs.google.com/spreadsheets/d/10UyaPNjSQ5P8mbF65DzHEpd5mrrnMyNY/edit#gid=354736027).


### 09. What is the trend of sales by month? What are the total sales per month? What are the total number of bottles sold per month?

```sql

---Sales per item categorized by expensive, medium and cheap:

SELECT category_name, btl_price, bottle_cost, concat(month_date, '/', year_date) AS month_and_year

FROM (
    SELECT category_name, btl_price, date_part('month', date) AS month_date, 
date_part('year', date) AS year_date,

    CASE
        WHEN btl_price >= 200 THEN 'expensive'
        WHEN btl_price >= 50 THEN 'medium'
        ELSE 'cheap'
        END AS bottle_cost
    
    FROM (
        SELECT category_name, cast(btl_price AS numeric), date FROM sales) AS l
    ) AS temp

WHERE category_name IS NOT NULL
GROUP BY category_name, btl_price, bottle_cost, month_date, year_date
ORDER BY btl_price DESC;

```

First, I categorized all bottles by price, sorting them into **Expensive**, **Medium**, and **Cheap** buckets. 

![alt text](https://github.com/donsmithsf/sql/blob/main/projects/Liquor%20Sales/images/09-1.JPG "Title")


Next, I graphed the **Total Liquor Sales by Month** and the **Total Bottles Sold by Month**.

```sql

---Total sales per month:

SELECT CONCAT(
    date_part('month', date), '/', date_part ('year', date)) AS month_and_date, SUM(total) AS total_sales_per_month
FROM sales
GROUP BY month_and_date
ORDER BY month_and_date ASC;

```

![alt text](https://github.com/donsmithsf/sql/blob/main/projects/Liquor%20Sales/images/09-2.JPG "Title")
![alt text](https://github.com/donsmithsf/sql/blob/main/projects/Liquor%20Sales/images/09-2-graph.JPG "Title")


```sql

---Total bottles sold per month:

SELECT CONCAT(
    date_part('month', date), '/', date_part ('year', date)) AS month_and_date, SUM(bottle_qty) AS total_bottles_sold_per_month
FROM sales
GROUP BY month_and_date
ORDER BY month_and_date ASC;

```

![alt text](https://github.com/donsmithsf/sql/blob/main/projects/Liquor%20Sales/images/09-3.JPG "Title")
![alt text](https://github.com/donsmithsf/sql/blob/main/projects/Liquor%20Sales/images/09-3-graph.JPG "Title")

As we can see, both graphs are almost identical, and tell the same story: sales are at their highest in the beginning of the year, peak in April, and were on a downward trend into the next year.


&rarr; For full data output, see [sheet 09](https://docs.google.com/spreadsheets/d/10UyaPNjSQ5P8mbF65DzHEpd5mrrnMyNY/edit#gid=467741207).


### 10. What are the most expensive bottles? Which stores sell bottles priced over $2000?

```sql

---List of products by bottle price:

SELECT DISTINCT category_name, btl_price
FROM sales
ORDER BY btl_price DESC;

```

![alt text](https://github.com/donsmithsf/sql/blob/main/projects/Liquor%20Sales/images/10-1.JPG "Title")


The most expensive category is **SINGLE BARREL BOURBON WHISKIES**, which has a bottle price of **$8,700.00**.

```sql

---Stores that sell bottles of alcohol priced at over $2000:

SELECT category_name, store, btl_price
FROM sales
WHERE cast(btl_price AS numeric) > 2000
ORDER BY btl_price DESC;

```

![alt text](https://github.com/donsmithsf/sql/blob/main/projects/Liquor%20Sales/images/10-2.JPG "Title")


&rarr; For full data output, see [sheet 10](https://docs.google.com/spreadsheets/d/10UyaPNjSQ5P8mbF65DzHEpd5mrrnMyNY/edit#gid=1409709480).


### 11. How many stores have more than $2,000,000 in total sales? How many stores have an average bottle price greater than $20?  

```sql

--How many stores have more than $2,000,000 in total sales?     

SELECT COUNT(*) AS "Number of stores with more than 2,000,000 in sales"
FROM (SELECT store, SUM(total) AS total_sales
    FROM sales
    GROUP BY store
    ORDER BY total_sales DESC) AS l
WHERE total_sales > 2000000

```

![alt text](https://github.com/donsmithsf/sql/blob/main/projects/Liquor%20Sales/images/11-1.JPG "Title")

**Twenty-four stores** have sales greater than **$2,000,000**.

&rarr; For full data output, see [sheet 14](https://docs.google.com/spreadsheets/d/10UyaPNjSQ5P8mbF65DzHEpd5mrrnMyNY/edit#gid=771702106).

```sql


--How many stores have an average bottle price greater than $20?    

SELECT COUNT(*) AS "Stores which have an average bottle price of more than $20"
FROM (SELECT store, AVG(cast(btl_price AS numeric)) AS average_bottle_price
    FROM sales
    GROUP BY store
    ORDER BY average_bottle_price DESC) AS l
WHERE average_bottle_price > 20

```

```sql

--Where are these stores located throughout the state and what does that mean?  

SELECT *
FROM (SELECT store, county, round(AVG(cast(btl_price AS numeric)), 2) AS average_bottle_price
    FROM sales
    GROUP BY store, county
    ORDER BY average_bottle_price DESC) AS l
WHERE average_bottle_price > 20 and county IS NOT NULL

```

![alt text](https://github.com/donsmithsf/sql/blob/main/projects/Liquor%20Sales/images/11-2.JPG "Title")

**Twenty-two stores** have an average bottle price greater than **$20**.

&rarr; For full data output, see [sheet 11](https://docs.google.com/spreadsheets/d/10UyaPNjSQ5P8mbF65DzHEpd5mrrnMyNY/edit#gid=1363682823).


### 12. Which stores have the highest sales of items over 90 proof?  

```sql

--Which stores have the highest sales of items over 90 proof?   

SELECT DISTINCT store, SUM(total) AS "Sales of items over 90 proof"
FROM (SELECT *
    FROM (SELECT sales.store, products.category_name, CAST(products.proof AS numeric), sales.total
        FROM products
        INNER JOIN sales
        ON products.item_no = sales.item
        ORDER BY proof DESC, total DESC) AS l
    WHERE proof > 90) AS u
GROUP BY store
ORDER BY "Sales of items over 90 proof" DESC

```

![alt text](https://github.com/donsmithsf/sql/blob/main/projects/Liquor%20Sales/images/12-1.JPG "Title")

&rarr; For full data output, see [sheet 12](https://docs.google.com/spreadsheets/d/10UyaPNjSQ5P8mbF65DzHEpd5mrrnMyNY/edit#gid=2013826773).


### 13. Which liquor has a per bottle profit margin that is greater than 50%?

```sql

--Liquor whose per bottle profit margin is greater than 50% 

SELECT DISTINCT category_name, description, vendor, btl_price, state_btl_cost, liter_size
FROM sales
WHERE (btl_price - state_btl_cost) >= (btl_price/2) AND category_name NOT LIKE 'DECANTERS & SPECIALTY PACKAGES'
ORDER BY btl_price DESC;

```

![alt text](https://github.com/donsmithsf/sql/blob/main/projects/Liquor%20Sales/images/13-1.JPG "Title")
![alt text](https://github.com/donsmithsf/sql/blob/main/projects/Liquor%20Sales/images/13-1-graph.JPG "Title")

&rarr; For full data output, see [sheet 13](https://docs.google.com/spreadsheets/d/10UyaPNjSQ5P8mbF65DzHEpd5mrrnMyNY/edit#gid=402802774).


### 14. Which stores have the highest total sales? 

```sql

--Stores with the highest total sales   

SELECT concat(county, ': ', store) AS count_and_store_number, total_sales
FROM (SELECT DISTINCT store, county, SUM(total) AS total_sales
    FROM(SELECT store, county, total
        FROM sales) AS l
    GROUP BY store, county
    ORDER BY total_sales DESC) AS l;

```


![alt text](https://github.com/donsmithsf/sql/blob/main/projects/Liquor%20Sales/images/14-1.JPG "Title")
![alt text](https://github.com/donsmithsf/sql/blob/main/projects/Liquor%20Sales/images/14-1-graph.JPG "Title")

&rarr; For full data output, see [sheet 14](https://docs.google.com/spreadsheets/d/10UyaPNjSQ5P8mbF65DzHEpd5mrrnMyNY/edit#gid=771702106).


## Recommendations
1. Focus on supplying **whiskey**, **vodka** and **rum**, specifically **canadian whisky**, **80 proof vodka**, and **spiced rum** as these are the products that sold the best, with the largest market share that are most in-demand
2. Focus on the following brands: **Black Velvet**, **Hawkeye Vodka** and **Captain Morgan** from those respective categories
3. Of the top 6 high-margin bottles of alcohol, **BLENDED WHISKIES** occupy spots 5 and 6, **Country Gal** and **Prairie Fire** respectively. Since whiskies are the top selling category, vendors should attempt to heavily market these high margin products to improve the bottom line
4. Focus on building partnerships with and supplying stores in the following three counties: **Polk**, **Linn** and **Scott**
5. Focus on getting the product in the following high-revenue stores within those respective counties: 
    1. **Polk:** 2633, 4829, 3420
    2. **Linn:** 3385, 3773
    3. **Scott:** 3952, 3354, 2625
6. Focus on selling alcohol to these stores in the beginning of the year (**January-April**), when sales are at their highest, and therefore demand is at its highest
7. In order to convert each store to a long-term customer, negotiate with them a bulk discount, making sure whenever possible to undercut other vendors while still keeping a healthy bottomline



