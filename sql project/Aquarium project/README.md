# SQL Project

During my studies, I had a project consisting of creating a database on one subject (I choose an aquarium), creating the tables of the database and showing different queries following some instructions.

In this README, here are the instructions I had to follow and the queries associated :

**5 queries involving 1 table including one with a *group By* and one with a *Order By***

* SELECT esnom, esor, esph FROM espece WHERE esph>5 AND esph<8;
* SELECT * FROM salleWHERE salong>600 AND salarg>600 AND sahaut>1000;
* SELECT menuid, menunom, menunour FROM menu WHERE menunour LIKE '_r%';
* SELECT empnom, empnaiss, empsal FROM employe WHERE empsal>20000 ORDER BY empsal ASC;
* SELECT pcoul, COUNT(pcoul) AS "nombre de poisson de cette couleur" FROM (SELECT pcoul FROM poisson) AS p GROUP BY pcoul;

**5 queries involving 2 tables with *internal joins* including *1 external* or *1 group by* or *1 sort***

* *Internal join*: SELECT DISTINCT pid, es1#, pcoul FROM aquarium a, poisson p WHERE a.aqnum=p.aq2# AND pcoul = 'rouge'; 
* *External join with ORDER BY*: SELECT a.aqnum, a.aqph, s.serid FROM aquarium a LEFT OUTER JOIN service s ON a.aqnum=s.aq1# WHERE a.aqph>7 ORDER BY s.serid;
* *External join with ORDER BY*: SELECT s.prestation, e.empnom FROM service s RIGHT OUTER JOIN employe e ON s.emp#=e.empnum ORDER BY s.prestation;
* *External join with GROUP BY*: SELECT e.empnom, COUNT(s.prestation) FROM employe e, service s WHERE  e.empnum = s.emp# GROUP BY  e.empnom HAVING 	COUNT(s.prestation)>1;
* *External join with ORDER BY*: SELECT e.espnom, e.esporigine, m.menunour FROM espece e RIGHT OUTER JOIN menu m ON e.espid=m.es2# WHERE e.esporigine LIKE 'G%';

**5 queries involving more than 2 tables with *internal joins* including *1 external* or *1 group by* or *1 sort***

* *query with ORDER BY*: SELECT e.empnom, e.empnum, e.empnaiss, e.empsal, a.aqnum FROM employe e LEFT JOIN service s ON e.empnum = s.emp# LEFT JOIN aquarium a ON a.aqnum = s.aq1# WHERE e.empsal>17000 ORDER BY e.empnom;
* *query with GROUP BY*: SELECT sa.sanumero, COUNT(sa.sanumero) FROM salle sa LEFT JOIN aquarium a ON sa.sanumero=a.sa# LEFT JOIN service se ON a.aqnum = se.aq1# WHERE se.prestation= 'Verification ph' GROUP BY sa.sanumero;
* *query witl multiple tables*: SELECT a.aqnum, e.esph, m.menunour FROM aquarium a, espece e, menu m WHERE a.aqph = e.esph AND e.esph=5 AND e.espid = m.es2#;
* *query witl multiple tables*: SELECT e.espnom, p.plong, p.ppoids, a.aqtemp FROM aquarium a, espece e, poisson p WHERE a.aqnum = p.aq2# AND a.aqtemp>20 AND p.ppoids>100 AND p.plong>10 AND e.espid = p.es1#;
* *query witl multiple tables*: SELECT s.sanumero, s.salarg, a.aqnum, p.pid, e.espnom FROM aquarium a, salle s, poisson p, espece e WHERE s.sanumero = a.sa# AND s.salarg>800 AND a.aqnum = p.aq2# AND p.es1#=e.espid;



