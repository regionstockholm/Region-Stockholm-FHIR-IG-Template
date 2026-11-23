# Förbereda en IG för publicering och göra en release

Branchbyggen kan publiceras till det egna repositoryts GitHub Pages. **Releasepublicering är däremot spärrad** i `.github/workflows/release.yml` tills Region Stockholms egna publiceringsmål och behörigheter har fastställts. En tagg eller manuell körning ger ett fel och publicerar ingenting.

## Förbered IG:n

1. Välj ett unikt paket-id och en långsiktigt förvaltad canonical URL i `sushi-config.yaml`. Samma id ska finnas i `ig.ini`. Kontrollera att canonical-adressen kan hanteras av den valda publiceringsmiljön innan första publiceringen.
2. Anpassa `publication-request.json` med IG:ns titel, beskrivning, CI-adress och registeruppgifter. Sätt `first` till `true` vid en ny IG:s första publicering. Bekräfta att kategori och registeruppgifter är giltiga för den valda publiceringslösningen.
3. Ersätt mallens profiler och exempelsidor, ange förvaltning och kontaktvägar samt uppdatera paketlänken och motsvarande rad i `input/ignoreWarnings.txt`.
4. Granska QA-resultatet och säkerställ att externa FHIR-paket är låsta till publicerade versioner. För en annan FHIR-version än R4 ska även terminologiserver och beroenden ses över.

## Konfigurera regional publicering

Ansvarig förvaltning behöver först bestämma produktions- och testmiljö, webbadresser, åtkomst, paketdistribution och eventuell registrering i FHIR:s register. Mallens canonical är inte i sig bevis för att en webbrot eller ett paketflöde finns.

Det återanvändbara [releaseworkflowet från Inera](https://github.com/Inera-AB/fhir-ig-workflows) har Ineras repositoryn som standardvärden. Om det ska användas måste en regional lösning för IG Publishers webbrot, layoutregler och övriga gemensamma filer finnas och testas. Kontrollera särskilt att paket-id och canonical matchar layouten. Ange uttryckligen `web-repo`, `test-web-repo`, och vid behov `web-branch` och `web-dir`; använd inte Ineras standardvärden. Konfigurera en hemlighet med minsta nödvändiga behörighet för de regionala repositoryna och förmedla den endast till det avsedda workflowet. Besluta separat om `package-feed` och eventuell registrering på packages.fhir.org.

Ersätt först därefter spärrjobbet i `release.yml` med ett godkänt regionalt releaseflöde. Dokumentera dess konkreta inställningar, begränsningar och kontrollsteg här. Aktivera inte releasepublicering genom att enbart ta bort spärren.

## När releaseflödet finns

1. Uppdatera version, versionshistorik och `publication-request.json`. `mode: milestone` kan användas för en aktuell release och `working` för en version som inte ska ersätta den aktuella. `desc` ska beskriva just den releasen.
2. Kör en testpublicering till den regionala testmiljön och granska resultatet.
3. Efter godkännande, skapa och pusha en tagg som motsvarar versionen, exempelvis:

   ```bash
   git tag -a 1.2.0 -m "1.2.0"
   git push origin 1.2.0
   ```

4. Kontrollera release, paket, versionshistorik och eventuella register enligt den regionala lösningen. Publicera aldrig om samma version; använd en ny version för rättelser.
