--Select distinct  id, place, name, water, perimeter, ST_Y(Geom) Lat, ST_X(Geom) Lon from (Select (ST_DumpPoints(geom)).geom, id, place, name, water, perimeter from xareas where id = 3) as xaeras order by id
--select * from trq where  st_numinteriorrings(geom) > 0
--select ID,  st_numinteriorrings(geom) InnerRings, st_nrings(geom), st_y((ST_DumpPoints(geom)).geom) lat,st_x((ST_DumpPoints(geom)).geom) lon , (st_dumppoints(geom)).path[1], (st_dumppoints(geom)).path[2],(st_dumppoints(geom)).path[3] from aeroports_pistes


Drop table if exists postgis2osm;

Create table postgis2osm
(
	xmlline text,
	rowid serial primary key
);

Drop table if exists xNodes;
Drop table if exists xNodesTmp;
Create Temp Table xNodesTmp as
With cte as
(
	Select Distinct Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon from (Select (ST_DumpPoints(geom)).geom from aeroports) as aeroports
	union all
	Select Distinct Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon from (Select (ST_DumpPoints(geom)).geom from aeroports_pistes) as aeroports_pistes
	union all
	Select Distinct Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon from (Select (ST_DumpPoints(geom)).geom from aqcf) as aqcf
	union all
	Select Distinct Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon from (Select (ST_DumpPoints(geom)).geom from aqcfpn) as aqcfpn
	union all
	Select Distinct Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon from (Select (ST_DumpPoints(geom)).geom from aqrp) as aqrp
	union all
	Select Distinct Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon from (Select (ST_DumpPoints(geom)).geom from barrages) as barrages
	union all
	Select Distinct Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon from (Select (ST_DumpPoints(geom)).geom from electrique) as electrique
	union all
	Select Distinct Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon from (Select (ST_DumpPoints(geom)).geom from inmoa) as inmoa
	union all
	Select Distinct Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon from (Select (ST_DumpPoints(geom)).geom from parcroutier) as parcroutier
	union all
	Select Distinct Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon from (Select (ST_DumpPoints(geom)).geom from photoradar) as photoradar
	union all
	Select Distinct Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon from (Select (ST_DumpPoints(geom)).geom from telephone_urg) as telephone_urg
	union all
	Select Distinct Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon from (Select (ST_DumpPoints(geom)).geom from terres_autochtones) as terres_autochtones
	union all
	Select Distinct Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon from (Select (ST_DumpPoints(geom)).geom from villes) as villes
)
Select distinct Lat, Lon from cte;


Create Temp table xNodes as
select Lat, Lon, row_number() over(order by lat, lon) NodeID from xNodesTmp;

Alter table aeroports add column id serial primary key;
Alter table aqcf add column id serial primary key;
Alter table aqcfpn add column id serial primary key;
Alter table barrages add column id serial primary key;
Alter table inmoa add column id serial primary key;
Alter table photoradar add column id serial primary key;
Alter table telephone_urg add column id serial primary key;
Alter table villes add column id serial primary key;


drop table if exists xNodesTmp;

drop table if exists xNodesAttributes;
Create Temp Table xNodesAttributes as
Select 	aeroports.ID, 'aeroports' tblName, Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon,
		unnest(array['icao','aeroway','name','description']) as AttributeName,
		unnest(array[icao, aeroway, name, description]) as AttributeValue
From 	aeroports
union all
Select 	aqcfpn.ID, 'aqcfpn' tblName, Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon,
		unnest(array['railway','name']) as AttributeName,
		unnest(array[railway, name]) as AttributeValue
From 	aqcfpn
union all
Select 	barrages.ID, 'barrages' tblName, Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon,
		unnest(array['name','website','waterway','barrageno','height','length','capacity']) as AttributeName,
		unnest(array[name,website,waterway,barrageno,height,length,capacity]) as AttributeValue
From 	barrages
union all
Select 	inmoa.ID, 'inmoa' tblName, Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon,
		unnest(array['name','mineral','historic','description','website']) as AttributeName,
		unnest(array[name,mineral,historic,description,website]) as AttributeValue
From 	inmoa
union all
Select 	photoradar.ID, 'photoradar' tblName, Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon,
		unnest(array['web','highway']) as AttributeName,
		unnest(array[web,highway]) as AttributeValue
From 	photoradar
union all
Select 	telephone_urg.ID, 'telephone_urg' tblName, Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon,
		unnest(array['operator','ref','emergency']) as AttributeName,
		unnest(array[operator,ref,emergency]) as AttributeValue
From 	telephone_urg
union all
Select 	villes.ID, 'villes' tblName, Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon,
		unnest(array['name','place','population']) as AttributeName,
		unnest(array[name,place,population]) as AttributeValue
From 	villes;

insert into postgis2osm (xmlline)
Select '<?xml version="1.0" encoding="UTF-8"?>'
union all
Select '<osm version="0.6" generator="PostGIS2OSM">'
union all
Select	Concat('<bounds minlat="', min(lat), '" minlon="', min(lon), '" maxlat="', max(lat), '" maxlon="', max(lon), '"/>') from xnodes;

