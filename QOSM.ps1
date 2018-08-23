<#
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

#>

<#
Modifiez les valeurs suivantes selon votre environnement
#>

# Emplacement où vous avez installé les scripts
$QOSMroot = "D:\QOSM"

# Code d'usager à utiliser pour se connecter à votre base de données PostGIS
$PGUser = "postgres"                                 

# Mot de passe de $PGUser
$PGPassword = "mot_de_passe"

# Emplacement de ogr2ogr.exe
$ogr2ogr = "C:\OSGeo4W64\bin\ogr2ogr.exe"

# Emplacement de psql.exe
$psql = "C:\progra~1\postgresql\10\bin\psql.exe"

# Télécharger les fichiers
$télécharger = $false

# Vous pouvez inclure la couche des territoires récréatifs du Québec (TRQ).
# Vous devez télécharger le fichier CTRQ-100K_CTRQ-100K_COVER_SO_TEL.zip vous-même sur la Geoboutique du Québec et le copier dans le répertoire sources.
# PDE = Pourvoiries à droit exclusif
# PNC = Parc National du Canada
# PNQ = Parc national du Québec
# PRE = Parc régional
# REC = Réserve écologique
# REF = Réserve faunique
# RFA = Refuge faunique
# RNF = Réserve nationale de faune
# ROM = Refuge d'oiseau migrateur
# SFO = Station forestière
# TEC = Territoire exclusif de chasse



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

# Ne pas modifier ces 5 variables.
$QOSMtelechargements = "$($QOSMRoot)\telechargements"                         # Répertoire pour les téléchargements
$QOSMsql = "$($QOSMroot)\sql"                                                 # Emplacement des scripts SQL
$QOSMgeodata = "$($QOSMroot)\geodata"                                   # Emplacement pour l'extraction etle traitement des fichiers.
$QOSMVBScript = "$($QOSMroot)\vbscript"                                       # Emplacement des scripts VB
$QOSMSources = "$($QOSMroot)\sources"


# Créer les répertoires telechargements et geodata au cas ou ils n'existeraient pas
"Création des répertoires"
New-Item -ItemType Directory -Force -Path $QOSMtelechargements
New-Item -ItemType Directory -Force -Path $QOSMgeodata
New-Item -ItemType Directory -Force -Path $QOSMSources



# Supprimer tous le contenu du répertoire geodata
Remove-Item "$($QOSMgeodata)\*.*"

