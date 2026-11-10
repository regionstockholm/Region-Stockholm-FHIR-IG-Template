# Förbereda en IG för publicering och göra en release

Den här sidan beskriver vad som måste göras i ett IG-repo innan den första publiceringen och vad som måste ändras inför varje release. Målet är att följande ska stämma överens:

- en version publicerad på `https://fhir.inera.se/ig/<namn>/<version>/` med releasebanner
- versionshistoriken på `https://fhir.inera.se/ig/<namn>/history.html`
- en git-tagg `<version>` på GitHub för varje publicerad version
- IG:n i FHIR:s IG-register och paketet på packages.fhir.org

Branchmodell, versionsformat och flödet beskrivs i [Versionshantering, brancher och releaser](versionshantering-och-release.md). En IG som redan har publicerats med det tidigare upplägget följer [Flytta en befintlig IG till publiceringsläget](flytta-befintlig-ig.md).

---

## Så hänger det ihop

| Begrepp | Var det bestäms | Kommentar |
|---|---|---|
| Paket-id | `id` i `sushi-config.yaml` | Exakt tre delar: `inera.<domän>.<namn>` |
| `<namn>` | Tredje delen av paket-id:t | Katalogen på fhir.inera.se. Måste vara unik bland Inera-IG:er |
| `canonical` | `sushi-config.yaml` | `https://fhir.inera.se/ig/<namn>`. Ändras aldrig efter första releasen |
| Version | `version` i `sushi-config.yaml` | Taggen måste vara identisk, utan `v` |
| Releasebeskrivning | `publication-request.json` | `desc`, `mode`, `status` och `sequence` per release |
| Versionshistorik | `package-list.json` i webbroten | Skrivs av IG Publisher. Finns inte i IG-repot |

När en releasetagg pushas gör `release.yml` följande:

