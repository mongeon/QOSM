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