if ($télécharger)
{
    "Téléchargements:"
    "...Aéroports"
    Invoke-WebRequest -Uri "https://ws.mapserver.transports.gouv.qc.ca/swtq?service=wfs&version=2.0.0&request=getfeature&typename=ms:aeroport&outputformat=shp&srsname=EPSG:4326" -Outfile "$($QOSMtelechargements)\aeroport.zip"

    "...Aéroports_pites"
    Invoke-WebRequest -Uri "https://ws.mapserver.transports.gouv.qc.ca/swtq?service=wfs&version=2.0.0&request=getfeature&typename=ms:aeroport_piste&outputformat=shp&srsname=EPSG:4326" -Outfile "$($QOSMtelechargements)\aeroport_piste.zip"

    "...Barrages"
    Invoke-WebRequest -Uri "https://www.cehq.gouv.qc.ca/depot/Barrages/bd/repertoire_des_barrages.xls" -Outfile "$($QOSMtelechargements)\barrages.xls"

    "...Réseau électrique"
    Invoke-WebRequest -Uri "https://mern.gouv.qc.ca/publications/territoire/portrait/1M/energ_l.zip" -Outfile "$($QOSMtelechargements)\energ_l.zip"

    "...Mines orphelines ou abandonnées"
    Invoke-WebRequest -Uri "https://www.donneesquebec.ca/recherche/dataset/22007337-1e32-4d70-8a97-50db186f2eee/resource/45ae02ec-c0d6-48a3-8b5d-6a654fb08f4f/download/initiative-nationale-pour-les-mines-orphelines-ou-abandonnees.csv" -Outfile "$($QOSMtelechargements)\inmoa.csv"

    "...Parc routier"
    Invoke-WebRequest -Uri "https://ws.mapserver.transports.gouv.qc.ca/swtq?service=wfs&version=2.0.0&request=getfeature&typename=ms:parc_routier&outputformat=shp&srsname=EPSG:4326" -Outfile "$($QOSMtelechargements)\parc_routier.zip"

    "...Radars Photos"
    Invoke-WebRequest -Uri "https://ws.mapserver.transports.gouv.qc.ca/swtq?service=wfs&version=2.0.0&request=getfeature&typename=ms:radars_photos&outputformat=shp&srsname=EPSG:4326" -Outfile "$($QOSMtelechargements)\radars_photos.zip"

    "...Téléphones d'urgence"
    Invoke-WebRequest -Uri "https://ws.mapserver.transports.gouv.qc.ca/swtq?service=wfs&version=2.0.0&request=getfeature&typename=ms:telephone_urg&outputformat=shp&srsname=EPSG:4326" -Outfile "$($QOSMtelechargements)\Telephone_urg.zip"

    "...Villes"
    Invoke-WebRequest -Uri "https://ws.mapserver.transports.gouv.qc.ca/swtq?service=wfs&version=2.0.0&request=getfeature&typename=ms:lieuhabite&outputformat=shp&srsname=EPSG:4326" -Outfile "$($QOSMtelechargements)\lieuhabite.zip"

    "...Accueils Zecs"
    Invoke-WebRequest -Uri "https://opendata.arcgis.com/datasets/71b1cab018514e6b97581af71cc98421_0.csv" -Outfile "$($QOSMtelechargements)\accueils_zecs.csv"

    "...Campings Zecs"
    Invoke-WebRequest -Uri "https://opendata.arcgis.com/datasets/70c40be18a1c4f5797bc4d2229222179_1.csv" -Outfile "$($QOSMtelechargements)\campings_zecs.csv"

    "... AQRéseau+"

    Invoke-WebRequest -Uri "ftp://transfert.mern.gouv.qc.ca/public/diffusion/RGQ/Vectoriel/Carte_Topo/Local/AQReseauPlus/ESRI(SHP)/AQreseauPlus_SHP.zip" -Outfile "$($QOSMtelechargements)\aqrp.zip"
    "...Territoires autochtones"
    Invoke-WebRequest -Uri "http://ftp.geogratis.gc.ca/pub/nrcan_rncan/vector/geobase_al_ta/shp_fra/AL_TA_QC_SHP_fra.zip" -Outfile "$($QOSMtelechargements)\terres_autochtones.zip"
}

# Transférer les fichiers téléchargés dans le répertoire sources et supprimer le répertoire des téléchargements.
# Ceci est pour éviter de perdre des fichiers si un téléchargement ne fonctionne pas. Nous aurons encore la version précédente dans Sources.
"Déplacer les téléchargements dans le répertoire sources."
Move-Item "$($QOSMtelechargements)\*.*" $QOSMSources -Force
Remove-Item $QOSMtelechargements -Recurse -ErrorAction Ignore


# Décompresser les fichiers sources en envoyant le résultat dans le répertoire geodata
"Extraction des fichiers zip:"
if(Test-Path -Path "$($QOSMsources)\aeroport.zip"){
    "...Aéroports"
    Expand-Archive -Path "$($QOSMsources)\aeroport.zip" -DestinationPath $QOSMgeodata -force
}

if(Test-path -Path  "$($QOSMsources)\aeroport_piste.zip"){
    "...Aéroports Pistes"
    Expand-Archive -Path "$($QOSMsources)\aeroport_piste.zip" -DestinationPath $QOSMgeodata -force
}

if(Test-Path -Path  "$($QOSMsources)\aqrp.zip"){
    "...AQRéseau+"
    Expand-Archive -Path "$($QOSMsources)\aqrp.zip" -DestinationPath $QOSMgeodata -force
}

if(Test-path -Path  "$($QOSMsources)\energ_l.zip"){
    "...Réseau électrique"
    Expand-Archive -Path "$($QOSMsources)\energ_l.zip" -DestinationPath $QOSMgeodata -force
}

if(Test-Path -Path "$($QOSMsources)\parc_routier.zip"){
    "...Parc routier"
    Expand-Archive -Path "$($QOSMsources)\parc_routier.zip" -DestinationPath $QOSMgeodata -force
}

if(Test-Path -Path "$($QOSMsources)\radars_photos.zip"){
    "...Radars photos"
    Expand-Archive -Path "$($QOSMsources)\radars_photos.zip" -DestinationPath $QOSMgeodata -force
}

