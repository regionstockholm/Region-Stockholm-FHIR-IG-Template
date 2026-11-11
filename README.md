# Region Stockholm FHIR Implementation Guide Template

[![Build and publish IG](https://github.com/regionstockholm/Region-Stockholm-FHIR-IG-Template/actions/workflows/publish.yml/badge.svg)](https://github.com/regionstockholm/Region-Stockholm-FHIR-IG-Template/actions/workflows/publish.yml)
[![Validate FSH](https://github.com/regionstockholm/Region-Stockholm-FHIR-IG-Template/actions/workflows/validate.yml/badge.svg)](https://github.com/regionstockholm/Region-Stockholm-FHIR-IG-Template/actions/workflows/validate.yml)
[![FHIR R4](https://img.shields.io/badge/FHIR-R4-blue)](https://hl7.org/fhir/R4/)
[![License: CC0-1.0](https://img.shields.io/badge/License-CC0_1.0-lightgrey.svg)](https://creativecommons.org/publicdomain/zero/1.0/)

This repository is a GitHub template for Region Stockholm Implementation Guides. It includes the standard IG structure, author guidance pages, an example FSH profile, and pre-configured GitHub Actions for validation and publishing.

---

## Design choices

Three deliberate choices shape how this template's narrative pages are organised:

- **Menu structure inspired by European specifications.** The top menu (Home / Inledning / Funktionellt / Implementering / Om / Artefakter — Home / Introduction / Functional / Implementation / About / Artifacts) mirrors the pattern used by specifications such as FHIR ePS, rather than the ad-hoc Background/Artifacts grouping used in earlier versions of this template. Funktionellt and Implementering are expandable dropdowns grouping several narrower topic pages; this gives implementers a familiar entry point across Inera and other European FHIR IGs, and separates background material (Inledning), business requirements (Funktionellt), and what implementers actually build against (Implementering) into distinct top-level sections.
- **Artifacts is a single, auto-generated page, not hand-maintained catalog pages.** Profiles, terminology (code systems/value sets) and examples are not given their own narrative pages — IG Publisher already lists them automatically on the generated `artifacts.html` page, so the "Artefakter" menu entry links straight there. Maintaining separate `profiles.md`/`terminology.md`/`examples.md` pages would just duplicate that listing and require manual upkeep as profiles change.
- **The information model is published externally, separate from the IG.** Concept models, information models and detailed business workflows are not restated in this template — they live in an authoritative, independently published information specification that the IG references (see `information-basis.md`'s "Informationsunderlag" page, under Funktionellt, and `mappings.md`). This avoids duplicate documentation that can drift out of sync between the information specification and the IG over time.

---

## Inera branding

The template uses region Stockholm's visual identity by default. All branding is isolated to four files:

| File | What it does |
|------|-------------|
| `input/includes/fragment-css.html` | Loads Region Stockholm CSS and favicon |
| `input/includes/fragment-header.html` | Region Stockholm logo in the header |
| `input/images/region-stockholm.css` | Region Stockholm colours, fonts and layout |
| `input/images/Region_Stockholm_*.svg`, `sll-logo.svg`, `favicon.svg` | Logos and favicon (placeholder, replace with the official one) |

Remove these files to revert to standard HL7 FHIR styling.

---

## How publishing works

Every Inera IG has three kinds of build:

| Build | Trigger | Published to |
|---|---|---|
| Branch build | Push to `main`, `develop`, `feature/**`, `support/**` (`publish.yml`) | The IG repo's own GitHub Pages: `https://inera-ab.github.io/<repo>/` (`main`), `…/branches/<branch>/` (other branches) |
| Release | Push of a release tag such as `1.2.0` (`release.yml`) | `https://fhir.inera.se/ig/<name>/<version>/`, with the latest milestone also at `https://fhir.inera.se/ig/<name>/` |
| Test publication | Manual run of `release.yml` on a branch | The test web root [inera-ab/fhir-portal-test](https://github.com/Inera-AB/fhir-portal-test), never fhir.inera.se |

Releases use IG Publisher's publication mode (`-go-publish`). The publisher publishes into a web root shared by all Inera IGs, the `ig/` folder of the `gh-pages` branch of [inera-ab/fhir-portal](https://github.com/Inera-AB/fhir-portal), and takes care of:

- the version folder and the copy of the latest milestone at the IG root
- the release banner on every page, including earlier versions ("The current version which supersedes this version is …")
- the version history: `package-list.json` and `history.html` at `https://fhir.inera.se/ig/<name>/history.html`
- the package and publication feeds (`package-feed.xml`, `publication-feed.xml`), through which packages reach packages.fhir.org once Inera's package feed is registered in FHIR/ig-registry (not yet done; it will be when the first real IG is published)
- the IG's entry in the FHIR IG registry (`fhir-ig-list.json`), saved as a workflow artifact for a PR to [FHIR/ig-registry](https://github.com/FHIR/ig-registry)

`<name>` is the third part of the package id: `inera.core.template` publishes to `https://fhir.inera.se/ig/template`. The layout rule in the web root's `publish-setup.json` only matches package ids with exactly three parts, and `<name>` must be unique among Inera IGs.

The Swedish instructions in [`docs/`](docs/) describe the process in full:

- [Versionshantering, brancher och releaser](docs/versionshantering-och-release.md)
- [Förbereda en IG för publicering och göra en release](docs/forbereda-och-releasa-ig.md)
- [Flytta en befintlig IG till publiceringsläget](docs/flytta-befintlig-ig.md)

---

## Creating a new IG from this template

Done once per IG repo. The web root on fhir.inera.se and the feeds are shared by all Inera IGs and already set up. In the addresses below, `<repo>` is the repository name and `<name>` the third part of the package id, e.g. `laboratory` in `inera.lab.laboratory`.

### Repository and GitHub settings

1. **Create the repository.** On this repository click **Use this template** → **Create a new repository**. Choose `inera-ab` as owner and a name that describes the IG, e.g. `ig-laboratory`. All files, including the workflows, are copied.
2. **Give Actions write access:** Settings → Actions → General → *Workflow permissions* → **Read and write permissions**. Branch builds need it to write to `gh-pages`.
3. **Add the secret `FHIR_PORTAL_TOKEN`:** Settings → Secrets and variables → Actions. A fine-grained PAT with **Contents: Read and write** on `inera-ab/fhir-portal` and `inera-ab/fhir-portal-test`. Releases use it to publish to fhir.inera.se and update the IG catalog. Note the token's expiry date.

### IG identity

4. **Fill in `sushi-config.yaml`:**

   | Field | Example | Notes |
   |-------|---------|-------|
   | `id` | `inera.lab.laboratory` | Exactly three parts: `inera.<domain>.<name>`. `<name>` becomes the IG's folder on fhir.inera.se and must be unique |
   | `canonical` | `https://fhir.inera.se/ig/laboratory` | `https://fhir.inera.se/ig/<name>`. Never change it after the first release |
   | `name` | `IneraLaboratory` | PascalCase, no spaces |
   | `title` | `"Inera Laboratory IG"` | Shown in the IG header and in the IG catalog |
   | `description` | `"FHIR-profiler för laboratoriesvar."` | Shown in the IG catalog |
   | `version` | `0.1.0` | The version the next release will get |
   | `status` | `draft` | Changed as the IG matures |
   | `fhirVersion` | `4.0.1` | One repository per FHIR base version |

5. **Set `ig = fsh-generated/resources/ImplementationGuide-<id>.json` in `ig.ini`**, with the same `id`. Easy to miss, and then IG Publisher finds no IG.
6. **Fill in `publication-request.json`** for the first release: `"mode": "milestone"`, `"first": true`, a `desc`, `title`, `introduction`, `ci-build` (`https://inera-ab.github.io/<repo>`) and the FHIR IG registry fields. The workflow fills in `package-id`, `version` and `path`.
7. **Remove the lines `with:` and `package-feed: false`** in `.github/workflows/release.yml`. They keep the template out of packages.fhir.org; your IG's packages should go there.
8. **Empty `input/pagecontent/version-history.md`** of the template's entries (see [Version history](#version-history)).
9. **Point the package link** in `input/pagecontent/downloads.md` to `https://fhir.inera.se/ig/<name>/package.tgz`, and update the matching line in `input/ignoreWarnings.txt`.
10. **Give each profile its own `* ^version`** if profiles are versioned separately. Otherwise they get the IG version.

### After the first push to `main`

11. **Turn on GitHub Pages:** Settings → Pages → *Deploy from a branch* → `gh-pages` / `(root)`. The `gh-pages` branch is created by the first build on `main`. Without this step no branch builds are visible.
12. **Create the `develop` branch** from `main`.

The template no longer needs *Allow GitHub Actions to create and approve pull requests*. That setting was for release-please, which has been removed.

### Check before the first release

- [ ] `id` is the same in `sushi-config.yaml` and `ig.ini`, and has three parts
- [ ] `<name>` is not already used on `https://fhir.inera.se/ig/`
- [ ] The repository has no `package-list.json` (the publisher keeps it in the web root and refuses to publish from a source folder that has one)
- [ ] The build on `main` is green and visible at `https://inera-ab.github.io/<repo>/`
- [ ] `FHIR_PORTAL_TOKEN` exists and has not expired
- [ ] A test publication has succeeded

---

## Daily workflow

1. Create a feature branch from `develop`, e.g. `feature/lab-observation`.
2. Push. `validate.yml` runs SUSHI and `publish.yml` builds the branch to `https://inera-ab.github.io/<repo>/branches/feature-lab-observation/`.
3. Open a pull request against `develop`. The pull request template (`.github/pull_request_template.md`) asks what changes, whether the change is backwards compatible, and, in the PR that bumps the version, for the release checklist. `pr-qa.yml` posts a QA report as a comment with the number of errors, warnings, hints and broken links, so there is no need to open the logs.
4. Merge when QA is green. `develop` is built to `https://inera-ab.github.io/<repo>/branches/develop/`, and the feature branch's build is removed when the branch is deleted.

Nothing is published to fhir.inera.se on ordinary merges. `develop` is merged to `main` before a release (see [Publish a release](#publish-a-release)).

Replace the template's placeholder content: profiles in `input/fsh/profiles/`, examples in `input/fsh/examples/` and narrative pages in `input/pagecontent/`.

### Editing in the browser

Any file can be edited on GitHub without cloning: open the file, click the pencil (*Edit this file*), make the change and choose *Create a new branch and start a pull request*, with `develop` as the target. `pr-qa.yml` runs automatically. Pressing `.` in a repository opens it in the web-based VS Code.

### Commit messages and choosing a version

The version is bumped by hand before a release, and the version history entry is written by hand. Nothing creates versions or tags automatically. Commit messages following [Conventional Commits](https://www.conventionalcommits.org/) make it easy to see what changed since the last release and which version the next one should get:

| Prefix | Meaning | Usually gives |
|---|---|---|
| `feat: ...` | New profile, element or page | Minor (0.1.0 → 0.2.0) |
| `fix: ...` | Bug fix in a profile or text | Patch (0.1.0 → 0.1.1) |
| `profile: ...` | Profile change | Patch |
| `valueset: ...` | Terminology change | Patch |
| `docs: ...` | Documentation only | Patch |
| `chore: ...` | Maintenance, CI | No new version |
| `feat!: ...` or `BREAKING CHANGE:` in the message | Backwards-incompatible change | Major (0.1.0 → 1.0.0) |

`git log --oneline <previous version>..HEAD` lists the changes since the last release, which are the basis for the entry in `input/pagecontent/version-history.md`.

---

## Publish a release

### Before tagging

On the branch that is released (`main`, or `support/<major>.x` for a patch to an older major version), via a pull request:

1. **Version:** set `version` in `sushi-config.yaml` and add an entry to `input/pagecontent/version-history.md` describing the changes.
2. **Publication request:** update `publication-request.json`:
   - `desc`: one line describing this release. It must differ from every earlier release.
   - `mode`: `milestone` for a release that becomes the current version at the IG root; `working` for a publication that does not replace the root, such as a release candidate or a patch to an older major version. (`technical-correction` also needs a `tech-correction.template.html` in the web root's templates, which is not set up yet.)
   - `status` and `sequence`: for example `release` / `Releases`.
   - `first`: `true` only for the IG's very first publication.

   `package-id`, `version` and `path` are filled in by the workflow from `sushi-config.yaml`.
3. **Dependencies:** pin them to published versions; the publisher refuses `current` dependencies.
4. **Test publication (optional):** Actions → *Publish release* → *Run workflow* on the branch publishes to the test web root.

### Tag

Release tags have no `v` prefix and must equal `version` in `sushi-config.yaml`:

```bash
git fetch origin
git tag -a 1.2.0 -m "1.2.0" origin/main
git push origin 1.2.0
```

`release.yml` then:

1. Checks that the tag, `sushi-config.yaml` and `publication-request.json` agree, and that the version and its description are new.
2. Builds the IG.
3. Checks out the web root (only this IG's folder and the shared files).
4. Runs `-go-publish`, which rebuilds the IG for publication and updates the web root.
5. Pushes the web root and updates the IG catalog on fhir.inera.se.
6. Saves the FHIR IG registry change (`fhir-ig-list.diff`) and the publication log as an artifact.

### After the release

- Check `https://fhir.inera.se/ig/<name>/<version>/`, `https://fhir.inera.se/ig/<name>/history.html` and the IG catalog at `https://fhir.inera.se/ig/`.
- Open a pull request to [FHIR/ig-registry](https://github.com/FHIR/ig-registry) with the change in `fhir-ig-list.diff`.

### Rules

- **Never publish the same version twice.** Package caches and packages.fhir.org may already hold it, and the feeds get duplicates. Publish a new patch version instead. The workflow refuses a version that is already in the web root.
- A failed run that never reached *Push web root* has changed nothing and can be re-run.

---

## Version history

`input/pagecontent/version-history.md` is the IG's change log. The publisher's `history.html` lists the published versions; the change log describes what changed in each.

Write each entry as `### [X.Y.Z] — YYYY-MM-DD` with `####` sections. Like every narrative page, the version history starts at `###`, below the `<h2>` page title the template adds. Do not use `{::options header_offset="1" /}`: since IG Publisher 3.0.2 the publisher seats markdown headings under the page title itself, and the option would push them down one more level, which QA reports as a skipped heading level.

---

## CI workflows

The workflows in `.github/workflows/` only set the triggers and permissions. They call the shared workflows in [Inera-AB/fhir-ig-workflows](https://github.com/Inera-AB/fhir-ig-workflows) at `@v1`, so fixes to the build and release flow reach every IG made from this template without copying files.

| Workflow | Trigger | What it does |
|----------|---------|--------------|
| `validate.yml` | Push to non-main branches; pull requests | Runs SUSHI |
| `pr-qa.yml` | Pull request (opened, synchronised) | Full IG Publisher build, posts QA report as PR comment. No terminology server unless `tx-server` is set |
| `publish.yml` | Push to `main`, `develop`, `feature/**`, `support/**`; manual trigger | Branch build, deployed to `gh-pages` of this repo under the branch's directory; updates the IG catalog entry |
| `release.yml` | Push of a release tag (`1.2.0`, `1.2.0-rc1`); manual trigger | Publishes the release with `-go-publish`: a tag to fhir.inera.se, a manual run on a branch to the test web root |
| `cleanup.yml` | Branch deleted | Removes the branch's build directory from `gh-pages` |

Settings such as the web roots, the terminology server and the IG Publisher version are inputs of the shared workflows, set with `with:` in the caller. An R5 IG sets `tx-server: https://tx.fhir.org/r5` in `publish.yml`, `release.yml` and `pr-qa.yml`; without a terminology server the QA build reports false errors on R5 core value sets. See the [fhir-ig-workflows README](https://github.com/Inera-AB/fhir-ig-workflows#using-them-from-an-ig-repo).

---

## Local development

Prerequisites:

- Git
- VS Code
- Node.js 20 or later, for SUSHI
- Java 17 or later, for IG Publisher
- Ruby and Jekyll, which IG Publisher uses to render the pages

The commands below are for Git Bash (included in Git for Windows) or a terminal on macOS and Linux.

Once:

```bash
git clone https://github.com/inera-ab/<repo>.git
cd <repo>

# SUSHI and Jekyll
npm install -g fsh-sushi
gem install jekyll

# IG Publisher
mkdir -p input-cache
curl -sL https://github.com/HL7/fhir-ig-publisher/releases/latest/download/publisher.jar -o input-cache/publisher.jar
```

Day to day:

```bash
# New feature branch from develop
git checkout develop
git pull
git checkout -b feature/lab-observation

# Check the FSH
sushi .

# Build the whole IG (a few minutes)
java -jar input-cache/publisher.jar -ig ig.ini

# Open the result
start output/index.html       # Windows
open output/index.html        # macOS
xdg-open output/index.html    # Linux

# Commit and push
git add .
git commit -m "feat: add LaboratoryObservation profile"
git push -u origin feature/lab-observation
```

Then open a pull request against `develop` on GitHub.

Recommended VS Code extensions:

| Extension | Description |
|---|---|
| FHIR Shorthand (vscode-fsh) | Syntax highlighting and snippets for FSH |
| YAML | Validation of `sushi-config.yaml` |
| GitHub Pull Requests | Handle pull requests in VS Code |
| GitLens | Better git history and blame |

---

## Tips and common pitfalls

**FSH and SUSHI**

- Run `sushi .` locally before pushing. It is faster than waiting for CI.
- Aliases in `input/fsh/aliases.fsh` save repeating long URLs in every profile.
- Do not add `hl7.fhir.r4.core` as a dependency in `sushi-config.yaml`. SUSHI adds the core package itself.
- Pin other dependencies to published versions before a release, never `current`.

**IG Publisher and cache**

- The first build downloads several hundred MB of FHIR packages. Later builds are faster thanks to the cache in `~/.fhir/packages/`.
- `output/`, `temp/`, `template/`, `input-cache/` and `fsh-generated/` are git-ignored and must never be committed.
- The repository must never have a `package-list.json`. The version history lives on fhir.inera.se, and the publisher refuses to publish from a repository that has the file.

**GitHub Pages**

- Every push to a branch rebuilds the branch's page. The build takes a few minutes.
- If the page does not update: go to Actions, open the latest run of *Build and publish IG* and read the log.

**QA report on pull requests**

- `pr-qa.yml` posts a comment with the number of errors, warnings, hints and broken links, and the first issues in a table.
- The comment is updated on every push to the PR branch instead of a new one being added.
- Warnings listed in `input/ignoreWarnings.txt` are not counted in the report.

---

## Repository structure

```
.github/
  pull_request_template.md Pull request template (Swedish): change, impact, checklists
  ISSUE_TEMPLATE/          Issue templates for change requests and bugs
  workflows/               Callers of the shared workflows in Inera-AB/fhir-ig-workflows
    validate.yml           Validate FSH on push / PR
    pr-qa.yml              IG Publisher QA on pull requests
    publish.yml            Branch builds to this repo's GitHub Pages
    release.yml            Releases with -go-publish to the web root
    cleanup.yml            Remove build dir for deleted branches
docs/                      Swedish instructions for versioning and publishing
publication-request.json   What the next release is (desc, mode, status, sequence)
sushi-config.yaml          IG metadata, dependencies, pages and menu
ig.ini                     IG Publisher configuration
input/
  fsh/
    aliases.fsh            Shared FSH aliases
    profiles/              FHIR profile definitions (.fsh)
    examples/              Example instances (.fsh)
  pagecontent/             Narrative IG pages (.md); no leading "# Title", the template renders the page title
  images/                  Images, CSS and diagrams
  includes/                Fragment overrides (CSS, header) and menu.xml (only the <ul>; the IG template supplies the surrounding navbar markup)
```

---

## Governance

This template is maintained by Inera AB. See the [Inera FHIR Landing Page](https://www.inera.se/fhir) for conformance requirements that apply to all Inera FHIR IGs.
