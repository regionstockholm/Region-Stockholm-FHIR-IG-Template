// Naming convention: [prefix][ResourceType] in PascalCase, per Inera's profiling guidance.
// Example: IneraPatient = prefix "Inera" + resource type "Patient".
Profile: IneraPatient
Parent: Patient
Id: IneraPatient
Title: "Inera Patient"
Description: """
A template patient profile demonstrating Inera's FHIR profiling conventions.
Authors should replace this description with the clinical purpose and scope of the profile.
"""

* ^status = #draft
* ^version = "0.1.0"
// Metadata identifier: kept the same as the profile name/id, per Inera's profiling guidance.
* ^identifier.value = "IneraPatient"
// Update on every material change to the profile.
* ^date = "2026-07-15"
* ^publisher = "Inera AB"
* ^contact.name = "Inera AB"
* ^contact.telecom.system = #url
* ^contact.telecom.value = "https://www.inera.se"
* ^jurisdiction = urn:iso:std:iso:3166#SE "Sweden"

// Identifier slice: Swedish personal identity number (personnummer)
// Open slicing chosen for forward compatibility - other producers may add further identifier
// slices later without breaking this profile. Consider closed slicing instead if this profile
// is meant to be a strict, fully specified endpoint rather than a base for further profiling.
* identifier MS
// Discriminator type "value" chosen over "profile": cheaper for validators to evaluate and
// specific enough to distinguish slices here. Prefer "value"/"pattern" discriminators over
// "profile" wherever possible.
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open
* identifier ^short = "Patient identifiers, including Swedish personnummer"

* identifier contains personnummer 0..1 MS
// Identifier.system is required (1..1) whenever the Identifier datatype is used, per Inera's
// profiling guidance, and fixed here to the canonical personnummer identifier system.
* identifier[personnummer].system 1..1
* identifier[personnummer].system = "http://electronichealth.se/identifier/personnummer"
* identifier[personnummer].value 1..1 MS
* identifier[personnummer].value ^short = "Swedish personal identity number (personnummer)"

// Name
* name MS
* name ^short = "Patient's name"
* name.family MS
* name.given MS

// Gender
// MustSupport (MS) here means: this IG requires producers to be able to populate, and
// consumers to be able to process, this element - FHIR's base spec does not define the exact
// meaning of MS beyond that; it is defined per IG. If you introduce your own coded elements,
// bind them to a ValueSet via `^binding.valueSet` rather than leaving them unbound.
* gender MS

// Birth date
* birthDate MS

// Address
* address MS
* address.postalCode MS
* address.city MS
* address.country MS
