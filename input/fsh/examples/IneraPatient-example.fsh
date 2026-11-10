// No need to set `meta.profile` manually: SUSHI populates it automatically from `InstanceOf`
// (here, the canonical URL of IneraPatient), which is what declares conformance to the profile.
Instance: IneraPatientExample
InstanceOf: IneraPatient
Title: "Inera Patient Example"
Description: "A minimal example of a patient conforming to the IneraPatient profile."
Usage: #example

* identifier[personnummer].system = "http://electronichealth.se/identifier/personnummer"
* identifier[personnummer].value = "195001011234"

* name.use = #official
* name.family = "Andersson"
* name.given[0] = "Anna"

* gender = #female

* birthDate = "1950-01-01"

* address.use = #home
* address.line[0] = "Testgatan 1"
* address.postalCode = "11122"
* address.city = "Stockholm"
* address.country = "SE"
