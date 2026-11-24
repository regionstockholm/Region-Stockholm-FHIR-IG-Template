# Region Stockholm FHIR Implementation Guide Template

[![Build and publish IG](https://github.com/regionstockholm/Region-Stockholm-FHIR-IG-Template/actions/workflows/publish.yml/badge.svg)](https://github.com/regionstockholm/Region-Stockholm-FHIR-IG-Template/actions/workflows/publish.yml)
[![Validate FSH](https://github.com/regionstockholm/Region-Stockholm-FHIR-IG-Template/actions/workflows/validate.yml/badge.svg)](https://github.com/regionstockholm/Region-Stockholm-FHIR-IG-Template/actions/workflows/validate.yml)
[![FHIR R4](https://img.shields.io/badge/FHIR-R4-blue)](https://hl7.org/fhir/R4/)
[![License: CC0-1.0](https://img.shields.io/badge/License-CC0_1.0-lightgrey.svg)](https://creativecommons.org/publicdomain/zero/1.0/)

En GitHub-mall för Region Stockholms FHIR Implementation Guides (IG). Den innehåller en sidstruktur, vägledning för författare, en exempelprofil i FHIR Shorthand (FSH) och workflows för validering och publicering. Mallen bygger på [Ineras FHIR-mall](https://github.com/Inera-AB/IneraFHIRTemplate), men ägs och förvaltas av Region Stockholm.

## Utformning

- **Meny inspirerad av europeiska specifikationer.** Hem, Inledning, Funktionellt, Implementering, Om och Artefakter skiljer bakgrund, verksamhetsbehov och implementeringsinformation åt.
- **Artefakter samlas automatiskt.** Profiler, terminologi och exempel listas av IG Publisher på `artifacts.html`; separata manuellt underhållna listningssidor skulle duplicera den informationen.
- **Informationsunderlag hålls åtskilt.** Verksamhetens informationsmodeller och detaljerade flöden kan ligga i en separat auktoritativ specifikation och refereras från IG:n, så att inte dubbla källor driver isär.

## Grafisk profil

Region Stockholms grafik och format finns i `input/includes/fragment-header.html`, `input/includes/fragment-css.html` och `input/images/region-stockholm.css`. Logotyperna och en **platshållare** för favicon finns i `input/images/`; kontrollera och ersätt platshållaren med en godkänd favicon. Anpassa eller ta bort dessa resurser om en IG ska använda annan godkänd profil.

## Skapa en IG från mallen

Gör detta en gång per IG-repository.

1. Skapa ett repository i Region Stockholms organisation med **Use this template**.
2. Anpassa `sushi-config.yaml`:

   | Fält | Exempel | Kommentar |
   |---|---|---|
   | `id` | `regionstockholm.example.my-ig` | Unikt paket-id, beslutat med förvaltningen |
   | `canonical` | `https://pub.regionstockholm.se/fhir/ig/my-ig` | Långsiktigt förvaltad URL; ändra inte efter publicering utan en migrationsplan |
   | `name` | `RegionStockholmMyIg` | Namn utan mellanslag |
   | `title` | `"Min FHIR IG"` | Visas i IG:n |
   | `description` | `"FHIR-profiler för ..."` | Beskrivning av IG:n |
   | `version` | `0.1.0` | Versionen för nästa release |
   | `status` | `draft` | Ändras när IG:n mognar |
   | `fhirVersion` | `4.0.1` | FHIR-basversion |

   Paket-id, canonical, namn och publiceringssökväg måste följa Region Stockholms beslutade publiceringslösning. Mallens canonical är en konfigurationsplatshållare, inte en garanti för att URL:en är driftsatt.
3. Ange samma paket-id i `ig.ini`, i sökvägen `fsh-generated/resources/ImplementationGuide-<id>.json`.
4. Ersätt exempelprofilen och exempelinstansen i `input/fsh/` och fyll i sidorna i `input/pagecontent/`. Uppdatera paketlänken i `downloads.md` och motsvarande undantag i `input/ignoreWarnings.txt`.
5. Anpassa `publication-request.json` med IG:ns titel, beskrivning, CI-adress och registeruppgifter. Sätt `"first": true` vid den nya IG:ns första publicering. Bekräfta kategori och övriga registeruppgifter med publiceringsansvarig.
6. Konfigurera Region Stockholms delade workflows och publiceringsmiljö enligt [förberedelserna för publicering](docs/forbereda-och-releasa-ig.md). Skapa gärna en `develop`-branch från `main`.
7. Töm mallens poster i `input/pagecontent/version-history.md` när IG:n startar sin egen versionshistorik. Behåll formatet `### [X.Y.Z] — ÅÅÅÅ-MM-DD`, med underrubriker vid behov.
8. Ge profilerna egna `* ^version` om de ska versionshanteras separat. Annars får en profil normalt IG:ns version.
9. Om det regionala workflowet skapar `gh-pages` för branchbyggen, aktivera vid behov **Settings → Pages → Deploy from a branch → `gh-pages` / `(root)`**. Kontrollera att Actions har de behörigheter som krävs för att uppdatera branchen.

<del style="color: red;">Ta bort `with:` och `package-feed: false` ur `release.yml` så att paketet publiceras till packages.fhir.org.</del> **Kommentar:** detta är en instruktion för Ineras paketfeed. Region Stockholm ska först besluta om och konfigurera sin paketdistribution; kopiera inte Ineras flaggor eller anta att ett paketflöde är aktivt.

<del style="color: red;">Inställningen *Allow GitHub Actions to create and approve pull requests* behövs inte längre eftersom release-please har tagits bort.</del> **Kommentar:** release-please har inte använts som regional versionsautomatisering i den här mallen. Aktivera bara Actions-behörigheter som den valda regionala workflowen faktiskt kräver.

### Kontroll före första publicering

- [ ] `id` är samma i `sushi-config.yaml` och `ig.ini`.
- [ ] Canonical, paket-id och publiceringssökväg är beslutade och stöds av målmiljön.
- [ ] `publication-request.json` har korrekt `first`, `desc`, titel, CI-adress och registermetadata.
- [ ] Exempelprofil, exempelsidor, paketlänk och `input/ignoreWarnings.txt` är anpassade.
- [ ] QA-resultat och externa beroenden är granskade; beroenden är låsta till publicerade versioner inför release, inte `current`.
- [ ] Eventuell paketlista och versionshistorik är hanterade enligt publiceringslösningen.
- [ ] Region Stockholms test- och produktionsmål, GitHub Pages och Actions-behörigheter är konfigurerade och testade.

## Arbetsflöde i vardagen

1. Skapa en `feature/`-branch från `develop`, exempelvis `feature/my-change`.
2. Ändra FSH och dokumentation, kör SUSHI lokalt och pusha branchen.
3. Öppna en pull request mot `develop`. Granska validering, IG Publisher QA och QA-rapporten innan merge.
4. Merga när ändringen är granskad. Integrera till `main` enligt repositoryts branchskydd och releaseprocess.

Ändringar i `input/fsh/profiles/`, `input/fsh/examples/` och `input/pagecontent/` ersätter mallens platshållarinnehåll. Redigering i GitHub går också bra: välj **Edit this file** och skapa en branch/pull request mot `develop`. I repositoryt kan `.` öppna den webbaserade VS Code-miljön.

Workflowen i det här repositoryt är för närvarande spärrade platshållare, inte fungerande CI. Triggerna finns, men jobben avslutas med fel tills Region Stockholms motsvarigheter har konfigurerats:

| Workflow | Nuvarande trigger | Avsedd funktion när regionalt konfigurerad |
|---|---|---|
| `validate.yml` | Push till brancher utom `main`, samt pull requests | Kör SUSHI |
| `pr-qa.yml` | Öppnad, uppdaterad eller återöppnad pull request | IG Publisher-bygge, QA och rapport till PR |
| `publish.yml` | Push till `main`, `develop`, `feature/**`, `support/**`, samt manuell körning | Branchbygge och eventuell förhandsvisning |
| `release.yml` | Taggar med semver-liknande format, samt manuell körning | Test- eller releasepublicering enligt mål och trigger |
| `cleanup.yml` | Borttagning av branch | Städning av förhandsvisningsbygge |

När PR-QA är implementerad kan rapporten exempelvis visa fel, varningar, hints och brutna länkar. Undantag i `input/ignoreWarnings.txt` kan påverka vad som redovisas. Bekräfta rapportens format och uppdateringsbeteende i det regionala workflowet innan du förlitar dig på det. Se [förberedelserna för publicering](docs/forbereda-och-releasa-ig.md).

### Commitmeddelanden och versionsval

Versionen räknas upp manuellt; mallens workflows skapar inte versioner eller taggar. [Conventional Commits](https://www.conventionalcommits.org/) kan underlätta granskning av ändringar:

| Prefix | Exempelbetydelse | Vanlig versionsökning |
|---|---|---|
| `feat:` | Ny profil, egenskap eller sida | Minor |
| `fix:` | Rättning av profil eller text | Patch |
| `profile:` / `valueset:` | Ändring av profil eller terminologi | Bedöms efter kompatibilitet |
| `docs:` | Dokumentationsändring | Vanligen ingen egen release |
| `chore:` | Underhåll eller CI | Vanligen ingen egen release |
| `feat!:` eller `BREAKING CHANGE:` | Bakåtinkompatibel ändring | Major |

`git log --oneline <föregående-version>..HEAD` kan användas som underlag för versionshistorik och releasebeskrivning. Prefixet är stöd för teamet, inte automatisk versionspolicy.

## Versioner och release

Håll isär FHIR-basversionen (`fhirVersion`), IG-paketets version (`version` i `sushi-config.yaml`) och eventuella separata profilversioner (`* ^version`). Följ semantisk versionering: major för bakåtinkompatibla ändringar, minor för bakåtkompatibla tillägg och patch för rättningar. Versioner, versionshistorik och taggar hanteras manuellt enligt [versionshantering och release](docs/versionshantering-och-release.md).

Innan release:

1. Uppdatera `version` i `sushi-config.yaml`, en post i versionshistoriken och releasebeskrivningen i `publication-request.json`.
2. Ange rätt `mode`: normalt `milestone` för en aktuell release, `working` för en release candidate eller en äldre supportversion som inte ska ersätta den aktuella.
3. Lås beroenden till publicerade versioner och granska profiler, exempel och QA.
4. Testpublicera i regional testmiljö när den är tillgänglig.
5. Skapa en tagg utan `v` som exakt motsvarar versionen i `sushi-config.yaml`, men först när Region Stockholms releaseworkflow är konfigurerat och godkänt.
6. Verifiera publicerad IG, historik, paket och eventuella register enligt den regionala processen.

Publicera inte samma version flera gånger; paket kan ligga kvar i cache. Använd en ny patchversion för rättelser.

<del style="color: red;">Inera-specifika adresser och system: publicera releaser på `https://fhir.inera.se/ig/<namn>/`, använd `inera-ab/fhir-portal` och `inera-ab/fhir-portal-test`, skapa en `FHIR_PORTAL_TOKEN` för dessa repositoryn och skicka en PR till FHIR/ig-registry efter varje release.</del> **Kommentar:** dessa mål, hemligheter och registerrutiner ägs av Inera och ska inte användas för Region Stockholms publicering. Regionala mål och registerkrav måste fastställas separat.

## CI och publicering

När de regionala workflowsen finns, dokumentera deras gränssnitt och bekräfta vad varje händelse gör. Typiska funktioner är:

| Workflow | Typisk funktion |
|---|---|
| `validate.yml` | SUSHI-validering vid push och pull request |
| `pr-qa.yml` | IG Publisher-bygge, QA och rapport till pull request |
| `publish.yml` | Branchbygge till avsedd test-/förhandsvisningsplats |
| `release.yml` | Publicering av en taggad version |
| `cleanup.yml` | Städning av förhandsvisningsbyggen när brancher tas bort |

För branchbyggen behöver Actions normalt få nödvändiga skrivbehörigheter, exempelvis till GitHub Pages. Releasepublicering kan kräva åtkomst till webbrot, paketflöde eller katalog; ge minsta nödvändiga behörighet och undvik att ärva hemligheter slentrianmässigt. R5-IG kan behöva en R5-kompatibel terminologiserver i publicerings- och QA-byggen.

<del style="color: red;">De delade workflowen i `Inera-AB/fhir-ig-workflows@v1`, publicering till Ineras GitHub Pages/webbrot och publiceringsadress `fhir.inera.se` är de aktiva standardmålen.</del> **Kommentar:** detta är Ineras ägda infrastruktur. Mallens kommenterade `uses:`-rader är endast exempel tills en regional workflow- och publiceringslösning finns.

## Lokal utveckling

För ett fullständigt bygge behövs Git, Node.js 20 eller senare, SUSHI, Java 17 eller senare, Ruby, Jekyll och IG Publisher. Följ verktygens aktuella installationsanvisningar. Exempel för macOS, Linux eller Git Bash:

```bash
git clone https://github.com/regionstockholm/<repo>.git
cd <repo>

npm install -g fsh-sushi
gem install jekyll
mkdir -p input-cache
curl -sL https://github.com/HL7/fhir-ig-publisher/releases/latest/download/publisher.jar -o input-cache/publisher.jar

sushi .
java -jar input-cache/publisher.jar -ig ig.ini
```

Öppna `output/index.html` efter bygget och granska QA-rapporten. Byggkatalogerna `output/`, `temp/`, `template/`, `input-cache/` och `fsh-generated/` ska inte checkas in. Lägg inte till `hl7.fhir.r4.core` som beroende i `sushi-config.yaml`; SUSHI lägger till kärnpaketet. Lås övriga beroenden till publicerade versioner inför release. Första bygget kan hämta stora FHIR-paket; efterföljande byggen använder normalt den lokala paketcachen.

Öppna bygget med `start output/index.html` på Windows, `open output/index.html` på macOS eller `xdg-open output/index.html` på Linux. Rekommenderade VS Code-tillägg är FHIR Shorthand (syntaxstöd), YAML (konfigurationsfiler), GitHub Pull Requests och GitLens.

## Tips och vanliga fallgropar

- Kör `sushi .` lokalt innan push; det är snabbare än att vänta på CI.
- Använd alias i `input/fsh/aliases.fsh` för återkommande långa URL:er i profiler.
- Lägg inte till `hl7.fhir.r4.core` som dependency; SUSHI hanterar kärnpaketet.
- QA kan få falska terminologifel om rätt terminologiserver saknas, särskilt vid R5.
- Lägg inte in `output/`, `temp/`, `template/`, `input-cache/` eller `fsh-generated/` i Git.
- Kontrollera Actions-loggar för byggfel och publiceringsfel; till dess att workflowen är aktiverad kommer placeholder-jobben avsiktligt att misslyckas.
- Undantag i `input/ignoreWarnings.txt` ska följa den IG:ns canonical och användas restriktivt.
- Kontrollera om vald publiceringslösning förutsätter att `package-list.json` ligger i publiceringskatalogen eller inte. Om IG Publisher används i publiceringsläge kan en sådan fil i källmappen hindra publicering; hantera den enligt målmiljöns instruktioner.

<del style="color: red;">Repositoryt får aldrig innehålla `package-list.json`; versionshistoriken finns alltid på fhir.inera.se och IG Publisher vägrar publicera från en källmapp som har filen.</del> **Kommentar:** katalogens plats och publisherns beteende beror på publiceringsmodellen. Detta gäller inte som generell regel för alla IG:n eller alla regionala mål.

## Versionshistorik

`input/pagecontent/version-history.md` är IG:ns ändringslogg, medan den publicerade versionskatalogen kan hanteras separat av IG Publisher. Skriv poster som `### [X.Y.Z] — YYYY-MM-DD`, med `####`-rubriker för ändringsgrupper. Sidorna använder rubriknivå `###` eftersom IG-templaten genererar sidtiteln. Lägg inte till `{::options header_offset="1" /}`; det kan skapa hopp i rubriknivåerna i QA.

## Repositorystruktur

| Sökväg | Innehåll |
|---|---|
| `.github/workflows/` | Validering, QA, städning och exempel för publicering |
| `.github/pull_request_template.md` | Mall för pull requests |
| `docs/` | Vägledning för versionering, migrering och publicering |
| `sushi-config.yaml`, `ig.ini` | IG:ns metadata och byggkonfiguration |
| `publication-request.json` | Metadata för en framtida release |
| `input/fsh/` | FSH-profiler, exempel och alias |
| `input/pagecontent/` | IG:ns narrativesidor, inklusive versionshistorik |
| `input/includes/`, `input/images/` | Meny, sidhuvud och grafiska resurser |

Sidtitlarna styrs av `pages` i `sushi-config.yaml`. Skriv därför sidornas egna rubriker från nivån `###`, under titeln som templaten genererar.

## Förvaltning

Mallen och dess regionala publiceringslösning förvaltas inom Region Stockholm. Publiceringsansvar, kontaktvägar, godkända visuella resurser och registermetadata ska bekräftas med Region Stockholms ansvariga innan en IG publiceras.

<del style="color: red;">Mallen förvaltas av Inera AB; se Ineras FHIR Landing Page för konformitetskrav.</del> **Kommentar:** mallens ägare och styrning är Region Stockholm. Ineras förvaltnings- och konformitetskrav gäller inte automatiskt.
