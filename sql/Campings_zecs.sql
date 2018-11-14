/*
    QOSM - Québec OSM - Collection de scripts et de programmes pour générer une carte du Québec pour l'expéditionnisme, compatible avec l'application OsmAnd (https://osmand.net) à partir de données ouvertes.
    
    copyright (C) 2018  Eric Gagné, Lachine, Qc

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

update sources.campings_zecs
	set nom = '' where nom is null;

update sources.campings_zecs
	set nom_lac = '' where nom_lac is null;
	
Drop table if exists travail.campings_zecs;
Create table travail.campings_zecs
(
	geom geometry(point,4326),
	name character varying(100),
	capacity character varying(10),
	tents character varying(3),
	amenity character varying(250),
	description character varying(250),
	tourism character varying(10),
	water character(3),
	drinking_water character(10),
	website character varying(100),
	camp_site character varying(15),
	leisure character varying (100),
	toilette character varying(1),
	toiletteseche character varying(1),
	picnic character varying(1),
	firepit character varying(1),
	douche character varying(1)	
);
Insert into travail.campings_zecs
(
	geom, name, capacity, tents, amenity, description, tourism, water, drinking_water, website, camp_site, leisure, toilette, toiletteseche,picnic,firepit,douche
)
Select 	geom, 'Zec: ' || trim(both '' from nom_zec) || ' - Lac: ' || trim(both '' from nom_lac) || ' - Camping: ' || trim(both '' from nom),
		nb_emp_tot, case when emp_tente = 1 then 'yes' else '' End, '', '', 'camp_site', 
		case when eau in ('Non potable','Potable') then 'yes' else '' End,
		case 
			when eau = 'Potable' then 'yes'
			when eau = 'Non potable' then 'no'
			else 'unknown'
		End,
		url, 
		case 
			when ty_camping = 'Sauvage désigné' then 'basic'
			when ty_camping = 'Rustique' then 'Standard'
			when ty_camping = 'Aménagé' then 'Service'
		End,'',
		case when position('Toilette à eau courante' in servi_camp) > 0 then 'Y' else 'N' End,
		case when position('Toilette sèche' in servi_camp) > 0 then 'Y' else 'N' End,
		case when position('Table à pique-nique' in servi_camp) > 0 then 'Y' else 'N' End,
		case when position('Emplacement de feu' in servi_camp) > 0 then 'Y' else 'N' End,
		case when position('Douche' in servi_camp) > 0 then 'Y' else 'N' End
from sources.campings_zecs;

update travail.campings_zecs set amenity = '', leisure = '';

update travail.campings_zecs
	set amenity = 'toilets' where toilette = 'Y' or toiletteseche = 'Y';
	
update travail.campings_zecs
	set amenity = case when amenity = '' then 'shower' else trim(both '' from amenity) || ';shower' End where douche = 'Y';

update travail.campings_zecs
	set leisure = 'picnic_table' where picnic = 'Y';

update travail.campings_zecs
	set leisure = case when leisure = '' then 'firepit' else trim(both '' from leisure) || ';firepit' End where firepit = 'Y';
	
alter table travail.campings_zecs
	drop column toilette,
	drop column toiletteseche,
	drop column picnic,
	drop column firepit,
	drop column douche,
	drop column description;

drop table if exists campings_zecs;
create table campings_zecs (like travail.campings_zecs including all);
insert into campings_zecs select * from travail.campings_zecs;
drop table travail.campings_zecs;
