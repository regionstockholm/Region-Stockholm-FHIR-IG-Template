# Versionshistorik - Inera FHIR Implementation Guide Template v2.3.0

## Versionshistorik

Den här sidan beskriver vad som har ändrats i varje version. Listan över alla publicerade versioner nås via länken i bannern överst på varje sida.

-------

### [2.3.0] — 2026-10-20

#### Features

* Releaser publiceras med IG Publishers officiella publiceringsläge (`-go-publish`) till den gemensamma webbroten på fhir.inera.se. Publishern skriver versionshistoriken (`history.html` och `package-list.json`), paket- och publiceringsflödena och IG:ns post i FHIR:s IG-register, och sätter releasebannern på alla sidor, även i tidigare versioner
* Ny workflow `release.yml`. Releasetaggar skrivs utan `v`, till exempel `2.3.0`. Manuella körningar publicerar till testwebbroten `inera-ab/fhir-portal-test`
* `publication-request.json` beskriver varje release. Paket-id, version och sökväg fylls i från `sushi-config.yaml`
* `package-list.json` finns inte längre i IG-repot. Den hålls av publishern i webbroten
* `publish.yml` bygger bara brancher
* release-please är borttaget. Versionen räknas upp för hand i `sushi-config.yaml`, med en post här och en `desc` i `publication-request.json`
* Workflowsen i `.github/workflows/` anropar de delade workflowsen i `Inera-AB/fhir-ig-workflows`

-------

### [2.2.2] — 2026-10-15

#### Bug Fixes

* `menu.xml` innehöll samma omslutande element (`#segment-navbar`, `#stripe`, `container` och `nav`) som templatet redan lägger runt menyn. Det gav dubbla id:n på varje sida och varningen `HTML_DUPLICATE_ID` i QA-rapporten. Filen innehåller nu bara `<ul class="nav navbar-nav">`
* Varje sida i `input/pagecontent/` började med en egen `# Rubrik`, men templatet visar redan sidans titel som `<h2>`. IG Publisher 3.0 rapporterar det som ett fel, eftersom sidans första rubrik måste vara dess högsta nivå. Raden är borttagen; titeln styrs av `pages` i `sushi-config.yaml`
* Övriga rubriker följer samma regel: versionerna i versionshistoriken är `###` och avsnitten `####`, och mallrubriken i `use-cases.md` är `###` i stället för `####`, så att ingen nivå hoppas över

-------

### [2.2.1] — 2026-08-27

#### Bug Fixes

* Reservindexet som byggs när IG Publisher inte genererar `history.html` skrevs bara till `index.html`. Publishern stämplar in en länk till `<canonical>/history.html` på varje sida, så den länken gav 404 medan `<canonical>/` fungerade. Filen skrivs nu under båda namnen

-------

### [2.2.0] — 2026-08-27

Version 2.1.0 sattes i `sushi-config.yaml` men släpptes aldrig — den fick ingen tagg och ingen changelog-post. Ändringarna därifrån ingår i den här releasen.

#### Features

* Byte till `fhir2.base.template`, HL7:s språkmedvetna bastemplate. Sidorna genereras under `output/sv/` med en omdirigering i roten, och template- texterna följer språkinställningen
* Omstrukturerad meny: Hem, Inledning, Funktionellt, Implementering, Om och Artefakter, med nya sidor för användningsfall, roller och ansvar, REST-interaktioner, förväntade svar, felhantering, säkerhet och testning
* Vägledande kommentarer för profilering inbäddade i exempelprofilen
* QA-skriptet utbrutet till `.github/scripts/qa-comment.js` med en testsvit som körs vid varje push och pull request

#### Bug Fixes

* `i18n-default-lang` ersätter det felstavade `i18n-default-language`, som publishern ignorerade tyst. Det var orsaken till att ett tidigare försök med fhir2 lade alla sidor under `/en` trots att svenska var konfigurerat
* QA-kommentaren rapporterade noll fel och noll varningar för bygget som hade sex varningar. Siffrorna hämtas nu från publisherns egen summering i `build.log` och detaljerna från `output/qa.txt`; en trasig eller saknad källa redovisas öppet i stället för att visas som ett rent bygge
* `history.html` söks även i språkkatalogen, så releasesteget använder publisherns riktiga versionslista i stället för reservindexet
* Nedladdningslänken pekar på canonical och paketet kopieras till IG-roten vid release
* Platshållaren `<namn>` i `index.md` tolkades som ett HTML-element

-------

### [2.0.0] — 2026-06-25

#### Features

* Svenska sidtexter och menyrubriker i alla mallsidor
* Återgång till `fhir.base.template` (eliminerar `/en`-routing och aktiv bugg i fhir2.base.template)
* `i18n-default-language: sv` konfigurerat

-------

### [1.0.1] — 2026-06-24

#### Bug Fixes

* Read IG metadata from build output instead of sushi-config.yaml
* Fix `is_release` flag in fhir-portal dispatch to use tag ref check
* Align dispatch payload fields with fhir-portal registry workflow

-------

### [1.0.0] — 2026-06-24

#### Features

* Multi-branch CI: `develop`, `feature/**` and `support/<M>.x` branches each build and deploy to their own subdirectory
* fhir-portal integration: optionally push built IG to `inera-ab/fhir-portal` and notify index rebuild via `repository_dispatch`
* QA report posted as PR comment by `pr-qa.yml`
* `cleanup.yml` removes build directories for deleted branches
* `release-please.yml` for automated version bumping and changelog (manual trigger)
* WCAG 2.1 AA accessibility fixes in `inera.css`

-------

### [0.1.0] — 2026-06-16

#### Features

* Initial IG template structure with Inera branding
* `IneraPatient` example profile with personnummer identifier slice
* Navigation pages: Workflow, Logical Models, Mappings, Examples, Terminology, Downloads
* GitHub Actions for SUSHI validation, full IG Publisher build, and GitHub Pages deployment
* ig-registry integration via `package-list.json`
* WCAG 2.1 AA-compliant CSS

