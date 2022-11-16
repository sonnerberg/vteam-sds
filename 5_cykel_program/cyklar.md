
# Inneh&aring;ll

-   [Översikt](#org6bd1c17)
    -   [Beteende](#orgde8e420)
    -   [Krav som måste uppfyllas](#org1143c7f)
        -   [Positionsdata](#org1f6a366)
        -   [Status](#orgf56a1bc)
        -   [Sensor](#org0c72933)
        -   [Positionsdata och/eller status och/eller sensor](#org0754226)
    -   [Elsparkcykel <-> server kommunikation](#orgda3bf18)
        -   [HTTP](#org9d12b10)
        -   [Websockets](#org74f00f1)
        -   [IoT protokoll](#org71950ba)
    -   [Simulering](#org355d067)
-   [SDS](#org3d17a31)
    -   [Att göra](#org94bfbf5)
    -   [Cykelns program](#orgd140aaf)



<a id="org6bd1c17"></a>

# Översikt


<a id="orgde8e420"></a>

## Beteende

-   Varje elsparkcykel har sitt eget program och id.
-   En elsparkcykel ska kunna meddela position/status med jämna mellanrum.
-   En användare ska kunna hyra och lämna tillbake en elsparkcykel.
-   En administratör ska kunna hantera och se information om elsparkcykeln.


<a id="org1143c7f"></a>

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


<a id="org1f6a366"></a>

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


<a id="orgf56a1bc"></a>

### Status

1.  Man kan se alla städer och elsparkcyklar som finns i systemet.
2.  Man skall kunna stänga av/stoppa en elsparkcykel så att den inte kan köras längre.
3.  När en användare hyr elsparkcykeln är det möjligt att starta den och köra.
4.  Användaren kan lämna tillbaka en elsparkcykel och släppa kontrollen över den.
5.  När elsparkcykeln tas in för underhåll eller laddning så markeras det att elsparkcykeln är i underhållsläge. En elsparkcykel som laddas på en laddstation kan inte hyras av en användare och en röd lampa visar att den inte är tillgänglig.
6.  \* Ledig elsparkcykel visas som grön, uthyrd som orange, ej tillgänglig som röd.


<a id="org0c72933"></a>

### Sensor

1.  Elsparkcykeln varnar när den behöver laddas.


<a id="org0754226"></a>

### Positionsdata och/eller status och/eller sensor

1.  Man kan se hur många (och vilka) elsparkcyklar som finns på varje laddstation och accepterad parkeringsplats.
2.  Varje resa som en användare gör kostar pengar, dels en fast taxa och en rörlig taxa per tidsenhet och en taxa beroende av var de parkerar.
3.  Om en användare tar en elsparkcykel som står på fri parkering - och lämnar på en definierad parkering - så blir startavgiften lite lägre
4.  Elsparkcykeln sparar en logg över sina resor med start (plats, tid) och slut (plats, tid) samt användare.
5.  \* hastighet, svänga, bromsa, position, batteri, lampor fungerar, luft i däcken etc.


<a id="orgda3bf18"></a>

## Elsparkcykel <-> server kommunikation

Här har jag, med mina begränsade kunskaper, vänt och vridit på olika sätt att få elsparkcykel
och server att prata med varandra och med risk för eventuella tankevurpor och snetänk
så har jag kommit fram till tre alternativ. (feedback uppskattas!)


<a id="org9d12b10"></a>

### HTTP

Att använda HTTP går bra från elsparkcykel till server, men är värre åt andra hållet.
Tusentals elsparkcyklar kräver lika många unika IP adresser och jag vet helt enkelt inte hur
servern ska kunna hitta/hålla reda på alla.


<a id="org74f00f1"></a>

### Websockets

Med en websockets connection kan data flöda åt båda hållen, men hur tusentals connections
påverkar serverns prestanda har jag idag ingen aning om. Jag tror inte att själva
kopplingen påverkar så mycket, utan snarare vad servern faktiskt gör med data som den får.


<a id="org71950ba"></a>

### IoT protokoll

Detta känns som en överkurs och skulle bli väldigt förvånad om en IoT lösning hade förväntats av oss.
Men alternativet finns.


<a id="org355d067"></a>

## Simulering

Allt ligger lokalt så här är elsparkcykel <-> server kommunikation ett mindre problem.


<a id="org3d17a31"></a>

# SDS


<a id="org94bfbf5"></a>

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


<a id="orgd140aaf"></a>

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

Det är endast när elsparkcykelns status har blivit ändrad till &rdquo;uthyrd&rdquo; eller på &rdquo;service som
elsparkcykeln är upplåst och går att köra. Så fort dess status återvänder till &rdquo;ledig&rdquo; så
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

