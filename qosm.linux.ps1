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
    Configuration.
    Modifiez les valeurs suivantes selon votre environnement et vos choix.
#>

$Linux = $false
$Windows = $true

# Emplacement de ogr2ogr
$ogr2ogr = "/usr/bin/ogr2ogr"

#Emplacement de psql
$psql = "/usr/bin/psql"

#Emplacement de ssconvert
$ssconvert = "/usr/bin/ssconvert"

# Emplacement où vous avez installé les scripts
$QOSMroot = "/mnt/d/qosm"

# Serveur PostgreSQL
$PGServer = "localhost"

# Port serveur
$PGPort = 5432

# Code d'usager à utiliser pour se connecter à votre base de données PostGIS
$PGUser = "qosm"                                 

# Mot de passe de $PGUser
$PGPassword = "xxxxxxxx"

# Nom et emplacement souhaité pour le fichier osm
$QOSMFinal = "/mnt/d/osmand/qosm.osm"

<#
    La série de variables qui suit sert à configurer les sélections.
    On peut choisir quels couches on veut télécharger.  Utilisez la variable $télécharger pour activer/désactiver tous les téléchargements d'un coup.
#>


<#
    La série de variables qui suit sert à configurer les sélections.
    On peut choisir quels couches on veut inclure dans le fichier final.
#>

# Identifier les couches à télécharger.  
# Vous pouvez utiliser la variable $télécharger pour activer/désactiver tous les téléchargements d'un coup.
$télécharger = $false
$obtenirAeroports = $true
$obtenirPistes = $true
$obtenirBarrages = $true
$obtenirElectrique = $true
$obtenirMines = $true
$obtenirParcRoutier = $true
$obtenirPhotoRadar = $true
$obtenirTelephone = $true
$obtenirVilles = $true
$obtenirAccueilsZecs = $true
$obtenirCampingsZecs = $true
$obtenirAQRP = $true
$obtenirTerresAutochtones = $true
$obtenirLieuxAccueil = $true

# Identifier les couches à inclure dans le fichier final.
# Vous pouvez utiliser la variable $télécharger pour activer/désactiver tous les téléchargements d'un coup.
$inclureAeroports = $true
$inclurePistes = $true
$inclureBarrages = $true
$inclureElectrique = $true
$inclureMines = $true
$inclureParcRoutier = $true
$inclurePhotoRadar = $true
$inclureTelephone = $true
$inclureVilles = $true
$inclureAccueilsZecs = $true
$inclureCampingsZecs = $true
$inclureAQRP = $true
$inclureTerresAutochtones = $true
$inclureLieuxAccueil = $true
$inclureTrq = $true

# La variable $extraire est utilisée pour désactiver l'étape d'extraction des données.  C'est utile pour déboguer.
$extraire = $true	


<# 
Vous pouvez inclure la couche des territoires récréatifs du Québec (TRQ).
Vous devez télécharger le fichier CTRQ-100K_CTRQ-100K_COVER_SO_TEL.zip vous-même sur la Geoboutique du Québec et le copier dans le répertoire sources.
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

