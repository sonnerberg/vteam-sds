
# Table of Contents

1.  [Översikt](#org9c4f134)
    1.  [Beteende](#org234b968)
    2.  [Krav som måste uppfyllas](#org2c05e9f)
        1.  [Positionsdata](#orgd7477f0)
        2.  [Status](#orgf9104ec)
        3.  [Sensor](#orgf2b88ab)
        4.  [Positionsdata och/eller status och/eller sensor](#orgcd000cd)
    3.  [Elsparkcykel <-> server kommunikation](#org09aead3)
        1.  [HTTP](#org62e0e71)
        2.  [Websockets](#org354abc5)
        3.  [IoT protokoll](#orgb4af644)
    4.  [Simulering](#orgf063198)
2.  [SDS](#org94e6a78)
    1.  [Att göra](#org248a7e4)
    2.  [Cykelns program](#org6267655)



<a id="org9c4f134"></a>

# Översikt


<a id="org234b968"></a>

## Beteende

-   Varje elsparkcykel har sitt eget program och id.
-   En elsparkcykel ska kunna meddela position/status med jämna mellanrum.
-   En användare ska kunna hyra och lämna tillbake en elsparkcykel.
-   En administratör ska kunna hantera och se information om elsparkcykeln.


<a id="org2c05e9f"></a>

## Krav som måste uppfyllas

Vilken data behövs för att tillmötesgå samtliga krav?

-   [X] Man kan se alla städer och elsparkcyklar som finns i systemet.
-   [X] Varje stad har ett antal laddstationer där elsparkcyklarna kan laddas. Användaren eller servicepersonalen kan förflytta en elsparkcykel dit.
-   [X] Varje stad har ett antal accepterade platser där elsparkcyklar bör parkeras.
-   [X] Elsparkcyklar kan även parkeras utanför laddstationer och utanför accepterade platser,men det kan då tillkomma en extra avgift för användaren. Detta kallas fri parkering.
-   [X] Man kan se var elsparkcyklarna finns parkerade.
-   [X] Man kan se hur många (och vilka) elsparkcyklar som finns på varje laddstation och accepterad parkeringsplats.
-   [X] Varje resa som en användare gör kostar pengar, dels en fast taxa och en rörlig taxa per tidsenhet och en taxa beroende av var de parkerar.
-   [X] Om en användare tar en elsparkcykel som står på fri parkering - och lämnar på en definierad parkering - så blir startavgiften lite lägre
-   [X] Man kan få en översikt över laddstationer och elsparkcyklar och deras position på en karta.
-   [X] (extra) Visa en kartbild där alla alla lediga elsparkcyklar finns.
-   [X] Elsparkcykeln meddelar dess position med jämna mellanrum.
-   [X] Elsparkcykeln meddelar om den kör eller står stilla och vilken hastighet den rör sig i.
-   [X] Man skall kunna stänga av/stoppa en elsparkcykel så att den inte kan köras längre.
-   [X] När en användare hyr elsparkcykeln är det möjligt att starta den och köra.
-   [X] Användaren kan lämna tillbaka en elsparkcykel och släppa kontrollen över den.
-   [X] Elsparkcykeln varnar när den behöver laddas.
-   [X] Elsparkcykeln sparar en logg över sina resor med start (plats, tid) och slut (plats, tid) samt användare.
-   [X] När elsparkcykeln tas in för underhåll eller laddning så markeras det att elsparkcykeln är i underhållsläge. En elsparkcykel som laddas på en laddstation kan inte hyras av en användare och en röd lampa visar att den inte är tillgänglig.
-   [X] \* Ledig elsparkcykel visas som grön, uthyrd som orange, ej tillgänglig som röd.
-   [X] \* hastighet, svänga, bromsa, position, batteri, lampor fungerar, luft i däcken etc.


<a id="orgd7477f0"></a>

### Positionsdata

1.  Man kan få en översikt över elsparkcyklar och deras position på en karta
2.  Varje stad har ett antal laddstationer där elsparkcyklarna kan laddas.
    Användaren eller servicepersonalen kan förflytta en elsparkcykel dit.
3.  Varje stad har ett antal accepterade platser där elsparkcyklar bör parkeras.
4.  Elsparkcyklar kan även parkeras utanför laddstationer och utanför accepterade platser,
    men det kan då tillkomma en extra avgift för användren. Detta kallas fri parkering.
5.  Man kan se var elsparkcyklarna finns parkerade.
6.  (extra) Visa en kartbild där alla alla lediga elsparkcyklar finns.
7.  Elsparkcykeln meddelar dess position med jämna mellanrum.
8.  Elsparkcykeln meddelar om den kör eller står stilla och vilken hastighet den rör sig i.


<a id="orgf9104ec"></a>

### Status

1.  Man kan se alla städer och elsparkcyklar som finns i systemet.
2.  Man skall kunna stänga av/stoppa en elsparkcykel så att den inte kan köras längre.
3.  När en användare hyr elsparkcykeln är det möjligt att starta den och köra.
4.  Användaren kan lämna tillbaka en elsparkcykel och släppa kontrollen över den.
5.  När elsparkcykeln tas in för underhåll eller laddning så markeras det att elsparkcykeln är i underhållsläge. En elsparkcykel som laddas på en laddstation kan inte hyras av en användare och en röd lampa visar att den inte är tillgänglig.
6.  \* Ledig elsparkcykel visas som grön, uthyrd som orange, ej tillgänglig som röd.


<a id="orgf2b88ab"></a>

### Sensor

1.  Elsparkcykeln varnar när den behöver laddas.


<a id="orgcd000cd"></a>

### Positionsdata och/eller status och/eller sensor

1.  Man kan se hur många (och vilka) elsparkcyklar som finns på varje laddstation och accepterad parkeringsplats.
2.  Varje resa som en användare gör kostar pengar, dels en fast taxa och en rörlig taxa per tidsenhet och en taxa beroende av var de parkerar.
3.  Om en användare tar en elsparkcykel som står på fri parkering - och lämnar på en definierad parkering - så blir startavgiften lite lägre
4.  Elsparkcykeln sparar en logg över sina resor med start (plats, tid) och slut (plats, tid) samt användare.
5.  \* hastighet, svänga, bromsa, position, batteri, lampor fungerar, luft i däcken etc.


<a id="org09aead3"></a>

## Elsparkcykel <-> server kommunikation

Här har jag, med mina begränsade kunskaper, vänt och vridit på olika sätt att få elsparkcykel
och server att prata med varandra och med risk för eventuella tankevurpor och snetänk
så har jag kommit fram till tre alternativ. (feedback uppskattas!)


<a id="org62e0e71"></a>

### HTTP

Att använda HTTP går bra från elsparkcykel till server, men är värre åt andra hållet.
Tusentals elsparkcyklar kräver lika många unika IP adresser och jag vet helt enkelt inte hur
servern ska kunna hitta/hålla reda på alla.


<a id="org354abc5"></a>

### Websockets

Med en websockets connection kan data flöda åt båda hållen, men hur tusentals connections
påverkar serverns prestanda har jag idag ingen aning om. Jag tror inte att själva
kopplingen påverkar så mycket, utan snarare vad servern faktiskt gör med data som den får.


<a id="orgb4af644"></a>

### IoT protokoll

Detta känns som en överkurs och skulle bli väldigt förvånad om en IoT lösning hade förväntats av oss.
Men alternativet finns.


<a id="orgf063198"></a>

## Simulering

Allt ligger lokalt så här är elsparkcykel <-> server kommunikation ett mindre problem.


<a id="org94e6a78"></a>

# SDS


<a id="org248a7e4"></a>

## Att göra

-   Beskrivning av hur det fungerar
    -   val av språk
        -   varför?
    -   implementation
        -   hur?
        -   varför?

-   Ett/flera usecases med tillhörande sekvensdiagram
    -   hyra, lämna tillbaka en elsparkcykel
    -   service

-   Ett stycke om Simuleringen


<a id="org6267655"></a>

## Cykelns program

En elsparkcykels huvudsakliga uppgift är att hela tiden meddela sin positon och hälsa via API&rsquo;et.

Elsparkcykelns program har bara information som rör sin egen position samt hälsa och övrig information
som rör dess omgivning skickas till den från backend.

-   Uthyrd till en användare
-   användare avslutar hyran
-   Begränsa hastighet när den befinner sig i specifika zoner
-   Stoppa elsparkcykeln ifall den är utanför tillåtet område.
-   Intagen på service
-   Service utförd

I varje elsparkcykel finns sensorer som känner av hälsan och när den ändras
så skickas den informationen till backend.

-   Batterinivån är låg
-   En lampa har gått sönder
-   Punktering etc.

Det är endast när elsparkcykelns status har blivit ändrad till &ldquo;uthyrd&rdquo; eller på &ldquo;service som
elsparkcykeln är upplåst och går att köra. Så fort dess status återvänder till &rdquo;ledig&ldquo; så
stängs den av och bromsas, och det enda sättat att flytta den är då att fysiskt lyfta upp och bära bort den.
Blir det rörelse på en elsparkcykel som ej är uthyrd skickas då en varning omgående till backend,
och sedan med ett tätt intervall tills den återigen står stilla. Detta möjliggör att personal kan hitta eventuellt stulna
elsparkcykelar.

Tusentals elsparkcyklar finns i systemet. Så för att minimera belastningen på API och backend så
uppdaterar dom sin position med olika intervall beroende på olika faktorer.

-   En uthyrd elsparkcykel i rörelse skickar positionsdata ofta
-   En ledig och stillastående elsparkcykel skickar positionsdata sällan
-   En elsparkcykel på laddning eller service skickar positionsdata sällan

Varje elsparkcykel sparar också en egen historik över alla sina resor.

-   Resans användare
-   Resans startposition samt klockslag
-   Resans slutposition samt klockslag

