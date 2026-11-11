# Flytta en befintlig IG

Det finns ännu inget automatiserat flöde för att migrera en tidigare publicerad IG till Region Stockholms publiceringsyta. Mallen kan bygga en taggad version som artifact, men varken flyttar tidigare versioner eller skapar publiceringshistorik.

Innan en migrering:

1. Samla befintliga canonical-adresser, paket-id, publicerade versioner, paket, versionshistorik och eventuella registerposter. Ändra inte en redan publicerad canonical utan en beslutad migrationsplan.
2. Kontakta ägaren av [regionstockholm/pub](https://github.com/regionstockholm/pub) och ansvariga för URI-förvaltningen. Bestäm URL-struktur, omdirigeringar, ansvar för tidigare utgåvor och hur historiken ska bevaras.
3. Anpassa IG-repots `sushi-config.yaml`, `ig.ini` och dokumentation enligt överenskommelsen. Förbered metadata i `publication-request.json`, men observera att nuvarande taggflöde inte använder filen.
4. Bygg och granska en version enligt [förberedelseguiden](forbereda-och-releasa-ig.md). Genomför eventuell pilot tillsammans med `pub`-ägaren i en separat testmiljö innan något blir officiellt.

Att kopiera ett vanligt `output/` till GitHub Pages är inte samma sak som IG Publishers publiceringsläge: det skapar inte automatiskt en komplett versionshistorik, releasebanners eller gemensamma flöden. Kopiera inte över befintlig historik eller återpublicera en tidigare version utan en verifierad migrationsplan.