# Les Uri des différents fichiers.
$UriAeroports = "https://ws.mapserver.transports.gouv.qc.ca/swtq?service=wfs&version=2.0.0&request=getfeature&typename=ms:aeroport&outputformat=shp&srsname=EPSG:4326"
$UriAeroportsPistes = "https://ws.mapserver.transports.gouv.qc.ca/swtq?service=wfs&version=2.0.0&request=getfeature&typename=ms:aeroport_piste&outputformat=shp&srsname=EPSG:4326"
$UriBarrages = "https://www.cehq.gouv.qc.ca/depot/Barrages/bd/repertoire_des_barrages.xls" 
$UriElectrique = "https://mern.gouv.qc.ca/publications/territoire/portrait/1M/energ_l.zip" 
$UriInmoa = "https://www.donneesquebec.ca/recherche/dataset/22007337-1e32-4d70-8a97-50db186f2eee/resource/45ae02ec-c0d6-48a3-8b5d-6a654fb08f4f/download/initiative-nationale-pour-les-mines-orphelines-ou-abandonnees.csv"
$UriParcRoutier = "https://ws.mapserver.transports.gouv.qc.ca/swtq?service=wfs&version=2.0.0&request=getfeature&typename=ms:parc_routier&outputformat=shp&srsname=EPSG:4326"
$UriPhotoradar =  "https://ws.mapserver.transports.gouv.qc.ca/swtq?service=wfs&version=2.0.0&request=getfeature&typename=ms:radars_photos&outputformat=shp&srsname=EPSG:4326"
$UriTelephoneurg = "https://ws.mapserver.transports.gouv.qc.ca/swtq?service=wfs&version=2.0.0&request=getfeature&typename=ms:telephone_urg&outputformat=shp&srsname=EPSG:4326"
$UriLieuxHabite =  "https://ws.mapserver.transports.gouv.qc.ca/swtq?service=wfs&version=2.0.0&request=getfeature&typename=ms:lieuhabite&outputformat=shp&srsname=EPSG:4326"
$UriAccueilsZec = "https://opendata.arcgis.com/datasets/71b1cab018514e6b97581af71cc98421_0.csv"
$UriCampingsZec = "https://opendata.arcgis.com/datasets/70c40be18a1c4f5797bc4d2229222179_1.csv"
$UriAqrp = "ftp://transfert.mern.gouv.qc.ca/public/diffusion/RGQ/Vectoriel/Carte_Topo/Local/AQReseauPlus/ESRI(SHP)/AQreseauPlus_SHP.zip"
$UriTerresAutochtones = "http://ftp.geogratis.gc.ca/pub/nrcan_rncan/vector/geobase_al_ta/shp_fra/AL_TA_QC_SHP_fra.zip"
$UriLieuxAccueil = "http://donnees.tourisme.gouv.qc.ca/donnees/Lieux_d_accueil.zip"


# IL N'Y A RIEN À MODIFIER DANS CE QUI SUIT, SI VOUS LE FAITES CE SERA À VOS RISQUES

# Ne pas modifier ces variables.
$QOSMTelechargements = "$($QOSMRoot)/telechargements"                         # Répertoire pour les téléchargements
$QOSMSQL = "$($QOSMroot)/sql"                                                 # Emplacement des scripts SQL
$QOSMGeodata = "$($QOSMroot)/geodata"                                         # Emplacement pour l'extraction etle traitement des fichiers.
$QOSMVBScript = "$($QOSMroot)/vbscript"                                       # Emplacement des scripts VB
$QOSMSources = "$($QOSMroot)/sources"
$SQLGeodata = "D:/qosm/geodata/"

$startDTM = (Get-Date)

# Créer les répertoires telechargements et geodata au cas ou ils n'existeraient pas
"Création des répertoires"
New-Item -ItemType Directory -Force -Path $QOSMTelechargements
New-Item -ItemType Directory -Force -Path $QOSMGeodata
New-Item -ItemType Directory -Force -Path $QOSMSources



# Supprimer tous le contenu du répertoire geodata
Remove-Item "$($QOSMGeodata)/*.*"

