# Förbereda en IG och bygga en version

**Övergångsläge:** En releasetagg bygger IG:n och sparar resultatet som en GitHub Actions-artifact. Det sker ingen officiell publicering, testpublicering eller registrering hos något FHIR-register. Ingen versionshistorik eller katalog i `regionstockholm/pub` uppdateras.

Se även [Versionshantering, brancher och releaser](versionshantering-och-release.md) och [Flytta en befintlig IG](flytta-befintlig-ig.md).

## Förbered ett nytt IG-repo

1. Skapa ett repo från mallen. Fyll i `id`, `name`, `title`, `description`, `publisher`, `version` och FHIR-basversion i `sushi-config.yaml`.
2. Säkerställ att `ig.ini` pekar på `fsh-generated/resources/ImplementationGuide-<id>.json` med samma id som i `sushi-config.yaml`.
3. Fastställ `canonical` tillsammans med ansvariga för Region Stockholms URI-ramverk och kommande publicering **innan** den första officiella publiceringen. Mallens canonical är ett exempel; URL-konventionen för `pub` är ännu inte fastställd.
4. Ersätt mallens profiler, exempel och sidinnehåll. Töm mallens gamla poster i `input/pagecontent/version-history.md` och skriv egna ändringar under `### [X.Y.Z] — ÅÅÅÅ-MM-DD`.
5. Anpassa `publication-request.json` för IG:n. Filen är endast förberedande metadata: det nuvarande taggflödet läser eller validerar den inte. Hur fälten ska användas och om registrering i externa FHIR-register ska ske bestäms när publiceringsflödet införs.
6. För förhandsvisningar, aktivera Actions skrivrättighet och GitHub Pages från `gh-pages` / `(root)` efter första branchbygget. Ingen `FHIR_PORTAL_TOKEN` behövs.

## Inför varje taggbygge

1. Uppdatera `version` i `sushi-config.yaml` och beskriv ändringarna i `input/pagecontent/version-history.md`. Uppdatera vid behov självständigt versionshanterade profiler.
2. Granska beroenden och QA-resultat. För en framtida officiell release behöver beroenden låsas till publicerade versioner och publiceringsmetadata granskas.
3. Merga ändringarna till avsedd branch, normalt `main` eller en supportbranch.
4. Skapa och pusha en tagg utan `v`, identisk med versionen:

   ```bash
   git fetch origin
   git tag -a 1.2.0 -m "1.2.0" origin/main
   git push origin 1.2.0
   ```

5. Öppna **Actions → Build release artifact → körningen → Artifacts** och hämta `ig-build-1.2.0`. Artifakten innehåller utdata från IG Publisher och sparas i 30 dagar. Granska även `qa.html` och `qa.json` i utdata.

Misslyckas bygget, läs loggen och rätta orsaken. En omkörning av samma workflow-körning bygger samma tagg igen men publicerar ingenting.

## Framtida publicering och pilot

Målet är publicering via [regionstockholm/pub](https://github.com/regionstockholm/pub), under `docs/fhir/implementationguide/`. Konfiguration, katalog, versionshantering, testmiljö och behörigheter där är ännu inte etablerade av denna mall. Koordinera en eventuell manuell pilot med ägaren av `pub`; att kopiera en artifact är inte likvärdigt med en versionerad `-go-publish`-publicering. När målflödet är verifierat behöver release-workflowen och instruktionerna uppdateras.
