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

drop table if exists travail.villes;
create table travail.villes (like sources.villes including all);
insert into travail.villes select * from sources.villes;
alter table travail.villes
	drop column mus_nm_mun,
	drop column objectid00,
	drop column reprsntgra,
	drop column codexcpt,
	drop column mrcindex,
	drop column localstn,
	drop column mus_co_geo,
	drop column mus_de_ind,
--	drop column classpop,
	drop column categorie,
	drop column commntr,
	drop column longitude_,
	drop column longitude,
	drop column latitude,
	drop column version,
	drop column mus_co_des,
    drop column ogc_fid,
    drop column objectid;

alter table travail.villes
	rename column typentitto to place;
	
alter table travail.villes
	rename column nomcartrou to name;
	
alter table travail.villes
	rename column popdecrt to population;

Update travail.villes
	set place = 'town';
	
update travail.villes
	set place = 'village' where classpop = '1';

alter table travail.villes 
	drop column classpop;

drop table if exists villes;
create table villes (like travail.villes including all);
insert into villes select * from travail.villes;
drop table if exists travail.villes;

