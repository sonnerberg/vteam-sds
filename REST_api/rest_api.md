
# Inneh&aring;ll

-   [REST-API](#orgbe735e5)
    -   [Dokumentation](#orgdda9518)
    -   [Versioner](#org93e4dc0)
    -   [Autentisering](#org6f2c41d)
        -   [Godkänd autentisering](#orge9bf721)
        -   [Misslyckad autentisering](#orgf887b34)



<a id="orgbe735e5"></a>

# REST-API

(Hur göra en intern github länk till Richards fantastiska API spreadsheet?)
(Känns som jag behöver skriva lite mer i denna del men kommer inte på vad.)

Systemets applikationer använder ett REST-API för att kommunicera med systemets backend.


<a id="orgdda9518"></a>

## Dokumentation

För att underlätta för tredjepartsleverntörer att bygga externa tjänster och applicationer är
REST-API&rsquo;et väldokumenterat.

-   Länk till dokumentationen?
-   Ett exempel från dokumentationen på en enskild endpoint?


<a id="org93e4dc0"></a>

## Versioner

REST-API&rsquo;et har byggts för att vara framtidssäkert där uppdateringar och tillägg hanteras med
versionsnummer som en del i URI:n.

-   &#x2026;/v1/endpoint


<a id="org6f2c41d"></a>

## Autentisering

Alla applikationer som använder REST-API&rsquo;et måste autentisera (JWT?) sig för att kontrollera att endast
endpoints som rör applikationen finns tillgängliga.


<a id="orge9bf721"></a>

### Godkänd autentisering

En applikation för administratörer kan se alla användare i systemet.

    GET ../v1/users/

    {
        "data": [
            {
                "id": 1,
                "name": "John Doe",
                ...
    
            },
            {
                "id": 2,
                "name": "Jane Doe",
                ...
            }
        ]
    }


<a id="orgf887b34"></a>

### Misslyckad autentisering

En applikation för användare kan **inte** se alla användare i systemet.

    GET ../v1/users/

    {
        "errors": {
            "status": 401,
            "source": "/users",
            "title": "Authorization failed",
            "detail": "No valid API key provided."
        }
    }

