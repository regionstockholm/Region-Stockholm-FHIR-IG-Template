# Förbereda en IG för publicering och göra en release

Branch- och releasepublicering är ännu inte konfigurerade. `.github/workflows/publish.yml` och `.github/workflows/release.yml` innehåller de tidigare anropen som kommenterade exempel samt tillfälliga jobb som ger ett tydligt fel. En push, tagg eller manuell körning som utlöser dem publicerar ingenting.

## Förbered IG:n

1. Välj ett unikt paket-id och en långsiktigt förvaltad canonical URL i `sushi-config.yaml`. Samma id ska finnas i `ig.ini`. Kontrollera att canonical-adressen kan hanteras av den valda publiceringsmiljön innan första publiceringen.
2. Anpassa `publication-request.json` med IG:ns titel, beskrivning, CI-adress och registeruppgifter. Sätt `first` till `true` vid en ny IG:s första publicering. Bekräfta att kategori och registeruppgifter är giltiga för den valda publiceringslösningen.
3. Ersätt mallens profiler och exempelsidor, ange förvaltning och kontaktvägar samt uppdatera paketlänken och motsvarande rad i `input/ignoreWarnings.txt`.
4. Granska QA-resultatet och säkerställ att externa FHIR-paket är låsta till publicerade versioner. För en annan FHIR-version än R4 ska även terminologiserver och beroenden ses över.

## 1. Sätt upp ett regionalt workflow-repository

De tidigare anropen använder [Inera-AB/fhir-ig-workflows](https://github.com/Inera-AB/fhir-ig-workflows), ett separat repository som ägs av Inera. Använd det som förlaga för ett motsvarande repository som Region Stockholm äger och förvaltar. Säkerställ tillgång till både `.github/workflows/` och `actions/`: de delade workflowen använder egna actions för bland annat verktygsinstallation, QA och publiceringsfiler.

1. Skapa eller välj ett regionalt repository för de delade workflowen och actions. Överför och granska innehållet, inklusive beroenden och uppdateringsrutiner.
2. Ändra interna `uses:`-referenser som fortfarande pekar på ursprungsrepositoryt, till exempel `actions/setup-ig-tools`, `actions/qa-comment`, `actions/history-assets` och `actions/package-feed-exclude`, så att de pekar på regionens repository. Kontrollera även övriga externa actions och behörigheter.
3. Granska förvalda repositoryn, URL:er och hemligheter i workflowen. `build.yml` har ett förvalt katalogrepository och `release.yml` har förvalda webbroot-repositoryn som tillhör Inera. Byt dessa till regionens konfiguration eller kräv uttryckliga regionala värden; ärv inte produktionshemligheter i onödan.
4. Publicera en stabil referens, exempelvis en tagg, och säkerställ att de IG-repositoryn som ska använda workflowen har åtkomst och att organisationens Actions-policy tillåter dem.

## 2. Förbered regionala publiceringsmål

Ansvarig förvaltning behöver bestämma produktions- och testmiljö, webbadresser, åtkomst, paketdistribution och eventuell registrering i FHIR:s register. Mallens canonical är inte i sig bevis för att en webbrot eller ett paketflöde finns.

För release med IG Publishers publiceringsläge behövs en kompatibel regional webbrot med layoutregler och gemensamma publiceringsfiler. Kontrollera att paket-id och canonical matchar layouten, att historik och eventuella paketflöden hanteras och att test- och produktionsmiljö är separerade. Besluta om `package-feed` och eventuell registrering på packages.fhir.org. Upprätta de hemligheter som det regionala workflowet kräver med minsta nödvändiga behörighet till rätt regionala repositoryn.

För branchbyggen behöver IG-repositoryts Actions ha skrivbehörighet till innehållet. När det regionala byggworkflowet har skapat branchen `gh-pages`, aktivera GitHub Pages under **Settings → Pages**, med `gh-pages` / `(root)` som källa. Om en regional IG-katalog ska uppdateras måste även dess repository och åtkomst konfigureras; annars ska kataloguppdateringen vara avstängd.

## 3. Aktivera anropen i IG-repositoryt

1. I `.github/workflows/publish.yml`, ersätt det tillfälliga feljobbet med det kommenterade `build`-anropet. Ändra `uses:` så att det pekar på regionens repository och godkända referens. Anpassa exempelvis `catalog-repo` och hemligheter enligt det regionala workflowets gränssnitt.
2. I `.github/workflows/release.yml`, ersätt på samma sätt feljobbet med det kommenterade `release`-anropet. Ändra `uses:` till regionens repository och ange de regionala indata som krävs, exempelvis `web-repo`, `test-web-repo` och vid behov `web-branch` och `web-dir`. Raden `package-feed: false` är ett exempel för en mall; besluta separat vad som gäller för varje IG. Ersätt `secrets: inherit` med uttrycklig överföring av nödvändiga hemligheter när gränssnittet tillåter det.
3. Ändra även anropen i `validate.yml`, `pr-qa.yml` och `cleanup.yml` till regionens motsvarande workflows. De använder tills dess fortfarande ursprungsrepositoryt.
4. Testa validering och QA i en pull request, branchbygge och GitHub Pages samt en manuell testpublicering till den regionala testmiljön. Kontrollera loggar, genererad IG och publiceringsmål innan release tillåts. Dokumentera de fastställda regionala adresserna, inställningarna och kontrollstegen.

## När releaseflödet finns

1. Uppdatera version, versionshistorik och `publication-request.json`. `mode: milestone` kan användas för en aktuell release och `working` för en version som inte ska ersätta den aktuella. `desc` ska beskriva just den releasen.
2. Kör en testpublicering till den regionala testmiljön och granska resultatet.
3. Efter godkännande, skapa och pusha en tagg som motsvarar versionen, exempelvis:

   ```bash
   git tag -a 1.2.0 -m "1.2.0"
   git push origin 1.2.0
   ```

4. Kontrollera release, paket, versionshistorik och eventuella register enligt den regionala lösningen. Publicera aldrig om samma version; använd en ny version för rättelser.
