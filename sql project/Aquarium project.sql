------------ project ------------------
DROP TABLE IF EXISTS services;
DROP TABLE IF EXISTS aquarium;
DROP TABLE IF EXISTS poisson;
DROP TABLE IF EXISTS espece;
DROP TABLE IF EXISTS menu;
DROP TABLE IF EXISTS employe;
DROP TABLE IF EXISTS salle;


CREATE TABLE salle (
    sanum   INT             CONSTRAINT pk_salle PRIMARY KEY,
    salong  INT             CONSTRAINT nl_salle_salong NOT NULL,
    salarg  INT             CONSTRAINT nl_salle_salarg NOT NULL,
    sahaut  INT             CONSTRAINT nl_salle_sahaut NOT NULL,
    safct   VARCHAR(20)     CONSTRAINT nl_salle_safct NOT NULL,
    CONSTRAINT check_salle_safct CHECK (safct IN ('Reserve','Garde-Manger','Aquarium','Reception'))
);

CREATE TABLE aquarium (
    aqnum       INT             CONSTRAINT pk_aquarium PRIMARY KEY,
    aqtemp      INT             CONSTRAINT nl_aquarium_aqtemp NOT NULL,
    aqlarge     INT             CONSTRAINT nl_aquarium_aqlarge NOT NULL,
    aqlong      INT             CONSTRAINT nl_aquarium_aqlong NOT NULL,
    aqhaut      INT             CONSTRAINT nl_aquarium_aqhaut NOT NULL,
    aqph        INT             CONSTRAINT nl_aquarium_aqph NOT NULL,
    sa#         INT             CONSTRAINT nl_aquarium_sa# NOT NULL,
    CONSTRAINT fk_aquarium_sa# FOREIGN KEY (sa#) REFERENCES salle (sanum)
);

CREATE TABLE employe (
    empnum      INT             CONSTRAINT pk_employe PRIMARY KEY,
    empnom      VARCHAR(12)     CONSTRAINT nl_employe_empnom NOT NULL CONSTRAINT uk_employe_empnom UNIQUE,
    empnaiss    DATE            CONSTRAINT nl_employe_empnaiss NOT NULL,
    empsal      NUMERIC(7,2)    CONSTRAINT nl_employe_empsal NOT NULL,
    emptel      VARCHAR(12),
    empadr      VARCHAR(20)      CONSTRAINT nl_employe_empadr NOT NULL
);

CREATE TABLE menu (
    menuid     INT             CONSTRAINT pk_menu PRIMARY KEY,
    menunom    VARCHAR(30)     CONSTRAINT nl_menu_menunom NOT NULL,
    menustock  VARCHAR(12)     CONSTRAINT nl_menu_menustock NOT NULL,
    menuperim  VARCHAR(12)     CONSTRAINT nl_menu_menuperim NOT NULL,
    menunour   VARCHAR(20)     CONSTRAINT nl_menu_menunour NOT NULL,
    CONSTRAINT check_menu_menunom CHECK (menunom IN ('Carnivore','Omnivore')),
    CONSTRAINT check_menu_menunour CHECK (menunour IN ('Larves','Insectes','Crustaces','Poulpes','Legumes','Fruits','Herbes','Viandes'))
);

CREATE TABLE espece (
    esid   INT             CONSTRAINT pk_espece PRIMARY KEY,
    esnom  VARCHAR(20)     CONSTRAINT nl_espece_esnom NOT NULL,
    esor   VARCHAR(20)     CONSTRAINT nl_espece_esorigine NOT NULL,
    esph   INT             CONSTRAINT nl_espece_esph NOT NULL,
    estemp INT             CONSTRAINT nl_espece_estemp NOT NULL,
    esmenu# INT             CONSTRAINT nl_espece_esmenu# NOT NULL,
    CONSTRAINT fk_espece_esmenu# FOREIGN KEY (esmenu#) REFERENCES menu (menuid)
);

CREATE TABLE poisson (
    pid     INT             CONSTRAINT pk_poisson PRIMARY KEY,
    pcoul   VARCHAR(10)     CONSTRAINT nl_poisson_pcoul NOT NULL,
    ppoids  INT             CONSTRAINT nl_poisson_ppoids NOT NULL,
    plong   INT             CONSTRAINT nl_poisson_plong NOT NULL,
    pes     INT             CONSTRAINT nl_poisson_es1# NOT NULL,
    paq     INT             CONSTRAINT nl_poisson_aq2# NOT NULL,
    CONSTRAINT fk_poisson_pes FOREIGN KEY (pes) REFERENCES espece (esid),
    CONSTRAINT fk_poisson_paq FOREIGN KEY (paq) REFERENCES aquarium (aqnum)
);

