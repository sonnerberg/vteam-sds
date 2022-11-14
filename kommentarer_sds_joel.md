# Angående SDS:

## Allmänt
- Vore bra att bestämma terminologi för status på cykeln:
    - Både servicesstatus och uthyrningsstatus eller bara en status?
    - Vilken status kan en cykel ha?

##  1. Introduktion 
- Lägg till bild över användare?
- Ska cykeln autentisera sig? (återkommande fråga nedan)
- Flytta noter till slutet av dokumentet


## 2. Kundens app
- beskriva möjligheterna att styra cykeln kanske bör flyttas till cykelprogrammet?
- Avslutad resa, färdens kostnad beroende på tid på dygnet - extrakrav?. Jag tolkar krav 7 under  administratörsgränssnittet som ett krav på att kostnaden ska beräknas utifrån en grundavgift + en hyra per sekund/minut/timme +/- ev rabatt beroende på var en parkering gjorts. 
- Lägg till en bild som beskriver interaktion med appen - likt den som finns under admingränssnitt
- Välj bland mock-ups

## 3. Kundens webbgränssnitt
- Lägga till: "eller genom Github Oauth" efter text om inloggning. Ska vi ha med båda sätten att logga in?
- Lägga till bild som beskriver interaktionen med appen likt den som finns under admingränssnitt

### API-tabellen: 
- Lägga till route(s) som sätter cykelns status (ok, serviceläge) (eller är det det som är stoppa-routen?)
- Lägga till route(s) som sätter cykelns uthyrningsstatus
- Lägga till routes som cykeln kan använda för att skicka:
- position, status och hastighet
- Lägg till route för att hämta och lägga till parkeringszoner (som t.ex. kan vara av typen parkering/fri parkering eller om vi vill också förbjuden parkering men det är extra)
- Lägga till route för att hantera resa - sätta kostnaden (om vi vill att admin ska kunna ge rabatt för en viss resa - vill vi det?)
- Lägga till route(s) för att hantera taxa: grundtaxa, tidstaxa, parkeringstaxa (krav 8 i admin)
- Ska zon-routsen heta forbidden zones eller bara zones (och sedan kan man hämta vilken typ av zon det är - om vi vill ha förbjudna zoner och hastighetsbegränsningszoner det är nog extrakrav)
- Ska vi kunna följa använderns position (finns en route för det) eller bara cykelns?
- Om vi lägger till routes för allt kanske tabellen passar bättre under avsnittet API - just nu innehåller den mer än det som rör kunden.
- Välj ut någon/några mock-ups


## 4. Admingränssnittet
- Kanske dela upp den stora bilden i tre mindre och sätta ut vid varje avsnitt?
- Användare eller administratörer ska ju kunna flytta elsparkcyklar till laddstationer. Tänker vi att admin gör det genom att uppdatera en cykel med samma koordinater som en laddstation har (fritt kan flytta runt en cykel) eller görs det genom att ange en laddstation och laddstationer och cyklar då har en mer hård koppling. (En laddstation har en eller flera cyklar)? Ska det vara en relation i databasen?
- Lägga till möjligheten att administrera taxor för en viss stad (eller hur ska vi tolka krav 8 under admin). Om ja så bör det också läggas till i bilden.
- Är de enda uppdateringarna man kan göra på en kund att ge rabatt eller ska andra saker (namn, adress, e-post salod t.ex.) också kunna ändras (bilden)?
- Bör admin kunna ta bort en kund? (bilden)
- Lägga till kartbilds mock-up?

## 5. Cykeln
- Vad i texten som finns i sammansatt md är tänkt att vara med? Är det allt eller det som kommer under rubriken SDS?
- Cykeln har bara information om sin egen hälsa och position - bör vi specificera hälsa här? Har cykeln t.ex. inte också information om den är uthyrd (upplåst) eller inte? Bör cykeln också ha information om sin hastighet (är det inte ett krav att den ska kunna meddela det)? Ska den ha info om den rör sig eller står stilla eller får vi det ur hastigheten kanske?
- Skickas detta via API:et?  Behöver cykeln autentiseras?

- Funderar över tjuvlarmet - det är kanske en extra feature?