if ($télécharger)
{
    "Téléchargements:"
    if ($obtenirAeroports){
        "...Aéroports"
        Invoke-WebRequest -Uri $UriAeroports -Outfile "$($QOSMTelechargements)/aeroport.zip"
    }
    if ($obtenirPistes){
        "...Aéroports_pites"
        Invoke-WebRequest -Uri $UriAeroportsPistes -Outfile "$($QOSMTelechargements)/aeroport_piste.zip"
    }
    if ($obtenirBarrages){
        "...Barrages"
       Invoke-WebRequest -Uri $UriBarrages -Outfile "$($QOSMTelechargements)/barrages.xls"
    }
    if ($obtenirElectrique){
        "...Réseau électrique"
        Invoke-WebRequest -Uri $UriElectrique -Outfile "$($QOSMTelechargements)/energ_l.zip"
    }
    if ($obtenirMines){
        "...Mines orphelines ou abandonnées"
        Invoke-WebRequest -Uri $UriInmoa -Outfile "$($QOSMTelechargements)/inmoa.csv"
    }
    if ($obtenirParcRoutier){
        "...Parc routier"
        Invoke-WebRequest -Uri $UriParcRoutier -Outfile "$($QOSMTelechargements)/parc_routier.zip"
    }
    if ($obtenirPhotoRadar){
        "...Radars Photos"
        Invoke-WebRequest -Uri $UriPhotoradar -Outfile "$($QOSMTelechargements)/radars_photos.zip"
    }
    if ($obtenirTelephone){
        "...Téléphones d'urgence"
        Invoke-WebRequest -Uri $UriTelephoneurg -Outfile "$($QOSMTelechargements)/telephone_urg.zip"
    }
    if ($obtenirVilles){
        "...Villes"
        Invoke-WebRequest -Uri $UriLieuxHabite -Outfile "$($QOSMTelechargements)/lieuhabite.zip"
    }
    if ($obtenirAccueilsZecs){
        "...Accueils Zecs"
        Invoke-WebRequest -Uri $UriAccueilsZec -Outfile "$($QOSMTelechargements)/accueils_zecs.csv"
    }
    if ($obtenirCampingsZecs){
        "...Campings Zecs"
        Invoke-WebRequest -Uri $UriCampingsZec -Outfile "$($QOSMTelechargements)/campings_zecs.csv"
    }
    if ($obtenirAQRP){
        "... AQRéseau+"
        if ($Windows){
            Invoke-WebRequest -Uri $UriAqrp -Outfile "$($QOSMTelechargements)/aqrp.zip"
        }
        if ($Linux){
    	    $file = "$($QOSMTelechargements)/aqrp.zip"
    	    $ftp = $UriAqrp
    	    $webclient = New-Object System.Net.WebClient
    	    $uri = New-Object System.Uri($ftp)
    	    $webclient.DownloadFile($uri, $file)
        }
    }
    if ($obtenirTerresAutochtones){
        "...Territoires autochtones"
        Invoke-WebRequest -Uri $UriTerresAutochtones -Outfile "$($QOSMTelechargements)/terres_autochtones.zip"
    }
    if ($obtenirLieuxAccueil){
        "...Lieux d'accueils"
        Invoke-WebRequest -Uri $UriLieuxAccueil -Outfile "$($QOSMTelechargements)/Lieux_d_accueil.zip"
    }
}

# Transférer les fichiers téléchargés dans le répertoire sources et supprimer le répertoire des téléchargements.
# Ceci est pour éviter de perdre des fichiers si un téléchargement ne fonctionne pas. Nous aurons encore la version précédente dans Sources.
"Déplacer les téléchargements dans le répertoire sources."
Move-Item "$($QOSMTelechargements)/*.*" $QOSMSources -Force
Remove-Item $QOSMTelechargements -Recurse -ErrorAction Ignore


# Décompresser les fichiers sources en envoyant le résultat dans le répertoire geodata

if ($extraire)
{
	"Extraction des fichiers zip:"
	if(Test-Path -Path "$($QOSMSources)/aeroport.zip"){
		"...Aéroports"
		Expand-Archive -Path "$($QOSMSources)/aeroport.zip" -DestinationPath $QOSMGeodata -force
	}
	
	if(Test-path -Path  "$($QOSMSources)/aeroport_piste.zip"){
		"...Aéroports Pistes"
		Expand-Archive -Path "$($QOSMSources)/aeroport_piste.zip" -DestinationPath $QOSMGeodata -force
	}
	
	if(Test-Path -Path  "$($QOSMSources)/aqrp.zip"){
		"...AQRéseau+"
		Expand-Archive -Path "$($QOSMSources)/aqrp.zip" -DestinationPath $QOSMGeodata -force
	}
	
	if(Test-path -Path  "$($QOSMSources)/energ_l.zip"){
		"...Réseau électrique"
		Expand-Archive -Path "$($QOSMSources)/energ_l.zip" -DestinationPath $QOSMGeodata -force
	}
	
	if(Test-Path -Path "$($QOSMSources)/parc_routier.zip"){
		"...Parc routier"
		Expand-Archive -Path "$($QOSMSources)/parc_routier.zip" -DestinationPath $QOSMGeodata -force
	}
	
	if(Test-Path -Path "$($QOSMSources)/radars_photos.zip"){
		"...Radars photos"
		Expand-Archive -Path "$($QOSMSources)/radars_photos.zip" -DestinationPath $QOSMGeodata -force
	}
	
	if(test-Path -Path "$($QOSMSources)/telephone_urg.zip"){
		"...Téléphones d'urgence"
		Expand-Archive -Path "$($QOSMSources)/telephone_urg.zip" -DestinationPath $QOSMGeodata -force
	}
	
	if(Test-Path -Path "$($QOSMSources)/terres_autochtones.zip"){
		"...Territoires Autochtones"
		Expand-Archive -Path "$($QOSMSources)/terres_autochtones.zip" -DestinationPath $QOSMGeodata -force
	}
	
	if(Test-Path -Path "$($QOSMSources)/lieuhabite.zip"){
		"...Villes"
		Expand-Archive -Path "$($QOSMSources)/lieuhabite.zip" -DestinationPath $QOSMGeodata -force
	}
	
	if(Test-Path -Path "$($QOSMSources)/CTRQ-100K_CTRQ-100K_COVER_SO_TEL.zip"){
		"...TRQ"
		Expand-Archive -Path "$($QOSMSources)/CTRQ-100K_CTRQ-100K_COVER_SO_TEL.zip" -DestinationPath $QOSMGeodata -force
	}
	
	if(Test-Path -Path "$($QOSMSources)/Lieux_d_accueil.zip"){
		"...Lieux d'accueil"
		Expand-Archive -Path "$($QOSMSources)/Lieux_d_accueil.zip" -DestinationPath $QOSMGeodata -force
	}
}