CREATE TABLE services (
    serid       INT             CONSTRAINT pk_service PRIMARY KEY,
    seremp      INT             CONSTRAINT nl_service_emp# NOT NULL,
    seraq       INT             CONSTRAINT nl_service_aq# NOT NULL,
    serhd       INT             CONSTRAINT nl_service_hd NOT NULL,
    serhf       INT             CONSTRAINT nl_service_ha NOT NULL,
    serdat      DATE,
    serprest    VARCHAR(24)     CONSTRAINT nl_service_prestation NOT NULL,
    CONSTRAINT service_fk_employe FOREIGN KEY (seremp) REFERENCES employe (empnum) ON DELETE CASCADE,
    CONSTRAINT fk_service_seraq FOREIGN KEY (seraq) REFERENCES aquarium (aqnum)
);

-- Corrected INSERT statements for salle table
INSERT INTO salle VALUES (1,850,890,1000,'Aquarium');
INSERT INTO salle VALUES (2,655,890,1100,'Aquarium');
INSERT INTO salle VALUES (3,850,1055,1350,'Garde-Manger');
INSERT INTO salle VALUES (4,650,1055,1000,'Garde-Manger');
INSERT INTO salle VALUES (5,430,550,800,'Reserve');
INSERT INTO salle VALUES (6,650,650,600,'Reception');
INSERT INTO salle VALUES (7,850,1055,1350,'Garde-Manger');

SELECT * FROM salle; 

-- Corrected INSERT statements for aquarium table
INSERT INTO aquarium VALUES (1,28,3,2,2,6,1);
INSERT INTO aquarium VALUES (2,22,4,1,1,6,2);
INSERT INTO aquarium VALUES (3,26,3,2,2,6,3);
INSERT INTO aquarium VALUES (4,22,3,2,2,6,4);

SELECT * FROM aquarium; 

-- Corrected INSERT statements for employe table
INSERT INTO employe VALUES (111,'Buffy','1995-04-20',25000,NULL,'123 Sunnydale');
INSERT INTO employe VALUES (112,'Willow','1996-02-20',26000,NULL,'124 Sunnydale');
INSERT INTO employe VALUES (113,'Xander','1994-09-15',24000,NULL,'125 Sunnydale');
INSERT INTO employe VALUES (114,'Giles','1964-09-15',27000,NULL,'126 Sunnydale');
INSERT INTO employe VALUES (115,'Angel','1743-10-28',28000,NULL,'127 Sunnydale');

SELECT * FROM employe;

-- Corrected INSERT statements for menu table
INSERT INTO menu VALUES (1,'Carnivore','17h00-21h00','17h00-21h00','Fruits');
INSERT INTO menu VALUES (2,'Omnivore','17h00-21h00','17h00-21h00','Fruits');
INSERT INTO menu VALUES (3,'Omnivore','14h00-19h00','14h00-19h00','Fruits');
INSERT INTO menu VALUES (4,'Carnivore','14h00-19h00','14h00-19h00','Fruits');

SELECT * FROM menu;

-- Corrected INSERT statements for espece table
INSERT INTO espece VALUES (1,'Tuna','Pacifique',6,18,1);
INSERT INTO espece VALUES (2,'Trout','Atlantic',6,15,2);
INSERT INTO espece VALUES (3,'Salmon','Pacific',6,15,2);
INSERT INTO espece VALUES (4,'Bass','Atlantic',6,15,3);

SELECT * FROM espece;

-- Corrected INSERT statements for poisson table
INSERT INTO poisson VALUES (1,'blue',5,40,1,1);
INSERT INTO poisson VALUES (2,'orange',5,30,2,2);
INSERT INTO poisson VALUES (3,'yellow',6,20,3,3);
INSERT INTO poisson VALUES (4,'red',7,35,4,4);

SELECT * FROM poisson;

-- Corrected INSERT statements for services table
INSERT INTO services VALUES (1,111,1,7,15,'2023-06-06','nettoyage');
INSERT INTO services VALUES (2,112,2,8,17,'2023-06-06','nettoyage');
INSERT INTO services VALUES (3,113,3,9,19,'2023-06-06','nettoyage');
INSERT INTO services VALUES (4,114,4,10,21,'2023-06-06','nettoyage');
INSERT INTO services VALUES (5,115,5,11,23,'2023-06-06','nettoyage');
INSERT INTO services VALUES (6,111,1,7,15,'2023-06-06','Verification ph');
INSERT INTO services VALUES (7,112,2,8,17,'2023-06-06','Verification ph');
INSERT INTO services VALUES (8,113,3,9,19,'2023-06-06','Verification ph');
INSERT INTO services VALUES (9,114,4,10,21,'2023-06-06','Verification ph');
INSERT INTO services VALUES (10,115,5,11,23,'2023-06-06','Verification ph');

