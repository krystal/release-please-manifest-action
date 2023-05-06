<h1 align="center">
  release-please-manifest-action
</h1>

Opinionated [action][1] for running [release-please][2] in [manifest mode][3]
with support for authenticating as a [GitHub App][4].

Implemented as a composite action which wraps [release-please-action][5] and
[github-app-token][6] actions, with opinionated default settings.

[1]: https://github.com/features/actions
[2]: https://github.com/googleapis/release-please
[3]:
  https://github.com/googleapis/release-please/blob/main/docs/manifest-releaser.md
[4]: https://docs.github.com/en/apps/overview
[5]: https://github.com/google-github-actions/release-please-action
[6]: https://github.com/tibdex/github-app-token

## Features

- Makes it easy to run release-please as a GitHub App, allowing checks to run on
  Release Pull Requests.
- Defaults to placing release-please config and manifest files within the
  `.github` folder instead of in the repository root:
  - `.github/release-please-manifest.json`
  - `.github/release-please-config.json`

## To-Do

- [ ] Verify stability of this action.
- [ ] Setup CI releases using itself, so the action can be referred to with
      `@v1` instead of `@main`.

## Examples

The below example assumes you have secrets already setup for the app ID and
private key.

If you do not want to authenticate as a GitHub App, simply do not provide
`app-id` and `private-key` inputs.

```yaml
on: push
jobs:
  release-please:
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main' || github.ref == 'refs/heads/master'
    steps:
      - uses: jimeh/release-please-action@main
        with:
          app-id: ${{ secrets.RELEASE_BOT_APP_ID }}
          private-key: ${{ secrets.RELEASE_BOT_PRIVATE_KEY }}
```

The above, is equivalent to:

```yaml
on: push
jobs:
  release-please:
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main' || github.ref == 'refs/heads/master'
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
          manifest-file: .github/release-please-manifest.json
```
