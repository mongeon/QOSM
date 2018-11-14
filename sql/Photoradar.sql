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

Drop table if exists travail.photoradar;
Create table travail.photoradar (like sources.photoradar including all);

insert into travail.photoradar select * from sources.photoradar;
Alter table travail.photoradar
	add column highway character varying(15);
Alter table travail.photoradar rename column urlimage to web;
Update travail.photoradar set highway = 'speed_camera';

Drop table if exists photoradar;
create table photoradar (like travail.photoradar including all);
Insert into photoradar select * from travail.photoradar;

alter table photoradar
	drop column ogc_fid,
	drop column region,
	drop column municipali,
	drop column arrondisse,
	drop column descriptio,
	drop column typeappare,
	drop column datedebuts;

drop table travail.photoradar;