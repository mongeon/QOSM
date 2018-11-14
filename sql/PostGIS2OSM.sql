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

/*
    Ne modifiez pas ce fichier
	Juste pour être clair, ça veut dire qu'il faut pas modifiez ce ficheir.
	Mais au cas ou ce serait toujours pas clair
	CE FICHIER NE DOIT PAS ÊTRE MODIFIÉ !
*/
-- S'assurer que toutes nos tables ont une colonne d'identification
Alter table accueils_zecs drop column if exists p2oid;
Alter table aeroports drop column if exists p2oid;
Alter table aeroports_pistes drop column if exists p2oid;
Alter table aqcf drop column if exists p2oid;
Alter table aqcfpn drop column if exists p2oid;
Alter table aqrp drop column if exists p2oid;
Alter table barrages drop column if exists p2oid;
Alter table campings_zecs drop column if exists p2oid;
Alter table electrique drop column if exists p2oid;
Alter table inmoa drop column if exists p2oid;
Alter table parcroutier drop column if exists p2oid;
Alter table photoradar drop column if exists p2oid;
Alter table telephone_urg drop if exists p2oid;
Alter table terres_autochtones drop column if exists p2oid;
Alter table tourisme drop if exists p2oid;
Alter table trq drop column if exists p2oid;
Alter table villes drop column if exists p2oid;

Alter table accueils_zecs add column p2oid serial primary key;
Alter table aeroports add column p2oid serial primary key;
Alter table aeroports_pistes add column p2oid serial primary key;
Alter table aqcf add column p2oid serial primary key;
Alter table aqcfpn add column p2oid serial primary key;
Alter table aqrp add column p2oid serial primary key;
Alter table barrages add column p2oid serial primary key;
Alter table campings_zecs add column p2oid serial primary key;
Alter table electrique add column p2oid serial primary key;
Alter table inmoa add column p2oid serial primary key;
Alter table parcroutier add column p2oid serial primary key;
Alter table photoradar add column p2oid serial primary key;
Alter table telephone_urg add p2oid serial primary key;
Alter table terres_autochtones add column p2oid serial primary key;
Alter table tourisme add p2oid serial primary key;
Alter table trq add column p2oid serial primary key;
Alter table villes add column p2oid serial primary key;


-- Supprimer et recréer notre table de données finales
Drop table if exists postgis2osm;

Create table postgis2osm
(
	xmlline text,
	rowid serial primary key
);

