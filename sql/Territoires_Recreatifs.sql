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
create table trq (like travail.trq including all);

insert into trq
	select * from travail.trq;

drop table travail.trq;