if(test-Path -Path "$($QOSMsources)\telephone_urg.zip"){
    "...Téléphones d'urgence"
    Expand-Archive -Path "$($QOSMsources)\telephone_urg.zip" -DestinationPath $QOSMgeodata -force
}

if(Test-Path -Path "$($QOSMsources)\terres_autochtones.zip"){
    "...Territoires Autochtones"
    Expand-Archive -Path "$($QOSMsources)\terres_autochtones.zip" -DestinationPath $QOSMgeodata -force
}

if(Test-Path -Path "$($QOSMsources)\lieuhabite.zip"){
    "...Villes"
    Expand-Archive -Path "$($QOSMsources)\lieuhabite.zip" -DestinationPath $QOSMgeodata -force
}

if(Test-Path -Path "$($QOSMsources)\CTRQ-100K_CTRQ-100K_COVER_SO_TEL.zip"){
    "...TRQ"
    Expand-Archive -Path "$($QOSMsources)\CTRQ-100K_CTRQ-100K_COVER_SO_TEL.zip" -DestinationPath $QOSMgeodata -force
}


# Supprimer du répertoire geodata les fichiers dont on aura pas besoin.
"Suppression des fichiers inutiles"
Remove-Item "$($QOSMgeodata)\*.atx"
Remove-Item "$($QOSMgeodata)\Route_blanche.*"
Remove-Item "$($QOSMgeodata)\Route_Verte.*"
Remove-Item "$($QOSMgeodata)\Transport_aerien.*"
Remove-Item "$($QOSMgeodata)\Transport_maritime.*"
Remove-Item "$($QOSMgeodata)\*.xml"
Remove-Item "$($QOSMgeodata)\*.html"
 
$cmdString = '-overwrite -f "PostgreSQL" PG:"host=localhost port=5432 dbname=qosm user=' + $PGUser + ' password=' + $PGPassword + '" '


# Charger les données dans PostGIS.
"Chargement des données dans PostGIS:"
if(Test-path -Path "$($QOSMgeodata)\Reseau_routier.shp"){
    "...AQRP routier"
    $cmdParms = $cmdString + $($QOSMgeodata) + '\Reseau_routier.shp -t_srs EPSG:4326 -lco geometry_name=geom -nln sources.aqrp'
    start-process -filepath $ogr2ogr $cmdParms  -NoNewWindow -Wait
}

if(Test-path -Path  "$($QOSMgeodata)\Reseau_ferroviaire.shp"){
    "...AQRP ferroviaire"
    $cmdParms = $cmdString  + $($QOSMgeodata) + '\Reseau_ferroviaire.shp -t_srs EPSG:4326 -lco geometry_name=geom -nln sources.aqcf'
    start-process -filepath $ogr2ogr $cmdParms  -NoNewWindow -Wait
}

if(Test-path -Path  "$($QOSMgeodata)\Reseau_ferroviaire_pn.shp"){
    "...AQRP points ferroviaires"
    $cmdParms = $cmdSTring + $($QOSMgeodata) + '\Reseau_Ferroviaire_pn.shp -t_srs EPSG:4326 -lco geometry_name=geom -nln sources.aqcfpn'
    start-process -filepath $ogr2ogr $cmdParms  -NoNewWindow -Wait
}

if(Test-path -Path  "$($QOSMgeodata)\energ_l.shp"){
    "...Réseau électrique"
    $cmdParms = $cmdString + $($QOSMgeodata) + '\energ_l.shp -t_srs EPSG:4326 -lco geometry_name=geom -lco precision=no -nln sources.electrique'
    start-process -filepath $ogr2ogr $cmdParms  -NoNewWindow -Wait
}

if(Test-path -Path  "$($QOSMgeodata)\aeroport.shp"){
    "...Aéroports"
    $cmdParms = $cmdString + $($QOSMgeodata) + '\aeroport.shp -t_srs EPSG:4326 -lco geometry_name=geom -lco precision=no -nln sources.aeroports'
    start-process -filepath $ogr2ogr $cmdParms  -NoNewWindow -Wait
}

if(Test-path -Path  "$($QOSMgeodata)\aeroport_piste.shp"){
    "...Aéroports pistes"
    $cmdParms = $cmdString + $($QOSMgeodata) + '\aeroport_piste.shp -t_srs EPSG:4326 -lco geometry_name=geom -lco precision=no -nln sources.aeroports_pistes'
    start-process -filepath $ogr2ogr $cmdParms  -NoNewWindow -Wait
}