-- Créer une table contenant tous les noeuds de toutes les tables.
-- Dans un premier temps on les envoie dans une table temporaire.
-- Ensuite on les transfère dans une seconde en y ajoutant le nouveau id p2oid.
Drop table if exists xNodesTmp;
Create Temp Table xNodesTmp as
With cte as
(
    Select p2oid, tblname, Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon from (Select p2oid, 'accueils_zecs' tblname, (ST_DumpPoints(geom)).geom from accueils_zecs) as accueils_zecs
	union all
	Select p2oid, tblname, Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon from (Select p2oid, 'aeroports' tblname, (ST_DumpPoints(geom)).geom from aeroports) as aeroports
	union all
    Select p2oid, tblname, Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon from (Select p2oid, 'aqcfpn' tblname, (ST_DumpPoints(geom)).geom from aqcfpn) as aqcfpn
	union all
	Select p2oid, tblname, Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon from (Select p2oid, 'barrages' tblname, (ST_DumpPoints(geom)).geom from barrages) as barrages
	union all
	Select p2oid, tblname, Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon from (Select p2oid, 'campings_zecs' tblname, (ST_DumpPoints(geom)).geom from campings_zecs) as campings_zecs
	union all
	Select p2oid, tblname, Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon from (Select p2oid, 'inmoa' tblname, (ST_DumpPoints(geom)).geom from inmoa) as inmoa
	union all
	Select p2oid, tblname, Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon from (Select p2oid, 'parcroutier' tblname, (ST_DumpPoints(geom)).geom from parcroutier) as parcroutier
	union all
	Select p2oid, tblname,  Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon from (Select p2oid, 'photoradar' tblname, (ST_DumpPoints(geom)).geom from photoradar) as photoradar
	union all
	Select p2oid, tblname, Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon from (Select p2oid, 'telephone_urg' tblname, (ST_DumpPoints(geom)).geom from telephone_urg) as telephone_urg
	union all
 	Select p2oid, tblname, Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon from (Select p2oid, 'tourisme' tblname, (ST_DumpPoints(geom)).geom from tourisme) as tourisme
	union all
	Select p2oid, tblname, Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon from (Select p2oid, 'villes' tblname, (ST_DumpPoints(geom)).geom from villes) as villes
    union all
	Select p2oid, tblname, Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon from (Select p2oid, 'aqcf' tblname, (ST_DumpPoints(geom)).geom from aqcf) as aqcf
	union all
	Select p2oid, tblname, Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon from (Select p2oid, 'aqrp' tblname, (ST_DumpPoints(geom)).geom from aqrp) as aqrp
	union all
	Select p2oid, tblname, Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon from (Select p2oid, 'electrique' tblname, (ST_DumpPoints(geom)).geom from electrique) as electrique
	union all
    Select p2oid, tblname,  Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon from (Select p2oid, 'aeroports_pistes' tblname, (ST_DumpPoints(geom)).geom from aeroports_pistes) as aeroports_pistes
	union all
	Select p2oid, tblname,  Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon from (Select p2oid, 'terres_autochtones' tblname, (ST_DumpPoints(geom)).geom from terres_autochtones) as terres_autochtones
	union all
    Select p2oid, tblname,  Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon from (Select p2oid, 'trq' tblname, (ST_DumpPoints(geom)).geom from trq) as trq                                                                                                                                                      
)
Select tblname, p2oid, Lat, Lon from cte;

Drop table if exists xNodes;

Create Temp table xNodes as
select tblname, p2oid, Lat, Lon, row_number() over(order by lat, lon) NodeID from xNodesTmp;

drop index if exists ix_xNodes;
create index ix_xNodes on xNodes (p2oid, tblname, lat, lon);

    
-- On supprime ensuite la table temporaire
drop table if exists xNodesTmp;

-- Nous avons maintenant une table de tous les noeuds de toutes les tables contenant la latitude, la longitude et un ID unique.
-- Nous l'utiliserons plus tard pour créer la liste des noeuds dans le fichier .osm et les références dans toutes les lignes et polygones.

-- Création d'une dtable d'atributs pour les points.
-- Elle sera utilisé pour pivoter les colonnes et les ramener en rangées pour chaque noeud.

drop table if exists xNodesAttributes;
Create Temp Table xNodesAttributes as
Select 	accueils_zecs.p2oid, 'accueils_zecs' tblName, Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon,
		unnest(array['name','phone','owner','payment:cash','payment:debit','payment:cheque','payment:visa','payment:mastercard','payment:american_express','payment:paypal','website','tourism','description']) as AttributeName,
		unnest(array[name,phone,owner,"payment:cash","payment:debit","payment:cheque","payment:visa","payment:mastercard","payment:american_express","payment:paypal",website,tourism,description]) as AttributeValue
From 	accueils_zecs
union all
Select 	aeroports.p2oid, 'aeroports' tblName, Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon,
		unnest(array['icao','aeroway','name','description']) as AttributeName,
		unnest(array[icao, aeroway, name, description]) as AttributeValue
From 	aeroports
union all
Select 	aqcfpn.p2oid, 'aqcfpn' tblName, Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon,
		unnest(array['railway','name']) as AttributeName,
		unnest(array[railway, name]) as AttributeValue
From 	aqcfpn
union all
Select 	barrages.p2oid, 'barrages' tblName, Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon,
		unnest(array['name','website','waterway','barrageno','height','length','capacity']) as AttributeName,
		unnest(array[name,website,waterway,barrageno,height,length,capacity]) as AttributeValue
