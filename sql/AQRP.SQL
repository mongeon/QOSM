/*
Créer la base de données.
Installer les extensions PostGIS: CREATE EXTENSION postgis;

Créer 2 nouveaux schémas: sources et travail.

Utilisation des schémas

Sources: sera utilisé pour les données originales qui ne seront jamais modifiées.
Travail: copie de travail des données dans sources
Public: Données finales, prêtes à publier

Importer les shapefile AQRP dans le schéma "sources" en utilisant les noms suivants

Reseau_routier.shp => aqrpxx (xx = numéro de version, 4.0 au moment d'écrire ce guide.)
Reseau_ferroviaire.shp => aqcfxx (cf = Chemin Fer)
Reseau_ferroviaire_PN => aqcfpn (cf = Chemin Fer, pn = Points)

*/

/* Copier dans le schéma travail */
Drop Table if exists travail.aqrp;
Create Table travail.aqrp (like sources.aqrp including all);
Insert into travail.aqrp Select * from sources.aqrp;


/* Traitement des données du Réseau Routier */

Alter table travail.aqrp add column highway character varying(20);
Alter table travail.aqrp add column junction character varying(20);
Alter table travail.aqrp rename column nomrte to name;
Alter table travail.aqrp add column ref character varying(20);
Alter table travail.aqrp rename column nbrvoies to lanes;
Alter table travail.aqrp add column tracktype character varying(20);
Alter table travail.aqrp add column winter_road character varying(5);
Alter table travail.aqrp add column bridge character varying(5);
Alter table travail.aqrp add column barrier character varying(10);
Alter table travail.aqrp add column surface character varying(10);
Alter table travail.aqrp add column maxweight character varying(10);
Alter table travail.aqrp add column maxspeed int;
Alter table travail.aqrp add column access character varying(10);
Alter table travail.aqrp add column description character varying(100);
Alter table travail.aqrp add column website character varying(250);

Create Index on travail.aqrp (clsrte);
Create index on travail.aqrp (caractrte);
Create index on travail.aqrp (norte,no_chefor);
Create index on travail.aqrp (cls_chefor);

Delete from travail.aqrp where clsrte = 'Rue piétonne';
Delete from travail.aqrp where clsrte = 'Liaison maritime';

Update travail.aqrp set highway = 'motorway' where clsrte = 'Autoroute';
Update travail.aqrp set highway = 'trunk' where clsrte = 'Artère';
Update travail.aqrp set highway = 'primary' where clsrte = 'Nationale';
Update travail.aqrp set highway = 'secondary' where clsrte = 'Régionale';
Update travail.aqrp set highway = 'tertiary' where clsrte in ('Collectrice municipale','Collectrice de transit','Accès aux ressources','Accès aux ressources et aux localités isolées');
Update travail.aqrp set highway = 'residential' where clsrte = 'Locale';
Update travail.aqrp set access = 'private' where gestion = 'Privé';
Update travail.aqrp set highway = 'motorway_link' where CaractRte = 'Bretelle';
Update travail.aqrp set highway = 'rest_area' where CaractRte = 'Parc routier';
Update travail.aqrp set junction = 'roundabout' where CaractRte = 'Carrefour giratoire';
Update travail.aqrp set ref = Cast(NoRte as char(10)) where NoRte is not null and no_chefor is null;
Update travail.aqrp set ref = no_chefor where NoRte is Null and no_chefor is not null;
Update travail.aqrp set ref = trim(both '' from cast(noRte as char(10))) || ';' || trim(both '' from no_chefor) where norte is not null and no_chefor is not null;
Update travail.aqrp set ref = trim(both '' from ref) || ' (' || trim(both '' from cls_chefor) || ')' where cls_chefor is not null and cls_chefor != 'NF';

