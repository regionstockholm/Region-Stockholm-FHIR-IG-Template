# Region Stockholm FHIR Implementation Guide Template

[![Build and publish IG](https://github.com/regionstockholm/Region-Stockholm-FHIR-IG-Template/actions/workflows/publish.yml/badge.svg)](https://github.com/regionstockholm/Region-Stockholm-FHIR-IG-Template/actions/workflows/publish.yml)
[![Validate FSH](https://github.com/regionstockholm/Region-Stockholm-FHIR-IG-Template/actions/workflows/validate.yml/badge.svg)](https://github.com/regionstockholm/Region-Stockholm-FHIR-IG-Template/actions/workflows/validate.yml)
[![FHIR R4](https://img.shields.io/badge/FHIR-R4-blue)](https://hl7.org/fhir/R4/)
[![License: CC0-1.0](https://img.shields.io/badge/License-CC0_1.0-lightgrey.svg)](https://creativecommons.org/publicdomain/zero/1.0/)

En GitHub-mall för Region Stockholms FHIR Implementation Guides (IG). Den innehåller en sidstruktur, vägledning för författare, en exempelprofil i FHIR Shorthand (FSH) och workflowfiler för validering och publicering.

Mallen bygger på [Ineras FHIR-mall](https://github.com/Inera-AB/IneraFHIRTemplate).

## Utformning

Menyn grupperar information under Hem, Inledning, Funktionellt, Implementering, Om och Artefakter. IG Publisher genererar artefaktsidan från profiler, exempel och terminologi. Informationsmodeller och verksamhetsflöden kan publiceras separat och refereras från IG:n för att undvika dubbla auktoritativa källor.

Region Stockholms grafik och format finns i `input/includes/fragment-header.html`, `input/includes/fragment-css.html` och `input/images/region-stockholm.css`. Logotyperna och en **platshållare** för favicon finns i `input/images/`; kontrollera och ersätt platshållaren med en godkänd favicon.

## Skapa en IG

1. Välj **Use this template** på GitHub och skapa ett repository i Region Stockholms organisation.
2. Anpassa `sushi-config.yaml`: paket-id (`id`), `canonical`, `name`, `title`, beskrivning, version och utgivare. Välj en långsiktigt förvaltad canonical URL innan IG:n publiceras; ändra inte en befintlig IG:s canonical utan en migrationsplan.
3. Ange samma paket-id i `ig.ini`, i sökvägen `fsh-generated/resources/ImplementationGuide-<id>.json`.
4. Ersätt exempelprofilen och exempelinstansen i `input/fsh/` och fyll i sidorna i `input/pagecontent/`. Uppdatera paketlänken i `downloads.md` och motsvarande undantag i `input/ignoreWarnings.txt` utifrån den nya canonical-adressen.
5. Anpassa `publication-request.json`, inklusive titel, beskrivning och `ci-build`. Första publiceringen av en ny IG använder `"first": true`. Bekräfta även kategori och övriga registeruppgifter med publiceringsansvarig.
6. Konfigurera Region Stockholms delade workflows och publiceringsmiljö enligt [förberedelserna för publicering](docs/forbereda-och-releasa-ig.md). Skapa gärna en `develop`-branch.

Mallens canonical `https://pub.regionstockholm.se/fhir/ig/template` och paketlänk är konfiguration, inte en garanti för att webbplatsen är driftsatt. Fastställ adress och publiceringsmiljö innan första publiceringen.

## Arbetsflöde och publicering

Skapa en `feature/`-branch från `develop`, ändra FSH och dokumentation, och öppna en pull request mot `develop`. `validate.yml` är avsett att köra SUSHI och `pr-qa.yml` att bygga IG:n och rapportera QA. De och `cleanup.yml` använder fortfarande delade workflows från mallens ursprungliga repository och ska flyttas till Region Stockholms motsvarighet när den finns.

**Publiceringsflödena är inte konfigurerade.** `publish.yml` och `release.yml` visar de tidigare anropen som kommenterade exempel och ger ett tydligt fel tills Region Stockholms motsvarighet har satts upp. De publicerar alltså varken branchbyggen eller releaser i nuläget. Se [förberedelser för publicering](docs/forbereda-och-releasa-ig.md) för hur flödena aktiveras.

Ytterligare vägledning:

- [Versionshantering, brancher och releaser](docs/versionshantering-och-release.md)
- [Förbereda en IG för publicering och göra en release](docs/forbereda-och-releasa-ig.md)
- [Flytta en befintlig IG](docs/flytta-befintlig-ig.md)
- [Region Stockholm on FHIR](https://vardgivarguiden.se/it-stod/informatik/region-stockholm-on-fhir/)

## Lokal utveckling

För ett fullständigt bygge behövs Git, Node.js, SUSHI, Java, Ruby, Jekyll och IG Publisher. Följ verktygens aktuella installationsanvisningar. Exempel:

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

Öppna `output/index.html` efter bygget och granska även QA-rapporten. Byggkatalogerna `output/`, `temp/`, `template/`, `input-cache/` och `fsh-generated/` ska inte checkas in. Lägg inte till `hl7.fhir.r4.core` som beroende i `sushi-config.yaml`; SUSHI lägger till kärnpaketet. Lås övriga beroenden till publicerade versioner inför release.

## Filer

| Sökväg | Innehåll |
|---|---|
| `.github/workflows/` | Validering, QA och städning samt exempel för branch- och releasepublicering |
| `docs/` | Vägledning för versionering, migrering och publicering |
| `sushi-config.yaml`, `ig.ini` | IG:ns metadata och byggkonfiguration |
| `publication-request.json` | Metadata för en framtida release |
| `input/fsh/` | FSH-profiler, exempel och alias |
| `input/pagecontent/` | IG:ns sidor, inklusive versionshistorik |
| `input/includes/`, `input/images/` | Meny, sidhuvud och grafiska resurser |

Sidtitlarna styrs av `pages` i `sushi-config.yaml`. Skriv därför sidornas egna rubriker från nivån `###`, under titeln som templatet genererar.
