# Versionshantering, brancher och releaser

Den här instruktionen beskriver hur Ineras FHIR Implementation Guides versionshanteras, vilka brancher som används och hur en release publiceras. Den gäller IG:er skapade från [IneraFHIRTemplate](https://github.com/Inera-AB/IneraFHIRTemplate).

Se även:

- [Förbereda en IG för publicering och göra en release](forbereda-och-releasa-ig.md): förberedelser inför första publiceringen och checklista för varje release
- [Flytta en befintlig IG till publiceringsläget](flytta-befintlig-ig.md): för IG:er som publicerades med det tidigare upplägget

---

## FHIR har tre versionsdimensioner

| Dimension | Vad den styr | Hanteras av |
|---|---|---|
| FHIR-basversion (R4, R5) | Vilket paketekosystem IG:n lever i | Eget repo per basversion |
| IG-version (major.minor.patch) | Mognad och förändringarnas art | `version` i `sushi-config.yaml` och git-taggen |
| Profilversion (major.minor.patch) | En enskild profils mognad | `* ^version` i profilens FSH-definition |

Dimensionerna är oberoende. En patchrelease på IG-nivå (1.2.1) kan tekniskt innehålla en ny majorversion av en enskild profil. Här tillämpas konventionen för semver för tjänstekontrakt.

En profil utan egen `* ^version` får IG:ns version. Om profilerna ska versionshanteras separat måste varje profil ha en egen `^version`.

---

## Repostruktur och FHIR-versioner

En IG per FHIR-basversion, inte brancher. R4 och R5 ger skilda npm-paket med olika beroendegrafer. Om en migrering till R5 inleds öppnas ett nytt repo:

```
ig-formular-r4/    ← aktivt
ig-formular-r5/    ← nytt repo vid R5-migrering
```

Versionsnumreringen börjar om från 1.0.0 i det nya repot, och de två repona lever sedan oberoende av varandra.

Det nya repot behöver ett eget paket-id och en egen canonical. Tredje delen av paket-id:t blir IG:ns katalog på fhir.inera.se och måste vara unik, till exempel `inera.blankett.formular-r5` → `https://fhir.inera.se/ig/formular-r5`. Workflowsen använder terminologiservern för R4 (`tx.fhir.org/r4`) som standard, och QA-bygget på pull requests ingen terminologiserver alls. Ett R5-repo sätter `tx-server: https://tx.fhir.org/r5` med `with:` i anropen i `publish.yml`, `release.yml` och `pr-qa.yml`. Utan terminologiserver rapporterar QA-bygget falska fel på R5:s kärnvärdemängder.

---

## Brancher och deras syfte

```
main          ← senaste stabila release
develop       ← integrationsbranch, pågående arbete mot nästa minor/major
feature/*     ← kortlivad, skapas från develop, mergas tillbaka till develop
support/<M>.x ← underhåll av äldre major, lever tills versionen är EOL
```

Regler:

- `main` uppdateras bara genom merge från `develop` (ny minor/major) eller direkt patch-commit för kritiska redaktionella fel.
- Varje commit på `main` som representerar en release ska ha en versionstagg.
- Taggar sätts enbart på `main` eller `support/<M>.x`, aldrig på `develop` eller `feature/*`.
- `feature/*`-brancher tas bort efter merge. Namngivning: latinska tecken och bindestreck, inga mellanslag.

---

## Vad CI gör

Workflowsen i IG-repot är korta anrop till de delade workflowsen i [Inera-AB/fhir-ig-workflows](https://github.com/Inera-AB/fhir-ig-workflows). En rättning där når alla IG:er som anropar samma huvudversion (`@v1`).

Branchbyggen hamnar bara på IG-repots egna GitHub Pages. Bara en releasetagg publicerar till fhir.inera.se.

| Händelse | Workflow | Publiceras till |
|---|---|---|
| Push till `main` | `publish.yml` | `https://inera-ab.github.io/<repo>/` |
| Push till `develop` | `publish.yml` | `https://inera-ab.github.io/<repo>/branches/develop/` |
| Push till `feature/abc` | `publish.yml` | `https://inera-ab.github.io/<repo>/branches/feature-abc/` |
| Push till `support/<M>.x` | `publish.yml` | `https://inera-ab.github.io/<repo>/branches/support-<M>-x/` |
| Pull request | `pr-qa.yml` | Ingenting. QA-sammanfattningen postas som kommentar på PR:en |
| Releasetagg, t.ex. `1.2.0` | `release.yml` | `https://fhir.inera.se/ig/<namn>/1.2.0/` |
| Manuell körning av *Publish release* på en branch | `release.yml` | Testwebbroten `https://inera-ab.github.io/fhir-portal-test/ig/<namn>/` ([inera-ab/fhir-portal-test](https://github.com/Inera-AB/fhir-portal-test)) |

I branchnamnet byts tecken som inte är bokstäver eller siffror, till exempel `/` och `.`, mot `-`. När en branch tas bort rensas dess katalog automatiskt (`cleanup.yml`).

En release publiceras med IG Publishers officiella publiceringsläge till den gemensamma webbroten på fhir.inera.se. `<namn>` är tredje delen av paket-id:t: `inera.core.template` publiceras till `https://fhir.inera.se/ig/template/`.

En milestone-release kopieras dessutom till IG:ns rot, `https://fhir.inera.se/ig/<namn>/`, som alltid visar den senaste milestone-releasen. Versionshistoriken finns på `https://fhir.inera.se/ig/<namn>/history.html`.

En publicerad version ändras aldrig och publiceras aldrig om. Publishern uppdaterar bara bannern i tidigare versioner, så att de hänvisar till den nya versionen.

---

## Versionsformat

| Fas | Tagg | `mode` i `publication-request.json` | Exempel |
|---|---|---|---|
| Arbete på `develop` | ingen tagg (ci-build) | — | — |
| Release candidate | `x.y.z-rcN` | `working` | `2.0.0-rc1` |
| Stabil release | `x.y.z` | `milestone` | `2.0.0` |
| Patch på support-branch | `x.y.z` | `working` | `1.3.1` |

Taggar skrivs **utan `v`**. Taggen måste vara identisk med `version` i `sushi-config.yaml`, annars avbryter CI.

`working` publicerar versionen utan att ersätta IG:ns rot. Det används för en release candidate och för en patch på en äldre major. Annars skulle `https://fhir.inera.se/ig/<namn>/` visa den äldre versionen.

---

## Release-flödet steg för steg

Checklista, testpublicering och felsökning finns i [Förbereda en IG för publicering och göra en release](forbereda-och-releasa-ig.md#inför-varje-release).

### Ny minor- eller major-release

1. **Merga `develop` till `main`** via en PR.
2. **Räkna upp versionen** i en PR mot `main`. Avsnittet *Inför release* i PR-mallen är checklistan:
    - `version` i `sushi-config.yaml`
    - en ny post `### [X.Y.Z] — ÅÅÅÅ-MM-DD` med `####`-avsnitt i `input/pagecontent/version-history.md`
    - `* ^version` på profiler som ändrats, enligt semver-konventionen
    - beroenden i `sushi-config.yaml` låsta till publicerade versioner, aldrig `current`
3. **Uppdatera `publication-request.json`** i samma PR: en ny `desc` som skiljer sig från tidigare releaser och `"mode": "milestone"`. Efter första releasen ska `"first"` vara `false`.
4. **Merga** när CI och IG Publisher QA är gröna.
5. **Testpublicera** (rekommenderas): Actions → *Publish release* → *Run workflow* på `main`. Granska resultatet på `https://inera-ab.github.io/fhir-portal-test/ig/<namn>/`.
6. **Tagga och pusha.** Taggen ska vara exakt versionen, utan `v`:

   ```bash
   git fetch origin
   git tag -a 2.1.0 -m "2.1.0" origin/main
   git push origin 2.1.0
   ```

7. **Följ körningen** under Actions → *Publish release*. Den publicerar, uppdaterar versionshistoriken och IG-katalogen och sparar ändringen för FHIR:s IG-register som artefakt.

### Release candidate

Som ovan, men med taggen `X.Y.Z-rcN` och `"mode": "working"`. Versionen publiceras under `https://fhir.inera.se/ig/<namn>/X.Y.Z-rcN/` utan att ersätta IG:ns rot.

### Patch på äldre version (support-branch)

```bash
git checkout support/1.x
# Gör rättningen direkt eller via en feature-branch från support/1.x.
# Räkna upp version i sushi-config.yaml och sätt "mode": "working"
# och en ny desc i publication-request.json.
git tag -a 1.3.1 -m "1.3.1"
git push origin 1.3.1
```

Rättningen mergas inte upp till `develop` eller `main`.

### Kontrollera efter publiceringen

- [ ] `https://fhir.inera.se/ig/<namn>/X.Y.Z/` visar IG:n med bannern *"(vX.Y.Z: Release) … current published version"*
- [ ] `https://fhir.inera.se/ig/<namn>/history.html` listar versionen
- [ ] En tidigare version har bannern *"The current version which supersedes this version is X.Y.Z"*
- [ ] Katalogen på `https://fhir.inera.se/ig/` visar den nya versionen

---

## Registrering

Bara FHIR:s IG-register kräver ett manuellt steg per release. Resten sköts av publiceringen eller görs en gång för hela Inera.

| Var | Vad som händer | Vem |
|---|---|---|
| IG-katalogen på `https://fhir.inera.se/ig/` | En milestone-release blir IG:ns senaste version i katalogen. En release med `working` blir det inte | `release.yml`, automatiskt |
| Versionshistoriken (`package-list.json`, `history.html`) | Ligger i webbroten på fhir.inera.se, inte i IG-repot. Redigeras aldrig för hand | IG Publisher, automatiskt |
| [FHIR/ig-registry](https://github.com/FHIR/ig-registry), `fhir-ig-list.json` | IG:n läggs till vid första releasen, och varje ny release som en utgåva. `release.yml` sparar ändringen som artefakten `fhir-ig-list.diff` | För hand: en PR till FHIR/ig-registry per release |
| packages.fhir.org | Hämtar alla paket i Ineras paketflöde `https://fhir.inera.se/ig/package-feed.xml`. Inget registreras per IG | Flödet registreras en gång i `package-feeds.json` i FHIR/ig-registry |

Paketflödet är inte registrerat än. Det registreras när den första riktiga IG:n publiceras.

Mallen publiceras på fhir.inera.se som exempel, men hålls utanför paketflödet med `package-feed: false` i sin `release.yml`. Därför ska en ny IG ta bort de raderna (se [förberedelserna](forbereda-och-releasa-ig.md#förberedelser-inför-första-publiceringen)).
