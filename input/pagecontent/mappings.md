Denna sida dokumenterar vilka delar av informationsunderlaget (se [Informationsunderlag](information-basis.html)) som denna IG realiserar, eventuella avvikelser i FHIR-realiseringen, samt hur enskilda element mappas till element i motsvarande FHIR-profiler.

---

### Omfattade delar

*Ange vilka kapitel, processer eller entiteter i informationsspecifikationen som denna IG realiserar i FHIR.*

---

### Avvikelser och tillägg

*Beskriv eventuella avvikelser från eller tillägg till informationsspecifikationen i FHIR-realiseringen, och motivera varför.*

---

### Syfte med mappningarna

*Förklara rollen för dessa mappningar. Exempel: "Mappningarna nedan spårar varje element i informationsmodellen till det FHIR-profilelement som bär den informationen. Detta gör det möjligt att verifiera täckning och vägleder implementatörer som behöver förstå sambandet mellan verksamhetskrav och deras tekniska representation."*

---

### Mappningstabeller

*Tillhandahåll en mappningstabell per informationsmodell/entitet. Varje rad ska visa ett modellelement, dess kardinalitet och motsvarande FHIR-profilsökväg. Om denna IG definierar egna logiska modeller i FSH (`input/fsh/logicalmodels/`), länka till respektive genererade StructureDefinition-sida.*

#### [Modellens namn] → [Profilnamn]

| Modellelement | Kard. | FHIR-profilelement | Noteringar |
|----------------|-------|--------------------|------------|
| *[Elementnamn]* | *1..1* | *[Profil.element](StructureDefinition-[Profil].html)* | *Noteringar om mappningen, t.ex. värdemängdsbegränsningar eller transformationsregler.* |
| *[Elementnamn]* | *0..\** | *[Profil.element](StructureDefinition-[Profil].html)* | |

---

### Omappade element

*Om element i informationsunderlaget inte täcks av ett profilelement, lista dem här och förklara varför (utanför scope, uppskjutet till framtida version, täcks av separat profil, etc.).*

| Modellelement | Orsak till att det inte mappas |
|----------------|-------------------------------|
| *[Elementnamn]* | *Förklaring.* |

---

> **Vägledning för författare:** Håll mappningarna uppdaterade i takt med att profilerna utvecklas. Mappningar kan också uttryckas med FHIR `ConceptMap`-resurser om maskinbearbetningsbar representation behövs.
