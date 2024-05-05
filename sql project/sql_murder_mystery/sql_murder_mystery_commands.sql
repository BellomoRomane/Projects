-- database: c:\Users\33666\Dropbox\Mon PC (LAPTOP-0IFVGQ66)\Downloads\sql-murder-mystery.db
--https://github.com/NUKnightLab/sql-mysteries/blob/master/sql-murder-mystery.db database
--exercice https://mystery.knightlab.com/
-- Use the ▷ button in the top right corner to run the entire file.

-- First, let's select the report of the crime we want to solve
SELECT * FROM crime_scene_report 
WHERE city = "SQL City" AND date = 20180115 AND type = "murder";

-- 2 witnesses : the first lives at the last house on "Northwestern Dr"
-- the second, Annabel, lives somewhere on "Franklin Ave"

-- Let's find the adresses and the personal informations of the two witnesses

-- First witness: id=14887, driver license=118009
Select id, name, license_id, MAX(address_number) as address_number, address_street_name FROM person
where (address_street_name = "Northwestern Dr")

--Union to get the two witnesses in one table
UNION 

--Second witness: id=16371, driver license=490173
Select id, name, license_id, address_number, address_street_name FROM person
where address_street_name = "Franklin Ave" AND name LIKE 'Annabel%';

--Driver licenses of the witnesses
SELECT * FROM drivers_license WHERE id = 118009 OR id = 490173;

--Interview of the witnesses
SELECT * FROM interview WHERE person_id = 14887 OR person_id = 16371;
--went to the gym on january the 9th
--"get fit now gym" bag, membership number started with "48Z", gold members
--plate of the car include "H42W"

--Query giving the murderer following what have said the witnesses
SELECT m.id, m.name, m.membership_status, c.check_in_date, d.plate_number 
FROM drivers_license AS d
JOIN person AS p ON d.id = p.license_id
JOIN get_fit_now_member AS m ON p.id = m.person_id
JOIN get_fit_now_check_in AS c ON m.id = c.membership_id
WHERE d.plate_number LIKE '%H42W%' 
AND m.membership_status = 'gold'
AND c.check_in_date = 20180109
AND m.id LIKE '48Z%';

--checking the solution
INSERT INTO solution VALUES (1, "Jeremy Bowers");

SELECT value FROM solution;

--printed message :
--Congrats, you found the murderer! But wait, there's more... 
--If you think you're up for a challenge, try querying the interview transcript 
--of the murderer to find the real villain behind this crime. 
--If you feel especially confident in your SQL skills, try to complete 
--this final step with no more than 2 queries. 
--Use this same INSERT statement with your new suspect to check your answer.

SELECT * FROM interview i
JOIN person p  ON i.person_id = p.id
JOIN drivers_license d ON p.license_id = d.id
WHERE name = "Jeremy Bowers";

-- Answer of the criminal :
--I was hired by a woman with a lot of money. 
--I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). 
--She has red hair and she drives a Tesla Model S. 
--I know that she attended the SQL Symphony Concert 3 times in December 2017.

SELECT p.license_id, p.name, d.height, d.gender, d.hair_color, d.car_make, d.car_model FROM drivers_license d
JOIN person p ON d.id = p.license_id
JOIN facebook_event_checkin f ON f.person_id=p.id
WHERE
height >= 65 AND height <=67 AND gender = "female" AND hair_color = "red"
AND car_make = "Tesla" AND car_model = "Model S"
AND f.event_name = 'SQL Symphony Concert' AND f.date >= 20171201 AND f.date < 20180101
GROUP BY p.name, p.address_street_name, d.plate_number
HAVING COUNT(f.event_name) = 3;


--checking the solution
INSERT INTO solution VALUES (1, "Miranda Priestly");

SELECT value FROM solution;