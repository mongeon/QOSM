/*
    QOSM - Québec OSM - Collection de scripts et de programmes pour générer une carte du Québec, compatible avec l'application OsmAnd (https://osmand.net) à partir de données ouvertes.
    
    Copyright (C) 2018  Eric Gagné, Lachine, Qc

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

drop table if exists sources.inmoa;

CREATE TABLE sources.inmoa
(
    nom_du_site_minier character varying COLLATE pg_catalog."default",
    lat double precision,
    lon double precision,
    statut_juridique character varying COLLATE pg_catalog."default",
    commodite character varying COLLATE pg_catalog."default",
    comm_code character varying COLLATE pg_catalog."default",
    type_de_mine character varying COLLATE pg_catalog."default",
    derniere_annee_operation character varying COLLATE pg_catalog."default"
);
COPY sources.inmoa FROM 'd:\qosm\sources\inmoa.csv' DELIMITERS ',' CSV HEADER ENCODING 'UTF8';
alter table sources.inmoa
	add column geom geometry(POINT, 4326);

Update sources.inmoa set lon = 0 - lon;
Update sources.inmoa
	set geom = ST_SetSRID(ST_MakePoint(lon, lat) ,4326);

drop table if exists sources.barrages;

CREATE TABLE sources.barrages
(
    no_barrage character varying COLLATE pg_catalog."default",
    nom_barrage character varying COLLATE pg_catalog."default",
    region_admi character varying COLLATE pg_catalog."default",
    mrc character varying COLLATE pg_catalog."default",
    mun character varying COLLATE pg_catalog."default",
    lat double precision,
    lon double precision,
    lat_a character varying COLLATE pg_catalog."default",
    lon_a character varying COLLATE pg_catalog."default",
    réservoir character varying COLLATE pg_catalog."default",
    territoire character varying COLLATE pg_catalog."default",
    amenagement character varying COLLATE pg_catalog."default",
    bassin character varying COLLATE pg_catalog."default",
    lac character varying COLLATE pg_catalog."default",
    cours_eau character varying COLLATE pg_catalog."default",
    cat_admin character varying COLLATE pg_catalog."default",
    utilisation character varying COLLATE pg_catalog."default",
    hauteur character varying,
    hauteur_de_retenue character varying,
    type_barrage character varying COLLATE pg_catalog."default",
    classe character varying COLLATE pg_catalog."default",
    zone_sismique character varying,
    superficie_bassin character varying,
    an_constr integer,
    an_mod integer,
    capacite bigint,
    longueur character varying,
    terrain_de_fondation character varying COLLATE pg_catalog."default",
    niveau_consequence character varying COLLATE pg_catalog."default",
    superficie_ha double precision,
    longueur_refoulement double precision,
    barrage_amont character varying COLLATE pg_catalog."default",
    barrage_aval character varying COLLATE pg_catalog."default",
    proprio_mandataire character varying COLLATE pg_catalog."default",
    adresse character varying COLLATE pg_catalog."default",
    code_postal character varying COLLATE pg_catalog."default",
    F1 character varying,
    F2 character varying,
    F3 character varying,
    F4 character varying,
    F5 character varying,
    F6 character varying COLLATE pg_catalog."default",
    F7 character varying,
	F8 character varying
);
COPY sources.barrages FROM 'd:\qosm\sources\barrages.csv' DELIMITERS ',' CSV HEADER ENCODING 'UTF8';
alter table sources.barrages
	add column geom geometry(POINT, 4326);

Update sources.barrages
	set geom = ST_SetSRID(ST_MakePoint(lon, lat) ,4326);
	
drop table if exists sources.accueils_zecs;

CREATE TABLE sources.accueils_zecs
(
	x numeric,
	y numeric,
	objectid bigint,
	id_poste bigint,
    zec_id bigint,
    nom_zec character varying(80) COLLATE pg_catalog."default",
    nom_poste character varying(93) COLLATE pg_catalog."default",
    date_inv character varying(80) COLLATE pg_catalog."default",
    longitude numeric,
    latitude numeric,
    tel character varying(80) COLLATE pg_catalog."default",
    principal bigint,
    appart_zec bigint,
    proprio character varying(80) COLLATE pg_catalog."default",
    commentair character varying COLLATE pg_catalog."default",
    se_rendre character varying COLLATE pg_catalog."default",
    an_invest character varying(80) COLLATE pg_catalog."default",
    invest character varying(80) COLLATE pg_catalog."default",
    accessibil character varying(80) COLLATE pg_catalog."default",
    arg_compt character varying(80) COLLATE pg_catalog."default",
    interact character varying(80) COLLATE pg_catalog."default",
    cheque character varying(80) COLLATE pg_catalog."default",
    visa character varying(80) COLLATE pg_catalog."default",
    mastercard character varying(80) COLLATE pg_catalog."default",
    ame_expres character varying(80) COLLATE pg_catalog."default",
    paypal character varying(80) COLLATE pg_catalog."default",
    no_sifz character varying(80) COLLATE pg_catalog."default",
    dat_ete_de character varying(80) COLLATE pg_catalog."default",
    dat_ete_fi character varying(80) COLLATE pg_catalog."default",
    hr_fer_ete character varying(80) COLLATE pg_catalog."default",
    auto_ete character varying(80) COLLATE pg_catalog."default",
    dat_cha_de character varying(80) COLLATE pg_catalog."default",
    dat_cha_fi character varying(80) COLLATE pg_catalog."default",
    hr_ouv_cha character varying(80) COLLATE pg_catalog."default",
    hr_fer_cha character varying(80) COLLATE pg_catalog."default",
    auto_cha character varying(80) COLLATE pg_catalog."default",
    dat_hor_de character varying(80) COLLATE pg_catalog."default",
    date_hor_f character varying(80) COLLATE pg_catalog."default",
    hr_ouv_hor character varying(80) COLLATE pg_catalog."default",
    hr_fer_hor character varying(80) COLLATE pg_catalog."default",
    auto_hor character varying(80) COLLATE pg_catalog."default",
    hor_com character varying COLLATE pg_catalog."default",
    hr_ouv_ete character varying(80) COLLATE pg_catalog."default",
    dist_chem character varying(80) COLLATE pg_catalog."default",
    last_user character varying(80) COLLATE pg_catalog."default",
    last_updat character varying(80) COLLATE pg_catalog."default",
    delete_fla character varying(80) COLLATE pg_catalog."default",
    service character varying(165) COLLATE pg_catalog."default",
    serv_loca character varying(104) COLLATE pg_catalog."default",
    serv_vente character varying COLLATE pg_catalog."default",
    recherche character varying(122) COLLATE pg_catalog."default",
    url character varying(80) COLLATE pg_catalog."default",
    photo character varying(80) COLLATE pg_catalog."default"
);
COPY sources.accueils_zecs FROM 'd:\qosm\sources\accueils_zecs.csv' DELIMITERS ',' CSV HEADER ENCODING 'UTF8';
alter table sources.accueils_zecs
	add column geom geometry(POINT, 4326);
	
Update sources.accueils_zecs
	set geom = ST_SetSRID(ST_MakePoint(longitude, latitude) ,4326);
	
drop table if exists sources.campings_zecs;
CREATE TABLE sources.campings_zecs
(
	x numeric,
	y numeric,	
	object_id bigint,
	id_camping bigint,
	nom character varying(80) COLLATE pg_catalog."default",
    zec_id bigint,
    lac_id bigint,
	longitude numeric,
	latitude numeric,
    emp_tente bigint,
    emp_court bigint,
    emp_saison bigint,
    emp_annuel bigint,
    nb_emp_tot bigint,
    dimensio_x numeric,
	dimensio_y numeric,
    commentair character varying COLLATE pg_catalog."default",
	an_invest character varying,
	investis character varying,
    type_milie character varying(80) COLLATE pg_catalog."default",
    eau character varying(80) COLLATE pg_catalog."default",
    accessibil character varying(80) COLLATE pg_catalog."default",
    type_fosse character varying(80) COLLATE pg_catalog."default",
    nom_zec character varying(80) COLLATE pg_catalog."default",
    nom_lac character varying(80) COLLATE pg_catalog."default",
	date_inv character varying,
	statut_sif character varying,
    canot_camp bigint,
	no_sizf character varying,	
	last_user character varying,
	last_update character varying,
	delete_flag character varying,
    veranda character varying(80) COLLATE pg_catalog."default",
    ty_camping character varying(80) COLLATE pg_catalog."default",
	sep_min character varying,
	sep_max character varying,
	sep_moy character varying,
	servi_camp character varying(118) COLLATE pg_catalog."default",
	recherche character varying,
	url character varying(80) COLLATE pg_catalog."default",
	photo character varying
);

COPY sources.campings_zecs FROM 'd:\qosm\sources\campings_zecs.csv' DELIMITERS ',' CSV HEADER ENCODING 'UTF8';
Update sources.campings_zecs 
	set longitude = 0-longitude where longitude > 0;
	
alter table sources.campings_zecs
	add column geom geometry(POINT, 4326);
	
Update sources.campings_zecs
	set geom = ST_SetSRID(ST_MakePoint(longitude, latitude) ,4326);
	



