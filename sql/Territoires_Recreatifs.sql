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

Drop table if exists travail.trq;
Create Table travail.trq
(
    geom geometry(MultiPolygonZ,4326),
    name character varying,
    boundary character varying,
    leisure character varying,
    protection_title character varying
);


Insert into travail.trq
(
	geom, name, boundary, leisure, protection_title
)
Select geom, trq_nm_ter, 'protected_area','fishing','' from sources.zecs
union all
Select geom, trq_nm_ter, 'national_park', 'nature_reserve', '' from sources.parcs_nationaux_canada
union all
select geom, trq_nm_ter, 'national_park',  'nature_reserve', '' from sources.parcs_nationaux_quebec
union all
select geom, trq_nm_ter, 'regional_park', 'nature_reserve', 'national_park' from sources.parcs_regionaux
union all
select geom, trq_nm_ter, 'protected_area','fishing','' from sources.pourvoiries
union all
select geom, trq_nm_ter, 'protected_area', 'nature_reserve','' from sources.refuges_oiseaux_migrateurs
union all
select geom, trq_nm_ter, '', 'nature-reserve','' from sources.reserves_naturelles_faune
union all
select geom, trq_nm_ter, 'protected_area', 'nature_reserve', '' from sources.reserves_fauniques;

drop table if exists trq;
Create table trq
(
    name character varying,
    boundary character varying,
    leisure character varying,
    protection_title character varying,
    geom geometry(polygonz,4326)
);

Insert into trq
(
    name,
    boundary,
    leisure,
    protection_title,
    geom
)
Select  name, boundary, leisure, protection_title, (st_dump(geom)).geom
from    travail.trq;
drop table travail.trq;