Update travail.aqrp set highway = 'track', tracktype = 
	Case 
    	when cls_chefor in ('HN','01') then 'grade1'
        when cls_chefor = '02' then 'grade2'
        when cls_chefor = '03' then 'grade3'
        when cls_chefor = '04' then 'grade4'
        when cls_chefor = '05' then 'grade5'
	End
    where cls_chefor in ('HN','01','02','03','04','05');

update travail.aqrp set ref = trim(both '' from ref) || ' (' || 
	Case 
		when cls_rat = 'HN' then '01'
		when cls_rat = 'CL1' then '01'
		when cls_rat = 'CL4' then '04'
		when cls_rat = 'INC' then 'NC'
	End || ')'
Where cls_chefor is null and highway='track' and cls_rat is not null and (tracktype = '' or tracktype is null);


Update travail.aqrp set highway = 'track', tracktype = '' where cls_chefor = 'NC';
Update travail.aqrp set highway = 'track', tracktype='', winter_road = 'yes' where cls_chefor = 'HI';
Update travail.aqrp set highway = 'track', tracktype = '' where cls_chefor = 'IN';

Update travail.aqrp set highway = 'track', tracktype = 
	Case
    	When cls_rat = 'CL4' then 'grade4'
        When cls_rat = 'CL1' then 'grade1'
        when cls_rat = 'HN' then 'grade1'
        when cls_rat = 'INC' then 'grade5'
	End
    where highway is null and cls_rat is not null and cls_chefor is null and clsrte is null;
	
Update travail.aqrp set bridge = 'yes' where CaractRte = 'Pont';

Update travail.aqrp set ref =
	case
		when tracktype='grade1' then '(01)'
		when tracktype='grade2' then '(02)'
		when tracktype='grade3' then '(03)'
		when tracktype='grade4' then '(04)'
		when tracktype='grade5' then '(05)'
		when tracktype='' then '(NC)'
	End
	where ref is null or ref = '' and highway = 'track';

Create index on travail.aqrp (etatrev);
Update travail.aqrp set surface = 'paved' where etatrev = 'Revêtue';
Update travail.aqrp set surface = 'unpaved' where etatrev = 'Non revêtue';

Create index on travail.aqrp (stat_pont);

Update travail.aqrp set barrier = 'yes', access='no' where stat_pont = 'F';
Update travail.aqrp set description = 
	Case
    	when stat_pont = 'F' then 'Pont ' || dossi_pont || ' (fermé).' else 'Pont ' || dossi_pont || '.'
    End,
	WebSite = 'https://www.google.com/maps/@?api=1&map_action=map&center=' || 
				Split_Part(Replace(Replace(ST_AsText(ST_Transform(ST_LineInterpolatePoint(geom, 0.5),4326)),'POINT(',''),')',''),' ',2) || ',' || 
				Split_Part(Replace(Replace(ST_AsText(ST_Transform(ST_LineInterpolatePoint(geom, 0.5),4326)),'POINT(',''),')',''),' ',1) || '&basemap=satellite&zoom=16'
	where bridge = 'yes';



Update travail.aqrp set name = '' where name is null;
update travail.aqrp set name = rTrim(name) || dossi_pont where dossi_pont is not null;

create index on travail.aqrp (cap_port);
Update travail.aqrp set maxweight = split_part(cap_port, '-',1) where cap_port is not null;

Create index on travail.aqrp (maxweight);
Update travail.aqrp set maxweight = '' where maxweight is null;
Update travail.aqrp set maxweight = '' where maxweight = 'INC';


Create index on travail.aqrp (tracktype);
Update travail.aqrp set maxspeed = 70 where tracktype = 'grade1';
Update travail.aqrp set maxspeed = 60 where tracktype = 'grade2';
Update travail.aqrp set maxspeed = 50 where tracktype = 'grade3';
Update travail.aqrp set maxspeed = 40 where tracktype = 'grade4';
Update travail.aqrp set maxspeed = 40 where tracktype = 'grade5';

