# Changelog

## [4.0.0](https://github.com/krystal/release-please-manifest-action/compare/v3.0.0...v4.0.0) (2026-06-16)


### ⚠ BREAKING CHANGES

* **deps:** the wrapped `actions/create-github-app-token` and `googleapis/release-please-action` dependencies are upgraded to new major versions that run on Node 24 and require compatible GitHub Actions runners. The GitHub App identifier input is now `client-id`; `app-id` remains accepted for compatibility but is deprecated.

### Miscellaneous Chores

* **deps:** update action dependency tooling ([#10](https://github.com/krystal/release-please-manifest-action/issues/10)) ([00ae20e](https://github.com/krystal/release-please-manifest-action/commit/00ae20ead6e275ebfe64e250513123bb6187d582))

## [3.0.0](https://github.com/krystal/release-please-manifest-action/compare/v2.0.0...v3.0.0) (2025-10-24)


### ⚠ BREAKING CHANGES

* **deps:** Removed various app token related inputs not available in new underlying action. Please see updated list of inputs in README.

### Features

* **deps:** migrate to actions/create-github-app-token ([#7](https://github.com/krystal/release-please-manifest-action/issues/7)) ([221b0b8](https://github.com/krystal/release-please-manifest-action/commit/221b0b85603f9c92ee59410c7172139915b4ee9f))

## [2.0.0](https://github.com/krystal/release-please-manifest-action/compare/v1.0.1...v2.0.0) (2025-05-22)


### ⚠ BREAKING CHANGES

* **input:** rename `default-branch` input to `target-branch`
* **input:** replaced `installation-id` input with `installation-retrieval-mode`
* **output:** rename `release-please` output to `raw`

### Features

* **deps:** upgrade release-please-action and github-app-token to latest major versions ([#5](https://github.com/krystal/release-please-manifest-action/issues/5)) ([7892ec6](https://github.com/krystal/release-please-manifest-action/commit/7892ec640ab82d7368eedeae7e444532d901aa66))
* **input:** rename `default-branch` input to `target-branch` ([7892ec6](https://github.com/krystal/release-please-manifest-action/commit/7892ec640ab82d7368eedeae7e444532d901aa66))
* **input:** replaced `installation-id` input with `installation-retrieval-mode` ([7892ec6](https://github.com/krystal/release-please-manifest-action/commit/7892ec640ab82d7368eedeae7e444532d901aa66))
* **output:** rename `release-please` output to `raw` ([7892ec6](https://github.com/krystal/release-please-manifest-action/commit/7892ec640ab82d7368eedeae7e444532d901aa66))

## [1.0.1](https://github.com/krystal/release-please-manifest-action/compare/v1.0.0...v1.0.1) (2024-05-13)


### Bug Fixes

* **deps:** use new name for Google's release please action ([b70c365](https://github.com/krystal/release-please-manifest-action/commit/b70c3650a3da78c2423c2860194d5c8459f61fba))

## 1.0.0 (2023-05-26)


### Features

* **action:** prepare for release of Krystal fork ([0861eea](https://github.com/krystal/release-please-manifest-action/commit/0861eeaf7a567c1567f31ffed56acd41d6f8444a))
