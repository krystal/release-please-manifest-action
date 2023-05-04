# release-please-action

Composite [GitHub Action][1] which wraps [release-please-action][2] and
[github-app-token][3] actions, with some opinionated default settings.

[1]: https://github.com/features/actions
[2]: https://github.com/google-github-actions/release-please-action
[3]: https://github.com/tibdex/github-app-token

## Features

- Makes it easy to run release-please as a GitHub App.
- Defaults to placing release place config and manifests within the `.github`
  folder in the repository root:
  - `.release-please-manifest.json` -> `.github/release-please-manifest.json`
  - `release-please-config.json` -> `.github/release-please-config.json`
