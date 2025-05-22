<h1 align="center">
  release-please-manifest-action
</h1>

<p align="center">
  <strong>
    Opinionated action for running release-please in manifest mode.
  </strong>
</p>

<p align="center">
  <a href="https://github.com/krystal/release-please-manifest-action/releases"><img src="https://img.shields.io/github/v/tag/krystal/release-please-manifest-action?label=release" alt="GitHub tag (latest SemVer)"></a>
  <a href="https://github.com/krystal/release-please-manifest-action/issues"><img src="https://img.shields.io/github/issues-raw/krystal/release-please-manifest-action.svg?style=flat&logo=github&logoColor=white" alt="GitHub issues"></a>
  <a href="https://github.com/krystal/release-please-manifest-action/pulls"><img src="https://img.shields.io/github/issues-pr-raw/krystal/release-please-manifest-action.svg?style=flat&logo=github&logoColor=white" alt="GitHub pull requests"></a>
  <a href="https://github.com/krystal/release-please-manifest-action/blob/master/LICENSE"><img src="https://img.shields.io/github/license/krystal/release-please-manifest-action.svg?style=flat" alt="License Status"></a>
</p>

A composite action which wraps [release-please-action][] and
[github-app-token][] actions, with opinionated defaults.

_Note: This is a fork of
[`jimeh/release-please-manifest-action`](https://github.com/jimeh/release-please-manifest-action),
customized by [@krystal](https://github.com/krystal) for their own needs.
Upstream changes will be included as appropriate._

[release-please-action]: https://github.com/googleapis/release-please-action
[github-app-token]: https://github.com/tibdex/github-app-token
[release-please]: https://github.com/googleapis/release-please
[manifest mode]:
  https://github.com/googleapis/release-please/blob/main/docs/manifest-releaser.md

# Features

- Supports having release-please authenticate as a GitHub App.
- Supports dynamic target branch based on regular expression pattern, enabling
  maintenance releases.
- Defaults to looking for release-please's config and manifest files within the
  top-level `.github` directory instead of in the repository root.

_Note: This action is not well suited for multi package/root release-please
configurations, as it does not support dynamic path-based outputs. A workaround
is to parse the `raw` output JSON string, but this is not ideal._

# Breaking changes from v1 to v2

- `default-branch` input was renamed to `target-branch`.
- `installation-id` input has been replaced by `installation-retrieval-mode`.
- `release-please` output was renamed to `raw`.

# Usage

All usage examples below assume you have placed your
`release-please-config.json` and `.release-please-manifest.json` within the
`.github` directory in the root of the repository.

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
      - uses: krystal/release-please-manifest-action@v1
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
      - uses: googleapis/release-please-action@v4
        id: release-please
        with:
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
      - uses: krystal/release-please-manifest-action@v1
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
      - uses: googleapis/release-please-action@v4
        id: release-please
        with:
          token: ${{ secrets.RELEASE_PAT_TOKEN }}
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
      - uses: krystal/release-please-manifest-action@v1
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
      - uses: tibdex/github-app-token@v2
        id: github-app-token
        with:
          app_id: ${{ secrets.RELEASE_BOT_APP_ID }}
          private_key: ${{ secrets.RELEASE_BOT_PRIVATE_KEY }}
      - uses: googleapis/release-please-action@v4
        id: release-please
        with:
          token: ${{ steps.github-app-token.outputs.token }}
          config-file: .github/release-please-config.json
          manifest-file: .github/.release-please-manifest.json
```

_Note: Outputs are not included in this equivalence example._

</details>

## Maintenance Releases

The `target-branch-pattern` input allows for dynamic targeting of different
branches. This means if you, for example, specify
`^(main|release-[0-9]+(\.[0-9]+)?)$` as the pattern, release-please will run
against the `main` branch, but also against any branch named `release-X` or
`release-X.X`, where `X` is one or more numbers.

The practical use of this looks something like this:

- The `main` branch is used for latest development and latest releases. Let's
  assume it is on version 1.5.7 right now.
- The `release-1.4` branch was created from the latest 1.4.x tag, and fixes are
  backported to it from `main`.
- When `main` is pushed to, release-please will create a release PR to merge
  into `main` that bumps the version accordingly.
- When `release-1.4` is pushed to, release-please will create a release PR
  against the `release-1.4` branch instead of `main`, so a new 1.4.x release can
  be safely created.

The thing to be careful of when working on maintenance branches is that release-
please might try and bump the minor or even major version just like it would in
`main` depending on the commit types. This should be overridden by either doing
an empty commit with a `Release-As:` footer, or by modifying the commit types
when cherry picking.

# Reference

<!-- action-docs-inputs -->

## Inputs

| parameter                      | description                                                                                                                                                                                                                                                                                                                                                                                            | required | default                               |
| ------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------- | ------------------------------------- |
| token                          | GitHub token used to authenticate.                                                                                                                                                                                                                                                                                                                                                                     | `false`  | ${{ github.token }}                   |
| app-id                         | ID of the GitHub App to use for authentication. If set, takes precedence over token input.                                                                                                                                                                                                                                                                                                             | `false`  |                                       |
| private-key                    | Private key of the GitHub App (can be Base64 encoded). Required when app-id is provided.                                                                                                                                                                                                                                                                                                               | `false`  |                                       |
| installation-retrieval-mode    | When using app authentication, the mode used to retrieve the installation for which the token will be requested. For more information, see: https://github.com/tibdex/github-app-token/blob/v2/action.yml                                                                                                                                                                                              | `false`  | repository                            |
| installation-retrieval-payload | When using app authentication, the payload used to retrieve the installation. For more information, see: https://github.com/tibdex/github-app-token/blob/v2/action.yml                                                                                                                                                                                                                                 | `false`  | ${{ github.repository }}              |
| repositories                   | When using app authentication, the JSON-stringified array of the full names of the repositories the token should have access to. Defaults to all repositories that the installation can access. See https://docs.github.com/en/rest/apps/apps?apiVersion=2022-11-28#create-an-installation-access-token-for-an-app's `repositories`.                                                                   | `false`  |                                       |
| permissions                    | JSON-stringified permissions granted to the app token. Defaults to all the GitHub app permissions, see: https://docs.github.com/en/rest/apps/apps#create-an-installation-access-token-for-an-app                                                                                                                                                                                                       | `false`  |                                       |
| github-api-url                 | Configure github API URL. Default `https://api.github.com`                                                                                                                                                                                                                                                                                                                                             | `false`  | ${{ github.api_url }}                 |
| github-graphql-url             | Configure github GraphQL URL. Default `https://api.github.com/graphql`                                                                                                                                                                                                                                                                                                                                 | `false`  | ${{ github.graphql_url }}             |
| repository                     | The full name of the repository to operate on in owner/repo format. Defaults to the current repository.                                                                                                                                                                                                                                                                                                | `false`  | ${{ github.repository }}              |
| target-branch                  | Branch to open pull release PR against. Defaults to the repository's default branch.                                                                                                                                                                                                                                                                                                                   | `false`  |                                       |
| target-branch-pattern          | Regular expression pattern to determine if current ref name is a target branch or not. When specified, the action will only run if the current ref name matches the pattern, and the current ref name will be used as the target branch. When not specified, the action will always run, and target the specified target-branch, or the repository's default branch if target-branch is not specified. | `false`  |                                       |
| config-file                    | Path to config file within the project.                                                                                                                                                                                                                                                                                                                                                                | `false`  | .github/release-please-config.json    |
| manifest-file                  | Path to manifest file within the project.                                                                                                                                                                                                                                                                                                                                                              | `false`  | .github/.release-please-manifest.json |

<!-- action-docs-inputs -->

<!-- action-docs-outputs -->

## Outputs

| parameter        | description                                              |
| ---------------- | -------------------------------------------------------- |
| release_created  | Whether or not a release was created.                    |
| upload_url       | Release upload URL.                                      |
| html_url         | Release URL.                                             |
| tag_name         | Release tag name.                                        |
| version          | Version that was released.                               |
| major            | Major version that was released.                         |
| minor            | Minor version that was released.                         |
| patch            | Patch version that was released.                         |
| sha              | Release SHA.                                             |
| pr               | Pull request number.                                     |
| path             | Path that was released.                                  |
| releases_created | Whether or not a release was created.                    |
| paths_released   | Paths that were released.                                |
| id               | Release ID.                                              |
| name             | Release name.                                            |
| body             | Release body.                                            |
| draft            | Whether or not the release is a draft.                   |
| prs_created      | Whether or not a pull request was created.               |
| pr_number        | Pull request number that created the release.            |
| prs              | Pull request numbers.                                    |
| raw              | All outputs from release-please action as a JSON string. |

<!-- action-docs-outputs -->

# License

[CC0 1.0 Universal](http://creativecommons.org/publicdomain/zero/1.0/)
