------------ projet ------------------
ALTER SESSION SET NLS_DATE_FORMAT='DD-MON-YYYY';
ALTER SESSION SET NLS_DATE_LANGUAGE='AMERICAN';


select * from tab;
drop table aquarium cascade constraints;
drop table salle cascade constraints;
drop table services cascade constraints;
drop table employe cascade constraints;
drop table menu cascade constraints;
drop table poisson cascade constraints;
drop table espece cascade constraints;


create table salle(
    sanum   number(4)       constraint pk_salle primary key,
    salong      number(4)       constraint nl_salle_salong  not null,
    salarg      number(4)       constraint nl_salle_salarg not null,
    sahaut      number(4)       constraint nl_salle_sahaut not null,
	safct		number(4)		constraint nl_salle_safct not null,
								constraint check_salle_safct check(safct)
                                IN('Reserve','Garde-Manger','Aquarium','Reception')

);

create table aquarium (
    aqnum       number(4)       constraint pk_aquarium primary key,
    aqtemp      number(4)       constraint nl_aquarium_aqtemp not null,
    aqlarge     number(4)       constraint nl_aquarium_aqlarge not null,
    aqlong      number(4)       constraint nl_aquarium_aqlong not null,
	aqhaut      number(4)       constraint nl_aquarium_aqhaut not null,
    aqph        number(4)       constraint nl_aquarium_aqph not null,
    sa#         number(4)       constraint nl_aquarium_sa# not null,
    constraint fk_aquarium_sa# foreign key (sa#)
    references SALLE (SANUM)

);


create table employe(
    empnum      number(4)       constraint pk_employe primary key,
    empnom      varchar2(12)    constraint nl_employe_empnom not null
                                constraint uk_employe_empnom unique,
    empnaiss    date            constraint nl_employe_empnaiss not null,
    empsal      number(7,2)     constraint nl_employe_empsal not null,
    emptel      varchar2(12),
    empadr      varchar2(20)	constraint nl_employe_empadr not null
);

create table menu(
    menuid     number(4)       constraint pk_menu primary key,
    menunom    varchar2(30)    constraint nl_menu_menunom not null,
								constraint check_menu_menunom check(menunom
                                IN('Carnivore','Omnivore')),
    menustock  varchar2(12)    constraint nl_menu_menustock not null,
    menuperim  varchar2(12)    constraint nl_menu_menuperim not null,
    menunour   varchar2(20)    constraint nl_menu_menunour not null,
								constraint check_menu_menunour check(menunour
                                IN('Larves','Insectes','Crustaces','Poulpes','Legumes','Fruits',
								'Herbes','Viandes'))
    
);


create table espece(
    esid   number(4)       constraint pk_espece primary key,
    esnom  varchar2(20)    constraint nl_espece_esnom not null,
    esor   varchar2(20)    constraint nl_espece_esorigine not null,
    esph	number(4)       constraint nl_espece_esph not null,
	estemp  number(4)		constraint nl_espece_estemp not null,
	esmenu# number(1)		constraint nl_espece_esmenu# not null,
							constraint fk_espece_esmenu# foreign key (esmenu#)
							references MENU (menuid)
    
);


create table poisson(
    pid     number(4)           constraint pk_poisson primary key,
    pcoul   varchar2(10)        constraint nl_poisson_pcoul not null,
    ppoids  number(4)           constraint nl_poisson_ppoids not null,
    plong   number(4)           constraint nl_poisson_plong not null,
    pes     number(4)          constraint nl_poisson_es1# not null,
    paq    number(4)           constraint nl_poisson_aq2# not null,
      
      constraint fk_poisson_pes foreign key (pes)
      references ESPECE (esid),
      constraint fk_poisson_paq foreign key (paq)
      references AQUARIUM (AQNUM)
);




create table services(
    serid       number(4)       constraint pk_service primary key,
    seremp      number(4)       constraint nl_service_emp# not null
                                constraint service_fk_employe references employe(empnum)
                                on delete cascade,
    seraq       number(4)       constraint nl_service_aq# not null,
    serhd       number(4)       constraint nl_service_hd not null,
    serhf       number(4)       constraint nl_service_ha not null,
    serdat      date,
    serprest    varchar2(24)    constraint nl_service_prestation not null
                                constraint check_service_prestation check(serprest
                                IN('Nettoyage','Verification temperature','Verification ph')),
    constraint service_chk_ha_hd check (serhf>serhd),
    constraint fk_service_seraq foreign key (seraq)
    references aquarium(aqnum)

);