- Det vore bra med en bild som visar att cykeln skickar:
    - info om status (batteri, kör eller står stilla, hastighet) - annan hälsa mer optionell tror jag) och position.
    - tar emot kommandon om uthyrningstatus, hastighetsbegränsning?, stopp, service från backend
    - tar emot kommandon om hastighet, riktning?/position? från användare 
    - sparar elsparkcykeln historik över sina resor eller skickar den för varje resa stop och start för position och tid och vi sparar detta i databasen? 


## 6. Databas
- Tror att man med en bra bild kan ta bort alla punkter och bara behålla kort info om vad tabellen innehåller samt hur den hänger ihop med andra tabeller och kanske bara förklara mer kryptiska fält som t.ex. status. Så kanske man kan utläsa egenskaperna via bilden och det räcker?

- Relationen mellan sparkcykel och användare - jag tänker att en sparkcykel kan ha en tillfällig användare i ett 1-1 förhållande och att Resa sedan är en kopplingstabell som löser många-många förhållanden mellan användare och sparkcyklar som uppstår genom en uthyrningshistorik. Jag tänkte att man lägger in ett användar-id i en kolumn i cykeltabellen vid uthyrning och tar bort detta (sätter till NULL) vid återlämning. Samtidigt lägger man in användar-id och cykel-id i Resa-tabellen tillsammans med info om starttid och startposition vid uthyrning (är det användarens app som skickar detta eller är det cykeln?) och sedan vid återlämning skickar stoptid och startposition och kostnad. Är det vettigt tänkt kring detta?

- Hur mycket uppgifter ska vi spara om användaren? Hur mycket kan vi spara? Har sett en annan grupp som verkar sikta på ett helt fakturahanteringssystem. Verkar lite overkill utifrån kraven eller?

- Lägg till hastighet i cykeltabellen?

- Räcker det med status i cykeltabellen och vad är det för datatyp - en sträng som nu eller ska det vara olika lägen?

- Lägg till kolumn för generell rabatt för i kundtabellen (om vi vill ha det)

- Lägga till tabell för taxor med koppling till stad? Grundtaxa, tidstaxa, (tid på dagen/kvällen/taxa?), parkeringstaxa

- Lägg till kostnad i resetabellen 

- Ska det finnas en relation mellan en cykel och en laddstation? Eller räcker det med cykelns position och status (laddas)

- Beskriv vilken typ av databas det rör sig om och varför vi valde denna. Om backendavsnittet kommer före detta avsnitt så kan vi hänvisa till det.



## 7. API
- Jag tror att en bild/tabell  över alla routes blir bra som huvudsaklig dokumentation. Tillsammans med bilder för de olika delarna liknande de som finns under admingränssnitt bör det ge en överblick över vad apiet ska hantera för requests och vilken data den får och skickar tillbaka. Vi kan också lägga till att API:et är skrivet i det språk vi väljer och hur vi har resonerat när vi valde bort andra. Bra också att skriva här hur autentiseringen går till vi bör nog beskriva tekniken. Tänker vi använda JWT för admin? OAuth för användare? Cykeln ska den och i så fall hur också autentiseras?

## 8. Backend
- Kanske ska detta avsnitt komma före avsnittet om databasen?
- Bra att inleda med kraven på systemet tycker jag.
- Här tycker jag också det vore bra med ett kort avsnitt om vilka geodatabibliotek som vi tänker använda (om vi kan välja det) och varför vi valt dem.

- Det vore också bra att beskriva vad backend gör i övrigt (i korthet). Är det t.ex. här vi tänker oss att vi:

    - beräknar kostnader för en resa?
    - skickar tillbaka ett response som stoppar en cykel eller begränsar dess hastighet om det behövs (förmodligen extra feeatures?
    - skickar kommandon till cykeln som sätter uthyrningsstatus, servicesstatus, laddningsstatus?
    - hör modeller som kommunicerar med databasen hit eller ligger de på API-nivån?
    - här tänker jag också att man kan beskriva kommunikationen med databasen, eller så läggs det i avsnittet om databasen

## 9. Tester
- Bara kort info om att systemet testas tycker jag, vilka verktyg vi använder kanske.

## 10. Simulering
- Kort stycke om simuleringen - att den kommer att utföras och vad den går ut på?

## 11. Driftsättning
- Ska vi skriva något om hur man kan driftsätta i SDS:en?