$PGConnectStr = "host=" + $PGServer + " port=" + $PGPort + " dbname=qosm user=" + $PGUser + " password=" + $PGPassword
$cmdString = '-overwrite -f "PostgreSQL" PG:"' + $PGConnectStr + '" '
$trqcmdString = '-f "PostgreSQL" PG:"' + $PGConnectStr + '" '

Set-Item Env:PGCLIENTENCODING UTF-8
Set-Item Env:PGPassword $PGPassword


# Charger les données vectorielles dans la base de données.
"Chargement des données dans PostGIS:"
if(Test-path -Path "$($QOSMGeodata)/Reseau_routier.shp"){
    "...AQRP routier"
    $cmdParms = $cmdString + $($QOSMGeodata) + '/Reseau_routier.shp -t_srs EPSG:4326 -lco geometry_name=geom -nln sources.aqrp'
    start-process -filepath $ogr2ogr $cmdParms  -NoNewWindow -Wait
}

if(Test-path -Path  "$($QOSMGeodata)/Reseau_ferroviaire.shp"){
    "...AQRP ferroviaire"
    $cmdParms = $cmdString  + $($QOSMGeodata) + '/Reseau_ferroviaire.shp -t_srs EPSG:4326 -lco geometry_name=geom -nln sources.aqcf'
    start-process -filepath $ogr2ogr $cmdParms  -NoNewWindow -Wait
}

if(Test-path -Path  "$($QOSMGeodata)/Reseau_ferroviaire_PN.shp"){
    "...AQRP points ferroviaires"
    $cmdParms = $cmdSTring + $($QOSMGeodata) + '/Reseau_ferroviaire_PN.shp -t_srs EPSG:4326 -lco geometry_name=geom -nln sources.aqcfpn'
    start-process -filepath $ogr2ogr $cmdParms  -NoNewWindow -Wait
}

if(Test-path -Path  "$($QOSMGeodata)/energ_l.shp"){
    "...Réseau électrique"
    $cmdParms = $cmdString + $($QOSMGeodata) + '/energ_l.shp -t_srs EPSG:4326 -lco geometry_name=geom -lco precision=no -nln sources.electrique'
    start-process -filepath $ogr2ogr $cmdParms  -NoNewWindow -Wait
}

if(Test-path -Path  "$($QOSMGeodata)/aeroport.shp"){
    "...Aéroports"
    $cmdParms = $cmdString + $($QOSMGeodata) + '/aeroport.shp -t_srs EPSG:4326 -lco geometry_name=geom -lco precision=no -nln sources.aeroports'
    start-process -filepath $ogr2ogr $cmdParms  -NoNewWindow -Wait
}

if(Test-path -Path  "$($QOSMGeodata)/aeroport_piste.shp"){
    "...Aéroports pistes" 
    $cmdParms = $cmdString + '-nlt MULTIPOLYGONZ ' + $($QOSMGeodata) + '/aeroport_piste.shp -t_srs EPSG:4326 -lco geometry_name=geom -lco precision=no -nln sources.aeroports_pistes'
    start-process -filepath $ogr2ogr $cmdParms  -NoNewWindow -Wait
}

