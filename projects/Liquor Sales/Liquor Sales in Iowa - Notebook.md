# Liquor Sales in Iowa

### Prompt
You’ve been hired as an analyst for a consulting company tasked with running a marketing campaign on liquor sales in Iowa. Various vendors want to increase their statewide marketing efforts, and your boss has asked you to analyze consumer purchasing data in order to make smarter decisions about upcoming campaigns. 

You’ll focus on how to allocate a marketing budget throughout the state. You could concentrate on specific types of liquor, counties in the state, or on a certain group of vendors. 

It will be up to you to decide if the marketing budget should be focused on growth opportunity in small or mid- sized liquor stores or on dealing with brands or types of liquor that already have large market shares in Iowa.


### Summary of Analysis

1. Reviewed revenue (total sales)
2. Found top liquor categories and brands, stores and counties by exploring the Sales table using aggregates and CASE statements
3. Found revenue and total bottles sold by month using date_part function
4. Explored possible data errors using date_part and aggregate functions
5. Excluded NULLS for my analysis using function in SQL
6. Used SQL functions learned in Unit 2 to clean, catalog, organize and export my data for further analysis in Excel
7. Used Excel to analyze and visualize my data

To review data, see this spreadsheet: https://docs.google.com/spreadsheets/d/10UyaPNjSQ5P8mbF65DzHEpd5mrrnMyNY/edit?usp=sharing&ouid=109339496547627177726&rtpof=true&sd=true

### Analysis

##### 1. Determine the types of Products Sold and Average Cost per Case .

```sql

--Type of Product Sold and Average Cost per Case    

SELECT DISTINCT category_name AS "Type of Product Sold", round((AVG(case_cost)), 2) AS "Average Cost per Case"
FROM products
WHERE category_name IS NOT NULL 
GROUP BY category_name
ORDER BY "Average Cost per Case" DESC;

--For output, see sheet 3.

```

[add screenshot of data]

