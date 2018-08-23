Drop Table if Exists travail.aeroports_pistes;
Create table travail.aeroports_pistes (like sources.aeroports_pistes including all);
Insert into travail.aeroports_pistes select * from sources.aeroports_pistes;

Alter table travail.aeroports_pistes 
	add column aeroway character varying(10),
	add column length character varying(10),
	add column ele character varying(10);
	
	
alter table travail.aeroports_pistes rename column codeindic to icao;
alter table travail.aeroports_pistes rename column nomnavcana to name;

update travail.aeroports_pistes set aeroway = 'runway';
update travail.aeroports_pistes set name = '' where name is null;
Update travail.aeroports_pistes set ele = trim(both '' from Cast(elevapieds as char(10))) || ' ft';
Update travail.aeroports_pistes set length = trim(both '' from Cast(longpiste as char(10))) || ' ft';
Update travail.aeroports_pistes set surface = Replace(surface, 'Asphalte', 'asphalt');
Update travail.aeroports_pistes set surface = Replace(surface, 'Béton', 'concrete');
Update travail.aeroports_pistes set surface = Replace(surface, 'Gravier', 'gravel');
Update travail.aeroports_pistes set surface = Replace(surface, 'Neige', 'snow');
Update travail.aeroports_pistes set surface = Replace(surface, 'Roche concassée', 'gravel');
Update travail.aeroports_pistes set surface = Replace(surface, 'Sable', 'sand');
Update travail.aeroports_pistes set surface = Replace(surface, 'Gazon', 'grass');

drop table if exists public.aeroports_pistes;
create table public.aeroports_pistes (like travail.aeroports_pistes including all);
insert into public.aeroports_pistes select * from travail.aeroports_pistes;

alter table public.aeroports_pistes
	drop column gid,
	drop column nom,
	drop column code,
	drop column idobj,
    drop column version,
    drop column elevapieds,
    drop column longpiste,
    drop column nbrpiste,
    drop column indicpiste,
    drop column province,
    drop column datemaj,
    drop column remarque,
	drop column source,
	drop column datdebappt,
	drop column datmodif, 
	drop column objectid,
	drop column ogc_fid;	
	drop table travail.aeroports_pistes;