From 	barrages
union all
Select 	campings_zecs.p2oid, 'campings_zecs' tblName, Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon,
		unnest(array['name','capacity','tents','amenity','tourism','water','drinking_water','website','camp_site','leisure']) as AttributeName,
		unnest(array[name,capacity, tents, amenity, tourism, water, drinking_water, website, camp_site, leisure]) as AttributeValue
From 	campings_zecs
union all
Select 	inmoa.p2oid, 'inmoa' tblName, Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon,
		unnest(array['name','mineral','historic','description','website']) as AttributeName,
		unnest(array[name,mineral,historic,description,website]) as AttributeValue
From 	inmoa
union all
Select 	parcroutier.p2oid, 'parcroutier' tblName, Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon,
		unnest(array['name','description','caravan','toilets','picnic_table','drinking_water','fuel','telephone','man_made','leisure','charging_station','highway','tourism','information']) as AttributeName,
		unnest(array[name,description,caravan,toilets,picnic_table, drinking_water, fuel, telephone, man_made, leisure, charging_station, highway, tourism, information]) as AttributeValue
From 	parcroutier
union all
Select 	photoradar.p2oid, 'photoradar' tblName, Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon,
		unnest(array['web','highway']) as AttributeName,
		unnest(array[web,highway]) as AttributeValue
From 	photoradar
union all
Select 	telephone_urg.p2oid, 'telephone_urg' tblName, Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon,
		unnest(array['operator','ref','emergency']) as AttributeName,
		unnest(array[operator,ref,emergency]) as AttributeValue
From 	telephone_urg
union all
Select 	tourisme.p2oid, 'tourisme' tblName, Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon,
		unnest(array['name','description','addr:address1','addr:city','addr:province','addr:postcode','type','debut','fin','email','phone','website','facebook','twitter','internet_access','shower','tourism','amenity']) as AttributeName,
		unnest(array[name, description, "addr:address1","addr:city","addr:province","addr:postcode",type, debut, fin, email, phone, website, facebook, twitter, internet_access, shower, tourism, amenity]) as AttributeValue
From 	tourisme
union all
Select 	villes.p2oid, 'villes' tblName, Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon,
		unnest(array['name','place','population']) as AttributeName,
		unnest(array[name,place,population]) as AttributeValue
From 	villes;
                                                                                         
-- On peut maintenant commencer à créer les données pour notre fichier .osm
-- Il faut d'abord créer l'entête et spécifier les limites
insert into postgis2osm (xmlline)
Select '<?xml version="1.0" encoding="UTF-8"?>'
union all
Select '<osm version="0.6" generator="PostGIS2OSM">'
union all
Select	Concat('<bounds minlat="', min(lat), '" minlon="', min(lon), '" maxlat="', max(lat), '" maxlon="', max(lon), '"/>') from xnodes;

-- Et on est prêt pour commencer à y ajouter les données.
-- On commence par les noeuds.
-- On doit lire les données 3 fois et les unir pour créer la séquence <node><tag></node> mais il faut pouvoir les placer dans l'ordre après.
-- Pour le faire on utilise un type d'enregistrement (RecordType)
-- 1N = Noeud (Node)
-- 2T = Tag
-- 3N = Noeud
-- En triant par "RecordType" on pourra garder la séquence <node><tag></node>

Drop Index if exists ix_xNodesAttr;
Create index ix_xNodesAttr on xNodesAttributes (p2oid, tblname, lat,lon);

Drop table if exists  xNodesWithAttributes;
Create Temp Table xNodesWithAttributes as
select 	'1N' RecordType, NodeID, concat('   <node id="', NodeID * -1, '" lat="', lat, '" lon="', lon, '"', 
        Case when exists (Select 1 from xNodesAttributes where p2oid = xnodes.p2oid and tblname = xnodes.tblname) then '>' else '/>' End) xmlLine 