select * from services;


--This query will return the name, origin, and pH of species where pH is greater than 5 and less than 8
SELECT esnom, esor, esph FROM espece 
WHERE esph>5 AND esph<8;


--This query will display all rooms where the length and width are greater than 600m and the height is greater than 1000m.
SELECT * FROM salle
WHERE salong>600 AND salarg>600 AND sahaut>1000;


--This query will retrieve the menu ID, name, and food where the second letter is 'r' in the food name.
SELECT menuid, menunom, menunour FROM menu 
WHERE menunour LIKE '_r%';


--This query will display the name, date of birth, and salary of employees whose salary is greater than 20000, sorted by salary in ascending order.
SELECT empnom, empnaiss, empsal FROM employe
WHERE empsal>20000
ORDER BY empsal ASC;

--This query will count the number of fish for each color.
SELECT pcoul, COUNT(pcoul) AS "nombre de poisson de cette couleur"
FROM (SELECT pcoul FROM poisson) AS p
GROUP BY pcoul;


-- This query will return the distinct aquarium numbers where there are red fish and the count of red fish in each aquarium.
SELECT DISTINCT aqnum, COUNT(pcoul)
FROM aquarium a, poisson p
WHERE a.aqnum=p.paq AND pcoul = 'rouge'
GROUP BY aqnum;


--This query will show the names of employees and the services they have to perform, ordered alphabetically by service.
SELECT a.aqnum, a.aqph, s.serid
FROM aquarium a LEFT OUTER JOIN services s 
ON a.aqnum=s.seraq
WHERE a.aqph>6
ORDER BY s.serid;


--This query will display the aquarium number, pH, and service ID for aquariums with a pH greater than 6, ordered by service ID.
SELECT  e.empnom, s.serprest
FROM services s RIGHT OUTER JOIN employe e 
ON s.seremp=e.empnum
ORDER BY s.serprest;


--This query will display the names of employees who have more than one service to perform.
SELECT e.empnom, COUNT(s.serprest) "Services"
FROM employe e, services s
WHERE  e.empnum = s.seremp
GROUP BY  e.empnom
HAVING 	COUNT(s.serprest)>1;


--This query will display the employee number, name, and service to be performed, ordered by employee number.
SELECT e.empnum,e.empnom, s.serprest FROM employe e, services s 
WHERE e.empnum = s.seremp
GROUP BY e.empnum,e.empnom, s.serprest 
ORDER BY e.empnum;


--This query will display the employee number, name, date of birth, salary, and aquarium number where they have to perform a service, for employees with a salary greater than 17000, ordered by employee number.
SELECT e.empnum, e.empnom, e.empnaiss, e.empsal, a.aqnum
FROM employe e LEFT JOIN services s
ON e.empnum = s.seremp LEFT JOIN aquarium a
ON a.aqnum = s.seraq
GROUP BY e.empnum, e.empnom, e.empnaiss, e.empsal, a.aqnum HAVING (e.empsal>17000)
ORDER BY e.empnum;


--This query will display the number of times the service 'Verification ph' needs to be performed in each Aquarium room, ordered by room number.
SELECT sa.sanum, COUNT(sa.sanum)
FROM salle sa ,aquarium a ,services se
where sa.sanum=a.sa# and a.aqnum = se.seraq 
and se.serprest = 'Verification ph' and sa.safct = 'Aquarium'
GROUP BY sa.sanum ORDER BY sa.sanum;


--This query will display the name of employees, room numbers where they have to perform a service, and their salary for employees with a salary greater than 20000, ordered first by salary in ascending order, then alphabetically by employee name.
SELECT e.empnom, s.sanum, e.empsal FROM employe e, aquarium a, salle s, services se 
WHERE se.seraq = a.aqnum 
AND s.sanum = a.sa# AND se.seremp = e.empnum
GROUP BY e.empnom, s.sanum, e.empsal HAVING(e.empsal >20000) ORDER BY e.empnom, e.empsal;


--This query will display the name of the species, length, weight of fish, and temperature of the aquariums where the fish belong to, with conditions specified on length, weight, and temperature.
SELECT e.esnom, p.plong, p.ppoids, a.aqtemp
FROM aquarium a, espece e, poisson p
WHERE a.aqnum = p.paq AND a.aqtemp > 22 AND p.ppoids > 150 
AND p.plong > 20 AND e.esid = p.pes;


--This query will show the aquarium number, pH of the species, and the food for the aquariums where the species swim in water with a pH of 7.
SELECT a.aqnum, e.esph, m.menunour
FROM aquarium a, espece e, menu m
WHERE e.esph=7 AND e.esmenu# = m.menuid;