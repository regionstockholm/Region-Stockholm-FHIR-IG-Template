## Vad ändras

<!-- Profiler, extensions, terminologi, exempel eller sidor. Länka till ärendet. -->

## Påverkan

- [ ] Bakåtkompatibel (patch eller minor)
- [ ] Bryter befintliga implementationer (major). Beskriv vad som bryts:

## Checklista

- [ ] `* ^version` uppdaterad på profiler som ändrats
- [ ] IG Publisher QA utan nya fel
- [ ] Nya varningar är rättade, eller motiverade i `input/ignoreWarnings.txt`

## Inför release

<!-- Bara i PR:en som räknar upp versionen. Ta annars bort avsnittet. -->

- [ ] `version` i `sushi-config.yaml`
- [ ] Post i `input/pagecontent/version-history.md`
- [ ] Ny `desc` och rätt `mode` i `publication-request.json`
- [ ] Beroenden låsta till publicerade versioner
