
# Admin-gränssnitt

1.  [Admin-gränssnitt](#org8a596ce)
    1.  [Översikt och daglig drift](#org2ecd51a)
    2.  [Hantering av kunder](#org34ef10e)
    3.  [Geodatahantering](#org0002f6b)

<a id="org8a596ce"></a>

# Admin-gränssnitt

Systemets admin-gränssnitt används av behöriga användare för att få en översikt över företagets alla resurser:

- Kunder
- Städer man opererar i
- Cyklar
- Laddstationer
- Parkeringsplatser
- Områden med särskilda bestämmelser

Admin-gränssnittet innehåller vyer för att inspektera resurser, skicka kommandon till enskilda cyklar, hantera kundinformation, samt uppdatera systemet med ny data, t ex nya städer man etablerar sig i, nya cyklar, nya parkeringsplatser etc.

<a id="org2ecd51a"></a>

## Översikt och daglig drift

I vyn för översikt och daglig drift presenteras all information kring cyklar, laddstationer, parkeringsplatser och områden med särskilda bestämmelser för varje stad man verkar i. Vyn är kartcentrerad. I kartan kan man se information om aktuell status för alla tillgängliga resurser i vald stad, samt även filtrera kartvyn baserat på resurser typ, identitet, eller status. Denna vy används också för att skicka manuella driftkommandon till enskilda cyklar. Det kan t ex vara ett kommando för att stoppa cykeln, om administratören ser behov av det.

FRÅGA - MAN TÄNKER SIG ATT STOPPKOMMANDO TILL CYKELN BORDE SKE AUTOMATISKT OM EN CYKEL ÅKER FÖR LÅNGT UT TEX.

<a id="org34ef10e"></a>

## Hantering av kunder

Kundvyn är en klassisk listvy. Här kan man se en lista på alla företagets kunder, som kan filtreras på stad, användarnamn, antal gjorda resor mm. I denna vyn kan administratören också uppdatera information om enskilda kunder, t ex för att ge en kund en generell rabatt eller rabatt för en enskild resa. Administratören kan också skapa upp nya kunder i denna vy, även om detta i normalfallet hanteras av kunden själv.


<a id="org0002f6b"></a>

## Geodatahantering

Systemet har kraftfulla och lättanvända funktioner för att hantera nya marknader och nuya resurser. I vyn för geodatahantering kan administratören lägga upp nya städer för företaget, samt skapa, uppdatera och radera information om enskilda resurser. 


