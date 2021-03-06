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

drop table if exists sources.tourisme;

CREATE TABLE sources.tourisme
(
    geom geometry(Point,4326),
    name character varying,
    description character varying,
    "addr:address1" character varying,
    "addr:city" character varying,
    "addr:province" character varying,
    "addr:postcode" character varying,
    lat double precision,
    lon double precision,
    type character varying,
    debut character varying,
    fin character varying,
    email character varying,
    phone character varying,
    website character varying,
    facebook character varying,
    twitter character varying,
    internet_access character varying,
    picnic character varying,
    distributrice character varying,
    shower character varying,
    atm character varying,
    publicphone character varying,
    tourism character varying,
    amenity character varying,
    etablissement_id int,
    etbl_id int
);

insert into sources.tourisme
(
    name, description, "addr:address1","addr:city","addr:province","addr:postcode",lat, lon, type, email, phone, website, facebook, twitter, etablissement_id, etbl_id, amenity, tourism
)
select  etbl_nom_fr, etbl_desc_fr,adr_civique, adr_municipalite, adr_province, adr_code_postal, cast(adr_latitude as double precision), cast(adr_longitude as double precision), etbl_type_fr, 
        email.cntct_val_fr, phone.cntct_val_fr, web.cntct_val_fr, fb.cntct_val_fr, tw.cntct_val_fr, e.etablissement_id, e.etbl_id, '', 'information'
from    sources.etablissement e
join    sources.etbl_adresses adrs on adrs.etablissement_id = e.etablissement_id
join    sources.etbl_adresse adr on adr.adresses_id = adrs.adresses_id
join    sources.etbl_types types on types.etablissement_id = e.etablissement_id
join    sources.etbl_type type on type.etbl_types_id = types.etbl_types_id
left outer join
        sources.etbl_contacts contacts on contacts.etablissement_id = e.etablissement_id
left outer join
        sources.etbl_contact email on email.contacts_id = contacts.contacts_id and email.cntcg_genre_id = '1165410'
left outer join
        sources.etbl_contact phone on phone.contacts_id = contacts.contacts_id and phone.cntcg_genre_id = '1165404'
left outer join
        sources.etbl_contact web on web.contacts_id = contacts.contacts_id and web.cntcg_genre_id = '1165412'
left outer join
        sources.etbl_contact fb on fb.contacts_id = contacts.contacts_id and fb.cntcg_genre_id = '253822562'
left outer join
        sources.etbl_contact tw on tw.contacts_id = contacts.contacts_id and tw.cntcg_genre_id = '253822565'
;

update  sources.tourisme 
    set geom = ST_SetSRID(ST_MakePoint(lon, lat) ,4326);

update  sources.tourisme
    set internet_access = 'wlan'
where   exists (
        select  1
        from    sources.etbl_caracteristiques a
        join    sources.etbl_caracteristique b on b.caracteristiques_id = a.caracteristiques_id
        join    sources.etbl_attributs c on c.caracteristique_id = b.caracteristique_id
        join    sources.etbl_attribut d on d.caract_attributs_id = c.caract_attributs_id and d.caract_attrib_id = '364299662'
        where   a.etablissement_id = sources.tourisme.etablissement_id
        );

update  sources.tourisme
    set picnic = 'yes'
where   exists (
        select  1
        from    sources.etbl_caracteristiques a
        join    sources.etbl_caracteristique b on b.caracteristiques_id = a.caracteristiques_id
        join    sources.etbl_attributs c on c.caracteristique_id = b.caracteristique_id
        join    sources.etbl_attribut d on d.caract_attributs_id = c.caract_attributs_id and d.caract_attrib_id = '1194965'
        where   a.etablissement_id = sources.tourisme.etablissement_id
        );

update  sources.tourisme
    set distributrice = 'yes'
where   exists (
        select  1
        from    sources.etbl_caracteristiques a
        join    sources.etbl_caracteristique b on b.caracteristiques_id = a.caracteristiques_id
        join    sources.etbl_attributs c on c.caracteristique_id = b.caracteristique_id
        join    sources.etbl_attribut d on d.caract_attributs_id = c.caract_attributs_id and d.caract_attrib_id = '1492639'
        where   a.etablissement_id = sources.tourisme.etablissement_id
        );
 
update  sources.tourisme
    set shower = 'yes'
where   exists (
        select  1
        from    sources.etbl_caracteristiques a
        join    sources.etbl_caracteristique b on b.caracteristiques_id = a.caracteristiques_id
        join    sources.etbl_attributs c on c.caracteristique_id = b.caracteristique_id
        join    sources.etbl_attribut d on d.caract_attributs_id = c.caract_attributs_id and d.caract_attrib_id = '8659960'
        where   a.etablissement_id = sources.tourisme.etablissement_id
        );

update  sources.tourisme
    set atm = 'yes'
