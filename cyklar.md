
# Table of Contents

1.  [Översikt](#orga1ba565)
    1.  [Beteende](#org5c1fe52)
    2.  [Krav som måste uppfyllas](#orgec13073)
        1.  [Positionsdata](#org017e467)
        2.  [Status](#org82378e0)
2.  [SDS](#org87b7e5c)



<a id="orga1ba565"></a>

# Översikt


<a id="org5c1fe52"></a>

## Beteende

-   Varje cykel har sitt eget program och id.
-   En cykel ska kunna meddela position/status med jämna mellanrum.
-   En kund ska kunna hyra och lämna igen en cykel.
-   En Admin ska kunna hantera och se info on cykeln.


<a id="orgec13073"></a>

## Krav som måste uppfyllas

Vilken data behövs för att tillmötesgå samtliga krav?

-   [X] Man kan se alla städer och cyklar som finns i systemet.
-   [X] Varje stad har ett antal laddstationer där cyklarna kan laddas. Kunden eller servicepersonalen kan förflytta en cykel dit.
-   [X] Varje stad har ett antal accepterade platser där cyklar bör parkeras.
-   [X] Cyklar kan även parkeras utanför laddstationer och utanför accepterade platser,men det kan då tillkomma en extra avgift för kunden. Detta kallas fri parkering.
-   [X] Man kan se var cyklarna finns parkerade.
-   [ ] Man kan se hur många (och vilka) cyklar som finns på varje laddstation och accepterad parkeringsplats.
-   [ ] Varje resa som en kund gör kostar pengar, dels en fast taxa och en rörlig taxa per tidsenhet och en taxa beroende av var de parkerar.
-   [ ] Om en kund tar en cykel som står på fri parkering - och lämnar på en definierad parkering - så blir startavgiften lite lägre
-   [X] Man kan få en översikt över laddstationer och cyklar och deras position på en karta.
-   [X] (extra) Visa en kartbild där alla alla lediga cyklar finns.
-   [X] Cykeln meddelar dess position med jämna mellanrum.
-   [X] Cykeln meddelar om den kör eller står stilla och vilken hastighet den rör sig i.
-   [X] Man skall kunna stänga av/stoppa en cykel så att den inte kan köras längre.
-   [X] När en kund hyr cykeln är det möjligt att starta den och köra.
-   [X] Kunden kan lämna tillbaka en cykel och släppa kontrollen över den.
-   [ ] Cykeln varnar när den behöver laddas.
-   [ ] Cykeln sparar en logg över sina resor med start (plats, tid) och slut (plats, tid) samt kund.
-   [X] När cykeln tas in för underhåll eller laddning så markeras det att cykeln är i underhållsläge. En cykel som laddas på en laddstation kan inte hyras av en kund och en röd lampa visar att den inte är tillgänglig.
-   [X] \* Ledig cykel visas som grön, uthyrd som orange, ej tillgänglig som röd.


<a id="org017e467"></a>

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


<a id="org82378e0"></a>

### Status

1.  Man kan se alla städer och cyklar som finns i systemet.
2.  Man skall kunna stänga av/stoppa en cykel så att den inte kan köras längre.
3.  När en kund hyr cykeln är det möjligt att starta den och köra.
4.  Kunden kan lämna tillbaka en cykel och släppa kontrollen över den.
5.  När cykeln tas in för underhåll eller laddning så markeras det att cykeln är i underhållsläge. En cykel som laddas på en laddstation kan inte hyras av en kund och en röd lampa visar att den inte är tillgänglig.
6.  \* Ledig cykel visas som grön, uthyrd som orange, ej tillgänglig som röd.


<a id="org87b7e5c"></a>

# SDS

