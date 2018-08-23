Drop table if exists travail.photoradar;
Create table travail.photoradar (like sources.photoradar including all);

insert into travail.photoradar select * from sources.photoradar;
Alter table travail.photoradar
	add column highway character varying(15);
Alter table travail.photoradar rename column urlimage to web;
Update travail.photoradar set highway = 'speed_camera';

Drop table if exists photoradar;
create table photoradar (like travail.photoradar including all);
Insert into photoradar select * from travail.photoradar;

alter table photoradar
	drop column ogc_fid,
	drop column region,
	drop column municipali,
	drop column arrondisse,
	drop column descriptio,
	drop column typeappare,
	drop column datedebuts;

drop table travail.photoradar;