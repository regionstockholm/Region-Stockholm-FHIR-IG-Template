# Hem - Inera FHIR Implementation Guide Template v2.3.0

## Hem

### [Domännamn]

**Ange ett namn som ringar in det avgränsade område som denna IG realiserar, t.ex. "Fasta kontakter" eller "Öppenvårdsemiss".**

**Välj ett kort, stabilt och beskrivande namn som speglar informationsmängden eller API:ets syfte, snarare än projekt-, organisations- eller versionsnamn. Domännamnet (canonical URL) ska ligga under en långsiktigt förvaltad Inera-domän, `https://fhir.inera.se/ig/<namn>`, och ska inte innehålla versionsnummer eftersom versioner hanteras i FHIR-paketet och Implementation Guidens metadata. Använd samma namn konsekvent i paketnamn, repository, canonical URL och dokumentation för att underlätta identifiering och återanvändning."**

-------

### Omfattning

**Definiera vad som ingår i denna IG och beskriv eventuella avgränsningar. Specificera vilka användningsfall, kliniska scenarier eller informationsutbyten som beskrivs. Om denna IG är avsedd att användas som en basprofil/gemensam profil för mer specialiserade guider, beskriv det här.**

-------

### Syfte

**Beskriv målet med denna IG. Förklara vilket problem den löser och hur den passar in i det bredare Inera- och e-hälsolandskapet. Hänvisa till nationella eller regionala program, standarder eller mandat som motiverat arbetet.**

-------

### Målgrupp

**Ange målgrupper för IG:n, (speciellt viktigt om IG:n vänder sig till andra målgrupper än systemarkitekter och utvecklare, t ex levernatörer av vissa system, eller verksamhetsarkitektrer inom en viss verksamhet). Hänvisa gärna nya läsare till [Inledning](introduction.md) och implementatörer till relevanta tekniska avsnitt, exempelvis [REST-interaktioner och sökparametrar](rest-interactions.md).**

-------

### Terminologi

På [Inera Terminologitjänst](https://www.inera.se/tjanster/alla-tjanster-a-o/terminologitjanst-for-nationell-e-halsa/) finns alla refererade kodsystem och värdemängder som utvecklats av Inera.

-------

### Beroenden

**Om denna IG har ett beroende till t ex SE-core, definierat av HL7 Sweden ska detta beskrivas här. Detta återspeglas även i de profiler som ärver från eller refererar till SECore-profiler.**

-------

### Dokumentation

Mer information om FHIR på Inera finns [här](https://fhir.inera.se/). FHIR på Inera är en del av RIVTA – referensarkitekturen för svensk hälso- och sjukvård.

Information om hur denna IG förvaltas finns under [Om](about.md).

-------

### Om mallens struktur

Menyn i denna IG är medvetet utformad efter samma mönster som europeiska specifikationer, t.ex. FHIR ePS (Hem / Inledning / Funktionellt / Implementering / Om / Artefakter), för att ge implementatörer en igenkännbar ingång oavsett vilken europeisk FHIR-IG de arbetar med.

Informationsmodellen för denna förmåga publiceras externt och fristående i en egen informationsspecifikation (se [Informationsunderlag](information-basis.md) under Funktionellt) snarare än i denna IG. Det håller informationsspecifikationen som den auktoritativa källan för begrepp och informationsstruktur, och undviker att IG:n och specifikationen glider isär över tid.

