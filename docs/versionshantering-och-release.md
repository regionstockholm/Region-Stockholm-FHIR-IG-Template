# Versionshantering, brancher och releaser

Den här vägledningen beskriver versionsdimensioner, branchmodell och releaseflöde för IG:er från Region Stockholms mall. Mallens validerings-, QA- och publiceringsworkflows är ännu inte konfigurerade; se [förberedelser för publicering](forbereda-och-releasa-ig.md).

## FHIR har flera versionsdimensioner

| Dimension | Vad den styr | Hanteras av |
|---|---|---|
| FHIR-basversion (R4, R5) | FHIR-resursernas och beroendenas tekniska bas | IG:ns `fhirVersion`, paket och kompatibel byggmiljö |
| IG-version (major.minor.patch) | Utgåvan av hela Implementation Guide | `version` i `sushi-config.yaml` och motsvarande Git-tagg |
| Profilversion (major.minor.patch) | En enskild profils utgåva | `* ^version` i profilens FSH-definition |

Dimensionerna är oberoende. En patchrelease på IG-nivå kan exempelvis innehålla en ny majorversion av en profil om profilens egen kompatibilitet kräver det. Fastställ versionspolicy med de system som konsumerar IG:n. En profil utan egen `* ^version` får normalt IG:ns version; ange en egen `^version` om profilerna ska versionshanteras separat.

FHIR-basversionen är en separat konfigurationsfråga från IG-versionen. Ett nytt FHIR-basversionsspår kan behöva separata beroenden, terminologiserver och publicering. Besluta om egen branch eller eget repository tillsammans med förvaltning och konsumenter; anta inte att de tekniska paketen kan blandas.

<del style="color: red;">Varje FHIR-basversion ska alltid ha ett eget repository. R4 till R5 innebär alltid nytt paket-id och canonical; det nya Inera-repot börjar om på 1.0.0 och använder tredje paket-id-delen som katalog på fhir.inera.se.</del> **Kommentar:** detta är en specifik rekommendation kopplad till Ineras paket- och katalogmodell, inte ett krav för alla IG:n. Välj Region Stockholms migrations- och versionsupplägg efter beroenden, konsumenter och publiceringsstöd.

## Brancher och syfte

En möjlig arbetsmodell för ett aktivt repository:

```text
main          senaste godkända stabila versionen
develop       integration av kommande ändringar
feature/*     kortlivat arbete, skapas från develop och mergas tillbaka
support/<M>.x underhåll av en äldre majorversion, om det behövs
```

Kom överens om branchskydd och mergeflöde. Rekommenderade principer:

- `main` ändras via granskade pull requests och representerar den stabila basen.
- `develop` samlar kommande ändringar när teamet använder en sådan integrationsbranch.
- `feature/*` brancher tas bort efter merge; använd korta namn med bokstäver, siffror och bindestreck.
- Taggar sätts endast på en godkänd releasecommit i branch som teamet valt för releaser.
- Underhåll av en äldre majorversion kan ske i `support/<M>.x` om den aktivt förvaltas. Nödvändiga rättningar förs vidare till aktuella brancher när det onödigt inte skapar konflikter.

`develop` och supportbrancher är en projektpolicy, inte ett krav från FHIR. Enklare repositoryn kan använda pull requests direkt mot `main` om förvaltningsmodellen anger det.

## CI och publiceringsmål

När Region Stockholms workflows är konfigurerade ska deras trigger och mål dokumenteras. Typisk ansvarsfördelning:

| Händelse | Vanligt workflow | Typisk funktion |
|---|---|---|
| Push till branch | `validate.yml`, `publish.yml` | SUSHI-validering och/eller förhandsvisningsbygge |
| Pull request | `validate.yml`, `pr-qa.yml` | SUSHI-validering, IG Publisher QA och rapport till PR |
| Borttagning av branch | `cleanup.yml` | Rensning av förhandsvisningsbygge |
| Release-tagg | `release.yml` | Validerad och godkänd publicering |
| Manuell körning | Beror på workflow | Testpublicering endast om målmiljö uttryckligen är vald |

I nuläget avslutar mallens jobb dessa flöden med fel eftersom de regionala workflowsen och publiceringsmålen inte finns konfigurerade. Kommenterade `uses:`-anrop är exempel, inte fungerande CI. Kontrollera också vilka Actions-behörigheter och hemligheter som krävs, särskilt skrivning till Pages, webbrot eller katalog. Ge bara minsta nödvändiga behörighet.

För R5 kan QA behöva en R5-kompatibel terminologiserver; annars kan kärnvärdemängder ge felaktiga valideringsfel. Ange servern uttryckligen och konsekvent i validering, QA, branchbygge och releaseflöde.

<del style="color: red;">Push till `main`, `develop`, `feature/**` och `support/**` publiceras med `publish.yml` till `inera-ab.github.io`; PR-QA kommenterar PR:en; branchborttagning städar Pages; manuell release på branch publiceras till `inera-ab/fhir-portal-test`; releasetaggar går till `fhir.inera.se`.</del> **Kommentar:** dessa triggers och adresser beskriver Ineras nuvarande workflow, inte Region Stockholms mall. Den regionala trigger-/målmatrisen måste fyllas i efter att workflows har satts upp.

## Versionsformat

| Fas | Exempel på version/tagg | Vanligt `mode` i `publication-request.json` |
|---|---|---|
| Arbete under utveckling | Ingen releasetagg; CI-build | — |
| Release candidate | `2.0.0-rc1` | `working` |
| Stabil release | `2.0.0` | `milestone` |
| Patch på äldre supportversion | `1.3.1` | `working` om den inte ska ersätta aktuell version |

