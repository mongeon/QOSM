Drop table if exists travail.terres_autochtones;
create table travail.terres_autochtones (like sources.terres_autochtones including all);
insert into travail.terres_autochtones select * from sources.terres_autochtones;

alter table travail.terres_autochtones
	drop column ogc_fid,
	drop column techacq,
	drop column couvermeta,
	drop column datecre,
	drop column daterev,
	drop column precision,
	drop column fournisseu,
	drop column nomjeudonn,
	drop column versnormes,
	drop column idn,
	drop column codeta,
	drop column langue1,
	drop column nom1,
	drop column langue2,
	drop column langue3,
	drop column nom3,
	drop column langue4,
	drop column nom4,
	drop column langue5,
	drop column nom5,
	drop column ter1,
	drop column ter2,
	drop column ter3,
	drop column ter4,
	drop column typeta,
	drop column refweb;

alter table travail.terres_autochtones
	add column boundary character varying(15),
	add column admin_level character (1);
	
update travail.terres_autochtones
	set boundary = 'administrative', admin_level = '8';

alter table travail.terres_autochtones
	rename column nom2 to name;
	
drop table if exists terres_autochtones;
create table terres_autochtones (like travail.terres_autochtones including all);
insert into terres_autochtones select * from travail.terres_autochtones;
	
drop table travail.terres_autochtones;