if(Test-path -Path  "$($QOSMgeodata)\lieuhabite.shp"){
    "...Villes"
    $cmdParms = $cmdString + $($QOSMgeodata) + '\lieuhabite.shp -t_srs EPSG:4326 -lco geometry_name=geom -lco precision=no -nln sources.villes' 
    start-process -filepath $ogr2ogr $cmdParms  -NoNewWindow -Wait
}

if(Test-path -Path  "$($QOSMgeodata)\parc_routier.shp"){
    "...Parc routier"
    $cmdParms = $cmdString  + $($QOSMgeodata) + '\parc_routier.shp -t_srs EPSG:4326 -lco geometry_name=geom -lco precision=no -nln sources.parcroutier' 
    start-process -filepath $ogr2ogr $cmdParms  -NoNewWindow -Wait
}

if(Test-path -Path  "$($QOSMgeodata)\radars_photos.shp"){
    "...Photoradars"
    $cmdParms = $cmdString + $($QOSMgeodata) + '\radars_photos.shp -t_srs EPSG:4326 -lco geometry_name=geom -lco precision=no -nln sources.photoradar' 
    start-process -filepath $ogr2ogr $cmdParms  -NoNewWindow -Wait
}

if(Test-path -Path  "$($QOSMgeodata)\telephone_urg.shp"){
    "...Téléphone d'urgence"
    $cmdParms = $cmdString + $($QOSMgeodata) + '\telephone_urg.shp -t_srs EPSG:4326 -lco geometry_name=geom -lco precision=no -nln sources.telephone_urg' 
    start-process -filepath $ogr2ogr $cmdParms  -NoNewWindow -Wait
}

if(Test-path -Path  "$($QOSMgeodata)\al_ta_qc_2_99_fra.shp"){
    "...Territoires autochtones"
    $cmdParms = $cmdString + '-nlt MULTIPOLYGONZ ' + $($QOSMgeodata) + '\al_ta_qc_2_99_fra.shp -s_srs EPSG:4617 -t_srs EPSG:4326 -lco geometry_name=geom -lco precision=no -nln sources.terres_autochtones'
    start-process -filepath $ogr2ogr $cmdParms  -NoNewWindow -Wait
}

# Supprimer le répertoire geodata après le chargement des données pour économiser l'espace disque.
Remove-Item $QOSMgeodata -Recurse -ErrorAction Ignore


# Traiter le fichier excel des barrages avant l'importation des données dans postgis.
# Convertir le fichier en csv en utilisant un script vb.
# Dans un 2e temps on va convertir le fichier en UTF-8
# Définir les fichiers xls et csv dans des variables.
"Conversion du fichiers barrages.xls en csv (utf8)."
$xls = "$($QOSMsources)\barrages.xls"
$csv = "$($QOSMsources)\barrages.csv"
$tmp = "$($QOSMsources)\temp.csv"

# Supprimer les csv s'ils existent déjà.
if(Test-Path "$csv"){
    Remove-Item $csv -Force
}

if(Test-Path "$tmp"){
    Remove-Item $tmp -Force
}

# Exécuter le VB script
cscript.exe "$($qosmvbscript)\xlstocsv.vbs" $xls $tmp

# Faire la conversion
$source = get-content $tmp
$utf8 = New-Object System.Text.UTF8Encoding $false
[system.io.file]::WriteAllLines($csv, $source, $utf8)


# Supprimer le fichier temporaire
if(Test-Path "$tmp"){
    Remove-Item $tmp -Force
}

