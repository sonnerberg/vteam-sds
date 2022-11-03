# Kundens app - Richard

1. Kunden kan hyra en specifik cykel.

   Välj elsparkcykel från en lista med lediga cyklar.

   Identifieras med ID.

   Elsparkcyklar som är registrerade i systemet för uthyrning och inte upptagna eller under service kan av en användare väljas för uthyrning.
   I verkligheten görs detta genom att scanna en QR-kod som identifierar elsparkcykeln. [referens](https://turiststockholm.se/sightseeing-guider/hyra-elsparkcykel-i-stockholm-med-voi/).
   I vårt program indentifieras en elsparkcykel genom att från en kartbild välja elsparcykelns ikon vilket ger användaren möjligheten att välja vald elsparkcykel för uthyrning.

1. Under hyrtiden kan kunden köra cykeln.

   - hastighet (slider)
   - vänster (knapp som har en konstant ROT)
   - höger (knapp som har en konstant ROT)
   - broms (bak/fram) (konstant deceleration)
   - visa batterinivå (stapel med olika färger (grön, orange, röd) och procent)

   Då en uthyrning påbörjats så kan användaren manövrera elsparkcykeln. De manövreringsmöjligheter som finns är:

   - elsparkcykelns hastighet (gashandtag)
   - svänga vänster och höger genom att svänga med styret
   - bromsa **_(finns det mer än en broms???)_**

   Användaren kan också få information från den hyrda elsparkcykeln i form av:

   - batterinivå
   - behov av service (med anledning av t.ex. punktering, trasiga lampor eller dåliga bromsar)

1. Kunden lämnar tillbaka cykeln.

   - Pengar dras från saldo. Notiser om bonussystem, "du kunde sparat pengar om..."

   Då användaren avslutar sin hyrning av elsparkcykeln så debiteras användarens konto automatiskt för färden. Färdens kostnad kan variera beroende på:

   - tid på dygnet (tillgång och efterfrågan)
   - om cykeln flyttats från fri parkering (valfri parkeringsplats utanför rekommenderade parkeringszoner) till en mer önskvärd parkeringsplats
   - om cykeln parkeras genom fri parkering

1. (extra) Visa en kartbild där alla laddstationer, accepterade parkeringsplatser finns.

   Denna kartbild visar var samtliga laddstationer och rekommenderade parkeringsplatser finns.

1. (extra) Visa en kartbild där alla alla lediga cyklar finns.

   Denna kartbild visar var samtliga lediga elsparkcyklar finns att hitta.

knappar som visar/döljer

~~filter~~: lediga (en användare ska bara se lediga cyklar)

mock-ups