--les salles
insert into salle values(1,850,890,1000,'Aquarium');
insert into salle values(2,655,890,1100,'Aquarium');
insert into salle values(3,850,1055,1350,'Aquarium');
insert into salle values(4,1055,790,1000,'Aquarium');
insert into salle values(5,850,545,1200,'Aquarium');
insert into salle values(6,850,890,1000,'Reception');
insert into salle values(7,655,900,1100,'Reserve');
insert into salle values(8,850,1050,1300,'Reserve');
insert into salle values(9,1000,790,1000,'Garde-Manger');
insert into salle values(10,800,600,1100,'Reserve');

select * from salle;


--les aquariums
insert into aquarium values(1,23,50,  70,   60, 6,  1);
insert into aquarium values(2,22,110,  130,  80, 8, 2);
insert into aquarium values(3,25,100,  120, 60,   6,   3);
insert into aquarium values(4,28,90,  110,   60,  7, 4);
insert into aquarium values(5,25,120,  120,   70, 6 ,5);
insert into aquarium values(6,25,80,  90, 70,   7,   5);
insert into aquarium values(7,25,110,  120, 80,   7,   2);
insert into aquarium values(8,24,15, 25, 20,  5,   3);
insert into aquarium values(9,22,40,  40, 20,   7,   4);
insert into aquarium values(10,25, 20, 30, 20,7, 1);


select * from aquarium;


--les employes
insert into employe values(1,'Bernard',to_date('16-08-1962'),18009.0,'93548254','Rue de Granit');
insert into employe values(2,'Franck',to_date('16-10-1973'),22100.0,'91548254','Route de Vapeur');
insert into employe values(3,'Emilie',to_date('11-03-1975'),15000.6,'93548254','Boulevard du Temple');
insert into employe values(4,'Pascal',to_date('25-06-1983'),21000.6,'96548254','Boulevard du Parc');
insert into employe values(5,'Viki',to_date('10-02-1989'),17000.6,'73548254','Boulevard de Cail');
insert into employe values(6,'Enrico',to_date('01-01-1972'),24500.0,'13548254','Rue du Port');
insert into employe values(7,'Geraldine',to_date('03-08-1966'),24500.0,'73548211','Rue de Mugissement');
insert into employe values(8,'Dave',to_date('17-09-1990'),17000.6,'93958211','Route de Saphir');
insert into employe values(9,'Margeaux',to_date('12-08-1965'),29000.0,'73223322','Voie du Moulin');
insert into employe values(10,'Claude',to_date('16-09-1965'),22100.0,'','Boulevard du Temple');
insert into employe values(11,'Charlotte',to_date('06-12-1952'),17000.6,'','Rue de Mugissement');
insert into employe values(12,'Martine',to_date('03-04-1952'),21100.0,'','Voie du Moulin');

select * from employe;




--les menus (à completer)
insert into menu values(1,'Carnivore','oui','non','Larves');
insert into menu values(2,'Carnivore','non','non','Insectes');
insert into menu values(3,'Carnivore','oui','non','Crustaces');
insert into menu values(4,'Carnivore','oui','non','Poulpes');
insert into menu values(5,'Omnivore','oui','non','Legumes');
insert into menu values(6,'Omnivore','oui','non','Fruits');
insert into menu values(7,'Omnivore','oui','non','Herbes');
insert into menu values(8,'Carnivore','oui','non','Viandes');
insert into menu values(9,'Omnivore','oui','non','Algues');
insert into menu values(10,'Carnivore','oui','non','Planctons');


select * from menu;

--les especes
insert into espece values(1,'Polleni','Afrique',7,25,3);
insert into espece values(2,'Ocellatus','Amérique du Sud',8,22,1);
insert into espece values(3,'Menarambo','Afrique',7,25,4);
insert into espece values(4,'Scalare','Amérique du Sud',6,25,3);
insert into espece values(5,'Polli','Afrique',6,23,7);
insert into espece values(6,'Splendens','Asie',6,23,4);
insert into espece values(7,'Aequifasciatus','Amérique du Sud',7,28,3);
insert into espece values(8,'Plecostomus ','Amérique du Sud',6,28,5);
insert into espece values(9,'Auratus','Asie',8,22,6);
insert into espece values(10,'Maculatus','Amérique du Sud',7,25,8);


select * from espece;




