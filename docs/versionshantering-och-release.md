# Versionshantering, brancher och releaser

Den här vägledningen gäller IG:er som bygger på Region Stockholms mall. Branch- och releasepublicering är ännu inte konfigurerade; se [förberedelserna](forbereda-och-releasa-ig.md).

## Versioner

Håll isär FHIR-versionen (`fhirVersion`), IG-paketets version (`version` i `sushi-config.yaml`) och eventuella separata versioner på enskilda profiler. En IG för en annan FHIR-version behöver egen konfiguration och vid behov ett eget repository och paket-id.

Använd semantisk versionering: öka major vid bakåtinkompatibla ändringar, minor vid bakåtkompatibla tillägg och patch vid rättningar. Dokumentera förändringarna i `input/pagecontent/version-history.md` med `### [X.Y.Z] — YYYY-MM-DD` och vid behov underrubriker på nivån `####`. En ny IG ska inte överta mallens versionshistorik som sin egen.

## Brancher och CI

| Branch eller händelse | Syfte |
|---|---|
| `main` | Stabil grund för releaser och, när publiceringen är konfigurerad, repositoryts huvudsida på GitHub Pages |
| `develop` | Integration av kommande ändringar |
| `feature/**` | Arbete som normalt integreras via pull request till `develop` |
| `support/<M>.x` | Underhåll av en äldre majorversion |
| Pull request | SUSHI-validering och IG Publisher QA |
| Push till branch eller tagg `X.Y.Z` eller `X.Y.Z-rcN` | Publiceringsworkflowet startar men avbryter tills regional publicering konfigurerats |

När branchpubliceringen är konfigurerad kan byggen publiceras på repositoryts egna GitHub Pages, normalt `https://regionstockholm.github.io/<repo>/` för `main` och under `branches/` för övriga brancher.

## Förbereda en release

1. Sammanställ ändringarna sedan föregående release och välj version.
2. Uppdatera `version` i `sushi-config.yaml`, versionshistoriken och releasebeskrivningen i `publication-request.json`.
3. Granska profiler, exempel, QA och låsta beroenden. Testa publiceringen i en separat regional testmiljö när en sådan finns.
4. När Region Stockholms releaseflöde är konfigurerat och godkänt, skapa en tagg utan `v` som exakt motsvarar versionen i `sushi-config.yaml`.
5. Kontrollera publicerad version, versionshistorik och eventuella register och paketflöden enligt den regionala publiceringslösningen.

Publicera inte samma version två gånger: FHIR-paket kan finnas kvar i cache. Använd en ny patchversion vid rättelser. En release candidate eller en patch på en äldre majorversion kan behöva `working` i stället för `milestone` för att inte ersätta den senaste versionen.
