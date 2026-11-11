# Region Stockholm FHIR Implementation Guide Template

[![Build IG preview](https://github.com/regionstockholm/Region-Stockholm-FHIR-IG-Template/actions/workflows/publish.yml/badge.svg)](https://github.com/regionstockholm/Region-Stockholm-FHIR-IG-Template/actions/workflows/publish.yml)
[![Validate FSH](https://github.com/regionstockholm/Region-Stockholm-FHIR-IG-Template/actions/workflows/validate.yml/badge.svg)](https://github.com/regionstockholm/Region-Stockholm-FHIR-IG-Template/actions/workflows/validate.yml)
[![FHIR R4](https://img.shields.io/badge/FHIR-R4-blue)](https://hl7.org/fhir/R4/)
[![License: CC0-1.0](https://img.shields.io/badge/License-CC0_1.0-lightgrey.svg)](https://creativecommons.org/publicdomain/zero/1.0/)

This repository is a GitHub template for Region Stockholm FHIR Implementation Guides (IGs). It includes FHIR Shorthand (FSH) examples, narrative pages, Region Stockholm styling, and workflows for validation and previews.

## Publishing status

**Official release publishing is not yet configured.** A version tag builds the IG and uploads the result as a GitHub Actions artifact; it does not publish to Region Stockholm, Inera, a FHIR package registry, or GitHub Releases. An ordinary build artifact is not an IG Publisher `-go-publish` release and does not create published version history, release banners, feeds or an IG catalog entry.

| Event | Workflow | Result |
|---|---|---|
| Push to `main`, `develop`, `feature/**`, `support/**`, or manual run | `publish.yml` | CI preview on the IG repository's own GitHub Pages; not an official release |
| Pull request | `pr-qa.yml` and `validate.yml` | IG Publisher QA comment and FSH validation |
| Version tag, e.g. `1.2.0` or `1.2.0-rc1` | `release.yml` | Version check and build artifact `ig-build-<tag>`, retained for 30 days |
| Branch deletion | `cleanup.yml` | Removes the branch preview from the IG repository's `gh-pages` |

Download a tag build under **Actions → Build release artifact → the run → Artifacts**. It contains the generated `output/` directory, including the package and QA report. A successful build or tag is not proof of an official publication. Check the workflow run for errors.

The intended destination for future releases is [regionstockholm/pub](https://github.com/regionstockholm/pub), under `docs/fhir/implementationguide/`, served by GitHub Pages. Its publication configuration, permanent canonical URL convention, test environment, catalog, access model and integration are not yet established by this template. Coordinate any pilot with that repository's owner; do not treat manually copied build files as a complete versioned publication. The existing canonical in this template is provisional and must be confirmed against Region Stockholm's URI framework before first publication.

The reusable validation, preview and QA workflows and the build-tool setup action come from [Inera-AB/fhir-ig-workflows](https://github.com/Inera-AB/fhir-ig-workflows) at `@v1`. The preview caller does **not** forward `FHIR_PORTAL_TOKEN` or other secrets, so its optional Inera catalog update is skipped. `release.yml` does not call Inera's publishing workflow. Branch previews still require the repository's `GITHUB_TOKEN` to write its own `gh-pages` branch.

## Creating a new IG

1. Select **Use this template → Create a new repository** in the appropriate Region Stockholm organization.
2. Set `id`, `name`, `title`, `description`, `version`, `status`, `fhirVersion` and `publisher` in `sushi-config.yaml`. Choose a stable `canonical` in consultation with the URI/publication owners; the template's value is only an example until the publication convention is decided.
3. Set `ig` in `ig.ini` to `fsh-generated/resources/ImplementationGuide-<id>.json`, using the same `id`.
4. Replace the template metadata in `publication-request.json` and the examples in `input/fsh/` and `input/pagecontent/`. That JSON is preparation for a future publication workflow; the current tag build neither validates it nor submits it.
5. Clear the template's historical entries in `input/pagecontent/version-history.md` when starting a new guide. Add a profile-specific `* ^version` only if a profile is versioned independently of the IG.
6. For branch previews, enable Actions write permissions and configure **Settings → Pages → Deploy from a branch → `gh-pages` / `(root)`** after the first build creates the branch. Create a `develop` branch if following the branch model below. No portal token is needed for the current workflows.

## Daily workflow

Create a feature branch from `develop`, make changes and open a pull request against `develop`. SUSHI validates FSH, while `pr-qa.yml` builds the IG and posts a QA summary. Branch builds are previews, normally available at `https://<owner>.github.io/<repo>/` for `main` and `https://<owner>.github.io/<repo>/branches/<branch-slug>/` for other branches. A deleted branch's preview is removed by `cleanup.yml`. The URLs depend on the repository's Pages configuration.

Commit messages following [Conventional Commits](https://www.conventionalcommits.org/) help explain changes and choose a version. Set the version and maintain the changelog manually; no workflow creates a version or tag automatically.

## Build a tagged version

1. In a pull request, update `version` in `sushi-config.yaml` and the change log in `input/pagecontent/version-history.md`. Review dependencies and update any independently versioned profiles.
2. Merge the changes. Create a tag **without `v`** that exactly matches the version, for example:

   ```bash
   git fetch origin
   git tag -a 1.2.0 -m "1.2.0" origin/main
   git push origin 1.2.0
   ```

3. Open **Actions → Build release artifact** and download `ig-build-1.2.0` from the successful run. The workflow checks the tag and builds with the R4 terminology server; it does not publish the build or validate `publication-request.json`.

For versioning and migration guidance, see:

- [Versionshantering, brancher och releaser](docs/versionshantering-och-release.md)
- [Förbereda en IG och bygga en version](docs/forbereda-och-releasa-ig.md)
- [Flytta en befintlig IG](docs/flytta-befintlig-ig.md)

## Local development

Prerequisites: Git, Node.js 20 or later, Java 17 or later, Ruby and Jekyll.

```bash
git clone https://github.com/<owner>/<repo>.git
cd <repo>
npm install -g fsh-sushi
gem install jekyll
mkdir -p input-cache
curl -fsSL https://github.com/HL7/fhir-ig-publisher/releases/latest/download/publisher.jar -o input-cache/publisher.jar

sushi .
java -jar input-cache/publisher.jar -ig ig.ini
```

Open `output/index.html` in a browser. The first build downloads FHIR packages into `~/.fhir/packages/`. Generated folders such as `output/`, `input-cache/` and `fsh-generated/` are ignored by Git.

The tag build uses `https://tx.fhir.org/r4`. For an R5 guide, configure an R5 terminology server in the preview and QA reusable workflow inputs **and** change the server in `release.yml`. Without a terminology server, QA may report errors for R5 core value sets.

## Design and structure

The menu separates introduction, functional and implementation guidance. IG Publisher generates the artifacts page rather than duplicating its listings in narrative pages. Detailed information models should be maintained in their authoritative external specifications and linked from the IG.

Region Stockholm branding is in `input/includes/fragment-css.html`, `input/includes/fragment-header.html` and `input/images/`. The favicon is a placeholder and should be replaced with an official one where appropriate.

```text
.github/workflows/       Validation, PR QA, previews, tag build and preview cleanup
docs/                    Swedish versioning and publication guidance
publication-request.json Metadata for a future publication workflow
sushi-config.yaml        IG identity, dependencies, pages and menu
ig.ini                   IG Publisher configuration
input/fsh/               FSH profiles, aliases and examples
input/pagecontent/       Narrative IG pages
input/includes/          Header, CSS and menu overrides
input/images/            Styles, logos and diagrams
```

Region Stockholm maintains this template. Consult [Region Stockholm on FHIR](https://vardgivarguiden.se/it-stod/informatik/region-stockholm-on-fhir/) and the applicable URI framework for local guidance.
