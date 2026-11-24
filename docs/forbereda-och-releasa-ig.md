# Förbereda en IG för publicering och göra en release

Den här sidan beskriver vad som behöver beslutas inför en IG:s första publicering och vad som normalt ändras inför varje release. I Region Stockholms mall är publiceringsflödena ännu inte konfigurerade: `.github/workflows/publish.yml` och `release.yml` innehåller kommenterade exempel samt jobb som avsiktligt avslutas med fel. En push, tagg eller manuell körning publicerar därför ingenting.

Målet för en fungerande publiceringslösning är att paketmetadata, versionshistorik, release-taggar, publicerad IG och eventuella paket/register ska stämma överens. Branchmodell och versionsval beskrivs mer i detalj i [Versionshantering, brancher och releaser](versionshantering-och-release.md). En redan publicerad IG som byter miljö följer även [Flytta en befintlig IG](flytta-befintlig-ig.md).

## Så hänger delarna ihop

| Begrepp | Var det bestäms | Att kontrollera |
|---|---|---|
| Paket-id | `id` i `sushi-config.yaml` | Samma id används av IG-konfiguration och paket |
| Canonical | `canonical` i `sushi-config.yaml` | Långsiktig adress, stödd av regional publiceringslösning |
| Version | `version` i `sushi-config.yaml` | Ska motsvara releasetaggen |
| Releasebeskrivning | `publication-request.json` | Beskriver just den releasen; `mode` styr publiceringsbeteende |
| Versionshistorik | `input/pagecontent/version-history.md` och/eller publiceringskatalog | Klargör vilken källa som är auktoritativ |
| Beroenden | `dependencies` i `sushi-config.yaml` | Lås till publicerade versioner inför release |

Ett regionalt releaseworkflow kan typiskt kontrollera tagg och metadata, bygga IG:n, publicera versionen och uppdatera en versionskatalog eller ett paketflöde. Exakt ansvar, gränssnitt, registersteg och återställningsmöjlighet måste dokumenteras när Region Stockholms workflow och publiceringsmål har valts. Separera test- och produktionsmiljö.

<del style="color: red;">`release.yml` kontrollerar tagg och beskrivning, fyller `package-id`, `version` och `path`, kör `-go-publish`, skriver versioner till `ig/<namn>/` i `inera-ab/fhir-portal`, uppdaterar fhir.inera.se, feeds och `package-registry.json` samt sparar `fhir-ig-list.diff` för en PR till FHIR/ig-registry.</del> **Kommentar:** detta beskriver Ineras specifika workflow, webbrot och registerintegration. Region Stockholms mall utför inte dessa steg; den regionala motsvarigheten behöver definiera dem.

## Förberedelser inför första publiceringen

Gör detta en gång per IG. Bekräfta först målmiljö, canonical, paketdistribution, registerkrav, behörigheter och publiceringsansvar.