if(Test-path -Path  "$($QOSMGeodata)/lieuhabite.shp"){
    "...Villes"
    $cmdParms = $cmdString + $($QOSMGeodata) + '/lieuhabite.shp -t_srs EPSG:4326 -lco geometry_name=geom -lco precision=no -nln sources.villes' 
    start-process -filepath $ogr2ogr $cmdParms  -NoNewWindow -Wait
}

if(Test-path -Path  "$($QOSMGeodata)/parc_routier.shp"){
    "...Parc routier"
    $cmdParms = $cmdString  + $($QOSMGeodata) + '/parc_routier.shp -t_srs EPSG:4326 -lco geometry_name=geom -lco precision=no -nln sources.parcroutier' 
    start-process -filepath $ogr2ogr $cmdParms  -NoNewWindow -Wait
}

if(Test-path -Path  "$($QOSMGeodata)/radars_photos.shp"){
    "...Photoradars"
    $cmdParms = $cmdString + $($QOSMGeodata) + '/radars_photos.shp -t_srs EPSG:4326 -lco geometry_name=geom -lco precision=no -nln sources.photoradar' 
    start-process -filepath $ogr2ogr $cmdParms  -NoNewWindow -Wait
}

if(Test-path -Path  "$($QOSMGeodata)/telephone_urg.shp"){
    "...Téléphone d'urgence"
    $cmdParms = $cmdString + $($QOSMGeodata) + '/telephone_urg.shp -t_srs EPSG:4326 -lco geometry_name=geom -lco precision=no -nln sources.telephone_urg' 
    start-process -filepath $ogr2ogr $cmdParms  -NoNewWindow -Wait
}

if(Test-path -Path  "$($QOSMGeodata)/al_ta_qc_2_102_fra.shp"){
    "...Territoires autochtones"
    $cmdParms = $cmdString + '-nlt MULTIPOLYGONZ ' + $($QOSMGeodata) + '/al_ta_qc_2_102_fra.shp -s_srs EPSG:4617 -t_srs EPSG:4326 -lco geometry_name=geom -lco precision=no -nln sources.terres_autochtones'
    start-process -filepath $ogr2ogr $cmdParms  -NoNewWindow -Wait
}

Set-Item Env:PGCLIENTENCODING ISO-8859-1

if(Test-path -path  "$($QOSMGeodata)/trq/terzec_s"){
    "... zecs"
    $cmdParms = $trqcmdString + '-nlt MULTIPOLYGONZ "' + $($QOSMGeodata) + '/trq/terzec_s" "pal" -s_srs EPSG:4269 -t_srs EPSG:4326 -lco geometry_name=geom -lco precision=no -lco schema=sources -lco overwrite=yes -nln "zecs"'
    start-process -filepath $ogr2ogr $cmdParms 
}

if(Test-path -path  "$($QOSMGeodata)/trq/terpde_s"){
    "... Pourvoiries à droits exclusifs"
    $cmdParms = $trqcmdString + '-nlt MULTIPOLYGONZ "' + $($QOSMGeodata) + '/trq/terpde_s" "pal" -s_srs EPSG:4269 -t_srs EPSG:4326 -lco geometry_name=geom -lco precision=no -lco schema=sources -lco overwrite=yes -nln "pourvoiries"'
    start-process -filepath $ogr2ogr $cmdParms -NoNewWindow -Wait
}

if(Test-path -path  "$($QOSMGeodata)/trq/terpnc_s"){
    "... Parcs Nationaux du Canada"
    $cmdParms = $trqcmdString + '-nlt MULTIPOLYGONZ "' + $($QOSMGeodata) + '/trq/terpnc_s" "pal" -s_srs EPSG:4269 -t_srs EPSG:4326 -lco geometry_name=geom -lco precision=no -lco schema=sources -lco overwrite=yes -nln "parcs_nationaux_canada"'
    start-process -filepath $ogr2ogr $cmdParms -NoNewWindow -Wait
}