----les poissons
insert into poisson values(1,'rouge',100,18,7,4);
insert into poisson values(2,'noir',200,30,1,7);
insert into poisson values(3,'argenté',150,29,3,6);
insert into poisson values(4,'jaune',185,28,8,5);
insert into poisson values(5,'bleu',160,17,4,3);
insert into poisson values(6,'rouge',136,15,9,9);
insert into poisson values(7,'blanc',56,10,5,1);
insert into poisson values(8,'rouge',115,19,7,4);
insert into poisson values(9,'argenté',120,24,3,6);
insert into poisson values(10,'orange',200,35,2,2);
insert into poisson values(11,'noir',187,26,2,2);
insert into poisson values(12,'rouge',35,5,10,10);
insert into poisson values(13,'noir',185,27,1,7);
insert into poisson values(14,'bleu',203,36,4,3);
insert into poisson values(15,'rouge',187,10,6,8);
insert into poisson values(16,'rouge',34,5,10,10);
insert into poisson values(17,'vert',154,36,4,3);
insert into poisson values(18,'rouge',120,19,9,9);
insert into poisson values(19,'jaune',190,25,8,5);
insert into poisson values(20,'blanc',53,9,5,1);



select * from poisson;


--les services
insert into  services values(1, 1,1,'1345', '1400',to_date('3-03-1989'),'Nettoyage');
insert into  services values(2,3,6,'1230', '1310',to_date('10-01-1989'),'Verification ph');
insert into  services values(3,4,1,'0745', '0810',to_date('3-03-1989'),'Nettoyage');
insert into  services values(4,12,6,'0640','0710',to_date('14-01-1989'),'Verification temperature');
insert into  services values(5,4,8,'0800', '0820',to_date('22-03-1989'),'Verification ph');
insert into  services values(6,5,3,'0700', '0730',to_date('6-11-1989'),'Nettoyage');
insert into  services values(7,8,4,'1200','1220',to_date('17-06-1989'),'Nettoyage');
insert into  services values(8,1,1,'1655', '1725',to_date('15-10-1989'),'Verification temperature');
insert into  services values(9,9,2,'1240', '1300',to_date('19-11-1989'),'Verification temperature');
insert into  services values(10,8,9,'1255','1320',to_date('4-06-1989'),'Verification temperature');
insert into  services values(11,3,8,'1450', '1525',to_date('15-10-1989'),'Verification ph');
insert into  services values(12,11,8,'1230','1400',to_date('9-03-1989'),'Nettoyage');
insert into  services values(13,9,5,'1240', '1300',to_date('19-11-1989'),'Verification temperature');
insert into  services values(14,8,9,'1255','1320',to_date('4-06-1989'),'Verification ph');
insert into  services values(15,3,10,'1450', '1525',to_date('15-10-1989'),'Verification ph');
insert into  services values(16,11,7,'1230','1400',to_date('9-03-1989'),'Nettoyage');

select * from services;





--5 requêtes impliquant 1 table 

--dont 1 avec un group By et une avec un Order By;



--requête impliquant une table

--Affichage du nom, de l'origine et du ph de l'espèce avec la condition que son ph soit
--entre 5 et 8 exclus

SELECT esnom, esor, esph FROM espece 

WHERE esph>5 AND esph<8;



--requête impliquant une table

-- Affichage de toutes les salles dont la longueur et la largeur sont supérieur à 6m et la hauteur
-- et la hauteur supérieur à 10m  

SELECT * FROM salle

WHERE salong>600 AND salarg>600 AND sahaut>1000;



--requête impliquant une table

--Affichage du numéro d'identifiant, du nom du menu et de sa nourriture 
--dont la 2ème lettre est un "e" 

SELECT menuid, menunom, menunour FROM menu 

WHERE menunour LIKE '_e%';



--requête impliquant une table avec order by

-- Affichage du nom, de la date de naissance et du salaire de l'employé 
-- trié en ordre descendant sur le salaire

SELECT empnom, empnaiss, empsal FROM employe

WHERE empsal>20000

ORDER BY asc empsal;



--requête impliquant une table avec group by

-- Nombre de poisson pour chaque couleur

SELECT pcoul, COUNT(pcoul) "nombre de poisson de cette couleur"

FROM (SELECT pcoul FROM poisson)

GROUP BY pcoul;





-- 5 requêtes impliquant 2 tables 

--avec jointures internes dont 1 externe + 1 group by + 1 tri;



--jointure interne

