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

Drop table if exists travail.barrages cascade;
CREATE TABLE travail.barrages
(
	id serial primary key,
    geom geometry(Point,4326),
    name character varying(75),
    website character varying(75),
	waterway character varying(10),
	barrageno character varying(10),
	height character varying(10),
	length character varying(10),
	capacity character varying(25)
);

Insert into travail.barrages 
(
	geom, name, website, waterway, barrageno, height, length, capacity
)
select 	geom, Case when nom_barrage is null then no_barrage else nom_barrage End,
		'https://www.cehq.gouv.qc.ca/barrages/detail.asp?no_mef_lieu=' || trim(both '' from no_barrage),
		'dam', no_barrage, trim(both ' ' from cast(hauteur as char(10))) || ' m', trim(both ' ' from cast(longueur as char(10))) || ' m',
		trim(both ' ' from to_char(capacite, '999 999 999 999 999')) || ' m³'
from sources.barrages;

Drop table if exists barrages;
create table barrages (like travail.barrages including all);

Insert into barrages
(
	geom, name, website, waterway, height, length, capacity
)
select geom, name, website, waterway, height, length, capacity
from (
	select row_number() over (partition by barrageno) as r,t.* from travail.barrages t) x where x.r <= 1;
	
Alter table barrages
	drop column id;

drop table travail.barrages;