if(Test-path -path  "$($QOSMGeodata)/trq/terpnq_s"){
    "... Parcs Nationaux du Québec"
    $cmdParms = $trqcmdString + '-nlt MULTIPOLYGONZ "' + $($QOSMGeodata) + '/trq/terpnq_s" "pal" -s_srs EPSG:4269 -t_srs EPSG:4326 -lco geometry_name=geom -lco precision=no -lco schema=sources -lco overwrite=yes -nln "parcs_nationaux_quebec"'
    start-process -filepath $ogr2ogr $cmdParms -NoNewWindow -Wait
}

if(Test-path -path  "$($QOSMGeodata)/trq/terpre_s"){
    "... Parcs Régionaux"
    $cmdParms = $trqcmdString + '-nlt MULTIPOLYGONZ "' + $($QOSMGeodata) + '/trq/terpre_s" "pal" -s_srs EPSG:4269 -t_srs EPSG:4326 -lco geometry_name=geom -lco precision=no -lco schema=sources -lco overwrite=yes -nln "parcs_regionaux"'
    start-process -filepath $ogr2ogr $cmdParms -NoNewWindow -Wait
}

if(Test-path -path  "$($QOSMGeodata)/trq/terref_s"){
    "... Réserves fauniques"
    $cmdParms = $trqcmdString + '-nlt MULTIPOLYGONZ "' + $($QOSMGeodata) + '/trq/terref_s" "pal" -s_srs EPSG:4269 -t_srs EPSG:4326 -lco geometry_name=geom -lco precision=no -lco schema=sources -lco overwrite=yes -nln "reserves_fauniques"'
    start-process -filepath $ogr2ogr $cmdParms -NoNewWindow -Wait
}

if(Test-path -path  "$($QOSMGeodata)/trq/terrnf_s"){
    "... Réserves naturelles de faune"
    $cmdParms = $trqcmdString + '-nlt MULTIPOLYGONZ "' + $($QOSMGeodata) + '/trq/terrnf_s" "pal" -s_srs EPSG:4269 -t_srs EPSG:4326 -lco geometry_name=geom -lco precision=no -lco schema=sources -lco overwrite=yes -nln "reserves_naturelles_faune"'
    start-process -filepath $ogr2ogr $cmdParms -NoNewWindow -Wait
}

if(Test-path -path  "$($QOSMGeodata)/trq/terrom_s"){
    "... Refuges d'oiseaux migrateurs"
    $cmdParms = $trqcmdString + '-nlt MULTIPOLYGONZ "' + $($QOSMGeodata) + '/trq/terrom_s" "pal" -s_srs EPSG:4269 -t_srs EPSG:4326 -lco geometry_name=geom -lco precision=no -lco schema=sources -lco overwrite=yes -nln "refuges_oiseaux_migrateurs"'
    start-process -filepath $ogr2ogr $cmdParms -NoNewWindow -Wait
}

Set-Item Env:PGCLIENTENCODING UTF-8

# On va maintenant traiter les autres fichiers (csv, xml, xls, etc)

# Les lieux d'accueils sont dans un fichiers .xml contenant plusieurs tables.
# On utilise un programme VB.NET(.NET CORE) pour les convertir en csv.
# Il faut d'abord créer le programme VB en utilisant le modèle

"Conversion des lieux d'accueil en csv."
(Get-Content "$($QOSMroot)/Program.vb.modele").replace('[geodata]', $QOSMGeodata+"/") | Set-Content "$($QOSMroot)/vbdotnet/Program.vb"

# On peut maintenant l'exécuter
$dotnetcmd = 'dotnet'
$dotnetparms = 'run -p ' + $($QOSMroot) + '/vbdotnet'
start-process -filepath $dotnetcmd $dotnetparms -NoNewWindow -Wait

# Traiter le fichier excel des barrages avant l'importation des données dans postgis.
# Convertir le fichier en csv en utilisant un script vb sous Windows ou gnumeric (ssconvert) sous Linux.
# Sous windows il faut aussi convertir le fichier en UTF-8

# Définir les fichiers xls et csv dans des variables.
"Conversion du fichiers barrages.xls en csv (utf8)."
$xls = "$($QOSMSources)/barrages.xls"
$csv = "$($QOSMSources)/barrages.csv"
$tmp = "$($QOSMSources)/temp.csv"