1. **Fyll i `sushi-config.yaml`.** Anpassa `id`, `canonical`, `name`, `title`, `description`, `version`, `status` och `fhirVersion`. Besluta paket-id och canonical med förvaltningen innan publicering; canonical ska inte ändras senare utan migrationsplan.
2. **Synka `ig.ini`.** `ig` ska peka på `fsh-generated/resources/ImplementationGuide-<id>.json` med samma id som i `sushi-config.yaml`. Om id ändras ska även sökvägen ändras.
3. **Fyll i `publication-request.json`.** Ange titel, `desc`, `mode`, `status`, `sequence`, `introduction`, `ci-build` och de registerfält målmiljön behöver. Sätt `"first": true` vid den nya IG:ns första publicering och därefter `false`. Bekräfta kategori och registermetadata med ansvarig.
4. **Ersätt mallinnehåll.** Anpassa profiler, exempel och narrativesidor. Töm mallens poster i `input/pagecontent/version-history.md`; fortsätt använda formatet `### [X.Y.Z] — ÅÅÅÅ-MM-DD` och vid behov `####`-rubriker.
5. **Uppdatera paketlänk och varningar.** Ändra paketlänken i `input/pagecontent/downloads.md` och motsvarande rad i `input/ignoreWarnings.txt` till godkänd regional adress.
6. **Bestäm profilversioner.** Om profiler versionshanteras separat, ange `* ^version` i respektive FSH-definition. Annars används IG-versionen normalt för profiler utan egen version.
7. **Granska beroenden och FHIR-basversion.** Använd publicerade beroendeversioner, inte `current`, inför release. Lägg inte till `hl7.fhir.r4.core` som dependency; SUSHI hanterar kärnpaketet. För annan FHIR-basversion behöver beroenden, terminologiserver och QA-konfiguration granskas.
8. **Konfigurera regionala workflows.** Ersätt kommenterade Inera-exempel i `validate.yml`, `pr-qa.yml`, `publish.yml`, `release.yml` och `cleanup.yml` med godkända regionala motsvarigheter. Kontrollera Actions-policy, behörigheter, runner, hemligheter, branchskydd och versionsreferenser för återanvändbara workflows.
9. **Konfigurera publiceringsmiljön.** Fastställ test- och produktionsadresser, webbrot/katalog, paketdistribution, registersteg och historikhantering. Konfigurera GitHub Pages för branchbyggen om det är den beslutade förhandsvisningen.
10. **Testa före skarp publicering.** Kör validering och QA på en pull request, branchbygge och en manuell testpublicering. Kontrollera genererad IG och testmiljö samt verifiera att testkörningen inte ändrar produktion.

### Fält i `sushi-config.yaml`

| Fält | Exempel | Kommentar |
|---|---|---|
| `id` | `regionstockholm.example.my-ig` | Unikt paket-id enligt Region Stockholms konvention |
| `canonical` | `https://pub.regionstockholm.se/fhir/ig/my-ig` | Exempel/platshållare; kontrollera att målmiljön hanterar adressen |
| `name` | `RegionStockholmMyIg` | Namn utan mellanslag |
| `title` | `"Min FHIR IG"` | Visas i IG:n och eventuellt katalog |
| `description` | `"FHIR-profiler för ..."` | Beskriver IG:n |
| `version` | `0.1.0` | Versionen för nästa release |
| `status` | `draft` | Ändras enligt IG:ns mognad |
| `fhirVersion` | `4.0.1` | FHIR-basversion |

### Fält i `publication-request.json`

Följ det format som det regionala publiceringsworkflowet/IG Publisher kräver. Exempel på värden som brukar behövas:

```json
{
  "mode": "milestone",
  "status": "release",
  "sequence": "Releases",
  "desc": "Första publicerade versionen.",
  "first": true,
  "title": "Min FHIR IG",
  "category": "Regional",
  "introduction": "Kort beskrivning för versionshistorik eller katalog.",
  "ci-build": "https://<regional-ci-adress>/<repo>",
  "registry-description": "Kort beskrivning för FHIR-register.",
  "registry-country": "se",
  "registry-authority": "Region Stockholm"
}
```

Fältnamn och tillåtna värden måste verifieras mot vald lösning. `package-id`, `version` och `path` kan fyllas automatiskt av workflowet, men det får inte antas innan dess gränssnitt är fastställt.

<del style="color: red;">Använd `inera.<domän>.<namn>` med exakt tre delar, `https://fhir.inera.se/ig/<namn>`, kategorin `National Base`, `registry-authority: Inera`, `FHIR_PORTAL_TOKEN` och `https://inera-ab.github.io/<repo>` som CI-adress.</del> **Kommentar:** paket-id-formatet, canonical, kategori, auktoritet, token och CI-adress är Ineras beslut och system. Region Stockholm ska använda egna godkända värden och hemligheter.

### Kontroll före första release