Använd semantisk versionering:

- **Major** (`X.0.0`): bakåtinkompatibel ändring enligt IG:ns kompatibilitetsdefinition.
- **Minor** (`0.X.0`): bakåtkompatibelt innehåll eller funktion.
- **Patch** (`0.0.X`): rättning som inte ändrar den avsedda kompatibiliteten.

Taggen ska vara exakt samma som `version` i `sushi-config.yaml`, vanligen utan `v`. `milestone` används normalt för en utgåva som ska bli aktuell. `working` kan användas för release candidates och äldre supportversioner som inte ska ersätta den aktuella. Verifiera dessa värden mot det regionala publiceringsworkflowet.

<del style="color: red;">`working` publicerar till versionssökvägen på fhir.inera.se utan att ersätta IG:ns rot; `milestone` ersätter alltid den roten där.</del> **Kommentar:** det är Ineras publiceringskonfiguration som avgör detta. Bestäm och testa motsvarande beteende i Region Stockholms mål innan mode används.

## Releaseflöde steg för steg

### Ny minor- eller major-release

1. Integrera godkända ändringar till releasebranchen enligt repositoryts policy.
2. Skapa en pull request som uppdaterar `version` i `sushi-config.yaml`, lägger till en versionshistorikpost och vid behov uppdaterar profilversioner.
3. Lås beroenden i `sushi-config.yaml` till publicerade versioner. Använd inte `current` som releaseberoende.
4. Uppdatera `publication-request.json`: en ny `desc`, lämpligt `mode` (normalt `milestone`) och korrekta releasemetadata. Efter första publiceringen ska `"first"` vara `false`.
5. Kör validering och IG Publisher QA och granska resultatet. Testpublicera i regional testmiljö när den är konfigurerad.
6. Merga när ändringen är godkänd och QA passerar.
7. Skapa en annoterad tagg på den avsedda releasecommiten och pusha den. Exempel:

   ```bash
   git fetch origin
   git tag -a 2.1.0 -m "2.1.0" origin/main
   git push origin 2.1.0
   ```

8. Följ releaseworkflowet och verifiera publicerad version, versionshistorik, paket och register/katalog enligt regionala rutiner.

### Release candidate

Använd en förhandsversionsidentifierare såsom `X.Y.Z-rcN` och `mode: working` om den regionala lösningen stöder formatet. Testa versionen utan att ersätta aktuell release. När den slutliga releasen publiceras ska dess version och releasebeskrivning vara uppdaterade enligt teamets policy.

### Patch på äldre version

Om en supportbranch används, gör den bakåtkompatibla rättningen där, öka patchversionen och publicera enligt stödflödet. För över rättningen till de aktiva brancherna när det behövs.

```bash
git checkout support/1.x
# Gör ändringen på supportbranchen.
# Uppdatera version och versionshistorik.
# Ange publication-request.json enligt regional releasepolicy.
git tag -a 1.3.1 -m "1.3.1"
git push origin 1.3.1
```

Kommandoexemplet förutsätter att supportbranchen finns och att releaseworkflowet är konfigurerat. Lägg inte tagg innan det är verifierat vilken commit och vilket publiceringsmål som används.

### Kontroll efter publicering

- [ ] Rätt version finns på den regionalt beslutade versionsadressen.
- [ ] IG:ns aktuella adress pekar på avsedd version, om en sådan finns.
- [ ] Versionshistorik och releasebanner är korrekta.
- [ ] Paket kan hämtas och har rätt metadata.
- [ ] Kataloger och register är uppdaterade enligt ansvarsfördelningen.
- [ ] Äldre versioner och canonical-referenser fungerar fortsatt.
- [ ] Publiceringslogg och eventuella artefakter är sparade.

<del style="color: red;">Kontrollera `https://fhir.inera.se/ig/<namn>/<version>/`, `history.html`, katalogen på `https://fhir.inera.se/ig/` och bannern på gamla versioner.</del> **Kommentar:** adresserna hör till Inera. Byt mot den godkända regionala adressen och kontrollera att motsvarande funktioner faktiskt finns.

## Versionshistorik och registrering

`input/pagecontent/version-history.md` är IG:ns redaktionella ändringslogg. En publiceringskatalog kan också innehålla utgivningsdatum, status och URL:er; den kan skötas automatiskt av IG Publisher eller separat av den regionala publiceringslösningen. Besluta vilken källa som är auktoritativ och undvik att manuellt skapa motstridiga historiker på två ställen.

Registrering kan omfatta publiceringskatalog, FHIR IG Registry, paketflöde eller andra regionala kataloger. Ansvar och rutin behöver fastställas: vissa steg kan skötas av workflowet, andra kan kräva en manuell pull request. Dokumentera om en ändring ska göras vid första release, varje release eller endast vid större metadataändring.

<del style="color: red;">`release.yml` sparar `fhir-ig-list.diff`, som ska skickas i en PR till FHIR/ig-registry vid varje release. packages.fhir.org hämtar alla paket från `https://fhir.inera.se/ig/package-feed.xml`; feeden registreras en gång i FHIR/ig-registry.</del> **Kommentar:** detta är Ineras integration och paketfeed. Bekräfta om Region Stockholm ska använda samma offentliga register eller en annan paketdistribution och fastställ ansvarig process.

## Relaterad vägledning

- [Förbereda en IG för publicering och göra en release](forbereda-och-releasa-ig.md)
- [Flytta en befintlig IG](flytta-befintlig-ig.md)
