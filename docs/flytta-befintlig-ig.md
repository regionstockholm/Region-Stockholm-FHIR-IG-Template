# Flytta en befintlig IG

Den här vägledningen gäller en befintlig IG som ska använda Region Stockholms mall. En befintlig publicerad IG har egna identiteter och historik som inte får ersättas med mallens exempelvärden.

1. Inventera paket-id, canonical URL, publicerade versioner, beroenden, exempel och befintliga konsumenter. Behåll dessa identiteter om IG:n endast ska byta mall.
2. För över relevanta sidor, grafik och workflows från [Region Stockholms mall](https://github.com/regionstockholm/Region-Stockholm-FHIR-IG-Template). Anpassa metadata, profilreferenser, meny och paketlänk till den befintliga IG:n. Kopiera inte mallens exempelprofil eller versionshistorik som om de tillhörde IG:n.
3. Bygg och validera IG:n. Jämför genererade resursers canonical-adresser och paketmetadata med den tidigare versionen och granska QA-rapporten.
4. Planera eventuell flytt av publiceringsadress separat med ansvarig förvaltning. Byte av canonical eller paket-id kan påverka referenser, paket och konsumenter och kräver en uttrycklig migrationsplan.
5. Bevara och verifiera befintlig versionshistorik i den nya publiceringsmiljön innan en release görs.

Mallens releaseworkflow är spärrat tills en regional publiceringslösning är konfigurerad. Se [förberedelser för publicering](forbereda-och-releasa-ig.md); använd inte Ineras standarddestinationer för en regional release.