from    xNodes
union all
select 	'2T' RecordType, xNodes.NodeID, Concat('      <tag k="', Trim(both '' from xNodesAttributes.AttributeName), '" v="', 
        replace(xNodesAttributes.attributevalue,'&','&amp;'), '"/>')
from	xNodes
join	xNodesAttributes on xnodesattributes.p2oid = xnodes.p2oid and xnodesattributes.tblname = xnodes.tblname and xnodesattributes.lat = xnodes.lat and
        xnodesattributes.lon = xnodes.lon
Union all
Select  '3N' RecordType, NodeID, '   </node>' 
from	 xNodes where exists (Select 1 from xNodesAttributes where p2oid = xnodes.p2oid and tblname = xnodes.tblname);

-- Nos noeuds sont maintenant prêts à être ajoutés à la table de données finales.
Drop index if exists ix_xNodesWithAttr;
Create index ix_xNodesWithAttr on xNodesWithAttributes (NodeID, RecordType);
Insert into
        postgis2osm (xmlLine)
select  xmlLine
from    xNodesWithAttributes 
order   by nodeid, recordtype;

-- Et on recommence pour les lignes.
-- Le processus est un peu plus compliqué parce que contrairement aux points, nous avons plusieurs noeuds pour créer une ligne et nous devons être en mesure de les garder en groupe
-- pour chaque ligne.
-- Il faut donc inclure le nom de la table d'origine (tblname) dans notre table temporaire (xWays)


drop table if exists xWays;
Create Temp Table xWays as
with cte as
(
	Select p2oid, Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon, Path, 'aqcf' tblname from
		(Select (ST_DumpPoints(geom)).geom, p2oid, (st_dumppoints(geom)).path[1] Path from aqcf) as aqcf
    union all
	Select p2oid, Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon, Path, 'aqrp' tblName from
		(Select (ST_DumpPoints(geom)).geom, p2oid, (st_dumppoints(geom)).path[1] Path from aqrp) as aqrp
	union all
	Select p2oid, Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon, Path, 'electrique' tblname from
    (Select (ST_DumpPoints(geom)).geom, p2oid, (st_dumppoints(geom)).path[1] Path from electrique) as electrique
)
select  cte.p2oid as p2oid, xNodes.NodeID, cte.path, dense_rank() over(order by cte.tblname, cte.p2oid) as ID2, cte.tblname
from    cte
join    xNodes on xNodes.p2oid = cte.p2oid and xNodes.tblname = cte.tblname and xNodes.Lat = cte.Lat and xNodes.Lon = cte.Lon 
order by p2oid, Path;

-- Traitement des attributs des lignes

drop table if exists xwayattributes;
create temp table xwayattributes as
Select 	aqrp.p2oid, 
		unnest(array['name','lanes','highway','junction','ref','tracktype','winter_road','bridge','barrier','surface','maxweight','maxspeed','access','description','website']) as AttributeName,
		unnest(array[name,lanes,highway,junction,ref,tracktype,winter_road,bridge,barrier,surface,maxweight,cast(maxspeed as varchar(10)),access,description,website]) as AttributeValue, 'aqrp' tblname, ID2
From 	aqrp
join 	xways x on x.p2oid = aqrp.p2oid and x.tblname = 'aqrp' and x.path = 1
union all
Select  aqcf.p2oid, 
		unnest(array['name','railway','usage']) as AttributeName,
		unnest(array[name,railway, usage]) as AttributeValue, 'aqcf' tblname, ID2
From 	aqcf
join 	xways x on x.p2oid = aqcf.p2oid and x.tblname = 'aqcf' and x.path = 1
union all
Select	electrique.p2oid, 	
		unnest(array['power']) as AttributeName,
		unnest(array[power]) as AttributeValue, 'electrique' tblname, ID2
From 	electrique
join 	xways x on x.p2oid = electrique.p2oid and x.tblname = 'electrique' and x.Path = 1
;

