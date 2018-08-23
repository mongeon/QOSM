Drop table if exists travail.electrique;
Create table travail.electrique (like sources.electrique including all);
Insert into travail.electrique select * from sources.electrique;
Alter table travail.electrique add column power character varying(10);
update  travail.electrique set power = 'line';

Drop table if exists electrique;
create table electrique (like travail.electrique including all);
insert into electrique select * from travail.electrique;

alter table electrique
	drop column layer,
	drop column "fnode_",
	drop column "tnode_",
	drop column "lpoly_",
	drop column "rpoly_",
	drop column length,
	drop column "energ_l_",
	drop column enl_va_lon,
	drop column enl_co_pre,
	drop column enl_no_ind,
	drop column enl_de_ind,
	drop column enl_co_ver,
	drop column enl_da_mod,
	drop column energ_l_id,
    drop column ogc_fid;

drop table travail.electrique;

