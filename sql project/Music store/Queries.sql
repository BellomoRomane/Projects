--1. Who is the senior most employee based on job title?
SELECT * FROM employee WHERE title LIKE 'Senior%';


--2. Which countries have the most Invoices?
SELECT TOP 1 billing_country, COUNT(*) AS TotalInvoices
FROM invoice
GROUP BY billing_country
ORDER BY TotalInvoices DESC;


--3. What are top 3 values of total invoice?
SELECT TOP 3 billing_country, COUNT(*) AS MaxInvoices
FROM invoice
GROUP BY billing_country
ORDER BY MaxInvoices DESC;

-- Modification of the type of a column for the following question
ALTER TABLE invoice
ALTER COLUMN total FLOAT;

--4. Which city has the best customers? Write a query that returns one city that has the highest 
--sum of invoice totals. Return both the city name & sum of all invoice totals
SELECT TOP 1 billing_city, SUM(total) AS MaxMoneyEarned from invoice
GROUP BY billing_city
ORDER BY MaxMoneyEarned DESC;

--5. Who is the best customer? The customer who has spent the most money will be declared the best customer.
SELECT TOP 1
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(i.total) AS MaxMoneySpent
FROM
    customer c
JOIN
    invoice i ON c.customer_id = i.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY
    MaxMoneySpent DESC;

--6. Write query to return the email, first name, last name, & Genre of all Rock Music
--listeners. Return your list ordered alphabetically by email starting with A
SELECT 
    c.email,
    c.first_name,
    c.last_name,
    g.name
FROM
    customer c
JOIN 
    invoice i ON c.customer_id = i.customer_id
JOIN 
    invoice_line l ON i.invoice_id = l.invoice_id
JOIN
    track t ON l.track_id = t.track_id
JOIN
    genre g ON t.genre_id = g.genre_id
WHERE 
    g.name LIKE '%Rock%'
GROUP BY
    c.email,
    c.first_name,
    c.last_name,
    g.name
ORDER BY 
    c.email ASC;

--7. Let's invite the artists who have written the most rock music in our dataset. Write a
--query that returns the Artist name and total track count of the top 10 rock bands
SELECT TOP 10
    a.name,
    COUNT(t.track_id) AS NumberOfWrittenRockMusic
FROM
    artist a
JOIN
    album al ON al.artist_id = a.artist_id 
JOIN
    track t ON t.album_id = al.album_id
JOIN 
    genre g ON g.genre_id = t.genre_id
WHERE
    g.name LIKE '%Rock%'
GROUP BY
    a.name
ORDER BY
    NumberOfWrittenRockMusic DESC;

--8. Return all the track names that have a song length longer than the average song length.
--Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first
SELECT name, milliseconds FROM track
 WHERE LEN(name) > (SELECT AVG(LEN(name)) FROM track)
 Order by len(name) DESC;

--9. Find how much amount spent by each customer on artists? Write a query to return
--customer name, artist name and total spent
SELECT
    c.first_name,
    c.last_name,
    a.name,
    SUM(i.total) AS TotalSpent
FROM
    customer c
JOIN
    invoice i ON c.customer_id = i.customer_id
JOIN
    invoice_line il ON i.invoice_id = il.invoice_id
JOIN
    track t ON il.track_id = t.track_id
JOIN
    album al ON t.album_id = al.album_id
JOIN
    artist a ON al.artist_id = a.artist_id
GROUP BY
    c.first_name,
    c.last_name,
    c.customer_id,
    a.name,
    a.artist_id
ORDER BY
    TotalSpent DESC;


--10. We want to find out the most popular music Genre for each country. Write a query that returns 
--each country along with the top Genre. For countries where the maximum number of purchases is shared return all Genres
WITH CountryGenrePurchases AS (
    SELECT
        c.country,
        g.name,
        COUNT(il.invoice_line_id) AS Purchases,
        RANK() OVER (PARTITION BY c.country ORDER BY COUNT(il.invoice_line_id) DESC) AS GenreRank
    FROM
        customer c
    JOIN
        invoice i ON c.customer_id = i.customer_id
    JOIN
        invoice_line il ON i.invoice_id = il.invoice_id
    JOIN
        track t ON il.track_id = t.track_id
    JOIN
        genre g ON t.genre_id = g.genre_id
    GROUP BY
        c.country,
        g.name,
        g.genre_id
)
SELECT
    country,
    name
FROM
    CountryGenrePurchases
WHERE
    GenreRank = 1;


--11. Write a query that determines the customer that has spent the most on music for each
--country. Write a query that returns the country along with the top customer and how
--much they spent. For countries where the top amount spent is shared, provide all
--customers who spent this amount
WITH CountryTopCustomers AS (
    SELECT
        c.country,
        c.first_name,
        c.last_name,
        SUM(i.total) AS TotalSpent,
        RANK() OVER (PARTITION BY c.country ORDER BY SUM(i.total) DESC) AS CustomerRank
    FROM
        customer c
    JOIN
        invoice i ON c.customer_id = i.customer_id
    GROUP BY
        c.country,
        c.first_name,
        c.last_name,
        c.customer_id
)
SELECT
    country,
    first_name,
    last_name,
    TotalSpent
FROM
    CountryTopCustomers
WHERE
    CustomerRank = 1;