-- Comme nous l'avons fait plus haut pour les points, il faut maintenant mettre toutes les données en ordre avant de les ajouter à notre table de données finales.
-- On utilise encore un type d'enregistrement (RecordType)
drop table if exists alldata;
create temp table alldata as
Select	Distinct '1W' RecordType, ID2, 0 Node, 0 Path, cast('' as char(20)) AttributeName, Cast('' as char(20)) AttributeValue 
From xWays
union all
select	'2N', ID2, NodeID, Path,'','' from xWays
union all
Select distinct '4W', ID2, 0, 0,'','' from xWays
union all
select '3W', ID2, 0, 0, AttributeName, Replace(AttributeValue, '&','&amp;')
from xWayAttributes
where AttributeValue is not null and AttributeValue != '';

Drop index if exists ix_alldata;
Create index ix_alldata on AllData (ID2, RecordType, Path);
insert into postgis2osm (xmlline) 
Select	
	case
		when recordtype = '1W' then '<way id="' || ID2 * -1 || '">'
		when recordtype = '2N' then '   <nd ref="' || node * -1 ||  '"/>'
		when recordtype = '3W' then '   <tag k="' || attributename || '" v="' || trim(both '' from attributevalue) || '"/>'
		when recordtype = '4W' then '</way>'
	End xmlline
From	alldata order by ID2, RecordType, Path;


-- A la prochaine étape nous allons ajouter les polygones.
-- Comme ils sont aussi contenus dans des tags <way> comme les lignes il faut poursuivre la séquences des ID
-- Ici on crée une table avec un seul enregistrement et une seule colonne dans laquelle on place la plus grande valeur ID que nous avons pour les lignes.
-- Cette valeur sera ajoutée aux ID que nous calculerons pour les polygones

drop table if exists MaxWayID;
Select  Max(ID2) as MaxWayID
into    MaxWayID
from    xWays;

-- On passe maintenant au traitement des polygones.
-- Puisque nos géométries sont des multi-polygones, il faut d'abord extraire les noeuds de chacun des polygones intérieurs.
-- On les place d'abord dans une table temporaire contenant leur po2id, le nom de la table, les latitudes et longitudes et les
-- valeur des path

Drop table if exists xTempArea;
Create Temp Table xTempArea as

select  distinct p2oID, 'aeroports_pistes' tblName,
        st_y((ST_DumpPoints(geom)).geom) lat,
        st_x((ST_DumpPoints(geom)).geom) lon,
        (st_dumppoints(geom)).path[1] p1,
        (st_dumppoints(geom)).path[2] p2,
        (st_dumppoints(geom)).path[3] p3
from    aeroports_pistes

union all
select  distinct p2oID, 'terres_autochtones' tblName,
        st_y((ST_DumpPoints(geom)).geom) lat,
        st_x((ST_DumpPoints(geom)).geom) lon,
        (st_dumppoints(geom)).path[1] p1,
        (st_dumppoints(geom)).path[2] p2,
        (st_dumppoints(geom)).path[3] p3
from    terres_autochtones
union all
select  distinct p2oID, 'trq' as tblname,
        st_y((ST_DumpPoints(geom)).geom) lat,
        st_x((ST_DumpPoints(geom)).geom) lon,
        (st_dumppoints(geom)).path[1] p1,
        (st_dumppoints(geom)).path[2] p2,
        (st_dumppoints(geom)).path[3] p3
from    trq
;


-- On crée maintenant une table contenant une liste de tous nos polygones
Drop table if exists xAreas;
with cte as (
    select  distinct
            p2oid OriginalID, tblname, p1
    from    xTempArea
)
select  originalID, tblname, row_number() over(order by tblname, ORiginalID, p1) p2oID, p1
into    xAreas
from    cte
order by tblName, OriginalID, p1;

-- Et on prépare les attributs pour les polygones comme précédemment pour les points et les lignes.
Drop table if exists xareaattributes;
create temp table xareaattributes as
Select 	aeroports_pistes.p2oid, 
		unnest(array['icao','name','surface','aeroway','length','ele']) as AttributeName,
		unnest(array[icao, name, surface, aeroway, length, ele]) as AttributeValue, 'aeroports_pistes' tblname, originalid
