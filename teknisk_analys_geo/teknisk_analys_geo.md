# Hantering av geodata i databas/backend

Vår plattform för hantering av elsparkcyklar behöver kunna hantera geodata på ett effektivt sätt. Geodata kommer att användas dels för presentation av cyklar och andra företeelser på en karta, och dels för vissa enklare analyser. En del av denna "geospatiala kompetens" kommer att befinna sig i en webklient, och en del kommer vi behöva implementera backend. Denna lilla studie försöker identifiera några olika, rimliga, alternativ för implementationen i backend.

## Systemets behov av geospatiala funktioner

Systemet behöver kunna:

* Visa objekt på karta med god prestanda (dvs hantera geografiska index på data)
* Känna av om en elsparkcykel befinner sig i ett område med särskilda begränsningar, t ex hastighetsbegränsning, ej tillåtet att framföra elsparkcykel

Det är även bra om systemet kan:

* Känna av om en elsparkcykel befinner sig utanför vägnätet
* Vid simulering och lasttest av systemet, simulera elsparkcyklars framfart längs vägnätet.

Kraven ovan innebär att systemet måste kunna:

* Lagra information om platsdata med geografiska index, för att möjliggöra god prestanda vid frågor mot databasen
* Stödja point-in-polygon-frågor (pip) för att kunna avgöra om en elsparkcykel befinner sig i ett område med särskilda krav
* Pip-frågor kan också användas för att avgöra var en elsparkcykel befinner sig i förhållande till vägnätet. Denna operation måste lösas inom en tidsram om några millisekunder för att kunna styra cykeln till att bara framföras på vägnätet. För att hantera denna styrning med pip behöver man omforma vägnätet, som vanligtvis består av linjesegment, till polygoner med hjälp av en buffer. Det finns dock en reell risk att vägnät-som-polygon resulterar i en geometri som är så komplex att pip-frågan tar alltför lång tid att besvara. Fundera därför gärna på andra möjliga sätt att hantera detta på.
* För att simulera en elsparkcykels framfart längs vägnätet krävs att systemet kan beräkna en rutt längs vägnätet från startpunkt till slutpunkt.

Genomgången nedan fokuserar på olika alternativa sätt att implementera lösningarna ovan i databas och/eller backend

## Databas

### PostGres/PostGIS/pgRouting

PostGres

