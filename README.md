<h1 align="center">
  release-please-manifest-action
</h1>

<p align="center">
  <strong>
    Opinionated action for running release-please in manifest mode.
  </strong>
</p>

<p align="center">
  <a href="https://github.com/jimeh/release-please-manifest-action/releases">
    <img src="https://img.shields.io/github/v/tag/jimeh/release-please-manifest-action?label=release" alt="GitHub tag (latest SemVer)">
  </a>
  <a href="https://github.com/jimeh/release-please-manifest-action/issues">
    <img src="https://img.shields.io/github/issues-raw/jimeh/release-please-manifest-action.svg?style=flat&logo=github&logoColor=white" alt="GitHub issues">
  </a>
  <a href="https://github.com/jimeh/release-please-manifest-action/pulls">
    <img src="https://img.shields.io/github/issues-pr-raw/jimeh/release-please-manifest-action.svg?style=flat&logo=github&logoColor=white" alt="GitHub pull requests">
  </a>
  <a href="https://github.com/jimeh/release-please-manifest-action/blob/master/LICENSE">
    <img src="https://img.shields.io/github/license/jimeh/release-please-manifest-action.svg?style=flat" alt="License Status">
  </a>
</p>

A composite action which wraps [release-please-action][] and
[github-app-token][] actions, with opinionated default settings focused on
running [release-please][] in [manifest mode][].

[release-please-action]:
  https://github.com/google-github-actions/release-please-action
[github-app-token]: https://github.com/tibdex/github-app-token
[release-please]: https://github.com/googleapis/release-please
[manifest mode]:
  https://github.com/googleapis/release-please/blob/main/docs/manifest-releaser.md

# Features

- Focuses on and only supports running release-please's manifest command.
- Optionally supports having release-please authenticate as a GitHub App.
- Defaults to looking for release-please's config and manifest files within the
  top-level `.github` directory instead of in the repository root.

# Examples

All examples assume you have placed your `release-please-config.json` and
`.release-please-manifest.json` within the `.github` directory in the root of
the repository.

See release-please's [manifest-releaser][manifest mode] documentation for
details about the config and manifest files.

## Basic (Actions Token)

This example will have release-please authenticate using `secrets.GITHUB_TOKEN`
that is automatically available to all actions.

This will prevent checks / GitHub Actions running against any Release Pull
Requests raised by release-please. This is a feature of GitHub as a means of
trying to avoid GitHub Actions jobs triggering themselves, causing an endless
loop.

If you need checks to run against Release Pull Requests, you will need to have
release-please authenticate with a Personal Access Token (PAT), or as a GitHub
App.

<!-- x-release-please-start-major -->

```yaml
on: push
jobs:
  release-please:
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: jimeh/release-please-manifest-action@v1
```

<!-- x-release-please-end -->

<details>
<summary>The above is equivalent to:</summary>

```yaml
on: push
jobs:
  release-please:
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: google-github-actions/release-please-action@v3
        id: release-please
        with:
          command: manifest
          config-file: .github/release-please-config.json
          manifest-file: .github/.release-please-manifest.json
```

_Note: Outputs are not included in this equivalence example._

</details>

## Personal Access Token (PAT) Authentication

This example will have release-please authenticate with a user's Personal Access
Token (PAT), performing all operations on behalf of that user. Allowing checks /
GitHub Actions to run against Release Pull Requests.

It is common to have a dedicated "bot" user created for these purposes. But
within paid organizations, that means an extra user seat needs to be paid for.
In that case you might prefer using a GitHub App instead.

<!-- x-release-please-start-major -->

```yaml
on: push
jobs:
  release-please:
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: jimeh/release-please-manifest-action@v1
        with:
          token: ${{ secrets.RELEASE_PAT_TOKEN }}
```

<!-- x-release-please-end -->

<details>
<summary>The above is equivalent to:</summary>

```yaml
on: push
jobs:
  release-please:
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: google-github-actions/release-please-action@v3
        id: release-please
        with:
          token: ${{ secrets.RELEASE_PAT_TOKEN }}
          command: manifest
          config-file: .github/release-please-config.json
          manifest-file: .github/.release-please-manifest.json
```

_Note: Outputs are not included in this equivalence example._

</details>

## GitHub App Authentication

This example will have release-please authenticate as a GitHub App, performing
all operations on behalf of the app.

