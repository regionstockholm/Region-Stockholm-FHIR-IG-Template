*Lista de system eller mänskliga roller som deltar i användningsfallen (se [Användningsfall](use-cases.html)). Beskriv för varje roll dess verksamhetsansvar i sammanhanget för denna IG — vem som ansvarar för vad, inte hur anropen tekniskt går till.*

| Roll | Ansvar |
|------|--------|
| *[Rollens namn]* | *Beskriv rollen och ansvarsområdena för denna aktör.* |
| *[Rollens namn]* | *Beskriv rollen och ansvarsområdena för denna aktör.* |

*Ange för varje roll vad den förväntas kunna göra vid implementering av denna IG, t.ex. med HL7 FHIR:s terminologi för förmågor där det är lämpligt.*

| Roll | Förväntning |
|------|-------------|
| *[Rollens namn]* | *Ange förväntningen, t.ex. "SHALL kunna producera en [Resurs] som uppfyller [Profil]."* |
| *[Rollens namn]* | *Ange förväntningen, t.ex. "SHALL kunna konsumera och bearbeta en [Resurs] som uppfyller [Profil]."* |

Fr.o.m. FHIR R5 kan `CapabilityStatement` uttrycka denna typ av förväntningar formellt via elementet `obligations`. Om denna IG definierar formella CapabilityStatements, se [CapabilityStatement](capabilitystatement.html) under Implementering.

*Referera till eller återge kortfattat det arbetsflöde där dessa roller interagerar — vad som utlöser flödet, i vilken ordning rollerna agerar och vad resultatet blir. Se [Informationsunderlag](information-basis.html) för den fullständiga, auktoritativa beskrivningen.*

---

> **Vägledning för författare:** Referera till relevanta nationella föreskrifter eller RIVTA-tjänstekontrakt där det är tillämpligt.
