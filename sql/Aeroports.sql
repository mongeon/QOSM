
Drop Table if Exists travail.aeroports;
Create table travail.aeroports (like sources.aeroports including all);
Insert into travail.aeroports select * from sources.aeroports;

Alter table travail.aeroports rename column typeinfras to aeroway;
alter table travail.aeroports rename column codeindic to icao;
alter table travail.aeroports 
	add column name character varying(75),
	add column description character varying(150);

update travail.aeroports set aeroway = 'aerodrome' where aeroway in ('Aéroport','Aérodrome','Hydroaérodrome','Hydroaéroport');
update travail.aeroports set aeroway = 'helipad' where aeroway = 'Héliport';
update travail.aeroports set nomnavcana = '' where nomnavcana is null;
update travail.aeroports set nomproprio ='' where nomproprio is null;
update travail.aeroports set nomexploit = '' where nomexploit is null;

update travail.aeroports 
	set name = nomnavcana,
		description = 		
			Case when nomproprio > '' then 'Propriété de: ' || trim(both '' from nomproprio) || '. ' else '' End  || 
			Case when nomexploit > '' then 'Exploité par: ' || trim(both '' from nomexploit) || '.' else '' End;

drop table if exists public.aeroports;
create table public.aeroports (like travail.aeroports including all);
insert into public.aeroports select * from travail.aeroports;

alter table public.aeroports
	drop column idobj,
    drop column version,
    drop column signalrout,
    drop column elevapieds,
    drop column longpiste,
    drop column nbrpiste,
    drop column indicpiste,
    drop column surface,
    drop column carburant,
    drop column douaneaoe,
    drop column latitude,
    drop column longitude,
    drop column proprietai,
    drop column province,
    drop column nomproprio,
    drop column nomexploit,
    drop column nomnavcana,
    drop column datemaj,
    drop column remarque,
	drop column source,
	drop column datdebappt,
	drop column datmodif, 
	drop column typecarto,
	drop column typeaerdr,
	drop column statut,
	drop column nomcarto,
	drop column remarques,
	drop column objectid,
	drop column ogc_fid;
	
drop table travail.aeroports;