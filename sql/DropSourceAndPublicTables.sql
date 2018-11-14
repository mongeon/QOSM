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

drop table if exists sources.accueils_zecs cascade;
drop table if exists sources.aeroports cascade;
drop table if exists sources.aeroports_pistes cascade;
drop table if exists sources.aqrp cascade;
drop table if exists sources.aqcf cascade;
drop table if exists sources.aqcfpn cascade;
drop table if exists sources.barrages cascade;
drop table if exists sources.campings_zecs cascade;
drop table if exists sources.electrique cascade;
drop table if exists sources.inmoa cascade;
drop table if exists sources.parcroutier cascade;
drop table if exists sources.photoradar cascade;
drop table if exists sources.telephone_urg cascade;
drop table if exists sources.terres_autochtones cascade;
drop table if exists sources.villes cascade;
drop table if exists sources.trq;
drop table if exists sources.zecs;
drop table if exists sources.parcs_nationaux_canada;
drop table if exists sources.parcs_nationaux_quebec;
drop table if exists sources.parcs_regionaux;
drop table if exists sources.pourvoiries;
drop table if exists sources.refuges_oiseaux_migrateurs;
drop table if exists sources.reserves_fauniques;
drop table if exists sources.reserves_naturelles_faune;
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
drop table if exists sources.tourisme;


drop table if exists accueils_zecs;
drop table if exists aeroports;
drop table if exists aeroports_pistes;
drop table if exists aqrp;
drop table if exists aqcf;
drop table if exists aqcfpn;
drop table if exists barrages;
drop table if exists campings_zecs;
drop table if exists electrique;
drop table if exists inmoa;
drop table if exists parcroutier;
drop table if exists photoradar;
drop table if exists telephone_urg;
drop table if exists terres_autochtones;
drop table if exists villes;
drop table if exists trq;
drop table if exists tourisme;
drop table if exists etablissement;
drop table if exists etbl_type;
drop table if exists etbl_types;
drop table if exists etbl_contact;
drop table if exists etbl_contacts;
drop table if exists etbl_attribut;
drop table if exists etbl_attributs;
drop table if exists etbl_caracteristique;
drop table if exists etbl_caracteristiques;
drop table if exists etbl_adresse;
drop table if exists etbl_adresses;
drop table if exists tourisme;
