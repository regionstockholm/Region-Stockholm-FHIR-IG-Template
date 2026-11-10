# Inera Patient Example - Inera FHIR Implementation Guide Template v2.3.0

## Exempel Patient: Inera Patient Example

Profil: [Inera Patient](StructureDefinition-IneraPatient.md)

Anna Andersson (official) Female, Födelsedatum: 1950-01-01 ( http://electronichealth.se/identifier/personnummer#195001011234)

-------

| | |
| :--- | :--- |
| Kontaktuppgift | Testgatan 1 Stockholm 11122 SE (home) |



## Resource Content

```json
{
  "resourceType" : "Patient",
  "id" : "IneraPatientExample",
  "meta" : {
    "profile" : ["https://fhir.inera.se/ig/template/StructureDefinition/IneraPatient"]
  },
  "identifier" : [{
    "system" : "http://electronichealth.se/identifier/personnummer",
    "value" : "195001011234"
  }],
  "name" : [{
    "use" : "official",
    "family" : "Andersson",
    "given" : ["Anna"]
  }],
  "gender" : "female",
  "birthDate" : "1950-01-01",
  "address" : [{
    "use" : "home",
    "line" : ["Testgatan 1"],
    "city" : "Stockholm",
    "postalCode" : "11122",
    "country" : "SE"
  }]
}

```
