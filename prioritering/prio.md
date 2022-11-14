# Prioritering av systemets komponenter och funktionalitet

## Underlag för prioritering

Alla krav i kravspecifikationen är hårda krav som skall uppfyllas. Men det har ju varit ganska tydligt att vi antas inte hinna med allt, och därför får se till att uppfylla det viktigaste för att få ett fungerande system. För att lyckas med detta behöver vi ha en tydlig intern prioriteringslista som stöttar oss i att fokusera på rätt saker.

Det finns dessutom ett par krav som vi har "uppfunnit" på egen hand. Dessa krav hade varit fräcka att implementera, och kanske kan resultera i en guldstjärna, men behandlas i denna genomgång som grädde på det funktionella moset.

Alla synpunkter nedan är i skrivande stund Patriks och representerar inte gruppens svärmmedvetande.

Komponent     | Funktion         | Obligatorisk | Kommentar
---------|--------------------|----------------|-----------
 Databas | Geografiska index | X | För att "kunna hantera relevant data", i detta fallet positioner. Utan geografiskt index kommer sökningar av typen "visa alla elsparkcyklar i denna kartvyn" ta onödigt lång tid
 Databas  | Hantera analyser som PointInPolygon | / | Behöver ej implementeras i databas även om man skulle vilja ha med. Kravet i spec finns men inte jättetydligt 
 Databas  | Hantera framtagning av rutter längs vägnät | - |För simulering. Tror lättast implementera i databas men overkill
 Backend  | Hantera analyser som PointInPolygon | / | Behöver ej implementeras i backend även om man skulle vilja ha med. Kravet i spec finns men inte jättetydligt 
 Backend  | Hantera framtagning av rutter längs vägnät | - |För simulering. Tror lättare implementera i databas men overkill
 API    | RESTful | - | Med tanke på att mos tycker man kan köra GraphQL verkar "REST" mest betyda...ja vad? oklart! 
 API  | Väldokumenterat | X | För vår skull såklart. Men också för tredjepartsleverantörer!
 API | Versionshantering | X | Detta kravet antar jag är till för att hantera vidareutveckling med bibehållen bakåtkompatibilitet? och är ju rimligt lätt att implementera bara man konstruerar sina routes rätt från början, sätter därför det som obligatoriskt
 API | Autentisering | X | Såklart! Bra avsätta ordentligt med tid till detta också pga känns svårt att få riktigt bra säkerhet och riktigt bra UX samtidigt
 Admin-gränssnitt | Kartvy med städer, laddstationer och elsparkcyklar | X | Grundläggande
 Admin-gränssnitt | Uppdatera data | X | Ny/ändrad stad, laddstation, parkeringsplats, område med speciella regler. Skall elsparkcyklar kunna initieras härifrån?
 Admin-gränssnitt | Laddstationer | X | Kunden ska kunna parkera vid laddstation. Oklar implementering av servicepersonalens flytt av elsparkcykel dit
 Admin-gränssnitt | Parkeringsplatser | X | Påverkar priset för kunden
 Admin-gränssnitt | Se elsparkcyklars status | X | Parkerad, uthyrd, på laddstation, med relation till parkeringsplats och laddstation i förekommande fall
 Admin-gränssnitt | Se lista på alla kunder | X | 
 Admin-gränssnitt | Hantera kund | X | 
 Admin-gränssnitt | Hantera taxa per kund | - | Ej uttalat krav
 Admin-gränssnitt | Hantera generella rabatter | - | Ej uttalat krav
 Admin-gränssnitt | Taxa för resa | X | Skall baseras på fast avgift, avgift per tid, och rabatt om elsparkcykel parkeras på anvisad plats + ytterligare rabatt om kund hyr elsparkcykel som står på ej anvisad plats
 Kunds webgränssnitt | Skapa konto | X | Blivande kund ska kunna skapa konto
 Kunds webgränssnitt | Inloggning | X | Inloggad kund ska kunna se detaljer om sitt konto
 Kunds webgränssnitt | Ändra uppgifter | - | Ej uttalat krav men rimligt att kunna ändra adress etc
 Kunds webgränssnitt | Resehistorik | X | Kund ska kunna se vilka resor man gjort, när, kostnad
 Kunds webgränssnitt | Betalning | X | Systemet ska antingen stödja förbetalda resor, eller låta systemet dra pengar automatiskt varje månad via betaltjänst tex Klarna
 Kunds app | Hyra elsparkcykel | X | 
 Kunds app | Köra hyrd elsparkcykel | X |
 Kunds app | Avsluta hyrning | X |
 Kunds app | Karta med laddstationer + parkeringar | - | Uttalat extrakrav i spec
 Kunds app | Karta med lediga elsparkcyklar | - | Uttalat extrakrav i spec
 Kunds app | Kunna köra "virtuell cykel" | - - - | Hade vart kul att ha kontroller för detta i app men ligger sist i prio
 Reparatörs app | Se alla elsparkcyklar i karta | - |
 Reparatörs app | Söka elsparkcykel | - | Efter avstånd, status
 Reparatörs app | Ändra status på elsparkcykel | - | Skanna QR-kod, regga som under reparation, förflyttas, tillgänglig 
 elsparkcykelhjärna | Köra i varje elsparkcykel | X |
 elsparkcykelhjärna | Meddela position regelbundet | X |
 elsparkcykelhjärna | Veta sin status | X | Laddläge, på underhåll, i rörelse, hastighet,
 elsparkcykelhjärna | Pusha status till backend | X |
 elsparkcykelhjärna | Kommunicera status till kund | X | Laddläge, på underhåll. Röd lampa på elsparkcykel, markör i karta
 elsparkcykelhjärna | Ta emot och agera på stoppkommando | X |
 elsparkcykelhjärna | Ta emot hyrkommando och öppna för drift | X |
 elsparkcykelhjärna | Ta emot kommando om avslutad hyra | X |
 elsparkcykelhjärna | Varna vid lågt batteri | X |
 elsparkcykelhjärna | Spara logg över resor | X | Start och slut med plats och tid för vardera, kund
 Simulering | Starta system och simulering med docker-compose | X | 
 Simulering | Lasttest | X | 1000-tals elsparkcyklar, 1000-tals kunder ska kunna hanteras
 Simulering | Visualisering | X | Man ska kunna se simuleringen i karta i realtid
 Simulering | Riktiga rutter | - | Tvinga elsparkcykel att köra längs väg
 Simulering | Vettiga rutter | - | Tvinga elsparkcykel att inte köra i vatten
 Kodbas | Repo | X | Ett eller flera, versionshanterat
 Kodbas | Dev-miljö funka med docker-compose | X | Löser vi med vår Docker-miljö
 Kodbas | Enkelt starta för test/dev | X | Löser vi med vår Docker-miljö
 Kodbas | Dokumentation | X | Varje repo dokumenteras med README.md
 Test | Automatiserade tester | X | Ska vi använda samma testverktyg för alla komponenter? Kan bli svårt hitta nåt som passar
 Test | CI/CD | X | Github Actions?
 Test | Kodkvalitet | X | Vad ska vi använda här? Har begränsad erfarenhet
 Test | Kodstandard | X | Detta vi börjat implementera med pre-commit - kommer vi hela vägen med pre-commit?
 Driftsättning | Docker-compose | X | Ett kommande för att starta. UTÖVER simuleringen, glöm inte denna!
 Driftsättning | Extern server | - | Hade varit kul att lösa! Men återkommer till denna senare, ej prio