# Le fichier excel des barrages contient une ligne d'entête avant celle des noms de colonnes comme ceci:
# IDENTIFICATION,,LOCALISATION,,,,,,,,,,HYDROGRAPHIE,,,CARACTÉRISTIQUES,,,,,,,,,,,,,,,,,,,,,ÉVALUATION DE LA SÉCURITÉ,,,,,,,
# Numéro barrage,Nom du barrage,Région administrative,MRC,Municipalité,Latitude deg dec (Nad 83),Longitude deg dec (Nad 83),Latitude (Nad 83),Longitude (Nad 83),Nom du réservoir,Territoire,Aménagement,Bassin,Lac,Cours d'eau,Catégorie Administrative,Utilisation,Hauteur du barrage (m),Hauteur de retenue               (m),Type de barrage,Classe,Zone sismique,Sup. Bassin                   (km2),Année Construction,Année Modification,Capacité de retenue                  (m3),Longueur                (m),Terrain de fondation,Niveau des conséquences,Sup. réservoir                  (ha),Longueur refoulement               (m),Barrage en amont,Barrage en aval,Propriétaire / Mandataire,Adresse,Code Postal,No Étude,Année prévue étude,Année dernière étude,Date prévue exposé correctifs,Réception exposé correctifs,Étape analyse approbation,Date approbation,Étape réalisation des correctifs
# Avant de pouvoir importer le fichier dans PostGIS nous devons supprimer cette ligne.
get-content $csv |
    select -Skip 1 |
    set-content "$file-temp"
move "$file-temp" $csv -Force

# Créer le script importer_csv.sql

(Get-Content "$($QOSMroot)\importer_csv.gabarit").replace('[source]', $QOSMgeodata) | Set-Content "$($QOSMSQL)\importer_csv.sql"


"Exécution des scripts SQL:"
Set-Item Env:PGPassword $PGPassword

"Chargement des données en fichiers csv dans la base de données PostGIS."
$cmdparms = '-d qosm -U ' + $PGUser + ' -f sql\importer_csv.sql'
start-process -FilePath $psql $cmdparms  -NoNewWindow -Wait

"Traitemen des données:"
"...Aéroports"
$cmdparms = '-d qosm -U ' + $PGUser + ' -f sql\Aeroports.sql'
start-process -FilePath $psql $cmdparms  -NoNewWindow -Wait

"...Aéroports pistes"
$cmdParms = '-d qosm -U ' + $PGUser + ' -f sql\Aeroports_Pistes.sql'
start-process -FilePath $psql $cmdparms  -NoNewWindow -Wait

"...Barrages"
$CmdParms = '-d qosm -U ' + $PGUser + ' -f sql\Barrages.sql'
start-process -FilePath $psql $cmdparms  -NoNewWindow -Wait

"...Réseau électrique"
$cmdParms = '-d qosm -U ' + $PGUser + ' -f sql\Electrique.sql'
start-process -FilePath $psql $cmdparms  -NoNewWindow -Wait

"...Mines orphelines ou abandonnées"
$cmdParms = '-d qosm -U ' + $PGUser + ' -f sql\Inmoa.sql'
start-process -FilePath $psql $cmdparms  -NoNewWindow -Wait

"...Parc routier"
$cmdParms = '-d qosm -U ' + $PGUser + ' -f sql\Parc_routier.sql'
start-process -FilePath $psql $cmdparms  -NoNewWindow -Wait

"...Radars photos"
$cmdParms = '-d qosm -U ' + $PGUser + ' -f sql\Photoradar.sql'
start-process -FilePath $psql $cmdparms  -NoNewWindow -Wait

"...Téléphones d'urgence"
$cmdParms = '-d qosm -U ' + $PGUser + ' -f sql\Telephone_urg.sql'
start-process -FilePath $psql $cmdparms  -NoNewWindow -Wait

"...Accueils Zecs"
$cmdParms = '-d qosm -U ' + $PGUser + ' -f sql\Accueils_Zecs.sql'
start-process -FilePath $psql $cmdparms  -NoNewWindow -Wait

"...Campings Zecs"
$cmdParms = '-d qosm -U ' + $PGUser + ' -f sql\Campings_Zecs.sql'
start-process -FilePath $psql $cmdparms  -NoNewWindow -Wait

"...Villes"
$cmdParms = '-d qosm -U ' + $PGUser + ' -f sql\Villes.sql'
start-process -FilePath $psql $cmdparms  -NoNewWindow -Wait

"...Territoires autochtones"
$cmdParms = '-d qosm -U ' + $PGUser + ' -f sql\Terres_Autochtones.sql'
start-process -FilePath $psql $cmdparms  -NoNewWindow -Wait

"...AQRéseau+ (Réseau routier et ferroviaire)"
$cmdParms = '-d qosm -U ' + $PGUser + ' -f sql\aqrp.sql'
start-process -FilePath $psql $cmdparms  -NoNewWindow -Wait


Set-Item Env:PGPassword ""

Get-Date