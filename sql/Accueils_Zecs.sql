update sources.accueils_zecs
	set nom_poste='' where nom_poste is null;
	
update sources.accueils_zecs
	set nom_poste = replace(nom_poste,'Poste','');
	
update sources.accueils_zecs
	set nom_poste = replace(nom_poste,'Poste','');
	
update sources.accueils_zecs
	set service = case when service is null then '' else service End, serv_loca = case when serv_Loca is null then '' else serv_loca End, serv_Vente = case when serv_vente is null then '' else serv_vente End;
delete from sources.accueils_zecs where zec_id is null and nom_zec is null;

drop table if exists travail.accueils_zecs;
Create table travail.accueils_zecs
(
	id serial primary key,
	geom geometry(Point,4326),
	zec_id int,
	name character varying(200),
	phone character varying(50),
	owner character varying(100),
	"payment:cash" character(3),
	"payment:debit" character(3),
	"payment:cheque" character(3),
	"payment:visa" character(3),
	"payment:mastercard" character(3),
	"payment:american_express" character(3),
	"payment:paypal" character(3),
	website character varying(100),
	tourism character varying(25),
	description Text,
	service character varying(200),
	serv_loca character varying(150),
	serv_vente character varying
);

Insert into travail.accueils_zecs
(
	geom, zec_id, name, phone, owner, "payment:cash", "payment:debit", "payment:cheque","payment:visa","payment:mastercard","payment:american_express", "payment:paypal", website,
	tourism, description, service, serv_loca, serv_vente
)
select 	geom, zec_id, 'Accueil Zec ' || trim(both '' from nom_zec) || ' - Poste: ' || trim(both '' from nom_poste), trim(both '' from tel), trim(both '' from proprio),
		Case when arg_compt = '1' then 'yes' else 'no' end, case when interact = '1' then 'yes' else 'no' end, case when cheque = '1' then 'yes' else 'no' end,
		case when visa = '1' then 'yes' else 'no' end, case when mastercard = '1' then 'yes' else 'no' end, case when ame_expres = '1' then 'yes' else 'no' end,
		case when paypal = '1' then 'yes' else 'no' End,
		url, 'information', case when commentair is null then '' else trim(both '' from commentair) End, service, serv_loca, serv_vente
from	sources.accueils_zecs;

Update travail.accueils_zecs
	set	description = Case when description = '' then 'Services: ' || trim(both '' from service) else trim(both '' from description) || ' | ' || 'Services: ' || trim(both '' from service) End
where	service > '';

Update travail.accueils_zecs
	set	description = Case when description = '' then 'Vente: ' || trim(both '' from serv_Vente) else trim(both '' from description) || ' | ' || 'Vente: ' || trim(both '' from serv_vente) End
where	serv_vente > '';


Update travail.accueils_zecs
	set	description = Case when description = '' then 'Location: ' || trim(both '' from serv_loca) else trim(both '' from description) || ' | ' || 'Location: ' || trim(both '' from serv_loca) End
where	serv_loca > '';

drop table if exists accueils_zecs;
create table accueils_zecs (like travail.accueils_zecs including all);
insert into accueils_zecs select * from travail.accueils_zecs;
alter table accueils_zecs
	drop column id,
	drop column service,
	drop column serv_loca,
	drop column serv_vente,
	drop column zec_id;
	
update accueils_zecs set description = replace(description, E'\r\n',' ');
update accueils_zecs set description = replace(description, '///','|');
update accueils_zecs set description = replace(description, '"','');
drop table travail.accueils_zecs;


