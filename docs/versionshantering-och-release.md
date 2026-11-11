# Versionshantering, brancher och releaser

Mallen publicerar ännu inte officiella releaser. En tagg ger ett byggresultat som Actions-artifact, inte en publicering i `regionstockholm/pub` eller hos Inera. Se [Förbereda en IG och bygga en version](forbereda-och-releasa-ig.md) för stegen.

## Versionsdimensioner

| Dimension | Hantering |
|---|---|
| FHIR-basversion, exempelvis R4 eller R5 | Ett separat IG-repo och paket per basversion rekommenderas |
| IG-version | `version` i `sushi-config.yaml`; en versionstagg ska vara identisk |
| Profilversion | En profil utan egen `* ^version` ärver normalt IG:ns version; ange en egen om profilen versionshanteras separat |

Välj major, minor och patch utifrån förändringens kompatibilitet. Håll en mänskligt läsbar ändringshistorik i `input/pagecontent/version-history.md`; den är inte samma sak som en framtida publicerad versionshistorik.

## Brancher

`develop` kan användas för integration, `feature/*` för kortlivade ändringar och `support/<major>.x` för underhåll av äldre versioner. Merga till `main` inför ett stabilt taggbygge. En tagg kan också sättas på en supportbranch vid underhåll. Brancher som inte är `main` publiceras som förhandsvisningar under `branches/<branch-slug>/` på IG-repots egna GitHub Pages.

| Händelse | Resultat |
|---|---|
| Push till `main`, `develop`, `feature/**` eller `support/**` | Branchförhandsvisning på det egna repots GitHub Pages |
| Pull request | SUSHI-validering och QA-kommentar |
| Versionstagg, exempelvis `1.2.0` eller `1.2.0-rc1` | Bygge och Actions-artifact, utan publicering |
| Raderad branch | Förhandsvisningen tas bort från det egna repots `gh-pages` |

Taggar skrivs utan `v` och måste matcha `version` i `sushi-config.yaml`. Taggbygget kontrollerar format och version men jämför inte mot tidigare publicerade versioner. Återanvänd aldrig en version som redan har publicerats officiellt.

## Publicering senare

`publication-request.json` är förberedande metadata, men används inte av taggbygget. I ett kommande publiceringsflöde kan en milestone och en arbetsversion få olika effekt på aktuell version; det är inte implementerat här. Samordna framtida canonical, publiceringssökvägar, äldre versioner och eventuell registerhantering med ägaren av `regionstockholm/pub` innan officiell publicering.

För en R5-IG behöver terminologiservern ändras till en lämplig R5-server i `publish.yml`, `pr-qa.yml` och taggbygget i `release.yml`. Taggbygget använder annars R4-servern.
