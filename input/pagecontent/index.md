### [Domännamn]

*Ange ett namn som ringar in det avgränsade område som denna IG realiserar, t.ex. "Genomic Data Repository".*

*Välj ett kort, stabilt och beskrivande namn som speglar informationsmängden eller API:ets syfte, snarare än projekt-, organisations- eller versionsnamn. Välj en långsiktigt förvaltad canonical URL under Region Stockholms domän och undvik versionsnummer i den. Versioner hanteras i FHIR-paketet och Implementation Guidens metadata. Använd samma namn konsekvent i paketnamn, repository, canonical URL och dokumentation.*

---

### Omfattning

*Definiera vad som ingår i denna IG och beskriv eventuella avgränsningar. Specificera vilka användningsfall, kliniska scenarier eller informationsutbyten som beskrivs. Om denna IG är avsedd att användas som en basprofil/gemensam profil för mer specialiserade guider, beskriv det här.*

---

### Syfte

*Beskriv målet med denna IG. Förklara vilket problem den löser och hur den passar in i det bredare e-hälsolandskapet. Hänvisa till nationella eller regionala program, standarder eller mandat som motiverat arbetet.*

---

### Målgrupp
*Ange målgrupper för IG:n, (speciellt viktigt om IG:n vänder sig till andra målgrupper än systemarkitekter och utvecklare, t ex levernatörer av vissa system, eller verksamhetsarkitektrer inom en viss verksamhet). Hänvisa gärna nya läsare till  [Inledning](introduction.html) och implementatörer till relevanta tekniska avsnitt, exempelvis [REST-interaktioner och sökparametrar](rest-interactions.html).*


---

### Terminologi

*Ange vilka kodsystem och värdemängder som används, vem som förvaltar dem och var de kan hämtas.*

---

### Beroenden

*Om denna IG har ett beroende till t ex SE-core, definierat av HL7 Sweden ska detta beskrivas här. Detta återspeglas även i de profiler som ärver från eller refererar till SECore-profiler.*

---

### Dokumentation

Mer information om FHIR inom Region Stockholm finns [här](https://vardgivarguiden.se/it-stod/informatik/region-stockholm-on-fhir/).

Information om hur denna IG förvaltas finns under [Om](about.html).

---

### Om mallens struktur

Menyn i denna IG är medvetet utformad efter samma mönster som europeiska specifikationer, t.ex. FHIR ePS (Hem / Inledning / Funktionellt / Implementering / Om / Artefakter), för att ge implementatörer en igenkännbar ingång oavsett vilken europeisk FHIR-IG de arbetar med.

Informationsmodellen för denna förmåga publiceras externt och fristående i en egen informationsspecifikation (se [Informationsunderlag](information-basis.html) under Funktionellt) snarare än i denna IG. Det håller informationsspecifikationen som den auktoritativa källan för begrepp och informationsstruktur, och undviker att IG:n och specifikationen glider isär över tid.
