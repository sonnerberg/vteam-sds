# Databas
Information systemets olika entiteter samlas i en databas. En entitet kan t.ex. vara "användare", "stad" eller "administratör". Varje entitet har en egen tabell i databasen. I detta avsnitt beskrivs vilka entiteter som finns i databasen, vilka egenskaper de har och hur entiteterna relaterar till varandra. 

Den databas som ingår i systemet är en DATABASTYP. Systemet kommunicerar med databasen via ORM/SQL/Redis? (Byggs ut när vi har bestämt oss)

Följande tabeller/entiteter finns i databasen:

## Stad
Denna tabell innehåller information om städer. Varje stad har:

- ett unikt id som identifierar staden i systemet
- ett namn
- en geografisk position

En stad har också relationer till andra entiteter den kan ha en eller flera:

- Elsparkcyklar
- Laddstationer
- Parkeringsplatser
- Zoner
- Verkstäder?

## Elsparkcykel
Denna tabell innehåller information om elsparkcyklar. Varje elsparkcykel har
- ett unikt id
- en position
- en status, ett värde som visar om elsparkcykeln är ok, laddas eller behöver service
- en batterinivå
- en uthyrningsstatus som visar om elsparkcykeln är uthyrd eller inte
- en hastighet

En elsparkcykel har också relationer till andra entiteter, den kan ha:
- en användare (om elsparkcykeln är uthyrd)
- en eller flera (historiska) resor

## Laddstation
Denna tabell innehåller information om laddstationer. Varje laddstation har:
- ett unikt id
- en position

Bör vi också koppla elsparkcyklar till specifika laddstationer?

## Parkeringsplats
Denna tabell innehåller information om parkeringsplatser, både tillåtna och otillåtna. Varje parkeringsplats har:
- ett unikt id
- en position
- en typ som talar om ifall detta är en "+parkeringsplats" en vanlig parkeringsplats eller en förbjuden parkeringsplats

## Zon
Denna tabell innehåller information om särskilda zoner. Varje zon har:
- ett unikt id
- en position
- en typ som visar om det är tillåtet att färdas i zonen eller inte
- en hastighetsbegränsning som bestämmer högsta tillåtna hastighet i zonen?

## Verkstad (ska verkstäder vara med?)
Denna tabell innehåller information om verkstäder där elsparkcyklar servas och repareras. Varje verkstad har:
- ett unikt id
- en position

## Användare
Denna tabell innehåller information om användare. Varje användare har:
- ett unikt id
- ett förnamn (får vi detta med OAuth?)
- ett efternamn (får vi detta med OAuth?)
- en adress (får vi detta med OAuth?)
- en faktureringsadress (får vi detta med OAuth?)
- ett användarnamn (behöver vi detta med OAuth?)
- ett lösenord (behöver vi detta med OAuth?)
- en e-postadress
- ett saldo
- en position? (behöver vi användarnas positioner?)
- en status som visar om användaren är inloggad eller inte? (behöver vi detta?)

En användare har också relationer till andra entiteter, den kan ha:
- en elsparkcykel (om användaren hyr en cykel)
- en eller flera (historiska) resor

## Resa
Denna tabell innehåller information om resor. Varje resa har:
- ett unikt id
- en startposition
- en slutposition
- en starttid
- en sluttid

Nedanstående bild visar de entiteter som förekommer i databasen, deras attribut och inbördes relationer.