# Supprimer les csv s'ils existent déjà.
if(Test-Path "$csv"){
    Remove-Item $csv -Force
}

if(Test-Path "$tmp"){
    Remove-Item $tmp -Force
}

# Exécuter le VB script ou ssconvert
if ($Windows){
    cscript.exe "$($QOSMVBScript)/xlstocsv.vbs" $xls $tmp
    # Faire la conversion UTF-8
    $source = get-content $tmp
    $utf8 = New-Object System.Text.UTF8Encoding $false
    [system.io.file]::WriteAllLines($csv, $source, $utf8)
}


if ($Linux){
    "Convertir barrages.xls vers barrages.csv"
    "..Un mise en garde à propos de D-BUS, X11 DISPLAY est normale sous WSL"
    $cmdParms = "$($xls) $($csv)"
    start-process -FilePath $ssconvert $cmdParms -NoNewWindow -Wait
}

# Le fichier excel des barrages contient une ligne d'entête avant celle des noms de colonnes comme ceci:
# IDENTIFICATION,,LOCALISATION,,,,,,,,,,HYDROGRAPHIE,,,CARACTÉRISTIQUES,,,,,,,,,,,,,,,,,,,,,ÉVALUATION DE LA SÉCURITÉ,,,,,,,
# Numéro barrage,Nom du barrage,Région administrative,MRC,Municipalité,Latitude deg dec (Nad 83),Longitude deg dec (Nad 83),Latitude (Nad 83),Longitude (Nad 83),Nom du réservoir,Territoire,Aménagement,Bassin,Lac,Cours d'eau,Catégorie Administrative,Utilisation,Hauteur du barrage (m),Hauteur de retenue               (m),Type de barrage,Classe,Zone sismique,Sup. Bassin                   (km2),Année Construction,Année Modification,Capacité de retenue                  (m3),Longueur                (m),Terrain de fondation,Niveau des conséquences,Sup. réservoir                  (ha),Longueur refoulement               (m),Barrage en amont,Barrage en aval,Propriétaire / Mandataire,Adresse,Code Postal,No Étude,Année prévue étude,Année dernière étude,Date prévue exposé correctifs,Réception exposé correctifs,Étape analyse approbation,Date approbation,Étape réalisation des correctifs
# Avant de pouvoir importer le fichier dans PostGIS nous devons supprimer cette ligne.
$csvtemp = "$($QOSMSources)/csvtmp.tmp"
get-content $csv |
    select -Skip 1 |
    set-content "$csvtemp"
move "$csvtemp" $csv -Force


# Supprimer les fichiers temporaires
if(Test-Path "$tmp"){
    Remove-Item $tmp -Force
}
if(Test-Path "$csvtemp"){
    Remove-Item $tmp -Force
}

# Copier les .csv dans le répertoire geodata
Copy-Item "$($QOSMSources)/*.csv" $QOSMGeodata -Force


# Créer le script importer_csv.sql
(Get-Content "$($QOSMroot)/importer_csv.modele").replace('[geodata]', $SQLGeodata) | Set-Content "$($QOSMSQL)/importer_csv.sql"

"Chargement des données en fichiers csv dans la base de données PostGIS."
$cmdParms = '-h gis -d qosm -U ' + $PGUser + ' -f sql/importer_csv.sql'
start-process -filepath $psql $cmdParms -NoNewWindow -Wait


"Traitement des données:"

if ($inclureAeroports){
    "...Aéroports"
    $cmdparms = '-h gis -d qosm -U ' + $PGUser + ' -f sql/Aeroports.sql'
    start-process -FilePath $psql $cmdparms  -NoNewWindow -Wait
}

if ($inclurePistes){
    "...Aéroports pistes"
    $cmdParms = '-h gis -d qosm -U ' + $PGUser + ' -f sql/Aeroports_Pistes.sql'
    start-process -FilePath $psql $cmdparms  -NoNewWindow -Wait
}

if ($inclureBarrages){
    "...Barrages"
    $CmdParms = '-h gis -d qosm -U ' + $PGUser + ' -f sql/Barrages.sql'
    start-process -FilePath $psql $cmdparms  -NoNewWindow -Wait
}