/* Nos données sont prêtes à transférer dans le schéma public */
Drop table if exists public.aqrp;
Create table public.aqrp (like travail.aqrp including all);
Insert into public.aqrp select * from travail.aqrp;

/* Finalement on supprime les colonnes qui ne sont pas pour OSM */
Alter table public.aqrp
	drop column idrte,
    drop column version,
    drop column norte,
    drop column no_chefor,
    drop column clsrte,
    drop column caractrte,
    drop column cls_chefor,
    drop column cls_rat,
    drop column an_classi,
    drop column carrte,
    drop column che_multi,
    drop column gestion,
    drop column source,
    drop column notes,
    drop column etatrev,
    drop column dossi_pont,
    drop column cap_port,
    drop column stat_pont,
    drop column aqrp_uuid,
    drop column ogc_fid;

/* Fin du traitement du réseau routier */
	

/* Traitement des données du réseau ferroviaire */
Drop table if exists travail.aqcf;
Create Table travail.aqcf (like sources.aqcf including all);
Insert into travail.aqcf select * from sources.aqcf;

Alter Table travail.aqcf add Column railway character varying(20);
Alter table travail.aqcf add column usage character varying(20);

Update travail.aqcf set railway = 'abandonned' where Etatc = 2;
Update travail.aqcf set railway = 'abandonned' where Etatc = -1;
Update travail.aqcf set railway = 'disused' where etatc = 4;
Update travail.aqcf set railway = 'rail' where etatc =3;

Update travail.aqcf set usage = 'tourism' where typeutilic = 3;
update travail.aqcf set usage = 'freight' where typeutilic = 1;
update travail.aqcf set usage = 'main' where typeutilic in (2,4,5);
Update travail.aqcf set nomvoie = '' where nomvoie = 'Aucun';

Alter table travail.aqcf rename column nomvoie to name;

Drop table if exists travail.aqcfpn;
Create table travail.aqcfpn (like sources.aqcfpn including all);
Insert into travail.aqcfpn select * from sources.aqcfpn;

Alter table travail.aqcfpn add column railway character varying(20);
Update travail.aqcfpn set railway = 'crossing' where cat_passg = 'Sentier';
Update travail.aqcfpn set railway = 'level_crossing' where cat_passg != 'Sentier';
Alter table travail.aqcfpn rename column odonyme to name;

/* Transfert dans le schéma public */
Drop Table if exists public.aqcf;
Create table public.aqcf (like travail.aqcf including all);
insert into public.aqcf select * from travail.aqcf;

Drop table if exists public.aqcfpn;
create table public.aqcfpn (like travail.aqcfpn including all);
insert into public.aqcfpn select * from travail.aqcfpn;

Alter table public.aqcf
	drop column version,
    drop column idsegchfer,
    drop column classvoie,
    drop column classvoic,
    drop column typeutilis,
    drop column typeutilic,
    drop column etat,
    drop column etatc,
    drop column nmfrexploi,
    drop column siglexploi,
    drop column debsubexpl,
    drop column finsubexpl,
    drop column nmfrpropr,
    drop column nmfruti1vo,
    drop column siguti1vo,
    drop column nmfruti2vo,
    drop column siguti2vo,
    drop column nomsubdiv1,
    drop column debsubdiv1,
    drop column finsubdiv1,
    drop column nomsubdiv2,
    drop column debsubdiv2,
    drop column finsubdiv2,
    drop column nivhierar,
    drop column nivhierarc,
    drop column datdebappl,
    drop column datmodif,
    drop column datfinappl,	
    drop column aqrp_uuid,
    drop column ogc_fid;

alter table public.aqcfpn
	drop column version,
    drop column idrte,
    drop column cat_passg,
    drop column ide_passg,
    drop column aqrp_uuid,
    drop column ogc_fid;

/* Fin du traitement pour le réseau ferroviaire */

drop table travail.aqcf;
drop table travail.aqcfpn;
drop table travail.aqrp;



