
# Table of Contents

1.  [Översikt](#orgf962567)
    1.  [Beteende](#org8e41923)
    2.  [Krav som måste uppfyllas](#org6c5bda4)
        1.  [Positionsdata](#org86c0ce5)
        2.  [Status](#org51d777d)
        3.  [Sensor](#orgd4f1785)
        4.  [Positionsdata och/eller Status och/eller Sensor](#org8eee9e3)
    3.  [Cykel <-> server kommunikation](#org72df0db)
        1.  [HTTP](#org2e9a925)
        2.  [Websockets](#orgcfe3873)
        3.  [IoT protokoll](#orgaa2d938)
    4.  [Simulering](#org58079d3)
2.  [SDS](#orgdd84fbf)
        1.  [Att göra](#org7450319)
        2.  [Cykelns program](#org6653382)



<a id="orgf962567"></a>

# Översikt


<a id="org8e41923"></a>

## Beteende

-   Varje cykel har sitt eget program och id.
-   En cykel ska kunna meddela position/status med jämna mellanrum.
-   En kund ska kunna hyra och lämna igen en cykel.
-   En Admin ska kunna hantera och se info on cykeln.


<a id="org6c5bda4"></a>

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


<a id="org86c0ce5"></a>

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


<a id="org51d777d"></a>

### Status

1.  Man kan se alla städer och cyklar som finns i systemet.
2.  Man skall kunna stänga av/stoppa en cykel så att den inte kan köras längre.
3.  När en kund hyr cykeln är det möjligt att starta den och köra.
4.  Kunden kan lämna tillbaka en cykel och släppa kontrollen över den.
5.  När cykeln tas in för underhåll eller laddning så markeras det att cykeln är i underhållsläge. En cykel som laddas på en laddstation kan inte hyras av en kund och en röd lampa visar att den inte är tillgänglig.
6.  \* Ledig cykel visas som grön, uthyrd som orange, ej tillgänglig som röd.


<a id="orgd4f1785"></a>

### Sensor

1.  Cykeln varnar när den behöver laddas.


<a id="org8eee9e3"></a>

### Positionsdata och/eller Status och/eller Sensor

1.  Man kan se hur många (och vilka) cyklar som finns på varje laddstation och accepterad parkeringsplats.
2.  Varje resa som en kund gör kostar pengar, dels en fast taxa och en rörlig taxa per tidsenhet och en taxa beroende av var de parkerar.
3.  Om en kund tar en cykel som står på fri parkering - och lämnar på en definierad parkering - så blir startavgiften lite lägre
4.  Cykeln sparar en logg över sina resor med start (plats, tid) och slut (plats, tid) samt kund.
5.  \* hastighet, svänga, bromsa, position, batteri, lampor fungerar, luft i däcken etc.


<a id="org72df0db"></a>

## Cykel <-> server kommunikation

Här har jag, med mina begränsade kunskaper, vänt och vridit på olika sätt att få cykel
och server att prata med varandra och med risk för eventuella tankevurpor och snetänk
så har jag kommit fram till tre alternativ. (feedback uppskattas!)


<a id="org2e9a925"></a>

### HTTP

Att använda HTTP går bra från cykel till server, men är värre åt andra hållet.
Tusentals cyklar kräver lika många unika IP adresser och jag vet helt enkelt inte hur
servern ska kunna hitta/hålla reda på alla.


<a id="orgcfe3873"></a>

### Websockets

Med en websockets connection kan data flöda åt båda hållen, men hur tusentals connections
påverkar serverns prestanda har jag idag ingen aning om. Jag tror inte att själva
kopplingen påverkar så mycket, utan snarare vad servern faktiskt gör med data som den får.


<a id="orgaa2d938"></a>

### IoT protokoll

Detta känns som en överkurs och skulle bli väldigt förvånad om en IoT lösning hade förväntats av oss.
Men alternativet finns.


<a id="org58079d3"></a>

## Simulering

Allt ligger lokalt så här är cykel <-> server kommunikation ett icke problem.


<a id="orgdd84fbf"></a>

# SDS


<a id="org7450319"></a>

### Att göra

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


<a id="org6653382"></a>

### Cykelns program

(Beroende på vilken lösning vi väjer kanske det inte blir via API&rsquo;et)
Cykels huvudsakliga uppgift är att hela tiden meddela sin positon och status via API&rsquo;et.

Tusentals cyklar finns i systemet. Så för att minimera belastningen på API och backend så
uppdaterar en cykel sin position och status med olika intervall beroende på olika faktorer.

-   En uthyrd cykel i rörelse skickar positionsdata ofta
-   En Ledig stillastående cykel skickar positionsdata sällan
-   En cykel på laddning eller service skickar positionsdata sällan

I varje cykel finns sensorer som känner av status hos cykeln och när statusen ändras
så skickas det statusdata omgående.

-   Batterinivån är låg
-   En lampa har gått sönder etc

Så fort det blir rörelse på en cykel som ej är uthyrd skickas position och statusdata
omgående, och sedan med ett tätt intervall tills cykeln återigen står stilla.

Det är backend som talar om för cykeln när, och av vem, den blir uthyrd. Först då är
det möjligt för en kund att framföra cykeln. När kunden väljer att avsluta lånet
så talar backend om att cykeln inte längre är utlånad och den låses och kan inte längre
köras.

Varje cykel sparar också en egen historik över alla sina resor.

-   Kund som hyrt cykeln
-   Resans startposition samt klockslag
-   Resans slutposition samt klockslag