--Affichage distinct du numéro des aquariums dans lesquels il y a des poissons rouges ou noirs 

SELECT DISTINCT aqnum, COUNT(pcoul)

FROM aquarium a, poisson p

WHERE a.aqnum=p.paq AND pcoul = 'rouge';



--jointure externe avec order by;

-- Affichage du numéro des aquariums dont le ph est supérieur à 6 
-- avec respectivement le numéro d'identifiant du service qui vont être effectué si il y en a un
-- trié par le numéro d'identifiant du service

SELECT a.aqnum, a.aqph, s.serid

FROM aquarium a LEFT OUTER JOIN services s 

ON a.aqnum=s.seraq

WHERE a.aqph>6

ORDER BY s.serid;


--jointure externe avec order by;

--Affichage du nom des employés et du services à accomplir s'ils en ont un
--trié alphabetiquement par le service à effectuer

SELECT  e.empnom, s.serprest

FROM services s RIGHT OUTER JOIN employe e 

ON s.seremp=e.empnum

ORDER BY s.serprest;


--jointure avec group by

-- Affichage du noms des employés qui ont plus d'un service à effectuer

SELECT e.empnom, COUNT(s.serprest) "Services"

FROM employe e, services s

WHERE  e.empnum = s.seremp

GROUP BY  e.empnom

HAVING 	COUNT(s.serprest)>1;



--jointure externe avec group by + order by;


-- Affichage du numéro, du nom de l'employé avec le service qu'il ou elle doit accomplir
-- trié par le numéro de l'employé

SELECT e.empnum,e.empnom, s.serprest FROM employe e, services s 

WHERE e.empnum = s.seremp(+)

GROUP BY e.empnum,e.empnom, s.serprest 

ORDER BY e.empnum;





--5 requêtes impliquant plus de 2 tables 

--avec jointures internes dont 1 externe + 1 group by + 1 tri



--requête avec order by et group by

-- Affichage du numéro, du nom, de la date de naissance et du salaire de l'employé 
-- et du numéro l'aquarium dont il doit faire un service s'il en a un 
-- trié par le numéro de l'employé

SELECT e.empnum, e.empnom, e.empnaiss, e.empsal, a.aqnum

FROM employe e LEFT JOIN services s

ON e.empnum = s.seremp LEFT JOIN aquarium a

ON a.aqnum = s.seraq

GROUP BY e.empnum, e.empnom, e.empnaiss, e.empsal, a.aqnum HAVING (e.empsal>17000)

ORDER BY e.empnum;




--requête avec group by + order by

-- Affichage des salles Aquariums avec le nombre de fois le service 'Vérification ph' 
-- est à réaliser dans les aquariums respectifs
-- trié par le numéro de la salle

SELECT sa.sanum, COUNT(sa.sanum)

FROM salle sa ,aquarium a ,services se

where sa.sanum=a.sa# and a.aqnum = se.seraq 

and se.serprest = 'Verification ph' and sa.safct = 'Aquarium'

GROUP BY sa.sanum ORDER BY sa.sanum;


--requête sur plusieurs tables


--Numéro des salles dans lesquelles les employés ayant un salaire supérieur à 20000 
--ont un service à faire
--trié d'abord par le salaire de manière descendante puis par le nom des employé alphabetiquement

SELECT e.empnom, s.sanum, e.empsal FROM employe e, aquarium a, salle s, services s 

WHERE s.seraq = a.aqnum 

AND s.sanum = a.sa# AND s.seremp = e.empnum

GROUP BY e.empnom, s.sanum, e.empsal HAVING(e.empsal >20000) ORDER BY e.empnom, e.empsal;



--requête sur plusieurs tables

-- Nom des espèces des poissons ayant une longueur supérieur à 20cm, un poids supérieur à 150g 
-- et dont la température de leur aquarium est supérieur à 22°C

SELECT e.esnom, p.plong, p.ppoids, a.aqtemp

FROM aquarium a, espece e, poisson p

WHERE a.aqnum = p.paq AND a.aqtemp > 22 AND p.ppoids > 150 

AND p.plong > 20 AND e.esid = p.pes;


--requête sur plusieurs tables


-- La nourriture allant dans les aquariums dans lequel 
-- les espèces nagent dans une eau dont leur ph vaut 7 

SELECT a.aqnum, e.esph, m.menunour

FROM aquarium a, espece e, menu m

WHERE e.esph=7 AND e.esmenu# = m.menuid;