Drop table if exists  xNodesWithAttributes;
Create Temp Table xNodesWithAttributes as
select 	'1N' RecordType, NodeID, concat('<node id="', NodeID * -1, '" lat="', lat, '" lon="', lon, '"', Case when exists (Select 1 from xNodesAttributes where lon = xnodes.lon and lat = xnodes.lat) then '>' else '/>' End) xmlLine from xNodes
union all
select 	'2T' RecordType, xNodes.NodeID, Concat('   <tag k="', Trim(both '' from xNodesAttributes.AttributeName), '" v="', replace(xNodesAttributes.attributevalue,'&','&amp;'), '"/>')
from	xNodes
join	xNodesAttributes on xnodesattributes.lat = xnodes.lat and xnodesattributes.lon = xnodes.lon
Union all
Select  '3N' RecordType, NodeID, '</node>' 
from	 xNodes where exists (Select 1 from xNodesAttributes where lat = xnodes.lat and lon = xnodes.lon);

Insert into postgis2osm (xmlLine)
select xmlLine from xNodesWithAttributes order by nodeid, recordtype;

drop table if exists xWays;
Create Temp Table xWays as
with cte as
(
	Select id, Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon, Path, 'aqcf' tblname from
		(Select (ST_DumpPoints(geom)).geom, id, (st_dumppoints(geom)).path[1] Path from aqcf) as aqcf
	union all
	Select id, Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon, Path, 'aqrp' tblName from
		(Select (ST_DumpPoints(geom)).geom, id, (st_dumppoints(geom)).path[1] Path from aqrp) as aqrp
	union all
	Select id, Cast(ST_Y(Geom) as Numeric(10,7)) Lat, Cast(ST_X(Geom) as Numeric(10,7)) Lon, Path, 'electrique' tblname from
		(Select (ST_DumpPoints(geom)).geom, id, (st_dumppoints(geom)).path[1] Path from electrique) as electrique

)
select cte.id as ID, xNodes.NodeID, cte.path, dense_rank() over(order by cte.tblname, cte.id) as ID2, cte.tblname
from cte
join xNodes on xNodes.Lat = cte.Lat and xNodes.Lon = cte.Lon
order by id, Path;

drop table if exists xattributes;
create temp table xattributes as
Select 	aqrp.ID, 
		unnest(array['name','lanes','highway','junction','ref','tracktype','winter_road','bridge','barrier','surface','maxweight','maxspeed','access','description','website']) as AttributeName,
		unnest(array[name,lanes,highway,junction,ref,tracktype,winter_road,bridge,barrier,surface,maxweight,cast(maxspeed as varchar(10)),access,description,website]) as AttributeValue, 'aqrp' tblname, ID2
From 	aqrp
join 	xways x on x.ID = aqrp.ID and x.tblname = 'aqrp' and x.path = 1
union all
Select  aqcf.ID, 
		unnest(array['name','railway','usage']) as AttributeName,
		unnest(array[name,railway, usage]) as AttributeValue, 'aqcf' tblname, ID2
From 	aqcf
join 	xways x on x.ID = aqcf.ID and x.tblname = 'aqcf' and x.path = 1
union all
Select	electrique.ID, 	
		unnest(array['power']) as AttributeName,
		unnest(array[power]) as AttributeValue, 'electrique' tblname, ID2
From 	electrique
join 	xways x on x.ID = electrique.id and x.tblname = 'electrique' and x.Path = 1
;


drop table if exists alldata;
create temp table alldata as
Select	Distinct '1W' RecordType, ID2, 0 Node, 0 Path, cast('' as char(20)) AttributeName, Cast('' as char(20)) AttributeValue From xWays
union all
select	'2N', ID2, NodeID, Path,'','' from xWays
union all
Select distinct '4W', ID2, 0, 0,'','' from xWays
union all
select '3W', ID2, 0, 0, AttributeName, AttributeValue
from xAttributes
where AttributeValue is not null and AttributeValue != '';

insert into postgis2osm (xmlline) 
Select	
	case
		when recordtype = '1W' then '<way id="' || ID2 * -1 || '">'
		when recordtype = '2N' then '   <nd ref="' || node * -1 ||  '"/>'
		when recordtype = '3W' then '   <tag k="' || attributename || '" v="' || replace(attributevalue,'&','&amp;') || '"/>'
		when recordtype = '4W' then '</way>'
	End xmlline
From	alldata order by ID2, RecordType, Path;

insert into postgis2osm values ('</osm>');



Copy (Select xmlline from PostGIS2OSM order by RowID) to 'D:\OSMAnd\PostGIS2OSM.osm';

Drop table if exists xNodes;
drop table if exists xWays;
drop table if exists xattributes;
drop table if exists alldata;
