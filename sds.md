# Inledning

## Bakgrund 

## Kundens domän krav

## Översikt över systemet

Bilder på hur systemet kommunicerar med de olika delarna.

Bilder på olika gränssnitt (mock-ups)

UML-diagram (draw.io t.ex.)

Komponentdiagram

# Backend och databas

* Backenden kan utvecklas i godtyckligt relevant programmeringsspråk (förslagsvis Python, PHP, JavaScript).
* Databasen skall kunna hantera relevant data.

ER-diagram

# REST API

* Systemet skall erbjuda ett väldokumenterat REST API som tredjepartsleverantörer kan använda för att bygga extra tjänster och applikationer.
* REST API:et skall kunna hantera flera olika versioner, tex genom att använda v1/ som en del i URI:n.
* REST API:et skall hantera autentisering så man kan kontrollera/begränsa belastningen som varje applikation ger. 

# Administrativt webbgränssnitt

Sök- och filtrerings-funktioner. Söka efter elsparkcykel...

* Man kan se alla städer och cyklar som finns i systemet.

Visas på en karta - exempel på en sådan karta? OpenStreetMap? (GeoJSON, Leaflet)

* Varje stad har ett antal laddstationer där cyklarna kan laddas. Kunden eller servicepersonalen kan förflytta en cykel dit.

Admin ska kunna styra alla cyklar.

Cyklar ska inte gå att flytta virtuellt. Ingen funktionalitet för att kunna flytta cyklar.

* Varje stad har ett antal accepterade platser där cyklar bör parkeras.

Detta ska finnas tillgängligt i en karta. Här kan man också ha exempel (bild). Bör finnas tillgänglig i kundens app och eventuellt i webbgränssnitt.

* Cyklar kan även parkeras utanför laddstationer och utanför accepterade platser, men det kan då tillkomma en extra avgift för kunden. Detta kallas fri parkering.

* Man kan se var cyklarna finns parkerade.

Filterfunktion: se endast parkerade.

* Man kan se hur många (och vilka) cyklar som finns på varje laddstation och accepterad parkeringsplats.

filter: på parkeringsplatser, på laddstationer

* Man skall kunna se och hantera kunder i systemet.

Lista på kunder och funktionalitet för att hantera dessa. CRUD. mock-up

* Varje resa som en kund gör kostar pengar, dels en fast taxa och en rörlig taxa per tidsenhet och en taxa beroende av var de parkerar.

Manipulera taxa? Olika taxa för olika städer.

* Om en kund tar en cykel som står på fri parkering - och lämnar på en definierad parkering - så blir startavgiften lite lägre

Rabatter för gott beteende. Bonussystem?

* Man kan få en översikt över laddstationer och cyklar och deras position på en karta. 

Karta med filter. mock-up

# Kundens webbgränssnitt

* Kunden kan logga in på en webbplats och se detaljer om sitt konto.

Användarnamn, lösenord, namn, adress etc. Saldo. mock-up

* Kunden kan skapa ett konto och logga in via OAuth. **Här väljer vi att använda minst Github**

Kan även logga in med användarnamn och lösenord. mock-up

* Kunden kan se en historik över resorna, med alla detaljer som sparats, inklusive kostnaden.

Lista som kan filtreras och söka i. mock-up

* Kunden kan fylla på med pengar till sitt konto (prepaid), eller låta systemet dra pengar varje månad via en betalningstjänst.  

Swish, Kort, Klarna etc. mock-up

# Kundens app

* Kunden kan hyra en specifik cykel.

Identifieras med ID.

* Under hyrtiden kan kunden köra cykeln.

hastighet, vänster, höger.

* Kunden lämnar tillbaka cykeln.

Pengar dras från saldo. Notiser om bonussystem, "du kunde sparat pengar om..."

* (extra) Visa en kartbild där alla laddstationer, accepterade parkeringsplatser finns.
* (extra) Visa en kartbild där alla alla lediga cyklar finns.

filter: lediga/i bruk

mock-ups

# Cykelns program

* Detta program är tänkt att köra i varje cykel och styra/övervaka den.

hastighet, svänga, bromsa, position, batteri, lampor fungerar, luft i däcken etc.

* Cykeln meddelar dess position med jämna mellanrum.

Olika beroende på om den kör eller står still. 

Ofta i hög fart, mindre ofta i låg. 1 gång per minut i stilla.

* Cykeln meddelar om den kör eller står stilla och vilken hastighet den rör sig i.

* Man skall kunna stänga av/stoppa en cykel så att den inte kan köras längre.

Underhållsläge - batteri lågt, lampor fungerar inte, dålig luft i däcken, i vissa positioner (utanför stadens område, strand etc.)

* När en kund hyr cykeln är det möjligt att starta den och köra.

* Kunden kan lämna tillbaka en cykel och släppa kontrollen över den.

(Ta emot bild på parkering)

* Cykeln varnar när den behöver laddas.
* Cykeln sparar en logg över sina resor med start (plats, tid) och slut (plats, tid) samt kund.
* När cykeln tas in för underhåll eller laddning så markeras det att cykeln är i underhållsläge. En cykel som laddas på en laddstation kan inte hyras av en kund och en röd lampa visar att den inte är tillgänglig.

Olika färger i kartan. Röd inte tillgänglig, orange i drift, grön ledig.

# Simulera drift i systemet

* Via docker-compose skall man kunna starta hela systemet och se det i drift.
* Man skall kunna simulera ett antal 1000 cyklar och ett antal 1000 kunder och simulera att de rör sig i systemet, som om det vore på riktigt. Detta är en viktig del för att kvalitetssäkra systemet och påvisa att det fungerar.

"Vårt system kan hantera 10000 cyklar och det bevisar vi genom simulering med systemet i drift."

# Kodbas

* Systemet skall finnas tillgängligt i ett (eller flera) versionshanterade repon.
* Det skall vara enkelt att sätta igång systemet för test och utveckling.
* Utvecklingsmiljön skall fungera med docker-compose (docker).
* Varje repo dokumenteras i sin README.md.

"Om vi slutar så finns kunskapen kvar på grund av våra versionshanterade repos."

# Test och verifikation

"Vi bygger en gedigen test-suite och testar innan koden går "live"."

* Systemet skall innehålla automatiserade tester.
* Systemet (och dess delar) skall ha ett CI/CD-flöde via en byggtjänst likt GitHub Actions/Scrutinizer/Travis/CircleCI.
* Systemet (och dess delar) skall vara kopplade till en eller flera tjänster som påvisar systemets kodkvalitet (Tex Scrutinizer eller liknande).
* Verktyg för att validera kodstandard och “mess detection” skall vara en del av de tester som körs.

# Driftsättning

* Systemet skall kunna köras via docker-compose. Med ett kommando kan man starta upp hela systemet och provköra det.
* Det är optionellt att visa hur man driftsätter hela systemet på en extern server.