PostGres är en populär relationsdatabashanterare i öppen källkod. Tillägget PostGIS ger PostGres ett stort utbud av geografiska datatyper, tillräckligt för i princip alla tänkbara tillämpningar, samt ett mycket rikt utbud av spatiala metoder som kan anropas med SQL (se https://postgis.net/ för mer info). Ett exempel på en sådan spatial metod som verkar användbar i detta sammanhang är ST_AsGeoJSON, som används för att hämta ut geodata lagrat enligt PostGIS spatiala datatyp som geojson, färdigt att konsumeras i en webbkarta (https://postgis.net/docs/ST_AsGeoJSON.html). 

PgRouting (https://pgrouting.org/) utökar PostGres ytterligare med allt som behövs för ruttanalyser.

Med data i en PostGres/PostGIS-databas har man all funktionalitet man behöver för att lösa de behov som identifierats ovan. Det innebär dock inte självklart att denna lösning ger tillräcklig prestanda. Det är framförallt uppdateringar av elsparkcyklarnas positioner som kan komma att utgöra en flaskhals, särskilt om man samtidigt vill veta huruvida positionen är tillåten.

### MongoDb

MongoDb har basalt stöd för att lagra geografisk data med ett geografiskt index (se https://www.mongodb.com/docs/manual/geospatial-queries/ för mer info). Detta basala stöd - geojson - är rimligtvis dock tillräckligt i denna tillämpning, då kartklienten ändå med stor sannolikhet kommer kunna och vilja utnyttja geojson.

MongoDb har också ett antal grundläggande "geospatial query operators" (se https://www.mongodb.com/docs/manual/reference/operator/query-geospatial/) som täcker in alla behovsom beskrivits ovan, förutom ruttplanering vid simulering. Precis som för PostGres är det dock inte säkert att uppdatering av elsparkcyklarnas positioner  kan ske med tillräcklig prestanda, särskilt om man samtidigt vill veta huruvida positionen är tillåten.

## Backend i övrigt

Man kan också tänka sig att man skriver kod för att hantera geografiska analyser i backenden utanför databasen. Vi tittar på vilka möjligheter som finns i ekosystemen kring NodeJS och Python nedan.

### NodeJS/npm

#### TurfJS 

https://www.npmjs.com/package/@turf/turf , http://turfjs.org/ , https://github.com/Turfjs/turf/

TurfJS är ett lite större, modulärt, bibliotek med färdiga funktioner för att lösa geografiska frågor. In- och utdata är geojson. Turf kan köras både i NodeJS och i browsern.

Bland de metoder som skulle kunna vara användbara i detta sammanhang finns bl a:

pointToLineDistance - minsta avståndet mellan en punkt (elsparkcykel) och en linestring (en del av vägnätet)

booleanPointInPolygon - är en punkt (elsparkcykel) i en polygon (område med särskilda bestämmelser)?

along - denna metod returnerar en punkt vid en position x m längs en linestring. Detta skulle potentiellt kunna användas för att skapa en simulerad rutt för en elsparkcykels färd längs vägnätet. 

#### Geolib

https://www.npmjs.com/package/geolib

Geolib kan köras både i NodeJS och i browsern. Indata kan vara ett objekt med ett koordinatpar på formen lat/lon, eller en geojson-koordinatarray på formen [lon, lat]. Såvitt jag kan utläsa ur dokumentationen accepteras inte "vanlig" geojson, utan endast en koordinatarray.

Den metod som mest uppenbart kan vara användbar i detta sammanhang är:

isPointInPolygon - är en punkt (elsparkcykel) i en polygon (område med särskilda bestämmelser)?


#### Sammanfattning NodeJS/npm

Det kan finnas fler bibliotek därute som kan vara till nytta, men TurfJS och Geolib är de, vad det verkar på npmjs.com, mest använda biblioteken. TurfJS förefaller ha lite fler metoder som kan vara potentiellt nyttiga, men jag har inte utvärderat prestande för någon av metoderna ovan. Om Geolibs algoritm för pip är snabbare än TurfJS är väl det absolut ett argument för att köra Geolib istället.

### Python

Python är det mest använda programmeringsspråket inom geospatial analys (https://www.gislounge.com/python-and-geospatial-analysis/). Det finns därför en uppsjö av olika bibliotek att använda sig av för att ge vår backend geospatiala analysmöjligheter. Det största problemet här är alltså att hitta lättanvända bibliotek av rimlig storlek, och helst då ett enda bibliotek som kan ge oss allt vi behöver.

#### GeoDjango

Vid en första anblick verkar GeoDjango (https://docs.djangoproject.com/en/2.2/ref/contrib/gis) vara precis vad vi letar efter - en go liten plugin till Django som låter oss bygga vår backend med stöd för geospatiala analyser. Det visar sig dock att GeoDjango i princip hämtar sina analysmöjligheter från databasen som används (https://docs.djangoproject.com/en/2.2/ref/contrib/gis/db-api/) och därför inte stöder vilken databas som helst. Vill man ha en, vad det verkar, lättanvänd Python-wrapper runt sin SQL kan dock GeoDjango vara ett bra alternativ, speciellt om man redan bestämt sig för att bygga sin backend i Django.

Som självständig, helt databasagnostisk komponent funkar den dock inte, så vi släpper GeoDjango här.

#### Shapely

Shapely (https://shapely.readthedocs.io/en/) är ett bibliotek med många olika funktioner för geospatial analys.Med hjälp av Shapely kan man tillfredställa alla våra behov utom ett, ruttning av elsparkcyklar vid simulering. Shapely kräver dock att man skapar upp geometrierna man vill använda på ett Shapely-specifikt sätt. För att kunna hantera ett dataflöde från, säg, en webbkarta till och från Shapely verkar man behöva använda andra bibliotek, t ex Fiona (https://fiona.readthedocs.io/en/stable/). Slänger man in Folium (https://python-visualization.github.io/folium/modules.html#module-folium.vector_layers) i mixen har man också en komponent som renderar Leaflet-baserade webbkartor åt en. Men det blev ju väldigt många olika bibliotek här...

PyQGIS (https://docs.qgis.org/3.22/en/docs/pyqgis_developer_cookbook/index.html) är ett Python-API mot QGIS, 