1. Kontrollerar att taggen och `sushi-config.yaml` stämmer, att `publication-request.json` har en beskrivning och att versionen inte redan är publicerad.
2. Fyller i `package-id`, `version` och `path` i `publication-request.json` från `sushi-config.yaml`.
3. Bygger IG:n.
4. Checkar ut webbroten (`ig/` på `gh-pages` i [inera-ab/fhir-portal](https://github.com/Inera-AB/fhir-portal)), men bara IG:ns egen katalog och de gemensamma filerna.
5. Kör IG Publisher med `-go-publish`. Publishern bygger IG:n på nytt för publicering och:
   - lägger versionen i `ig/<namn>/<version>/`
   - kopierar en milestone-release till `ig/<namn>/`
   - uppdaterar `package-list.json` och `history.html`
   - skriver om bannern i tidigare versioner
   - uppdaterar paket- och publiceringsflödena och `package-registry.json`
   - lägger till IG:n i sin kopia av FHIR:s IG-register
6. Pushar webbroten och uppdaterar IG-katalogen på `https://fhir.inera.se/ig/`.
7. Sparar ändringen i IG-registret (`fhir-ig-list.diff`) och publiceringsloggen som artefakt.

Branchbyggen publiceras bara till repots egna GitHub Pages.

---

## Förberedelser inför första publiceringen

Görs en gång per IG-repo. Kolumnen *Mallen* anger vad mallen redan sköter.

| # | Steg | Mallen |
|---|---|---|
| 1 | Skapa repot med **Use this template** på IneraFHIRTemplate. | Workflows, Inera-grafik, sidstruktur och QA följer med |
| 2 | Fyll i `sushi-config.yaml` (se nedan). | Nej |
| 3 | Sätt `ig = fsh-generated/resources/ImplementationGuide-<id>.json` i `ig.ini`, med samma `id` som i `sushi-config.yaml`. | Nej. Missas lätt, och då hittar IG Publisher ingen IG |
| 4 | Fyll i `publication-request.json` för första releasen (se nedan) med `"first": true`. | Filen finns med mallens värden |
| 5 | Ta bort raderna `with:` och `package-feed: false` i `.github/workflows/release.yml`. Mallen håller sig själv utanför FHIR:s paketregister med dem, men IG:ns paket ska nå packages.fhir.org. | Kommentar i filen |
| 6 | Töm `input/pagecontent/version-history.md` på mallens poster. Posterna skrivs som `### [X.Y.Z] — ÅÅÅÅ-MM-DD` med `####`-avsnitt, under sidtiteln. | Mallens poster visar formatet |
| 7 | Byt länken till paketet i `input/pagecontent/downloads.md` till `https://fhir.inera.se/ig/<namn>/package.tgz`, och motsvarande rad i `input/ignoreWarnings.txt`. | Nej |
| 8 | Ge varje profil en egen version med `* ^version = "x.y.z"` om profilerna ska versionshanteras separat. | Exempelprofilen visar hur |
| 9 | Slå på GitHub Pages för branchbyggen: Settings → Pages → *Deploy from a branch* → `gh-pages` / `(root)`. | Nej |
| 10 | Ge Actions skrivrättighet: Settings → Actions → General → **Read and write permissions**. | Nej |
| 11 | Lägg in hemligheten `FHIR_PORTAL_TOKEN`: Settings → Secrets and variables → Actions. En fine-grained PAT med *Contents: Read and write* på `inera-ab/fhir-portal` och `inera-ab/fhir-portal-test`. Notera tokens utgångsdatum. | Workflows använder den automatiskt |
| 12 | Skapa branchen `develop` från `main`. | Nej |

Webbroten på fhir.inera.se, flödena och layoutregeln är gemensamma för alla Inera-IG:er och redan uppsatta. De beskrivs i [fhir-portals README](https://github.com/Inera-AB/fhir-portal).

### `sushi-config.yaml`

| Fält | Exempel | Kommentar |
|---|---|---|
| `id` | `inera.lab.laboratory` | Exakt tre delar. Samma värde i `ig.ini` |
| `canonical` | `https://fhir.inera.se/ig/laboratory` | `https://fhir.inera.se/ig/<namn>` |
| `name` | `IneraLaboratory` | PascalCase, inga mellanslag |
| `title` | `"Inera Laboratoriesvar"` | Visas i IG:n och i katalogen på fhir.inera.se |
| `description` | `"FHIR-profiler för laboratoriesvar."` | Visas i katalogen |
| `version` | `0.1.0` | Versionen som nästa release får |
| `status` | `draft` | Ändras när IG:n mognar |
| `fhirVersion` | `4.0.1` | Ett repo per FHIR-basversion |

### `publication-request.json` för första releasen

```json
{
  "mode" : "milestone",
  "status" : "release",
  "sequence" : "Releases",
  "desc" : "Första publicerade versionen.",
  "first" : true,
  "title" : "Inera Laboratoriesvar",
  "category" : "National Base",
  "introduction" : "En rad om IG:n, visas på historiksidan.",
  "ci-build" : "https://inera-ab.github.io/<repo>",
  "registry-description" : "En rad om IG:n, för FHIR:s IG-register.",
  "registry-country" : "se",
  "registry-authority" : "Inera"
}
```

`package-id`, `version` och `path` fylls i av workflowen. Sätt `"first": false` efter första releasen.

### Registrering

- **IG-katalogen på fhir.inera.se** fylls i automatiskt vid första releasen.
- **FHIR:s IG-register:** skicka en PR till [FHIR/ig-registry](https://github.com/FHIR/ig-registry) med ändringen från artefakten `fhir-ig-list.diff`.
- **packages.fhir.org** hämtar paketet från Ineras paketflöde. Ingenting behöver registreras per IG. Flödet är inte registrerat än, utan registreras en gång för hela Inera när den första riktiga IG:n publiceras.

### Kontroll innan första releasen

- [ ] `id` är samma i `sushi-config.yaml` och `ig.ini`, och har tre delar
- [ ] `canonical` är `https://fhir.inera.se/ig/<namn>`
- [ ] `<namn>` är inte redan använt på `https://fhir.inera.se/ig/`
- [ ] Repot har ingen `package-list.json`
- [ ] Bygget på `main` är grönt och syns på `https://inera-ab.github.io/<repo>/`
- [ ] `FHIR_PORTAL_TOKEN` finns och har inte gått ut
- [ ] En testpublicering har gått igenom (se nedan)

---

## Inför varje release

### Vad som måste ändras

| Var | Vad | Vem |
|---|---|---|
| `sushi-config.yaml` | `version: X.Y.Z` | För hand |
| `input/pagecontent/version-history.md` | Ny post `### [X.Y.Z] — ÅÅÅÅ-MM-DD` med ändringarna i `####`-avsnitt | För hand |
| `publication-request.json` | `desc` för den här releasen, och `mode` | För hand |
| `sushi-config.yaml`, `dependencies` | Låsta till publicerade versioner, aldrig `current` | För hand |
| Profiler som ändrats | `* ^version` enligt konventionen för semver | För hand |
| Git-tagg | `X.Y.Z` på release-commiten, utan `v` | För hand |
| Versionshistorik, flöden, IG-register | — | IG Publisher, via `release.yml` |

### Steg för steg

1. **Välj version** enligt semver-konventionen. `fix` ger patch, `feat` ger minor och en brytande ändring ger major.
2. **Räkna upp versionen** i en PR på branchen som ska releasas (`main`, eller `support/<M>.x` för en patch): `version` i `sushi-config.yaml` och en post i `version-history.md`. Avsnittet *Inför release* i PR-mallen är checklistan.
3. **Uppdatera `publication-request.json`** i samma PR: en ny `desc` och rätt `mode` (`milestone`, eller `working` för en release candidate eller en patch på en äldre major).
4. **Kontrollera** att CI och IG Publisher QA är gröna på release-commiten.
5. **Testpublicera (rekommenderas):** Actions → *Publish release* → *Run workflow* på branchen. Resultatet hamnar i [inera-ab/fhir-portal-test](https://github.com/Inera-AB/fhir-portal-test) och kan granskas på `https://inera-ab.github.io/fhir-portal-test/ig/<namn>/`. Länkarna där pekar på fhir.inera.se, eftersom canonical är densamma.
6. **Tagga och pusha.** Taggen ska vara exakt versionen i `sushi-config.yaml`:
   ```
   git fetch origin
   git tag -a X.Y.Z -m "X.Y.Z" origin/main
   git push origin X.Y.Z
   ```
7. **Följ körningen** under Actions → *Publish release*.
8. **Verifiera:**
   - [ ] `https://fhir.inera.se/ig/<namn>/X.Y.Z/` visar IG:n med bannern *"(vX.Y.Z: Release) … current published version"*
   - [ ] `https://fhir.inera.se/ig/<namn>/history.html` listar versionen
   - [ ] En tidigare version har bannern *"The current version which supersedes this version is X.Y.Z"*
   - [ ] Katalogen på `https://fhir.inera.se/ig/` visar den nya versionen
9. **Skicka PR till FHIR/ig-registry** med ändringen från artefakten `fhir-ig-list.diff`.

### Om något går fel

| Symtom | Orsak | Åtgärd |
|---|---|---|
| *Tag X does not match version Y in sushi-config.yaml* | Versionen räknades inte upp före taggningen | Ta bort taggen (`git push origin :refs/tags/X`), rätta versionen och tagga igen |
| *publication-request.json has no desc* eller *desc … is the same as for an earlier version* | Beskrivningen saknas eller är kvar från förra releasen | Skriv en ny `desc` och tagga igen |
| *X is already published* | Versionen finns redan i webbroten | Publicera aldrig om en version. Gör en ny patchversion |
| *Bad credentials*, *403* eller *Permission denied* vid push | `FHIR_PORTAL_TOKEN` har gått ut eller saknar åtkomst | Skapa en ny token, uppdatera hemligheten och kör om |
| Publishern stoppar med *depends on … current* | Ett beroende pekar på `current` | Lås beroendet till en publicerad version |
| Publishern stoppar med *Increase in Errors/Warnings/Hints* | Publiceringsbygget gav fler fel än det första bygget, oftast på grund av terminologiservern | Kör om. Kvarstår felet, rätta det i IG:n |
| Körningen misslyckades före steget *Push web root* | — | Ingenting har ändrats i webbroten. Rätta och kör om |
| Taggen finns men ingen release startade | Taggen skapades av en GitHub Action, och sådana taggar startar inga workflows | Kör *Publish release* manuellt på taggen: *Use workflow from* → *Tags* → `X.Y.Z`. En körning på en tagg publicerar till fhir.inera.se, en körning på en branch till testwebbroten |

---

## Kända begränsningar

- **Bannern och historiksidan är på engelska.** Texten skrivs av IG Publisher och följer inte IG:ns språk.
- **Ingen content negotiation.** fhir.inera.se ligger på GitHub Pages. En resurs canonical-adress skickar vidare till resursens HTML-sida, men ett anrop med `Accept: application/fhir+json` får inte JSON. Maskiner hämtar JSON-filen direkt eller använder paketet.
- **Storleken.** GitHub Pages tillåter högst 1 GB för hela fhir.inera.se. Varje release tar ungefär dubbla IG-storleken, eftersom den senaste versionen även kopieras till IG:ns rot.
- **`technical-correction`** kräver mallen `tech-correction.template.html` i webbrotens `templates/`. Den är inte uppsatt än.
- **"source id Unknown (todo)"** i flödena är en funktion som inte är färdig i IG Publisher.