From 	aeroports_pistes
join 	xareas x on x.originalID = aeroports_pistes.p2oid and x.tblname = 'aeroports_pistes'

union all
Select  terres_autochtones.p2oid, 
		unnest(array['name','boundary','admin_level']) as AttributeName,
		unnest(array[name,boundary,admin_level]) as AttributeValue, 'terres_autochtones' tblname, originalID
From 	terres_autochtones
join 	xareas x on x.originalID = terres_autochtones.p2oid and x.tblname = 'terres_autochtones'
union all
Select	trq.p2oid, 	
		unnest(array['name','boundary','leisure','protection_title']) as AttributeName,
		unnest(array[name,boundary,leisure,protection_title]) as AttributeValue, 'trq' tblname, originalid
From 	trq
join 	xareas x on x.originalid = trq.p2oid and x.tblname = 'trq'
;

drop index if exists ix_xTempArea;
drop index if exists ix_xareaAttr;

create index ix_xTempArea on xTempArea (p2oid, tblname);
Create index ix_xAreaAttr on xAreaAttributes(tblname, originalid);


Drop table if exists AllAreaData;

Create Temp Table AllAreaData as
Select  distinct '1W' RecordType, 0 as Node, tblname, p2oid + (Select MaxWayID from MaxWayID) as p2oid, p1, 0 p2, originalID, ' ' AreaType, '' AttributeName, '' AttributeValue
from    xareas 
union all
select  distinct '2N0',  0-n.nodeid, a.tblname, a.p2oid + (Select MaxWayID from MaxWayID) as p2oid, a.p1, b.p2, a.originalid, ' ' AreaType,'',''
from    xareas a
join    xtemparea b on b.p2oid = a.originalid and b.tblname = a.tblname and b.p1 = a.p1
join    xNodes n on n.p2oid = a.originalid and n.tblname = a.tblname and n.lat = Cast(b.lat as numeric(10,7)) and n.lon = cast(b.lon as numeric(10,7))
union all
select  distinct '3T1', 0, tblname, p2oid + (Select MaxWayID from MaxWayID) as p2oid, p1, 0, originalid, ' ' AreaType,'',''
from    xAreas a
union all
select  distinct '3T2', 0, a.tblname, a.p2oid + (Select MaxWayID from MaxWayID) as p2oid, a.p1, 0, a.originalid, ' ' AreaType, attributename, Replace(attributevalue,'&','&amp;')
from    xAreas a
join    xAreaAttributes b on b.tblname = a.tblname and b.originalid = a.originalid 
union all
select  distinct '4W', 0, tblname, p2oid + (Select MaxWayID from MaxWayID) as p2oid, p1, 0, originalid, ' ' AreaType,'',''
from    xAreas;

Drop index if exists ix_allAreaData;
Create index ix_AllAreaDAta on AllAreaData (tblname, originalID, p2oid, recordtype, p1, p2);

 
-- Avant de poursuivre nous devons identifier les polygones simples pour pouvoir leur ajouter le tag "area=yes"

Drop table if exists xSingleAreas;

Create temp table xSingleAreas as
Select  Distinct OriginalID, tblname
From    xAreas
Group by OriginalID, tblname
Having count(*)  = 1;

Drop index if exists ix_SingleAreas;
Create index ix_SingleAreas on xSingleAreas(OriginalID);

-- Et on les flag dans notre table AllAreaData

Update  AllAreaData as z
   set  AreaType = 'S'
from    xSingleAreas y
where   z.originalID = y.OriginalID and z.tblname = y.tblname;