- [ ] `id` i `sushi-config.yaml` stämmer med `ig.ini` och genererad ImplementationGuide.
- [ ] Canonical, paket-id, publiceringssökväg och titel är godkända.
- [ ] `publication-request.json` har korrekt `first`, releasebeskrivning och registermetadata.
- [ ] CI-adress och paketlänk pekar på avsedd regional miljö.
- [ ] Mallens exempel och versionshistorik har ersatts/tömts för den nya IG:n.
- [ ] QA-resultat är granskade och externa beroenden är låsta till publicerade versioner.
- [ ] Test- och produktionsmål, GitHub Pages och Actions-behörigheter är konfigurerade.
- [ ] En testpublicering har lyckats och har verifierats av ansvarig.

## Inför varje release

### Vad som ska ändras

| Var | Vad |
|---|---|
| `sushi-config.yaml` | Öka `version` enligt semver |
| `input/pagecontent/version-history.md` | Lägg till `### [X.Y.Z] — ÅÅÅÅ-MM-DD` med beskrivning av ändringar |
| `publication-request.json` | Ny `desc` för releasen och lämpligt `mode` |
| `sushi-config.yaml`, `dependencies` | Lås beroenden till publicerade versioner, inte `current` |
| Ändrade profiler | Uppdatera `* ^version` om profiler versionshanteras separat |
| Git-tagg | Tagga releasecommiten med samma version utan `v` |
| Versionskatalog, paket, register | Uppdateras enligt den regionala lösningens ansvarsfördelning |

### Steg för steg

1. **Välj version** enligt [versionshanteringsreglerna](versionshantering-och-release.md). Som riktlinje ger bakåtkompatibla tillägg minor, rättningar patch och bakåtinkompatibla ändringar major.
2. **Gör releaseändringarna i en pull request** mot releasebranchen (`main` eller en beslutad `support/<M>.x`-branch): uppdatera `version`, versionshistorik, relevanta profilversioner och `publication-request.json`.
3. **Ange `mode` och `desc`.** `milestone` används normalt för en version som ska bli aktuell; `working` för en release candidate eller en äldre supportversion som inte ska ersätta den aktuella. Beskrivningen ska vara ny och avse just denna release.
4. **Granska kvalitet och beroenden.** Kör SUSHI och IG Publisher QA. Kontrollera att beroenden är låsta till utgivna versioner, och att terminologiserver stämmer med FHIR-basversionen.
5. **Testpublicera** i regional testmiljö om sådan finns. Granska IG:n, versionslistan, historik, paket och länkar.
6. **Merga releaseändringen** enligt teamets godkännandeprocess.
7. **Tagga och pusha** efter att det regionala releaseworkflowet har konfigurerats och godkänts. Taggen ska exakt motsvara `version` i `sushi-config.yaml`, utan `v`. Exempel:

   ```bash
   git fetch origin
   git tag -a 1.2.0 -m "1.2.0" origin/main
   git push origin 1.2.0
   ```

8. **Följ workflowkörningen.** Kontrollera loggar och artefakter; verifiera att den förväntade versionen publicerats till rätt miljö.
9. **Verifiera efter release.** Kontrollera versionens URL, IG:ns huvudsida om sådan finns, versionshistorik, paketnedladdning och eventuella katalog- och registerposter. Dokumentera utförda manuella steg.

### Om något går fel

