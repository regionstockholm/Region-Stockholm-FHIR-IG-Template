# Flytta en befintlig IG till publiceringsläget

Den här instruktionen gäller en IG som redan har releaser på fhir.inera.se från det tidigare upplägget, där CI skrev `package-list.json` och en egen `history.html`. Efter flytten publiceras releaser med IG Publishers officiella publiceringsläge och bygger vidare på den befintliga historiken. Publishern skriver då också om bannern i de gamla versionerna, från "Lokal utvecklingsbygge" till en hänvisning till den senaste versionen.

Mallen själv flyttades på det här sättet med version 2.3.0. Flytten övades först i testwebbroten [inera-ab/fhir-portal-test](https://github.com/Inera-AB/fhir-portal-test).

---

## 1. Uppdatera IG-repot från mallen

Ta över följande från [IneraFHIRTemplate](https://github.com/Inera-AB/IneraFHIRTemplate):

- Alla filer i `.github/workflows/`. De är korta anrop till de delade workflowsen i [Inera-AB/fhir-ig-workflows](https://github.com/Inera-AB/fhir-ig-workflows) och ersätter IG-repots egna kopior. En IG som behöver andra inställningar, till exempel terminologiservern för R5, sätter dem med `with:` i anropet. Ta bort `package-feed: false` i `release.yml`: den håller mallen utanför FHIR:s paketregister och ska inte följa med till IG:n.
- `publication-request.json`, ifylld för IG:n med `"first": false`.

Ta bort `.github/scripts/` om den finns, eftersom skripten nu ligger i fhir-ig-workflows. Ta också bort release-please (`.github/workflows/release-please.yml`, `release-please-config.json` och `.release-please-manifest.json`). Versionen räknas upp för hand.

Ta bort `package-list.json` ur IG-repot. Publishern vägrar publicera från en källmapp som har en.

Kontrollera att paket-id:t har exakt tre delar och att `canonical` är `https://fhir.inera.se/ig/<namn>`, där `<namn>` är tredje delen av paket-id:t och samma som IG:ns befintliga katalog på fhir.inera.se. Om de inte stämmer kan IG:n inte flyttas på det här sättet. Det kräver då `movedFrom` i `publication-request.json`, som inte beskrivs här.

Releasetaggar skrivs utan `v` från och med flytten. De gamla taggarna (`v1.0.0` …) ligger kvar.

---

## 2. Förbereda IG:ns katalog i webbroten

Ändringarna görs i `ig/<namn>/` på `gh-pages` i [inera-ab/fhir-portal](https://github.com/Inera-AB/fhir-portal), via en PR.

### `package-list.json` i publisherns format

CI skrev `package-list.json` i ett format som publishern inte läser rätt. Skriv om den:

- Posten för ci-build först, med `"version": "current"`, `"status": "ci-build"`, `"sequence": "ci-build"` och utan `current`.
- Därefter versionerna med **den nyaste först**. Publishern tar den första posten som senaste version.
- `fhirversion` som text (`"4.0.1"`), inte som lista.
- Ett `date` (`ÅÅÅÅ-MM-DD`) per version. CI skrev bara datumet i `desc`.
- `status` och `sequence` enligt vad versionerna faktiskt var. CI skrev alltid `draft` och `STU 1`. Mallen använder `release` och `Releases`.
- `"current": true` på den senaste milestone-versionen och inte på någon annan.
- En `desc` per version. Byt gärna "Release X" mot en mening om vad versionen innehöll.

Exempel för mallen:

```json
{
  "package-id": "inera.core.template",
  "title": "Inera FHIR Implementation Guide Template",
  "canonical": "https://fhir.inera.se/ig/template",
  "introduction": "Mall för Ineras FHIR Implementation Guides.",
  "category": "National Base",
  "list": [
    {
      "version": "current",
      "path": "https://inera-ab.github.io/IneraFHIRTemplate",
      "status": "ci-build",
      "sequence": "ci-build",
      "desc": "Continuous Integration Build (latest in version control) - Content subject to frequent changes"
    },
    {
      "version": "2.2.2",
      "path": "https://fhir.inera.se/ig/template/2.2.2",
      "status": "release",
      "sequence": "Releases",
      "fhirversion": "4.0.1",
      "date": "2026-10-15",
      "desc": "Release 2.2.2",
      "current": true
    },
    {
      "version": "2.2.0",
      "path": "https://fhir.inera.se/ig/template/2.2.0",
      "status": "release",
      "sequence": "Releases",
      "fhirversion": "4.0.1",
      "date": "2026-08-27",
      "desc": "Release 2.2.0"
    }
  ]
}
```

### Saknade versionsmappar

Varje version i `package-list.json` måste ha sin mapp i `ig/<namn>/`. Publishern läser alla versionsmappar för att skriva om bannern och stoppar om en saknas. Kopiera en saknad version från IG-repots egna GitHub Pages (`gh-pages`, mappen `<version>/`), eller ta bort versionen ur listan om den aldrig ska finnas.

För mallen saknades 1.0.1, som fanns i listan men aldrig hade kopierats till fhir-portal.

### Historiksidans filer

Publishern kopierar historikmallens stilar och skript bara vid en första publicering. `release.yml` kopierar dem därför före varje publicering, så det behövs inget manuellt steg.

---

## 3. Öva i testwebbroten

1. Kopiera `ig/<namn>/` från `gh-pages` i fhir-portal till `gh-pages` i fhir-portal-test, med samma normalisering som ovan.
2. Kör *Publish release* manuellt på branchen med flytten. En manuell körning på en branch publicerar alltid till testwebbroten.
3. Kontrollera på `https://inera-ab.github.io/fhir-portal-test/ig/<namn>/`:
   - [ ] `package-list.json` har den nya versionen först, som `current`
   - [ ] Bannern i varje gammal version säger *"The current version which supersedes this version is X.Y.Z"*
   - [ ] `history.html` visar alla versioner, med stil
   - [ ] IG:ns rot visar den nya versionen

---

## 4. Den skarpa flytten

1. Merga PR:en i fhir-portal med den förberedda katalogen.
2. Merga PR:en i IG-repot med de nya workflows och `publication-request.json`.
3. Tagga den nya versionen utan `v` och pusha taggen.
4. Verifiera enligt [checklistan för en release](forbereda-och-releasa-ig.md#steg-för-steg).
5. Skicka PR till FHIR/ig-registry med ändringen från artefakten `fhir-ig-list.diff`.

Den gamla `history.html` och `index.html` i IG:ns rot ersätts av publisherns vid den första milestone-releasen efter flytten.
