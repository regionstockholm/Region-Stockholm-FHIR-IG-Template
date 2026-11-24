# Flytta en befintlig IG

Den här vägledningen gäller en Implementation Guide (IG) som ska börja använda Region Stockholms mall eller flyttas till en ny publiceringslösning. En redan publicerad IG har egna identiteter och historik som inte får ersättas med mallens exempelvärden.

<del style="color: red;">Instruktionen gäller en IG som har releaser på `fhir.inera.se` och flyttas från Ineras tidigare CI-upplägg till IG Publishers publiceringsläge. Mallen själv flyttades på detta sätt med version 2.3.0 och flytten övades i `inera-ab/fhir-portal-test`.</del> **Kommentar:** den historiken och de systemen tillhör Inera och beskriver inte en Region Stockholm-migrering. Region Stockholms målmiljö och migreringsmetod behöver fastställas med ansvarig förvaltning.

## 1. Inventera och planera

1. Inventera paket-id, canonical URL, publicerade versioner, FHIR-basversion, beroenden, profiler, exempel och befintliga konsumenter.
2. Dokumentera den nuvarande publiceringsmodellen: branchbyggen, release-trigger, paketdistribution, webbrotsstruktur, katalog/register och historik.
3. Bestäm om IG:n bara byter mall/byggmiljö eller även ska byta paket-id, canonical eller publiceringsadress. Bevara befintliga identiteter om syftet enbart är ett mallbyte.
4. Planera hur alla befintliga versioner, paket, historiksidor och länkar ska bevaras. En ändrad canonical eller ett nytt paket-id kan bryta referenser och kräver en uttrycklig migrationsplan.
5. Kom överens om testmigrering, produktionsmigrering, ansvariga, återställningsplan och kommunikation med konsumenter.

## 2. Uppdatera IG-repositoryt

1. Ta över relevanta sidor, grafiska resurser och byggkonfiguration från [Region Stockholms mall](https://github.com/regionstockholm/Region-Stockholm-FHIR-IG-Template). Anpassa meny och sidinnehåll.
2. Anpassa `sushi-config.yaml` till den befintliga IG:n. Behåll `id`, `canonical`, `name`, titel, FHIR-version och beroenden om ingen separat identitetsmigrering har beslutats.
3. Ange samma paket-id i `ig.ini`, i sökvägen `fsh-generated/resources/ImplementationGuide-<id>.json`.
4. Behåll IG:ns profiler, exempel och versionshistorik. Ta inte över mallens exempelprofil eller versionshistorik som om de tillhörde IG:n.
5. Uppdatera `publication-request.json`, paketlänken i `input/pagecontent/downloads.md` och motsvarande rad i `input/ignoreWarnings.txt` enligt den nya publiceringslösningen.
6. Granska `.github/workflows/`. Ersätt äldre bygg- och publiceringsanrop med godkända regionala motsvarigheter. I den här mallen är anropen platshållare och workflows är spärrade tills den regionala lösningen har konfigurerats.
7. Ta bort gamla skript och automatiseringar endast när deras funktion har ersatts och ingen annan process använder dem. Verifiera särskilt versionshantering, taggar, QA, publicering och städning.

<del style="color: red;">Ta bort `release-please.yml`, `release-please-config.json` och `.release-please-manifest.json`; ta bort `package-list.json` eftersom IG Publisher vägrar publicera från en källmapp som innehåller filen.</del> **Kommentar:** detta är inte en generell migreringsregel. Behåll eller ta bort versionsautomatisering enligt Region Stockholms beslut; hantera `package-list.json` utifrån om den aktuella eller nya publiceringslösningen kräver en sådan i källan.

## 3. Migrera versionskatalog och historik

Om målmiljön använder IG Publishers publiceringsläge ska dess `package-list.json` följa publisherns format. Inventera och kontrollera bland annat:

- CI-builden, om sådan används, står före utgåvorna och har rätt `version`, `status`, `sequence` och sökväg.
- Utgåvorna är i den ordning publishern förväntar sig; kontrollera särskilt vilken post som tolkas som senaste.
- `fhirversion` är i det format publishern förväntar sig, och varje version har ett korrekt `date`.
- `status`, `sequence`, `desc` och eventuell `current`-markering beskriver versionernas verkliga status.
- Varje version som listas har en motsvarande versionsmapp och alla mappade filer går att nå.
- Historiksidans stil och skript finns på plats enligt målmiljöns förväntningar.

Publisherns publiceringsläge kan uppdatera bannern i äldre versioner. Provkör detta först i testmiljön och kontrollera att tidigare publicerade artefakter i övrigt är oförändrade. Kontrollera även om den valda IG Publisher-versionen bara kopierar historiksidans stil och skript vid första publiceringen; i så fall behöver befintliga filer flyttas med eller kopieras av publiceringsworkflowet.

<del style="color: red;">Skriv om katalogen under `ig/<namn>/` på `gh-pages` i `inera-ab/fhir-portal`; lägg CI-builden först med `"version": "current"`, sätt Ineras `"category": "National Base"` och kopiera saknade mappar från IG-repots GitHub Pages.</del> **Kommentar:** sökväg, kategori, repository och katalogformat är Inera-specifika. Följ endast motsvarande steg om Region Stockholms beslutade webbrotsformat uttryckligen kräver det.

## 4. Testa innan skarp flytt

1. Bygg och validera IG:n från den branch som ska migreras. Jämför QA-resultat med den tidigare byggmiljön och utred nya fel, varningar och saknade länkar.
2. Gör en testmigrering i en isolerad regional testmiljö. Kontrollera paket-id, canonical, publicerad URL, versionslista, historik, releasebanner och paketnedladdning.
3. Kontrollera att gamla versions-URL:er, canonical-referenser och konsumenter fortfarande fungerar eller har en dokumenterad vidareflytt.
4. Kontrollera behörigheter och publiceringsloggar. Verifiera att testkörningen inte har skrivit till produktionsmiljön.
5. Få godkännande från IG:ns förvaltning och publiceringsansvarig innan produktionsflytt.

<del style="color: red;">Kör *Publish release* manuellt på en branch för att publicera till `inera-ab/fhir-portal-test`, kontrollera `https://inera-ab.github.io/fhir-portal-test/ig/<namn>/` och pusha sedan en versionstagg för publicering till `fhir.inera.se`.</del> **Kommentar:** dessa workflowbeteenden och URL:er gäller Ineras installation. De är inte konfigurerade i Region Stockholms mall.

## 5. Genomför den regionala flytten

1. Slutför eventuella ändringar av webbrot, katalog eller gemensamma publiceringsfiler genom Region Stockholms ordinarie ändringsprocess.
2. Merga den granskade ändringen i IG-repositoryt och invänta godkänd validering/QA.
3. Utför den beslutade första publiceringen enligt Region Stockholms releaseprocess. Byt inte canonical eller paket-id utan godkänd migreringsplan.
4. Verifiera publicerad version, äldre versionssidor, historik, paket och register/katalog.
5. Dokumentera resultat och kvarstående åtgärder. Återställ eller pausa migreringen om gamla länkar eller versioner inte bevaras som planerat.

En befintlig publicerad version ska inte publiceras om med förändrat innehåll. Använd en ny version för rättningar. Se även [förberedelser för publicering och release](forbereda-och-releasa-ig.md).
