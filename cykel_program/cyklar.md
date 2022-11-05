
# Table of Contents

1.  [Översikt](#orgff24b2b)
    1.  [Beteende](#org91347f5)
    2.  [Krav som måste uppfyllas](#org9b9c93d)
        1.  [Positionsdata](#org689404c)
        2.  [Status](#org57212d5)
        3.  [Sensor](#org60cbc6c)
        4.  [Positionsdata och/eller Status och/eller Sensor](#org4ad30f3)
    3.  [Cykel <-> server kommunikation](#org91640b8)
        1.  [HTTP](#org63ef627)
        2.  [Websockets](#org0b7f3ff)
        3.  [IoT protokoll](#org8bae176)
    4.  [Simulering](#org783b4b3)
2.  [SDS](#org662e5ec)
    1.  [Att göra](#org3058b61)
    2.  [Cykelns program](#org9094e66)



<a id="orgff24b2b"></a>

# Översikt


<a id="org91347f5"></a>

## Beteende

-   Varje cykel har sitt eget program och id.
-   En cykel ska kunna meddela position/status med jämna mellanrum.
-   En kund ska kunna hyra och lämna igen en cykel.
-   En Admin ska kunna hantera och se info on cykeln.


<a id="org9b9c93d"></a>

## Krav som måste uppfyllas

Vilken data behövs för att tillmötesgå samtliga krav?

-   [X] Man kan se alla städer och cyklar som finns i systemet.
-   [X] Varje stad har ett antal laddstationer där cyklarna kan laddas. Kunden eller servicepersonalen kan förflytta en cykel dit.
-   [X] Varje stad har ett antal accepterade platser där cyklar bör parkeras.
-   [X] Cyklar kan även parkeras utanför laddstationer och utanför accepterade platser,men det kan då tillkomma en extra avgift för kunden. Detta kallas fri parkering.
-   [X] Man kan se var cyklarna finns parkerade.
-   [X] Man kan se hur många (och vilka) cyklar som finns på varje laddstation och accepterad parkeringsplats.
-   [X] Varje resa som en kund gör kostar pengar, dels en fast taxa och en rörlig taxa per tidsenhet och en taxa beroende av var de parkerar.
-   [X] Om en kund tar en cykel som står på fri parkering - och lämnar på en definierad parkering - så blir startavgiften lite lägre
-   [X] Man kan få en översikt över laddstationer och cyklar och deras position på en karta.
-   [X] (extra) Visa en kartbild där alla alla lediga cyklar finns.
-   [X] Cykeln meddelar dess position med jämna mellanrum.
-   [X] Cykeln meddelar om den kör eller står stilla och vilken hastighet den rör sig i.
-   [X] Man skall kunna stänga av/stoppa en cykel så att den inte kan köras längre.
-   [X] När en kund hyr cykeln är det möjligt att starta den och köra.
-   [X] Kunden kan lämna tillbaka en cykel och släppa kontrollen över den.
-   [X] Cykeln varnar när den behöver laddas.
-   [X] Cykeln sparar en logg över sina resor med start (plats, tid) och slut (plats, tid) samt kund.
-   [X] När cykeln tas in för underhåll eller laddning så markeras det att cykeln är i underhållsläge. En cykel som laddas på en laddstation kan inte hyras av en kund och en röd lampa visar att den inte är tillgänglig.
-   [X] \* Ledig cykel visas som grön, uthyrd som orange, ej tillgänglig som röd.
-   [X] \* hastighet, svänga, bromsa, position, batteri, lampor fungerar, luft i däcken etc.


<a id="org689404c"></a>

### Positionsdata

1.  Man kan få en översikt över cyklar och deras position på en karta
2.  Varje stad har ett antal laddstationer där cyklarna kan laddas.
    Kunden eller servicepersonalen kan förflytta en cykel dit.
3.  Varje stad har ett antal accepterade platser där cyklar bör parkeras.
4.  Cyklar kan även parkeras utanför laddstationer och utanför accepterade platser,
    men det kan då tillkomma en extra avgift för kunden. Detta kallas fri parkering.
5.  Man kan se var cyklarna finns parkerade.
6.  (extra) Visa en kartbild där alla alla lediga cyklar finns.
7.  Cykeln meddelar dess position med jämna mellanrum.
8.  Cykeln meddelar om den kör eller står stilla och vilken hastighet den rör sig i.


<a id="org57212d5"></a>

### Status

1.  Man kan se alla städer och cyklar som finns i systemet.
2.  Man skall kunna stänga av/stoppa en cykel så att den inte kan köras längre.
3.  När en kund hyr cykeln är det möjligt att starta den och köra.
4.  Kunden kan lämna tillbaka en cykel och släppa kontrollen över den.
5.  När cykeln tas in för underhåll eller laddning så markeras det att cykeln är i underhållsläge. En cykel som laddas på en laddstation kan inte hyras av en kund och en röd lampa visar att den inte är tillgänglig.
6.  \* Ledig cykel visas som grön, uthyrd som orange, ej tillgänglig som röd.


<a id="org60cbc6c"></a>

### Sensor

1.  Cykeln varnar när den behöver laddas.


<a id="org4ad30f3"></a>

### Positionsdata och/eller Status och/eller Sensor

1.  Man kan se hur många (och vilka) cyklar som finns på varje laddstation och accepterad parkeringsplats.
2.  Varje resa som en kund gör kostar pengar, dels en fast taxa och en rörlig taxa per tidsenhet och en taxa beroende av var de parkerar.
3.  Om en kund tar en cykel som står på fri parkering - och lämnar på en definierad parkering - så blir startavgiften lite lägre
4.  Cykeln sparar en logg över sina resor med start (plats, tid) och slut (plats, tid) samt kund.
5.  \* hastighet, svänga, bromsa, position, batteri, lampor fungerar, luft i däcken etc.


<a id="org91640b8"></a>

## Cykel <-> server kommunikation

Här har jag, med mina begränsade kunskaper, vänt och vridit på olika sätt att få cykel
och server att prata med varandra och med risk för eventuella tankevurpor och snetänk
så har jag kommit fram till tre alternativ. (feedback uppskattas!)


<a id="org63ef627"></a>

### HTTP

Att använda HTTP går bra från cykel till server, men är värre åt andra hållet.
Tusentals cyklar kräver lika många unika IP adresser och jag vet helt enkelt inte hur
servern ska kunna hitta/hålla reda på alla.


<a id="org0b7f3ff"></a>

### Websockets

Med en websockets connection kan data flöda åt båda hållen, men hur tusentals connections
påverkar serverns prestanda har jag idag ingen aning om. Jag tror inte att själva
kopplingen påverkar så mycket, utan snarare vad servern faktiskt gör med data som den får.


<a id="org8bae176"></a>

### IoT protokoll

Detta känns som en överkurs och skulle bli väldigt förvånad om en IoT lösning hade förväntats av oss.
Men alternativet finns.


<a id="org783b4b3"></a>

## Simulering

Allt ligger lokalt så här är cykel <-> server kommunikation ett icke problem.


<a id="org662e5ec"></a>

# SDS


<a id="org3058b61"></a>

## Att göra

-   Beskrivning av hur det fungerar
    -   val av språk
        -   varför?
    -   implementation
        -   hur?
        -   varför?

-   Ett/flera usecases med tillhörande sekvensdiagram
    -   hyra, lämna tillbaka en cykel
    -   service

-   Ett stycke om Simuleringen


<a id="org9094e66"></a>

## Cykelns program

En elsparkcykels huvudsakliga uppgift är att hela tiden meddela sin positon och hälsa via API&rsquo;et.

Elsparkcykelns program har bara information som rör sin egen position samt hälsa och övrig information
som rör dess omgivning skickas till den från backend.

-   Uthyrd till en kund
-   Kund avslutar lånet
-   Begränsa hastighet när den befinner sig i specifika zoner
-   Stoppa den ifall den är utanför tillåtet område.
-   Intagen på service
-   Service utförd

I varje elsparkcykel finns sensorer som känner av hälsan och när den ändras
så skickas den informationen till backend.

-   Batterinivån är låg
-   En lampa har gått sönder
-   Punktering etc

Det är endast när elsparkcykelns status har blivit ändrad till &rsquo;uthyrd&rsquo; eller på &rsquo;service&rsquo; som
elsparkcykeln är upplåst och går att köra. Så fort dess status återvänder till &rsquo;ledig&rsquo; så
stängs den av och bromsas, och det enda sättat att flytta den är då att fysiskt lyfta upp och bära bort den.
Blir det rörelse på en elsparkcykel som ej är uthyrd skickas då en varning omgående till backend,
och sedan med ett tätt intervall tills den återigen står stilla. Så att personal kan hitta eventuellt stulna
elsparkcykelar.

Tusentals elsparkcyklar finns i systemet. Så för att minimera belastningen på API och backend så
uppdaterar dom sin position med olika intervall beroende på olika faktorer.

-   En uthyrd elsparkcykel i rörelse skickar positionisdata ofta
-   En ledig och stillastående elsparkcykel skickar positionsdata sällan
-   En elsparkcykel på laddning eller service skickar positionsdata sällan

Varje elsparkcykel sparar också en egen historik över alla sina resor.

-   Resans kund
-   Resans startposition samt klockslag
-   Resans slutposition samt klockslag