![alt text](https://github.com/donsmithsf/sql/blob/main/projects/Liquor%20Sales/images/Capture.JPG?raw=true "Title")

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

--For output, see sheet 4.

```

```sql

--Summarize the products represented by different types of stores in counties throughout the state. How many total products are in the product table? How about products by vendor or category?

SELECT DISTINCT category_name, COUNT(category_name)
FROM sales
WHERE category_name IS NOT NULL
GROUP BY category_name; 


SELECT DISTINCT vendor, category_name, COUNT(category_name) AS "Number of item"
FROM sales
WHERE category_name IS NOT NULL and vendor IS NOT NULL
GROUP BY category_name, vendor
ORDER BY vendor;

--There are 68 unique products. 
--For output, see sheet 5.

```

```sql

--Review the Sales table. Which products sell the best? Make sure to decide how “best” will be defined (i.e., total sales, total units sold, market share, etc.).   

SELECT "Type of Product Sold", SUM(total) as "Total Sales"
FROM (SELECT category_name AS "Type of Product Sold", total
    FROM sales
    WHERE category_name IS NOT NULL) AS l
GROUP BY "Type of Product Sold"
ORDER BY "Total Sales" DESC; 


SELECT description, category_name, SUM(total) AS "Total Sales"
FROM (SELECT description, category_name, total
    FROM sales
    WHERE category_name IS NOT NULL) AS l
GROUP BY description, category_name
ORDER BY "Total Sales" DESC;    

---Top 10:

---CANADIAN WHISKIES: $48,053,061.91
---80 PROOF VODKA: $48,045,532.51
---SPICED RUM: $31,600,618.50
---IMPORTED VODKA: $23,879,524.63
---TEQUILA: $21,411,263.64
---STRAIGHT BOURBON WHISKIES: $20,924,480.19
---WHISKEY LIQUEUR: $19,339,201.42
---TENNESSEE WHISKIES: $17,647,970.35
---PUERTO RICO & VIRGIN ISLANDS RUM: $12,729,072.76
---BLENDED WHISKIES: $12,037,250.55


--For output, see sheet 6.

```

```sql

--Review the Counties table. What areas of the state sell more liquor than others?  

SELECT sales.county, counties.population, SUM(sales.total) as "Total Sales"
FROM sales
LEFT JOIN counties
ON sales.county = counties.county
GROUP BY sales.county, counties.population
ORDER BY "Total Sales" DESC;

---Top 10:

---Polk: $86,397,461.79
---Linn: $34,460,047.49
---Scott: $27,902,848.67
---Johnson: $24,200,402.25
---Black Hawk: $22,967,283.29
---Pottawattamie: $14,177,698.30
---Woodbury: $13,242,016.16
---Story: $12,267,027.18
---Dubuque: $11,879,190.38
---Cerro Gordo: $7,998,958.92

--For output, see sheet 7.

```

```sql

--Summarize your exploration of the sales in your presentation. Some sample questions you could answer include:         
---What are the top 10 categories of liquor sold based on the total amount of sales revenue?    

---Total Sales by Type of Product:

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

----Top 9 best selling categories of alcohol by sales:

----Whiskey/Bourbon: $135,418,097.97 
----Vodka: $92,993,705.16 
----Rum: $53,126,653.19 
----Brandy: $36,497,624.08 
----Gin and other Spirits: $26,264,734.54 
----Tequila: $21,411,263.64 
----Schnapps/Liqueur/Crème de Cacao/Anisette/Triple Sec: $16,110,241.30 
----Cocktails: $6,314,010.87 
----Beer/Ale: $272,284.44

```

```sql

--Which rum products have sales greater than $10,000? How about whiskey or vodka products?  

---Rum:

SELECT "Type of Rum Products Sold"
FROM (SELECT category_name AS "Type of Rum Products Sold", total
    FROM sales
    WHERE category_name IS NOT NULL AND category_name LIKE '%RUM%' AND total > 10000
    GROUP BY ""Type of Rum Products Sold"", total
    ORDER BY total DESC) AS l
GROUP BY "Type of Rum Products Sold";


---Whiskey:

SELECT "Type of Whiskey Products Sold"
FROM (SELECT category_name AS "Type of Whiskey Products Sold", total
    FROM sales
    WHERE category_name IS NOT NULL AND category_name LIKE '%WHISK%'AND category_name LIKE '%BOURBON%' AND total > 10000
    GROUP BY "Type of Whiskey Products Sold", total
    ORDER BY total DESC) AS l
GROUP BY "Type of Whiskey Products Sold";


---Vodka: 

SELECT "Type of Vodka Products Sold"
FROM (SELECT category_name AS "Type of Vodka Products Sold", total
    FROM sales
    WHERE category_name IS NOT NULL AND category_name LIKE '%VODKA%' AND total > 10000
    GROUP BY "Type of Vodka Products Sold", total
    ORDER BY total DESC) AS l
GROUP BY "Type of Vodka Products Sold"; 

----Type of Rum Products Sold:
-----FLAVORED RUM
-----PUERTO RICO & VIRGIN ISLANDS RUM
-----SPICED RUM

----Type of Whiskey Products Sold:
-----SINGLE BARREL BOURBON WHISKIES
-----STRAIGHT BOURBON WHISKIES

----Type of Vodka Products Sold:
-----80 PROOF VODKA
-----IMPORTED VODKA
-----IMPORTED VODKA 
-----MISC


```

```sql

--Which county sold the most amount of vodka during February 2014? Is this among the counties that sold the most vodka in other months of 2014 as well? (Hint: You can use the date_part function to extract the month and year from the date.) 

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

---Top 10 counties with the highest vodka sales 2/2014

---Polk: 699113.42
---Linn: 271014.73
---Scott: 243703.73
---Johnson: 221415
---Black Hawk: 208446.96
---Pottawattamie: 118724.34
---Dubuque: 99071.28
---Story: 96807.7
---Woodbury: 93486.75
---Dallas: 64481.86

--The top 5 counties listed above are exactly the same for each month of 2014, while the others change their relative positions from month to month.

--For output, see sheet 11.

```

```sql

--What is the trend of sales by month? Break up variables such as bottle_price or liter_size into categories (for example: cheap, medium, or expensive). Extract the data and graph out sales over time in Excel. 

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


---Total sales per month:

SELECT CONCAT(
    date_part('month', date), '/', date_part ('year', date)) AS month_and_date, SUM(total) AS total_sales_per_month
FROM sales
GROUP BY month_and_date
ORDER BY month_and_date ASC;


---Total bottles sold per month:

SELECT CONCAT(
    date_part('month', date), '/', date_part ('year', date)) AS month_and_date, SUM(bottle_qty) AS total_bottles_sold_per_month
FROM sales
GROUP BY month_and_date
ORDER BY month_and_date ASC;


--For output, see sheet 12.

```

```sql

--Summarize your exploration of stores in your presentation. Some sample questions you could answer include:    

--Which stores sell one of the top five most expensive bottles of alcohol?  


---List of products by bottle price:

SELECT DISTINCT category_name, btl_price
FROM sales
ORDER BY btl_price DESC;

---Stores that sell bottles of alcohol priced at over $2000:

SELECT category_name, store, btl_price
FROM sales
WHERE cast(btl_price AS numeric) > 2000
ORDER BY btl_price DESC;

----Top 5 most expensive bottles of alcohol:

----SINGLE BARREL BOURBON WHISKIES: $8,700.00 
----DECANTERS & SPECIALTY PACKAGES: $2,398.80 
----IMPORTED GRAPE BRANDIES: $2,098.94 
----SINGLE MALT SCOTCH: $845.10 
----SCOTCH WHISKIES: $747.96 

--The most expensive is SINGLE BARREL BOURBON WHISKIES at $8,700.00 per bottle. Will search for which stores sell this bottle.

--From the output in sheet 14, we can see that stores 2588 and 2590 sell SINGLE BARREL BOURBON WHISKIES.

```

```sql

--How many stores have more than $2,000,000 in total sales?     

SELECT COUNT(*) AS "Number of stores with more than 2,000,000 in sales"
FROM (SELECT store, SUM(total) AS total_sales
    FROM sales
    GROUP BY store
    ORDER BY total_sales DESC) AS l
WHERE total_sales > 2000000

--Twenty-four stores have sales greater than two million.

-------------------------------------------------

--How many stores have an average bottle price greater than $20?    

SELECT COUNT(*) AS "Stores which have an average bottle price of more than $20"
FROM (SELECT store, AVG(cast(btl_price AS numeric)) AS average_bottle_price
    FROM sales
    GROUP BY store
    ORDER BY average_bottle_price DESC) AS l
WHERE average_bottle_price > 20

--Twenty-two stores have an average bottle price greater than $20.

```

```sql

--Where are these stores located throughout the state and what does that mean?  

SELECT *
FROM (SELECT store, county, round(AVG(cast(btl_price AS numeric)), 2) AS average_bottle_price
    FROM sales
    GROUP BY store, county
    ORDER BY average_bottle_price DESC) AS l
WHERE average_bottle_price > 20 and county IS NOT NULL

--For output, see sheet 17.

```

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

---Top 10 stores with the highest sales of items over 90 proof

---2633:    $689,442.44
---4829:    $564,993.84
---2512:    $361,513.53
---3814:    $334,316.94
---3385:    $285,790.98
---3420:    $264,973.86
---3952:    $209,604.39
---3354:    $195,723.16
---3773:    $173,803.96
---2599:    $170,751.64

--For output, see sheet 18.

```

```sql

--Liquor whose per bottle profit margin is greater than 50% 

SELECT DISTINCT category_name, description, vendor, btl_price, state_btl_cost, liter_size
FROM sales
WHERE (btl_price - state_btl_cost) >= (btl_price/2) AND category_name NOT LIKE 'DECANTERS & SPECIALTY PACKAGES'
ORDER BY btl_price DESC;

--For output, see sheet 19.

--Stores with the highest total sales   

SELECT concat(county, ': ', store) AS count_and_store_number, total_sales
FROM (SELECT DISTINCT store, county, SUM(total) AS total_sales
    FROM(SELECT store, county, total
        FROM sales) AS l
    GROUP BY store, county
    ORDER BY total_sales DESC) AS l;

--For output, see sheet 20.

```


### Conclusions

Generally, vendors should focus on building partnerships with the highest-earning stores in the most-populated counties. In order to convert them to long-term customers, you should aggressively negotiate a wholesale discount for their most popular whiskey, vodka and rum products. Specifically, you should:
1. Focus on supplying whiskey, vodka and rum, specifically canadian whisky, 80 proof vodka, and spiced rum as these are the products that are most in-demand.
2. Focus on the following brands: Black Velvet, Hawkeye Vodka and Captain Morgan from those respective categories
3. Focus on building partnerships with and supplying stores in the following three counties: Polk, Linn and Scott
4. Focus on getting your product in the following high-revenue stores within those respective counties: 
    -Polk: 2633, 4829, 3420
    -Linn: 3385, 3773
    -Scott: 3952, 3354, 2625
5. In order to convert each store to a long-term customer, negotiate with them a bulk discount, making sure whenever possible to undercut other vendors while still keeping a healthy bottomline