This has a few benefits compared to using the token provided by GitHub Actions
or a user's personal access token:

- It allows checks / GitHub Actions to run against the Release Pull Requests
  raised by release-please.
- An app can be given permissions to access all repos within an organization.
- Compared to creating a separate "bot" user, paid organizations do not need to
  pay for an extra user seat when using an app.

Below we assume you have already setup `RELEASE_BOT_APP_ID` and
`RELEASE_BOT_PRIVATE_KEY` secrets in the repository or organization.

To set the private key secret, it is easiest to base64 encode the contents of
the `*.pem` file you get from the GitHub App's configuration page. The base64
encoded string should not have any line-breaks.

<!-- x-release-please-start-major -->

```yaml
on: push
jobs:
  release-please:
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: jimeh/release-please-manifest-action@v1
        with:
          app-id: ${{ secrets.RELEASE_BOT_APP_ID }}
          private-key: ${{ secrets.RELEASE_BOT_PRIVATE_KEY }}
```

<!-- x-release-please-end -->

<details>
<summary>The above is equivalent to:</summary>

```yaml
on: push
jobs:
  release-please:
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: tibdex/github-app-token@v1
        id: github-app-token
        with:
          app_id: ${{ secrets.RELEASE_BOT_APP_ID }}
          private_key: ${{ secrets.RELEASE_BOT_PRIVATE_KEY }}
      - uses: google-github-actions/release-please-action@v3
        id: release-please
        with:
          token: ${{ steps.github-app-token.outputs.token }}
          command: manifest
          config-file: .github/release-please-config.json
          manifest-file: .github/.release-please-manifest.json
```

_Note: Outputs are not included in this equivalence example._

</details>

# Reference

<!-- action-docs-inputs -->

## Inputs

| parameter       | description                                                                                                                                                                                      | required | default                               |
| --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------- | ------------------------------------- |
| token           | GitHub token used to authenticate.                                                                                                                                                               | `false`  | ${{ github.token }}                   |
| app-id          | ID of the GitHub App to use for authentication. If set, takes precedence over token input.                                                                                                       | `false`  |                                       |
| private-key     | Private key of the GitHub App (can be Base64 encoded). Required when app-id is provided.                                                                                                         | `false`  |                                       |
| installation-id | ID of the installation for which the app token will be requested. Defaults to the ID of the repository's installation.                                                                           | `false`  |                                       |
| permissions     | JSON-stringified permissions granted to the app token. Defaults to all the GitHub app permissions, see: https://docs.github.com/en/rest/apps/apps#create-an-installation-access-token-for-an-app | `false`  |                                       |
| github-api-url  | Configure github API URL.                                                                                                                                                                        | `false`  | ${{ github.api_url }}                 |
| repository      | The full name of the repository to operate on in owner/repo format. Defaults to the current repository.                                                                                          | `false`  | ${{ github.repository }}              |
| default-branch  | Branch to open pull release PR against. Defaults to the repository's default branch.                                                                                                             | `false`  |                                       |
| config-file     | Pat to config file within the project.                                                                                                                                                           | `false`  | .github/release-please-config.json    |
| manifest-file   | Path to manifest file within the project.                                                                                                                                                        | `false`  | .github/.release-please-manifest.json |

<!-- action-docs-inputs -->

<!-- action-docs-outputs -->

## Outputs

| parameter        | description                                              |
| ---------------- | -------------------------------------------------------- |
| release_created  | Whether or not a release was created.                    |
| releases_created | Whether or not a release was created.                    |
| id               | Release ID.                                              |
| name             | Release name.                                            |
| tag_name         | Release tag name.                                        |
| sha              | Release SHA.                                             |
| body             | Release body.                                            |
| html_url         | Release URL.                                             |
| draft            | Whether or not the release is a draft.                   |
| upload_url       | Release upload URL.                                      |
| path             | Path that was released.                                  |
| version          | Version that was released.                               |
| major            | Major version that was released.                         |
| minor            | Minor version that was released.                         |
| patch            | Patch version that was released.                         |
| paths_released   | Paths that were released.                                |
| pr               | Pull request number.                                     |
| prs              | Pull request numbers.                                    |
| release-please   | All outputs from release-please action as a JSON string. |

<!-- action-docs-outputs -->

# License

[CC0 1.0 Universal](http://creativecommons.org/publicdomain/zero/1.0/)