if ($inclureElectrique){
    "...Réseau électrique"
    $cmdParms = '-h gis -d qosm -U ' + $PGUser + ' -f sql/Electrique.sql'
    start-process -FilePath $psql $cmdparms  -NoNewWindow -Wait
}

if ($inclureMines){
    "...Mines orphelines ou abandonnées"
    $cmdParms = '-h gis -d qosm -U ' + $PGUser + ' -f sql/Inmoa.sql'
    start-process -FilePath $psql $cmdparms  -NoNewWindow -Wait
}

if ($inclureParcRoutier){
    "...Parc routier"
    $cmdParms = '-h gis -d qosm -U ' + $PGUser + ' -f sql/Parc_routier.sql'
    start-process -FilePath $psql $cmdparms  -NoNewWindow -Wait
}

if ($inclurePhotoRadar){
    "...Radars photos"
    $cmdParms = '-h gis -d qosm -U ' + $PGUser + ' -f sql/Photoradar.sql'
    start-process -FilePath $psql $cmdparms  -NoNewWindow -Wait
}

if ($inclureTelephone){
    "...Téléphones d'urgence"
    $cmdParms = '-h gis -d qosm -U ' + $PGUser + ' -f sql/Telephone_urg.sql'
    start-process -FilePath $psql $cmdparms  -NoNewWindow -Wait
}

if ($inclureVilles){
    "...Villes"
    $cmdParms = '-h gis -d qosm -U ' + $PGUser + ' -f sql/Villes.sql'
    start-process -FilePath $psql $cmdparms  -NoNewWindow -Wait
}

if ($inclureAccueilsZecs){
    "...Accueils Zecs"
    $cmdParms = '-h gis -d qosm -U ' + $PGUser + ' -f sql/Accueils_Zecs.sql'
    start-process -FilePath $psql $cmdparms  -NoNewWindow -Wait
}

if ($inclureCampingsZecs){
    "...Campings Zecs"
    $cmdParms = '-h gis -d qosm -U ' + $PGUser + ' -f sql/Campings_Zecs.sql'
    start-process -FilePath $psql $cmdparms  -NoNewWindow -Wait
}


if ($inclureTerresAutochtones){
    "...Territoires autochtones"
    $cmdParms = '-h gis -d qosm -U ' + $PGUser + ' -f sql/Terres_Autochtones.sql'
    start-process -FilePath $psql $cmdparms  -NoNewWindow -Wait
}

if ($inclureAQRP){
    "...Fermetures de ponts depuis la dernière mise à jour AQ Réseau+."
    $cmdParms = '-h gis -d qosm -U ' + $PGUser + ' -f sql/Fermetures_Ponts.sql'
    start-process -FilePath $psql $cmdparms  -NoNewWindow -Wait
}


if ($inclureAQRP){
    "...AQRéseau+ (Réseau routier et ferroviaire)"
    $cmdParms = '-h gis -d qosm -U ' + $PGUser + ' -f sql/aqrp.sql'
    start-process -FilePath $psql $cmdparms  -NoNewWindow -Wait
}

if ($inclureTrq){
    "...TRQ (Territoires Récréatifs)"
    $cmdParms = '-h gis -d qosm -U ' + $PGUser + ' -f sql/Territoires_recreatifs.sql'
    start-process -FilePath $psql $cmdparms  -NoNewWindow -Wait
}

if ($inclureLieuxAccueil){
    "...Tourisme (Lieux d'accueil)"
    $cmdParms = '-h gis -d qosm -U ' + $PGUser + ' -f sql/Tourisme.sql'
    start-process -FilePath $psql $cmdparms  -NoNewWindow -Wait
}

# Créer le script final
(Get-Content "$($QOSMroot)/PostGIS2OSM.sql.modele").replace('[qosmfinal]', $QOSMFinal) | Set-Content "$($QOSMSQL)/PostGIS2OSM.sql"


"...création du fichier osm"
$cmdParms = '-h gis -d qosm -U ' + $PGUser + ' -f sql/PostGIS2osm.sql'
start-process -FilePath $psql $cmdparms  -NoNewWindow -Wait

Set-Item Env:PGPassword ""
Set-Item Env:PGCLIENTENCODING ""

$endDTM = (Get-Date)

# Echo Time elapsed
"Temps écoulé: $(($endDTM-$startDTM).totalseconds) secondes."