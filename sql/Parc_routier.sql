drop table if exists travail.parcroutier;
create table travail.parcroutier (like sources.parcroutier including all);
insert into travail.parcroutier select * from sources.parcroutier;

alter table travail.parcroutier
	add column highway character varying(10);
	
update travail.parcroutier
	set highway = 
		case
			when typparrout = 'Halte routière' then 'rest_area'
			when typparrout = 'Aire de service' then 'service'
			when typparrout = 'Relais routier' then 'rest_area'
			when typparrout = 'Belvédère' then 'rest_area'
			when typparrout = 'Aire de repos pour camionneurs' then 'rest_area'
		End;

alter table travail.parcroutier
	rename column nomparrout to name;
	
alter table travail.parcroutier
	rename column tabpiqniqu to picnic_table;

alter table travail.parcroutier
	rename column acvehlourd to caravan;

alter table travail.parcroutier
	rename column carburant to fuel;

Alter table travail.parcroutier
	rename column airejeux to leisure;
	
alter table travail.parcroutier
	rename column survcamera to man_made;

alter table travail.parcroutier
	rename column desclocal to description;
	
alter table travail.parcroutier
	rename column eaupotrobi to drinking_water;

alter table travail.parcroutier
	rename column toilettes to toilets;
	
alter table travail.parcroutier
	rename column bornelect to charging_station;
	
Alter table travail.parcroutier
	add column tourism character varying(30),
	add column information character varying(15);

update travail.parcroutier
	set tourism = '', information = '';
	
Update travail.parcroutier
	set picnic_table = case when picnic_table = 'Oui' then 'yes' else 'no' End;
	
update travail.parcroutier
	set tourism = 'information' where infotouris = 'Oui';
	
Update travail.parcroutier
	set tourism = case when tourism = '' then 'viewpoint' else ';viewpoint' End where typparrout = 'Belvédère';

update travail.parcroutier
	set information = 'terminal' where consol511 = 'Oui';

update travail.parcroutier
	set drinking_water = case when drinking_water = 'Oui' then 'yes' else 'no' end;

update travail.parcroutier
	set toilets = Case when toilets = 'Oui' then 'yes' else 'no' end;

update travail.parcroutier
	set telephone = case when telephone = 'Oui' then 'yes' else 'no' End;
	
update travail.parcroutier
	set fuel = case when fuel = 'Oui' then 'yes' else 'no' End;
	
update travail.parcroutier
	set man_made = case when man_made = 'Oui' then 'surveillance' else '' End;
	
update travail.parcroutier
	set leisure = case when leisure = 'Oui' then 'playground' else '' end;
	
update travail.parcroutier
	set caravan = case when caravan = 'Oui' then 'yes' else 'no' End;

update travail.parcroutier
	set charging_station = case when charging_station = 'Oui' then 'yes' else 'no' End;
	
alter table travail.parcroutier
	drop column ogc_fid,
	drop column objectid,
	drop column gid,
	drop column ctqoffic,
	drop column dirroute,
	drop column emplacemen,
    drop column typalimeau,
	drop column typparrout,
	drop column accunivers,
	drop column infotouris,
	drop column consol511,
	drop column internet,
	drop column haltetexto,
	drop column restaurati,
	drop column alimlegere,
	drop column peroperat,
	drop column eaurobinet,
	drop column datdebappl,
	drop column datmaj,
	drop column orgrespon,
	drop column nomroute,
	drop column noroute,
	drop column rtss,
	drop column chainage,
	drop column dt,
	drop column cs,
	drop column regadm,
	drop column regtouris,
	drop column nommun,
	drop column codemun,
	drop column modgestion,
	drop column longitude,
	drop column latitude,
	drop column version,
	drop column idobj,
	drop column desgmun;

drop table if exists parcroutier;
create table parcroutier (like travail.parcroutier including all);
insert into parcroutier select * from travail.parcroutier;
drop table if exists travail.parcroutier;
