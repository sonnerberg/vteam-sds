
# Table of Contents

1.  [Översikt](#org8d0b2ce)
    1.  [Beteende](#org7eafb98)
    2.  [Krav som måste uppfyllas](#org2328e6c)
        1.  [Positionsdata](#orgffe5342)
        2.  [Status](#orgd0570b1)
        3.  [Sensor](#org6d74660)
        4.  [Positionsdata och/eller Status och/eller Sensor](#org16710f7)
    3.  [Cykel <-> server kommunikation](#orgfeeb4ca)
        1.  [HTTP](#orgf1ea5ad)
        2.  [Websockets](#org8c82319)
        3.  [IoT protokoll](#orge803cab)
2.  [SDS](#org77b7b6d)



<a id="org8d0b2ce"></a>

# Översikt


<a id="org7eafb98"></a>

## Beteende

-   Varje cykel har sitt eget program och id.
-   En cykel ska kunna meddela position/status med jämna mellanrum.
-   En kund ska kunna hyra och lämna igen en cykel.
-   En Admin ska kunna hantera och se info on cykeln.


<a id="org2328e6c"></a>

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


<a id="orgffe5342"></a>

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


<a id="orgd0570b1"></a>

### Status

1.  Man kan se alla städer och cyklar som finns i systemet.
2.  Man skall kunna stänga av/stoppa en cykel så att den inte kan köras längre.
3.  När en kund hyr cykeln är det möjligt att starta den och köra.
4.  Kunden kan lämna tillbaka en cykel och släppa kontrollen över den.
5.  När cykeln tas in för underhåll eller laddning så markeras det att cykeln är i underhållsläge. En cykel som laddas på en laddstation kan inte hyras av en kund och en röd lampa visar att den inte är tillgänglig.
6.  \* Ledig cykel visas som grön, uthyrd som orange, ej tillgänglig som röd.


<a id="org6d74660"></a>

### Sensor

1.  Cykeln varnar när den behöver laddas.


<a id="org16710f7"></a>

### Positionsdata och/eller Status och/eller Sensor

1.  Man kan se hur många (och vilka) cyklar som finns på varje laddstation och accepterad parkeringsplats.
2.  Varje resa som en kund gör kostar pengar, dels en fast taxa och en rörlig taxa per tidsenhet och en taxa beroende av var de parkerar.
3.  Om en kund tar en cykel som står på fri parkering - och lämnar på en definierad parkering - så blir startavgiften lite lägre
4.  Cykeln sparar en logg över sina resor med start (plats, tid) och slut (plats, tid) samt kund.
5.  \* hastighet, svänga, bromsa, position, batteri, lampor fungerar, luft i däcken etc.


<a id="orgfeeb4ca"></a>

## Cykel <-> server kommunikation

Här har jag, med mina begränsade kunskaper, vänt och vridit på olika sätt att få cykel
och server att prata med varandra och med risk för eventuella tankevurpor och snetänk
så har jag kommit fram till tre alternativ. (feedback uppskattas!)


<a id="orgf1ea5ad"></a>

### HTTP

Att använda HTTP går bra från cykel till server, men är värre åt andra hållet.
Tusentals cyklar kräver lika många unika IP adresser och jag vet helt enkelt inte hur
servern ska kunna hitta/hålla reda på alla.


<a id="org8c82319"></a>

### Websockets

Med en websockets connection kan data flöda åt båda hållen, men hur tusentals connections
påverkar serverns prestanda har jag idag ingen aning om. Jag tror inte att själva
kopplingen påverkar så mycket, utan snarare vad servern faktiskt gör med data som den får.


<a id="orge803cab"></a>

### IoT protokoll

Detta känns som en överkurs och skulle bli väldigt förvånad om en IoT lösning hade förväntats av oss.
Men alternativet finns.


<a id="org77b7b6d"></a>

# SDS

Here be dragons&#x2026;.

-   Beskrivning av förutsättningarna
    -   ev väldigt många cycklar
    -   lätt att lägga till, ta bort cykel
    -   lätt att få information om cyklar
    -   all debiterbar data har en cykel som ursprung

-   Beskrivning av hur det fungerar
    -   val av språk
        -   varför?
    -   implementation
        -   hur?
        -   varför?

-   Ett/flera usecases med tillhörande sekvensdiagram
    -   lägga till, ta bort cykel
    -   hyra, lämna tillbaka en cykel
    -   lågt batteri
    -   service

