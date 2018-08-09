/*
    QOSM - Québec OSM - Collection de scripts et de programmes pour générer une carte du Québec, compatible avec l'application OsmAnd (https://osmand.net) à partir de données ouvertes.
    
    Copyright (C) 2018  Eric Gagné, Lachine, Qc

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

Drop table if exists travail.inmoa;
create table travail.inmoa (like sources.inmoa including all);
insert into travail.inmoa select * from sources.inmoa;
alter table travail.inmoa rename column nom_du_site_minier to name;
alter table travail.inmoa rename column commodite to mineral;
alter table travail.inmoa
	add column historic character varying(5),
	add column description character varying(128),
	add column website character varying(128);
update travail.inmoa set type_de_mine = 'Souterraine' where type_de_mine = 'Souterrainee';
Update travail.inmoa set derniere_annee_operation = 'n/a' where derniere_annee_operation is null;
update travail.inmoa set type_de_mine = 'n/a' where type_de_mine is null or type_de_mine = 'NULL';
Update travail.inmoa set  
	historic = 'mine',
	description = 'Type: ' || trim(both '' from type_de_mine) || '. Fermée en ' || derniere_annee_operation ||
	'. Minerai: ' || 
	case 
		when mineral = 'PHOSPHATE' then 'Phosphate.'
		when mineral = 'GARNET' then 'Grenat.'
		when mineral = 'LITHIUM' then 'Lithium.'
		when mineral = 'COPPER' then 'Cuivre.'
		when mineral = 'PYRITE' then 'Pyrite.'
		when mineral = 'ZINC' then 'Zinc.'
		when mineral = 'ANTIMONY' then 'Antimoine.'
		when mineral = 'FELDSPAR' then 'Feldspath.'
		when mineral = 'MICA' then 'Mica.'
		when mineral = 'URANIUM' then 'Uranium.'
		when mineral = 'TUNGSTEN' then 'Tungstène.'
		when mineral = 'NICKEL' then 'Nickel.'
		when mineral = 'BISMUTH' then 'Bismuth.'
		when mineral = 'GOLD' then 'Or.'
		when mineral = 'LEAD' then 'Plomb.'
		when mineral = 'TALC' then 'Talc.'
		when mineral = 'ASBESTOS' then 'Amiante.'
		when mineral = 'CHROMIUM' then 'Chrome.'
		when mineral = 'MOLYBDENUM' then 'Molybène.'
		when mineral = 'SILVER' then 'Argent.'
		when mineral = 'QUARTZITE' then 'Quartzite.'
		when mineral = 'GRAPHITE' then 'Graphite.'
		when mineral = 'IRON' then 'Fer.'
		when mineral = 'SILICA' then 'Silice.'
		when mineral = 'NOBIUM' then 'Nobium.'
		else 'Inconnu.'
	End,
	website = 'https://www.google.com/maps/@?api=1&map_action=map&center=' || trim(both '' from cast(lat as character varying(10))) || ',' ||
		 trim(both '' from cast(lon as character varying(10))) || '&basemap=satellite&zoom=16';

drop table if exists inmoa;
create table inmoa (like travail.inmoa including all);
insert into inmoa select * from travail.inmoa;

alter table inmoa
	drop column lat,
	drop column lon,
	drop column statut_juridique,
	drop column comm_code,
	drop column type_de_mine,
	drop column derniere_annee_operation;

drop table travail.inmoa;
