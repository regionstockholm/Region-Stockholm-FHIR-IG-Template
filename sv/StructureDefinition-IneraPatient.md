# Inera Patient - Inera FHIR Implementation Guide Template v2.3.0

## Resursprofil: Inera Patient 

**Användningar:**

* Exempel för denna Profil: [Patient/IneraPatientExample](Patient-IneraPatientExample.md)

Du kan också kontrollera [användningar i FHIR IG-statistiken](https://packages2.fhir.org/xig/inera.core.template|current/StructureDefinition/IneraPatient)

### Formella vyer av profilinnehåll

 [Beskrivningsdifferentialer, ögonblicksbilder och andra representationer](http://build.fhir.org/ig/FHIR/ig-guidance/readingIgs.html#structure-definitions). 

*  [Tabell med nyckelelement](#tabs-key) 
*  [Differentialtabell](#tabs-diff) 
*  [Ögonblicksbildstabell](#tabs-snap) 
*  [Statistik/referenser](#tabs-summ) 
*  [Alla](#tabs-all) 

#### Terminologibindningar

#### Begränsningar

Denna struktur är härledd från [Patient](http://hl7.org/fhir/R4/patient.html) 

#### Terminologibindningar

#### Begränsningar

Denna struktur är härledd från [Patient](http://hl7.org/fhir/R4/patient.html) 

 **Vy med nyckelelement** 

#### Terminologibindningar

#### Begränsningar

 **Differentialvy** 

Denna struktur är härledd från [Patient](http://hl7.org/fhir/R4/patient.html) 

 **ÖgonblicksbildsvyView** 

#### Terminologibindningar

#### Begränsningar

Denna struktur är härledd från [Patient](http://hl7.org/fhir/R4/patient.html) 

 

Andra representationer av profilen: [CSV](../StructureDefinition-IneraPatient.csv), [Excel](../StructureDefinition-IneraPatient.xlsx), [Schematron](../StructureDefinition-IneraPatient.sch) 



## Resource Content

```json
{
  "resourceType" : "StructureDefinition",
  "id" : "IneraPatient",
  "url" : "https://fhir.inera.se/ig/template/StructureDefinition/IneraPatient",
  "identifier" : [{
    "value" : "IneraPatient"
  }],
  "version" : "2.3.0",
  "name" : "IneraPatient",
  "title" : "Inera Patient",
  "status" : "draft",
  "date" : "2026-07-15",
  "publisher" : "Inera AB",
  "contact" : [{
    "name" : "Inera AB",
    "telecom" : [{
      "system" : "url",
      "value" : "https://www.inera.se"
    }]
  }],
  "description" : "A template patient profile demonstrating Inera's FHIR profiling conventions.\nAuthors should replace this description with the clinical purpose and scope of the profile.",
  "jurisdiction" : [{
    "coding" : [{
      "system" : "urn:iso:std:iso:3166",
      "code" : "SE",
      "display" : "Sweden"
    }]
  }],
  "fhirVersion" : "4.0.1",
  "mapping" : [{
    "identity" : "rim",
    "uri" : "http://hl7.org/v3",
    "name" : "RIM Mapping"
  },
  {
    "identity" : "cda",
    "uri" : "http://hl7.org/v3/cda",
    "name" : "CDA (R2)"
  },
  {
    "identity" : "w5",
    "uri" : "http://hl7.org/fhir/fivews",
    "name" : "FiveWs Pattern Mapping"
  },
  {
    "identity" : "v2",
    "uri" : "http://hl7.org/v2",
    "name" : "HL7 v2 Mapping"
  },
  {
    "identity" : "loinc",
    "uri" : "http://loinc.org",
    "name" : "LOINC code for the element"
  }],
  "kind" : "resource",
  "abstract" : false,
  "type" : "Patient",
  "baseDefinition" : "http://hl7.org/fhir/StructureDefinition/Patient",
  "derivation" : "constraint",
  "differential" : {
    "element" : [{
      "id" : "Patient",
      "path" : "Patient"
    },
    {
      "id" : "Patient.identifier",
      "path" : "Patient.identifier",
      "slicing" : {
        "discriminator" : [{
          "type" : "value",
          "path" : "system"
        }],
        "rules" : "open"
      },
      "short" : "Patient identifiers, including Swedish personnummer",
      "mustSupport" : true
    },
    {
      "id" : "Patient.identifier:personnummer",
      "path" : "Patient.identifier",
      "sliceName" : "personnummer",
      "min" : 0,
      "max" : "1",
      "mustSupport" : true
    },
    {
      "id" : "Patient.identifier:personnummer.system",
      "path" : "Patient.identifier.system",
      "min" : 1,
      "patternUri" : "http://electronichealth.se/identifier/personnummer"
    },
    {
      "id" : "Patient.identifier:personnummer.value",
      "path" : "Patient.identifier.value",
      "short" : "Swedish personal identity number (personnummer)",
      "min" : 1,
      "mustSupport" : true
    },
    {
      "id" : "Patient.name",
      "path" : "Patient.name",
      "short" : "Patient's name",
      "mustSupport" : true
    },
    {
      "id" : "Patient.name.family",
      "path" : "Patient.name.family",
      "mustSupport" : true
    },
    {
      "id" : "Patient.name.given",
      "path" : "Patient.name.given",
      "mustSupport" : true
    },
    {
      "id" : "Patient.gender",
      "path" : "Patient.gender",
      "mustSupport" : true
    },
    {
      "id" : "Patient.birthDate",
      "path" : "Patient.birthDate",
      "mustSupport" : true
    },
    {
      "id" : "Patient.address",
      "path" : "Patient.address",
      "mustSupport" : true
    },
    {
      "id" : "Patient.address.city",
      "path" : "Patient.address.city",
      "mustSupport" : true
    },
    {
      "id" : "Patient.address.postalCode",
      "path" : "Patient.address.postalCode",
      "mustSupport" : true
    },
    {
      "id" : "Patient.address.country",
      "path" : "Patient.address.country",
      "mustSupport" : true
    }]
  }
}

```