where   exists (
        select  1
        from    sources.etbl_caracteristiques a
        join    sources.etbl_caracteristique b on b.caracteristiques_id = a.caracteristiques_id
        join    sources.etbl_attributs c on c.caracteristique_id = b.caracteristique_id
        join    sources.etbl_attribut d on d.caract_attributs_id = c.caract_attributs_id and d.caract_attrib_id = '1268985'
        where   a.etablissement_id = sources.tourisme.etablissement_id
        );
  
update  sources.tourisme
    set publicphone = 'yes'
where   exists (
        select  1
        from    sources.etbl_caracteristiques a
        join    sources.etbl_caracteristique b on b.caracteristiques_id = a.caracteristiques_id
        join    sources.etbl_attributs c on c.caracteristique_id = b.caracteristique_id
        join    sources.etbl_attribut d on d.caract_attributs_id = c.caract_attributs_id and d.caract_attrib_id = '10601'
        where   a.etablissement_id = sources.tourisme.etablissement_id
        );
  
 
 

drop table if exists travail.tourisme;
create table travail.tourisme (like sources.tourisme including all);
insert into travail.tourisme select * from sources.tourisme;


alter table travail.tourisme
	drop column lat,
	drop column lon,
    drop column etablissement_id,
    drop column etbl_id;
    

update travail.tourisme
	set amenity = 'vending_machine' where distributrice = 'yes';
	
Update travail.tourisme
	set amenity = Case when amenity = '' then 'shower' else trim(both '' from amenity) || ';shower' End---
	where shower = 'yes';

update travail.tourisme
	set amenity = CAse when amenity = '' then 'atm' else trim(both '' from amenity) || ';atm' End
	where atm = 'yes';

update travail.tourisme
	set amenity = Case when amenity = '' then 'telephone' else trim(both '' from amenity) || ';telephone' End
	where publicphone = 'yes';

alter table travail.tourisme
	drop column picnic,
	drop column atm,
	drop column publicphone,
	drop column distributrice;
	
drop table if exists tourisme;

create table tourisme (like travail.tourisme including all);
insert into tourisme select * from travail.tourisme;

drop table if exists travail.tourisme;
drop table if exists sources.etablissement;
drop table if exists sources.etbl_type;
drop table if exists sources.etbl_types;
drop table if exists sources.etbl_contact;
drop table if exists sources.etbl_contacts;
drop table if exists sources.etbl_attribut;
drop table if exists sources.etbl_attributs;
drop table if exists sources.etbl_caracteristique;
drop table if exists sources.etbl_caracteristiques;
drop table if exists sources.etbl_adresse;
drop table if exists sources.etbl_adresses;

update tourisme set description = replace(description, '¿','''');


Update tourisme set description = replace(description, $$<span style="font-family: 'Verdana','sans-serif'; font-size: 9pt; mso-fareast-font-family: Calibri; mso-ansi-language: FR-CA; mso-fareast-language: FR-CA; mso-bidi-language: AR-SA; mso-bidi-font-family: Arial;">$$, '');
update tourisme set description = replace(description, $$<span style="font-family: Arial, sans-serif; font-size: 10pt;">$$,'');
update tourisme set description = replace(description, $$<span style="color: black; font-family: 'Verdana','sans-serif'; font-size: 9pt;">$$,'');
update tourisme set description = replace(description, $$<span style="margin: 0px; color: #333333; font-family: 'Arial','sans-serif'; font-size: 12pt;">$$,'');
update tourisme set description = replace(description, $$<p class="MsoNormal" style="text-align: justify;"><span style="font-size: 9pt; line-height: 107%; font-family: Verdana, sans-serif; background-image: initial; background-attachment: initial; background-size: initial; background-origin: initial; background-clip: initial; background-position: initial; background-repeat: initial;">$$,'');
update tourisme set description = replace(description, $$<span style="font-family: Verdana, sans-serif; line-height: 12.8400001525879px;">$$,'');
update tourisme set description = replace(description, $$<span style="font-family: Verdana, sans-serif; font-size: 9pt; line-height: 107%;">$$,'');
update tourisme set description = replace(description, $$<p class="MsoNormal" style="text-align: justify;"> $$,'');
update tourisme set description = replace(description, '<strong>','');
update tourisme set description = replace(description, '</strong>','');
update tourisme set description = replace(description, $$<span style="color: #000000;">$$,'');
update tourisme set description = replace(description, $$<p style="-qt-block-indent: 0; text-indent: 0px; margin: 0px;">$$,'');
update tourisme set description = replace(description, $$<p class="MsoNormal" style="margin-bottom: 13.5pt;"><span style="font-size: 10pt; font-family: Arial, sans-serif;">$$,'');
update tourisme set description = replace(description, $$<br />$$,'');
update tourisme set description = replace(description, $$</span>$$,'');
update tourisme set description = replace(description, $$</em>$$,'');
update tourisme set description = replace(description, $$<em>$$,'');
