<#
    QOSM - Québec OSM - Collection de scripts et de programmes pour générer une carte du Québec pour l'expéditionnisme, compatible avec l'application OsmAnd (https://osmand.net) à partir de données ouvertes.
    
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

#>

<#

A propos de QOSM
(Anciennement Carte de l'AQE et projet RDF)

Définition: Collection de scripts et de programmes pour générer une carte du Québec pour l'expéditionnisme, compatible avec l'application OsmAnd (https://osmand.net) à partir de données ouvertes.


Présentement au stade 1.  Ce script va:
1. Télécharger les données
2. Décompresser les fichiers zip et convertir les fichiers excel en csv.
3. Importer les données dans postgis (base de données: qosm, schema: sources)
4. Traiter les données pour convertir les attributs d'origine en tag Openstreet Map et les transférer dans le schema public

A ce stade les données des tables dans le schema public peuvent être exporter en fichier .osm.
Le fichier peut ensuite être utilisé avec OsmAndMapCreator pour créer la carte.

Prérequis.
- Un serveur PostgreSQL
- Une base de données appelée rdf avec les extensions PostGIS.
- Un schéma appelé sources et un autre appelé travail en plus du schema public.   Les données seront chargées dans des tables dans le schema sources, copiées dans le schema travail pour le traitement et finalement transférées dans public après traitement.
- Le programme ogr2org qui est utilisé pour charger les données dans Posgis.
- Avoir les autorisations pour l'exécution de scripts powershell.


Mode d'emploi
- Télécharger tous les fichiers dans un répertoire de votre choix.
- Modifier les cinq variables aux lignes 25 à 41 du script powershell qosm.ps1
- Exécuter le script.
- Exporter dans un fichier .osm les données des tables du schema public avec l'application de votre choix
- Exécuter OsmAndMapCreator


Développements à venir.
- Créer un programme pour exporter les données dans un fichier .osm
- Ajouter une commande à la fin du script pour exécuter OsmAndMapCreator automatically
- Ajouter de nouvelles données lorsqu'elles seront disponibles en données ouvertes (Territoires récréatifs, réseau hydrographique)

#>
