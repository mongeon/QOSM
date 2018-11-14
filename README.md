<#
    QOSM - Québec OSM - Collection de scripts et de programmes pour générer une carte du Québec pour l'expéditionnisme, 
						compatible avec l'application OsmAnd (https://osmand.net) à partir de données ouvertes et gratuites.
    
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

	Définition: Collection de scripts et de programmes pour générer une carte du Québec pour l'expéditionnisme, 
				compatible avec l'application OsmAnd (https://osmand.net) à partir de données ouvertes.
	
	Deux scripts sont inclus.
	qosm.linux.ps1: Développé et testé sous Ubuntu 16.04 sous WSL (Windows subsystem for Linux)
	qosm.win.ps1: Développé est testé sous Windows 10


	Présentement au stade 2.  Ce script va:
	1. Télécharger les données.
	2. Décompresser les fichiers zip et convertir les fichiers excel et xml en csv.
	3. Importer les données dans postgis (base de données: qosm, schema: sources)
	4. Traiter les données pour convertir les attributs d'origine en tag Openstreet Map et les transférer dans le schema public
	5. Exécuter un script sql pour exporter les données dans un fichier osm.

	Le fichier peut ensuite être utilisé avec OsmAndMapCreator pour créer la carte.


	Prérequis.
	- Un serveur PostgreSQL
	- Une base de données appelée qosm avec les extensions PostGIS.
	- Un schéma appelé sources et un autre appelé travail en plus du schema public.   
		Les données seront chargées dans des tables dans le schema sources, copiées dans le schema travail pour le traitement et finalement
		transférées dans public après traitement.
	- GDAL, qui est utilisé pour charger les données dans PostgreSQL.
	- Avoir les autorisations pour l'exécution de scripts powershell.
	- Dotnet Core SDKf

	Mode d'emploi
	- Télécharger tous les fichiers dans un répertoire de votre choix (Exemple: D:\qosm).
	- Configurer le script powershell de votre choix (Linux ou Windows -voir les instructions dans le script)
	- Exécuter le script.
		Windows: powershell -file qosm.win.ps1
		Linux: pwsh qosm.linux.ps1
	- Soyez patient, ces scripts vont traiter des giga-octets de données représentant plus de 1,3 millions d'objets géographiques.
		A titre de référence:  
			AMD FX-4300 (4 coeurs) 3,8 Mhz
			32 Gb de mémoire
			Disques SSD
			Temps d'exécution: 2700 secondes (45 minutes)
	- Exécuter OsmAndMapCreator pour créer votre carte
		Copiez la carte et les fichiers du répertoire osmand dans votre appareil
			Mettre la carte et le fichier routing.xml dans le dossier Files de OsmAnd
			Mettre les fichiers Route-des-Forêts-xx.render.xml dans le dossier Rendering de OsmAnd
		
		

	Développements à venir.
	- Ajouter une commande à la fin du script pour exécuter OsmAndMapCreator automatically
	- Ajouter de nouvelles données lorsqu'elles seront disponibles en données ouvertes (Territoires récréatifs, réseau hydrographique)
#>

<#
	Problèmes connus:
	Linux: 	ogr2ogr2 ne reconnait pas certais polypogones dans le chargement de la couche des territoires récréatifs du québec.  
			si vous choisissez d'inclure TRQ vous devriez utiliser le script windows.
#>

<#
LINUX:
Installer Windows Linux Subsystem et Ubuntu 16.04 LTS recommandé, .NET SDK ne peut pas être installé sur 18.04
Installer les applications
	GDAL: http://www.sarasafavi.com/installing-gdalogr-on-ubuntu.html
		sudo add-apt-repository ppa:ubuntugis/ppa && sudo apt-get update
		sudo apt-get install gdal-bin
		
	GNumeric
		sudo apt-get install -y gnumeric
		
	DOT NET SDK	
		wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb
		sudo dpkg -i packages-microsoft-prod.deb
		sudo apt-get install apt-transport-https
		sudo apt-get update
		sudo apt-get install dotnet-sdk-2.1
		# Il faut l'exécuter une fois pour compléter l'installation
		dotnet 

	Powershell
		sudo apt-get install powershell

	Client PSQL (Assurez-vous d'installer le client pour la version de PostgreSQL que vous avez.  Ici on utilise PostgreSQL 10)
		sudo add-apt-repository 'deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main'
		wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
		sudo apt-get update
		sudo apt-get install postgresql-client-10
		
Avec PostgreSQL on ne peut pas passer un mot de passe sur la ligne de commande. Il faut utiliser un fichier .pgpass dans le répertoire home 
de l'usager sous lequel le script sera exécuté.

On peut le faire comme ceci.  Remplacez <usager> dans les commandes par le nom d'usager que vous utilisez.

$ sudo touch /home/<usager>/.pgpass
$ sudo chmod 600 /home/<usager>/.pgpass

Utilisez votre éditeur préféré pour ajouter cette ligne dans votre fichier .pgpass en remplaçant server, port, database, username et password
par vos informations de connexion.

server:port:database:username:password

#>

<#
Source des données

Ministère de l’Énergie et des ressources naturelles.
	Adresses Québec – AQ Réseau+
	Routes et chemins forestiers.
	    Chemins de fer
	Données ouvertes – INMOA
	    Mines abandonnées
    Base de données géographiques
	    Réseau électrique
Transport Québec.
	Données ouvertes 
	Aéroports
	    Aéroports Pistes
	    Radar Photo
	    Téléphones de secours
	    Villes (Lieux habités du Québec)
	    Parc routier
Tourisme Québec
	Lieux d’accueil et de renseignement touristiques du Québec
Centre d’expertise hydrique du Québec.
	Répertoire des barrages (format Excel)
Canada – Gouvernement ouvert
	Territoires autochtones
Réseau Zecs – Données ouvertes
    Postes d’accueil
    Campings
#>



		