| Symtom | Möjlig orsak | Åtgärd |
|---|---|---|
| Taggen matchar inte versionen | Versionen uppdaterades inte före taggning | Avbryt publiceringen; rätta versionen och skapa korrekt ny tagg enligt repositoryts policy |
| Releasebeskrivning saknas eller är återanvänd | `desc` har inte uppdaterats | Ange en ny beskrivning och kör om enligt workflowets instruktioner |
| Versionen finns redan publicerad | Taggen/versionen har redan använts | Publicera inte om; skapa en ny patchversion |
| `403`, `Bad credentials` eller nekad push | Hemlighet saknas, har gått ut eller har för bred/fel behörighet | Kontrollera regionalt credential och minsta behörighet; rotera vid behov |
| Publishern klagar på beroende `current` | Beroendet är inte låst | Välj en publicerad paketversion |
| QA visar fler fel/varningar | Byggkonfiguration, terminologi eller IG-innehåll har ändrats | Granska rapporten, rätta orsaken och kör QA igen |
| Taggen finns men releaseworkflowet startade inte | Taggen kan ha skapats av en GitHub Action eller på annat sätt utan att en workflow-run triggas | Kontrollera händelsekälla och Actions-loggar; starta publicering manuellt endast enligt godkänd process |
| Publiceringen avbröts | Workflow kan ha misslyckats före eller efter skrivning till mål | Kontrollera logg och publiceringsmål innan omkörning; verifiera om delvisa ändringar finns |

<del style="color: red;">Om en körning misslyckas före steget *Push web root* har ingenting ändrats; en branchkörning publicerar alltid till `inera-ab/fhir-portal-test` och en taggkörning alltid till `fhir.inera.se`.</del> **Kommentar:** den garantin och separationen gäller Ineras workflow. En regional körning måste dokumentera sina egna transaktionsgränser och mål; kontrollera målstatus innan omkörning.

## Publicering och register

Före produktionssättning behöver Region Stockholm besluta vem som hanterar:

- IG:ns publicerade versionssidor och aktuell huvudsida.
- `package-list.json`, `history.html` eller motsvarande versionshistorik.
- Paketflöde och eventuell distribution till FHIR-paketregister.
- Registrering i FHIR IG Registry eller andra kataloger.
- Hemligheter, åtkomst till webbrot och test-/produktionsseparation.
- Arkivering, ändring av gammal version, återställning och incidenthantering.

Om IG Publisher används i publiceringsläge kan den hantera versionskatalog och historiksida automatiskt samt uppdatera releasebannern i tidigare versioner. Bekräfta beteendet mot den aktuella publisher-versionen och målmiljön och testa med en kopia först. Publicerade versioner bör vara oföränderliga; publicera rättelser som en ny patchversion.

<del style="color: red;">För varje release skapas en PR till `FHIR/ig-registry` med artefakten `fhir-ig-list.diff`; packages.fhir.org hämtar paketen från Ineras `package-feed.xml`, som registreras en gång i `package-feeds.json`.</del> **Kommentar:** dessa manuella registersteg och Ineras feed gäller inte automatiskt Region Stockholm. Fastställ om regional IG Registry-registrering eller paketfeed behövs och vem som ansvarar.

## Kända begränsningar att bedöma

- **Språk:** IG Publisher kan skapa vissa standardbanners eller historiksidor på engelska, oavsett IG:ns språk. Kontrollera vad som kan översättas i den valda versionen.
- **Content negotiation:** en statisk webbpublicering behöver inte returnera FHIR JSON för canonical-URL:er; dokumentera hur maskinkonsumenter hämtar resurser och paket.
- **Lagring:** versionskopior kan göra att publiceringsytan växer snabbt. Bestäm retention och övervakning.
- **Tekniska rättelser:** publisherfunktioner såsom `technical-correction` kan kräva separata mallar eller serverinställningar; aktivera inte utan att verifiera hela målmiljön.
- **Publisherfunktioner under utveckling:** granska QA och publiceringsloggar för ofärdiga metadatafält i paket- och publiceringsflöden.

<del style="color: red;">fhir.inera.se saknar content negotiation eftersom det ligger på GitHub Pages, har en gräns på 1 GB och varje release tar ungefär dubbla IG-storleken. Ineras `technical-correction` saknar `tech-correction.template.html`, och "source id Unknown (todo)" är en ofärdig publisherfunktion.</del> **Kommentar:** de första tre påståendena gäller Ineras hosting och konfiguration. Kontrollera regional lagring, content negotiation och templates innan motsvarande begränsning anges för Region Stockholm; publisherfunktioner ska verifieras mot den version som faktiskt används.
