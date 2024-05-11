SELECT * FROM employee WHERE title LIKE 'Senior%';


SELECT TOP 1 billing_country, COUNT(*) AS TotalInvoices
FROM invoice
GROUP BY billing_country
ORDER BY TotalInvoices DESC;


SELECT TOP 3 billing_country, COUNT(*) AS MaxInvoices
FROM invoice
GROUP BY billing_country
ORDER BY MaxInvoices DESC;


ALTER TABLE invoice
ALTER COLUMN total FLOAT;


SELECT TOP 1 billing_city, SUM(total) AS MaxMoneyEarned from invoice
GROUP BY billing_city
ORDER BY MaxMoneyEarned DESC;


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


SELECT name, milliseconds FROM track
 WHERE LEN(name) > (SELECT AVG(LEN(name)) FROM track)
 Order by len(name) DESC;


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
