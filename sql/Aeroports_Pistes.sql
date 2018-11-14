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

Update sources.aeroports_pistes set nomnavcana = 'Dolbeau-Mistassini/Potvin Héli-Base (héli.)' where codeindic = 'CPH4';
update sources.aeroports_pistes set nomnavcana = 'Dolbeau-Saint-Félicien' where codeindic = 'CYDO';
update sources.aeroports_pistes set nomnavcana = 'Montréal/Sacré-Coeur (héli.)' where codeindic = 'CSZ8';

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
Create table aeroports_pistes
(
    icao character varying,
    name character varying,
    surface character varying,
    aeroway character varying,
    length character varying,
    ele character varying,
    geom geometry(polygonz, 4326)
);

insert into aeroports_pistes
(
    icao, name, surface, aeroway, length, ele, geom
)
select  icao, name, surface, aeroway, length, ele, (st_dump(geom)).geom
from    travail.aeroports_pistes;

drop table travail.aeroports_pistes;