insert into postgis2osm (xmlline) 
Select	
	case
		when recordtype = '1W' then  '   <way id="' || p2oid * -1 || '">'
		when recordtype = '2N0' then '      <nd ref="' || Cast(node as character varying) ||  '"/>'
		when recordtype = '3T1' then  '      <tag k="area" v="yes"/>'
        when recordtype = '3T2' then  '      <tag k="' || trim(both '' from attributename) || '" v="' || trim(both '' from attributevalue) || '"/>'
		when recordtype = '4W' then  '   </way>'
	End xmlline
From	AllAreaData
where  (recordType != '3T1' or (RecordType = '3T1' and AreaType = 'S')) and (recordType != '3T2' or (RecordType = '3T2' and AreaType = 'S'))
order by tblname, originalID, p2oid, recordtype, p1, p2;

                                                                    
-- Il ne nous reste qu'à créer les relations.

-- D'abord il faut faire une liste des polygones qui ont des cercles internes.
-- Il suffit d'extraire les enregistrements de xAreas qui ont plusieurs "originalID"

Drop table if exists xTempRelations;

Create Temp table xTempRelations as
Select  Distinct tblname, OriginalID
From    xAreas
Group by tblname, OriginalID
Having count(*)  > 1;


-- On peut maintenant créer nos relations.

Drop table if exists xRelations;

Create temp table xRelations as
Select  tblname, OriginalID, row_number() over(order by originalid,tblname) p2oid
From    xTempRelations
order by tblname, originalID;

Drop Table if exists AllRelationsData;

Create Temp Table AllRelationsData as
Select  '1' RecordType, OriginalID, p2oid as RelationID, 0 RefID, 0 p1,'' attributename, '' attributevalue
From    xRelations
Union all
Select  '2a' Recordtype, OriginalID, p2oid as RelationID, 0 RefID, 0 p1,'',''
From    xRelations
Union all
Select  distinct '2b' Recordtype, a.OriginalID, a.p2oid as RelationID, 0 RefID, 0 p1, c.attributename, c.attributevalue
From    xRelations a
join    xareas b on b.originalid = a.originalid and b.tblname = a.tblname
join    xareaattributes c on c.tblname = b.tblname and c.originalid = b.originalid
where   c.attributevalue is not null and c.attributevalue != ''
Union all
Select  '3' RecordType, a.OriginalID, a.p2oid as Relationid, b.p2oid + (Select MaxWayID from MaxWayID) as RefID, b.p1,'',''
from    xRelations a
join    xAreas b on b.OriginalID = a.OriginalID and b.tblname = a.tblname
union all
Select  '4' RecordType, OriginalID, p2oid as RelationID, 0 RefID, 0 p1,'',''
From    xRelations;

Insert into  postgis2osm (xmlline)
Select
    Case
        when RecordType = '1' then '   <relation id="' || Cast(0-RelationID as character varying) || '">'
        when RecordType = '2a' then '      <tag k="type" v="multipolygon" />'
        when RecordType = '2b' then '      <tag k="' || trim(both '' from attributename) || '" v="' || trim(both '' from Replace(attributevalue,'&','&amp;')) || '"/>'
        when RecordType = '3' then '      <member type="way" ref="' || Cast(0-RefID as character varying) || 
            Case 
                when p1 = 1 then '" role="outer"/>'
                else '" role="inner"/>'
            End
        when recordType = '4' then '   </relation>'
    End
From    AllRelationsData
order by RelationID, originalid, recordtype, refid;

insert into postgis2osm values ('</osm>');
\Copy (Select xmlline from PostGIS2OSM order by RowID) to '/mnt/d/osmand/qosm.osm';

drop table if exists xnodestmp;
drop table if exists xnodes;
drop table if exists xnodesattributes;
drop table if exists xnodeswithattributes;
drop table if exists xways;
drop table if exists xwayattributes;
drop table if exists alldata;
drop table if exists maxwayid;
drop table if exists xtemparea;
drop table if exists xareas;
drop table if exists allareadata;
drop table if exists xsingleareas;
drop table if exists xtemprelations;
drop table if exists xrelations;
drop table if exists allrelationsdata;
drop table if exists PostGIS2OSM;
