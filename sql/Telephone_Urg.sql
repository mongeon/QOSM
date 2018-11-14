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

Drop table if exists travail.telephone_urg;
create table travail.telephone_urg (like sources.telephone_urg including all);
insert into travail.telephone_urg select * from sources.telephone_urg;

Alter table travail.telephone_urg
	add column emergency character varying(10);
	

Alter table travail.telephone_urg rename column orgresp to operator;
alter table travail.telephone_urg rename column remarque to ref;

Update travail.telephone_urg set emergency = 'phone';
Update travail.telephone_urg set ref='' where ref is null;


drop table if exists telephone_urg;
create table telephone_urg (like travail.telephone_urg including all);
insert into telephone_urg select * from travail.telephone_urg;


Alter table telephone_urg
	drop column desclocal,
	drop column version,
	drop column idtelsec,
	drop column datdebappl,
	drop column datmaj,
	drop column peroperat,
	drop column norte,
	drop column dirrte,
	drop column desc_local,
	drop column rtss,
	drop column chainage,
	drop column emplacemen,
	drop column dt,
	drop column cs,
	drop column regadm,
	drop column regtourist,
	drop column nommun,
	drop column codemun,
	drop column desgmun,
	drop column longitude,
	drop column latitude,
	drop column datfinappl,
	drop column nomrte,
	drop column objectid,
    drop column ogc_fid;
	
drop table travail.telephone_urg;
